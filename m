Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8724F21C276
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgGKGJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:09:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:11246 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726958AbgGKGJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:09:42 -0400
IronPort-SDR: hEgT6D3u93TYiUIoxoKWZhuW8DQ0ANBLTD8Key8tw3TlevEB2U+KE6mD8ilkEJaqNxMc8liegT
 fhqgyr23QKmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="136534498"
X-IronPort-AV: E=Sophos;i="5.75,338,1589266800"; 
   d="scan'208";a="136534498"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 23:09:41 -0700
IronPort-SDR: PmSfM7g2eMJJvdWSFUuNZPctpgQZTLq8QgPLabE9sddBDoHGIDzt8AnTJC/sSYusrgjA1DsK9t
 rF5Rme91Sffw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,338,1589266800"; 
   d="scan'208";a="323746397"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2020 23:09:41 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, davem@davemloft.net,
        alexander.h.duyck@linux.intel.com, andy.lavr@gmail.com
Subject: [PATCH v4] fs/epoll: Enable non-blocking busypoll when epoll timeout is 0
Date:   Fri, 10 Jul 2020 23:09:41 -0700
Message-Id: <1594447781-27115-1-git-send-email-sridhar.samudrala@intel.com>
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

v4:
- Fix a typo (Andy)
v3:
- reset napi_id if no event available after busy poll (Alex)
v2: 
- Added net_busy_loop_on() check (Eric)
---
 fs/eventpoll.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..10da7a8e1c2b 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1847,6 +1847,22 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		eavail = ep_events_available(ep);
 		write_unlock_irq(&ep->lock);
 
+		/*
+		 * Trigger non-blocking busy poll if timeout is 0 and there are
+		 * no events available. Passing timed_out(1) to ep_busy_loop
+		 * will make sure that busy polling is triggered only once.
+		 */
+		if (!eavail && net_busy_loop_on()) {
+			ep_busy_loop(ep, timed_out);
+
+			write_lock_irq(&ep->lock);
+			eavail = ep_events_available(ep);
+			write_unlock_irq(&ep->lock);
+
+			if (!eavail)
+				ep_reset_busy_poll_napi_id(ep);
+		}
+
 		goto send_events;
 	}
 
-- 
2.25.4

