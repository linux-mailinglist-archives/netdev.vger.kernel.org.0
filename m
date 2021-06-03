Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABDB39A7B3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhFCRMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhFCRLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19A661401;
        Thu,  3 Jun 2021 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740174;
        bh=GUmsdrypy+WfvYXFVm51F2A01cgs32RP1c4xJfdyHK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GiT5X1L6mEpKGQc5Crf7hgUxeXegQMqwM4a+C3ShaVP7R7nbF1RWfy45Rk6amhS/8
         y1tHHgKPQylJrapIE05Lmw8Lg2A5hopL5mSnsmKyOpRmrXH7EbDjmMReKgzgTNZoJT
         mA9uFR3EygkmKn8V5isEYjjiAlyqULi5m1vu5mEQHy9PeWUDDnxlumvJ1rGpWOGeOG
         gNFktlCwDUVOSs6Zj2bnnaPH0gyRjgKIePDvdb5WtFLqLCeTAJyh/D4YJP/rB3wUSQ
         5FHDoU2sYsNPP1spQLVG4Vd20SDyAgO0Rri7CAg7X2y9h3BXaUfdofO7KuLvjj43G4
         TqlD1J62O3i9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/31] netlink: disable IRQs for netlink_lock_table()
Date:   Thu,  3 Jun 2021 13:09:00 -0400
Message-Id: <20210603170919.3169112-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1d482e666b8e74c7555dbdfbfb77205eeed3ff2d ]

Syzbot reports that in mac80211 we have a potential deadlock
between our "local->stop_queue_reasons_lock" (spinlock) and
netlink's nl_table_lock (rwlock). This is because there's at
least one situation in which we might try to send a netlink
message with this spinlock held while it is also possible to
take the spinlock from a hardirq context, resulting in the
following deadlock scenario reported by lockdep:

       CPU0                    CPU1
       ----                    ----
  lock(nl_table_lock);
                               local_irq_disable();
                               lock(&local->queue_stop_reason_lock);
                               lock(nl_table_lock);
  <Interrupt>
    lock(&local->queue_stop_reason_lock);

This seems valid, we can take the queue_stop_reason_lock in
any kind of context ("CPU0"), and call ieee80211_report_ack_skb()
with the spinlock held and IRQs disabled ("CPU1") in some
code path (ieee80211_do_stop() via ieee80211_free_txskb()).

Short of disallowing netlink use in scenarios like these
(which would be rather complex in mac80211's case due to
the deep callchain), it seems the only fix for this is to
disable IRQs while nl_table_lock is held to avoid hitting
this scenario, this disallows the "CPU0" portion of the
reported deadlock.

Note that the writer side (netlink_table_grab()) already
disables IRQs for this lock.

Unfortunately though, this seems like a huge hammer, and
maybe the whole netlink table locking should be reworked.

Reported-by: syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c2a5174387ff..9d993b4cf1af 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -452,11 +452,13 @@ void netlink_table_ungrab(void)
 static inline void
 netlink_lock_table(void)
 {
+	unsigned long flags;
+
 	/* read_lock() synchronizes us to netlink_table_grab */
 
-	read_lock(&nl_table_lock);
+	read_lock_irqsave(&nl_table_lock, flags);
 	atomic_inc(&nl_table_users);
-	read_unlock(&nl_table_lock);
+	read_unlock_irqrestore(&nl_table_lock, flags);
 }
 
 static inline void
-- 
2.30.2

