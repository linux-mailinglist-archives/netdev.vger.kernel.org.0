Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB5079A20
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfG2UlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:41:21 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:35277 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728915AbfG2UlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1564432878;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=58Z8bDRgyAi1iHQvHHwK8+g7BxsaAQ9fV6DBfYqu6nI=;
        b=F2ivxhPOOLN6tdjHSjli/a4rX/BrPWuIeCWO6rPZNAjsFK2wIvfQjuuqoFrnu86BGs
        GLUafAUb6dgQuWSHyno7fLzgaXFfKeApPZVAVrqqCXXxqiBhqY1TKR+PfzZgSw5TGJbs
        rSvJLPBsLBZkZuMDLitKYxdNQdXMHWzk4J81AiSoIZkJFFNxRARzAoAqmQUIMYG6GJ1J
        Q94asqQ9S64anFq1dfB6+CIzxbX8/9s6kgXj2PGamrovFJfOv2Dx5MH1DhWB2wi9jEyG
        5rE2PvyjN5fH1EX/HQqypQQlbmtD0s0ZLvrJIGSweMkskz6WnnlTtep6sA36qa6bBdla
        qZag==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lO8DsfULo/u6TWni45U="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id k05d3bv6TKfCvOi
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 29 Jul 2019 22:41:12 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH net-next] can: fix ioctl function removal
Date:   Mon, 29 Jul 2019 22:40:56 +0200
Message-Id: <20190729204056.2976-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 60649d4e0af ("can: remove obsolete empty ioctl() handler") replaced the
almost empty can_ioctl() function with sock_no_ioctl() which always returns
-EOPNOTSUPP.

Even though we don't have any ioctl() functions on socket/network layer we need
to return -ENOIOCTLCMD to be able to forward ioctl commands like SIOCGIFINDEX
to the network driver layer.

This patch fixes the wrong return codes in the CAN network layer protocols.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: 60649d4e0af ("can: remove obsolete empty ioctl() handler")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/bcm.c | 9 ++++++++-
 net/can/raw.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 8da986b19d88..bf1d0bbecec8 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1680,6 +1680,13 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	return size;
 }
 
+int bcm_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
+			 unsigned long arg)
+{
+	/* no ioctls for socket layer -> hand it down to NIC layer */
+	return -ENOIOCTLCMD;
+}
+
 static const struct proto_ops bcm_ops = {
 	.family        = PF_CAN,
 	.release       = bcm_release,
@@ -1689,7 +1696,7 @@ static const struct proto_ops bcm_ops = {
 	.accept        = sock_no_accept,
 	.getname       = sock_no_getname,
 	.poll          = datagram_poll,
-	.ioctl         = sock_no_ioctl,
+	.ioctl         = bcm_sock_no_ioctlcmd,
 	.gettstamp     = sock_gettstamp,
 	.listen        = sock_no_listen,
 	.shutdown      = sock_no_shutdown,
diff --git a/net/can/raw.c b/net/can/raw.c
index ff720272f7b7..da386f1fa815 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -837,6 +837,13 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	return size;
 }
 
+int raw_sock_no_ioctlcmd(struct socket *sock, unsigned int cmd,
+			 unsigned long arg)
+{
+	/* no ioctls for socket layer -> hand it down to NIC layer */
+	return -ENOIOCTLCMD;
+}
+
 static const struct proto_ops raw_ops = {
 	.family        = PF_CAN,
 	.release       = raw_release,
@@ -846,7 +853,7 @@ static const struct proto_ops raw_ops = {
 	.accept        = sock_no_accept,
 	.getname       = raw_getname,
 	.poll          = datagram_poll,
-	.ioctl         = sock_no_ioctl,
+	.ioctl         = raw_sock_no_ioctlcmd,
 	.gettstamp     = sock_gettstamp,
 	.listen        = sock_no_listen,
 	.shutdown      = sock_no_shutdown,
-- 
2.20.1

