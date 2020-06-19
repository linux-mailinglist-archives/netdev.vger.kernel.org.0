Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A00201A18
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgFSSNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:13:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:33762 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732041AbgFSSNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 14:13:30 -0400
IronPort-SDR: 8MCLT0i/T5nQbIJK74XROZHOkXdhSFLJqNpYlIEs3KSbaJ7DCPlob3KNL7HgM8GfNB+IIPaTB3
 oQyCxjBATIUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9657"; a="123318297"
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="123318297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 11:13:29 -0700
IronPort-SDR: MmQOS16F6jSPC1+37JshrgfInwslKZJW8J7FcDYQhKRjZxyzJMIcDdeL4L5urI4ZAIDV7SsNXp
 jXmnodX42X3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="352798646"
Received: from arch-p28.jf.intel.com ([10.166.187.31])
  by orsmga001.jf.intel.com with ESMTP; 19 Jun 2020 11:13:29 -0700
From:   Sridhar Samudrala <sridhar.samudrala@intel.com>
To:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] fs/epoll: Enable non-blocking busypoll with epoll timeout of 0
Date:   Fri, 19 Jun 2020 11:13:29 -0700
Message-Id: <1592590409-35439-1-git-send-email-sridhar.samudrala@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch triggers non-blocking busy poll when busy_poll is enabled and
epoll is called with a timeout of 0 and is associated with a napi_id.
This enables an app thread to go through napi poll routine once by calling
epoll with a 0 timeout.

poll/select with a 0 timeout behave in a similar manner.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 fs/eventpoll.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..5f55078d6381 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		eavail = ep_events_available(ep);
 		write_unlock_irq(&ep->lock);
 
+		/*
+		 * Trigger non-blocking busy poll if timeout is 0 and there are
+		 * no events available. Passing timed_out(1) to ep_busy_loop
+		 * will make sure that busy polling is triggered only once and
+		 * only if sysctl.net.core.busy_poll is set to non-zero value.
+		 */
+		if (!eavail) {
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

