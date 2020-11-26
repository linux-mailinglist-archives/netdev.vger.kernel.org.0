Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C1E2C5C96
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 20:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404345AbgKZTVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 14:21:50 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:27989 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731736AbgKZTVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 14:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606418508;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=auFNMuUKo/sAb8aIEJr26iC3nfJ6C+wXjXg9088Jfn8=;
        b=g6DJLcgScqWk3lSCgwsNWNohW17wmdjL5YQ8n5hViXxcPpCHGPWlFU0YwwDF0l+qMP
        apO1KBZP/NAi9cM4au8GUj/Mp5KWL7/j3P3qoKpTQ+yU4PkXZx+GQDVY4C9DSNp2rfc1
        qYFms1pXPNilyEdx5wNd0mg2dc3WQxvEIx3h0isuiJomVRgxVmICe/qgbu+ncpwHjcTI
        FZOSj4qIySGDM2SoOzFED8m3IZgdgGZPk8DrMgjVrToSZBLQXdjAABdQKdD7zsY5UbNr
        mnv6KfjJrl9SvrYo00NosrlrJXYMjYS+KCjGJk3BXajbBir28y9AVUgYEq9hvJr/N0r3
        Fdwg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lu8GW276Zq2NBHY="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwAQJLkunS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 26 Nov 2020 20:21:46 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     mkl@pengutronix.de, dvyukov@google.com, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Cc:     syzkaller-bugs@googlegroups.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
        syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
        syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
Subject: [PATCH] can: remove WARN() statement from list operation sanity check
Date:   Thu, 26 Nov 2020 20:21:40 +0100
Message-Id: <20201126192140.14350-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To detect potential bugs in CAN protocol implementations (double removal
of receiver entries) a WARN() statement has been used if no matching list
item was found for removal.

The fault injection issued by syzkaller was able to create a situation
where the closing of a socket runs simultaneously to the notifier call
chain for removing the CAN network device in use.

This case is very unlikely in real life but it doesn't break anything.
Therefore we just replace the WARN() statement with pr_warn() to
preserve the notification for the CAN protocol development.

Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com
Reported-by: syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com
Reported-by: syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/af_can.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5d124c155904..7c5ccdec89e1 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -539,14 +539,17 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 			break;
 	}
 
 	/* Check for bugs in CAN protocol implementations using af_can.c:
 	 * 'rcv' will be NULL if no matching list item was found for removal.
+	 * As this case may potentially happen when closing a socket while
+	 * the notifier for removing the CAN netdev is running we just print
+	 * a warning here. Reported by syskaller (see commit message)
 	 */
 	if (!rcv) {
-		WARN(1, "BUG: receive list entry not found for dev %s, id %03X, mask %03X\n",
-		     DNAME(dev), can_id, mask);
+		pr_warn("can: receive list entry not found for dev %s, id %03X, mask %03X\n",
+			DNAME(dev), can_id, mask);
 		goto out;
 	}
 
 	hlist_del_rcu(&rcv->list);
 	dev_rcv_lists->entries--;
-- 
2.29.2

