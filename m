Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B724CEE09
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiCFV7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiCFV65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3011C10B;
        Sun,  6 Mar 2022 13:58:03 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5mJtRIowvgYZCiSTq+NtxJb9H6gCqcNXdX+dpkXf+g=;
        b=cqZBGB7x5Qf0QYHo+lrfj9zTEh35gmXe4IkRFTr2FwoK2Z+iCLNL2qFOF9AIPb4DOq7Syo
        KEfmnSmGFyZImPECArA2blbT+kOUqQK59ZZ/j3uBIIt1znHhRB/JmA3Ped/7LMsS0nyeiJ
        fb4WL8jPeInCtkmc6zDyfTlob4YFJmf0s4YS1vD+68NjiTY3jGcxYzR5M188zxw5T/BU2l
        HSb/F2r+LkO89MBxyZrbdglxLJo35vKaNYITYIgsjP6nNw6nyhbdJblkLmrJblF0ZvZvbz
        i5Uj0vP/Mp3dRBnyua7snpkFXoGNGgFuRhaXB58sRpSK+TKOVBnMSIlz6Zyk0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D5mJtRIowvgYZCiSTq+NtxJb9H6gCqcNXdX+dpkXf+g=;
        b=HBtNd4/Tyx6e/nI6Vj+ACCCp8y6y2dvib57iQ0IhcmSk4+J0KPZZxJ/NgdMfe9pxAEe9bQ
        Y7XCwMu1K4SkqxCw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH net-next 01/10] s390: net: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:44 +0100
Message-Id: <20220306215753.3156276-2-bigeasy@linutronix.de>
In-Reply-To: <20220306215753.3156276-1-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any co=
ntext.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/s390/net/ctcm_main.c | 2 +-
 drivers/s390/net/netiucv.c   | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 5ea7eeb07002b..e0fdd54bfeb70 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -166,7 +166,7 @@ void ctcm_unpack_skb(struct channel *ch, struct sk_buff=
 *pskb)
 		ch->logflags =3D 0;
 		priv->stats.rx_packets++;
 		priv->stats.rx_bytes +=3D skblen;
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		if (len > 0) {
 			skb_pull(pskb, header->length);
 			if (skb_tailroom(pskb) < LL_HEADER_LENGTH) {
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 981e7b1c6b962..65aa0a96c21de 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -620,11 +620,7 @@ static void netiucv_unpack_skb(struct iucv_connection =
*conn,
 		pskb->ip_summed =3D CHECKSUM_UNNECESSARY;
 		privptr->stats.rx_packets++;
 		privptr->stats.rx_bytes +=3D skb->len;
-		/*
-		 * Since receiving is always initiated from a tasklet (in iucv.c),
-		 * we must use netif_rx_ni() instead of netif_rx()
-		 */
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		skb_pull(pskb, header->next);
 		skb_put(pskb, NETIUCV_HDRLEN);
 	}
--=20
2.35.1

