Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764A113F48C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389543AbgAPRI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389527AbgAPRIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F05D21D56;
        Thu, 16 Jan 2020 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194534;
        bh=VJQh8LzQJm90j6pqB8gOqtTs5p3bVSui1JBgLcl6G1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf9WYvg2/xb1r3RMXmn3AJkmuv7C/vV22EzrAy1T1jdy5TNOvjpy60ksj2xNmwGJG
         c/M2vud/mJ9x6iDP9MlJjv94X97XIGuO/OzcqKv4cRT+om4W/RoxXi0p55yPV6Duwf
         lxYrcQpNJLl1dEgkzo7k994S34VwcdBlZsJFT6vk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 422/671] net/af_iucv: build proper skbs for HiperTransport
Date:   Thu, 16 Jan 2020 12:01:00 -0500
Message-Id: <20200116170509.12787-159-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 238965b71b968dc5b3c0fe430e946f488322c4b5 ]

The HiperSockets-based transport path in af_iucv is still too closely
entangled with qeth.
With commit a647a02512ca ("s390/qeth: speed-up L3 IQD xmit"), the
relevant xmit code in qeth has begun to use skb_cow_head(). So to avoid
unnecessary skb head expansions, af_iucv must learn to
1) respect dev->needed_headroom when allocating skbs, and
2) drop the header reference before cloning the skb.

While at it, also stop hard-coding the LL-header creation stage and just
use the appropriate helper.

Fixes: a647a02512ca ("s390/qeth: speed-up L3 IQD xmit")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index f024914da1b2..e07daee1227c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -13,6 +13,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/errno.h>
@@ -355,6 +356,9 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 		err = -ENODEV;
 		goto err_free;
 	}
+
+	dev_hard_header(skb, skb->dev, ETH_P_AF_IUCV, NULL, NULL, skb->len);
+
 	if (!(skb->dev->flags & IFF_UP) || !netif_carrier_ok(skb->dev)) {
 		err = -ENETDOWN;
 		goto err_free;
@@ -367,6 +371,8 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 		skb_trim(skb, skb->dev->mtu);
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
+
+	__skb_header_release(skb);
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb) {
 		err = -ENOMEM;
@@ -466,12 +472,14 @@ static void iucv_sever_path(struct sock *sk, int with_user_data)
 /* Send controlling flags through an IUCV socket for HIPER transport */
 static int iucv_send_ctrl(struct sock *sk, u8 flags)
 {
+	struct iucv_sock *iucv = iucv_sk(sk);
 	int err = 0;
 	int blen;
 	struct sk_buff *skb;
 	u8 shutdown = 0;
 
-	blen = sizeof(struct af_iucv_trans_hdr) + ETH_HLEN;
+	blen = sizeof(struct af_iucv_trans_hdr) +
+	       LL_RESERVED_SPACE(iucv->hs_dev);
 	if (sk->sk_shutdown & SEND_SHUTDOWN) {
 		/* controlling flags should be sent anyway */
 		shutdown = sk->sk_shutdown;
@@ -1131,7 +1139,8 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	 * segmented records using the MSG_EOR flag), but
 	 * for SOCK_STREAM we might want to improve it in future */
 	if (iucv->transport == AF_IUCV_TRANS_HIPER) {
-		headroom = sizeof(struct af_iucv_trans_hdr) + ETH_HLEN;
+		headroom = sizeof(struct af_iucv_trans_hdr) +
+			   LL_RESERVED_SPACE(iucv->hs_dev);
 		linear = len;
 	} else {
 		if (len < PAGE_SIZE) {
-- 
2.20.1

