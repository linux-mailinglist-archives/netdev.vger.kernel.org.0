Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3572CD6FB
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436852AbgLCNbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436833AbgLCNbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 08:31:03 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
        syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
        syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/23] can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check
Date:   Thu,  3 Dec 2020 08:29:35 -0500
Message-Id: <20201203132935.931362-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132935.931362-1-sashal@kernel.org>
References: <20201203132935.931362-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit d73ff9b7c4eacaba0fd956d14882bcae970f8307 ]

To detect potential bugs in CAN protocol implementations (double removal of
receiver entries) a WARN() statement has been used if no matching list item was
found for removal.

The fault injection issued by syzkaller was able to create a situation where
the closing of a socket runs simultaneously to the notifier call chain for
removing the CAN network device in use.

This case is very unlikely in real life but it doesn't break anything.
Therefore we just replace the WARN() statement with pr_warn() to preserve the
notification for the CAN protocol development.

Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com
Reported-by: syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com
Reported-by: syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201126192140.14350-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index fd6ef6d26846f..306d3584a4417 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -539,10 +539,13 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* Check for bugs in CAN protocol implementations using af_can.c:
 	 * 'rcv' will be NULL if no matching list item was found for removal.
+	 * As this case may potentially happen when closing a socket while
+	 * the notifier for removing the CAN netdev is running we just print
+	 * a warning here.
 	 */
 	if (!rcv) {
-		WARN(1, "BUG: receive list entry not found for dev %s, id %03X, mask %03X\n",
-		     DNAME(dev), can_id, mask);
+		pr_warn("can: receive list entry not found for dev %s, id %03X, mask %03X\n",
+			DNAME(dev), can_id, mask);
 		goto out;
 	}
 
-- 
2.27.0

