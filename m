Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44333207C2F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391283AbgFXTa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:30:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:53443 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391239AbgFXTa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 15:30:58 -0400
IronPort-SDR: 2PEVwDbMjjT0Ha25qPDp7bNNTkt1RVm9UFuhT//UkH+v0hxij9YK/q79Ju+/BctJ/9ZYV4bPcf
 JIkXgam+h1oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="206132527"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="206132527"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 12:30:57 -0700
IronPort-SDR: hKXL9dTRuty1dvpXZ/gPP0sioal8A+I3+xQbIWWGuuBDkHOW754HEhS5XCua/xC/UxZ37JtF7h
 m5HuA2bCrhJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="311751951"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jun 2020 12:30:56 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, davem@davemloft.net
Subject: [PATCH v2] fs/epoll: Enable non-blocking busypoll when epoll timeout is 0
Date:   Wed, 24 Jun 2020 12:30:56 -0700
Message-Id: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch triggers non-blocking busy poll when busy_poll is enabled,
epoll is called with a timeout of 0 and is associated with a napi_id.
This enables an app thread to go through napi poll routine once by
calling epoll with a 0 timeout.

poll/select with a 0 timeout behave in a similar manner.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

v2:
Added net_busy_loop_on() check (Eric)

---
 fs/eventpoll.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..c33cc98d3848 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		eavail = ep_events_available(ep);
 		write_unlock_irq(&ep->lock);
 
+		/*
+		 * Trigger non-blocking busy poll if timeout is 0 and there are
+		 * no events available. Passing timed_out(1) to ep_busy_loop
+		 * will make sure that busy polling is triggered only once.
+		 */
+		if (!eavail && net_busy_loop_on()) {
+			ep_busy_loop(ep, timed_out);
+			write_lock_irq(&ep->lock);
+			eavail = ep_events_available(ep);
+			write_unlock_irq(&ep->lock);
+		}
+
 		goto send_events;
 	}
 
-- 
2.25.4

