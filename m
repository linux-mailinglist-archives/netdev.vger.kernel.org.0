Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAA121AE3B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 06:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgGJEvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 00:51:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:27372 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgGJEvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 00:51:50 -0400
IronPort-SDR: 5nja2vo498iWm9NMcxeacWH7KAEKLBFZ03vw2aqYWh+/WMzOd78B13Y/aJs0IqwqUIRB774tfi
 XeyMqDpA99hQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="149620795"
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="149620795"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 21:51:49 -0700
IronPort-SDR: CeCBg8QBdQx7bYkYEEehvVHIxWT9pEJFgnO32sSWyX0GPKw6DK1eWOaggyaXoyKaxddPZgoNpM
 BmjAOaPysPdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="324482821"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga007.jf.intel.com with ESMTP; 09 Jul 2020 21:51:49 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, davem@davemloft.net,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH v3] fs/epoll: Enable non-blocking busypoll when epoll timeout is 0
Date:   Thu,  9 Jul 2020 21:51:49 -0700
Message-Id: <1594356709-23748-1-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trigger non-blocking busy poll when busy_poll is enabled and
epoll is called with a timeout of 0 and is associated with a 
napi_id. This enables an app thread to go through napi poll 
routine once by calling epoll with a 0 timeout.

poll/select with a 0 timeout behave in a similar manner.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

v3: reset napi_id if no event available after busy poll (Alex)
v2: Added net_busy_loop_on() check (Eric)
---
 fs/eventpoll.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..b035b5cd19ce 100644
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
+			if (!evail)
+				ep_reset_busy_poll_napi_id(ep);
+		}
+
 		goto send_events;
 	}
 
