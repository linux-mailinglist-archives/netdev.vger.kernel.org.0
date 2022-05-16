Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF982529244
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348229AbiEPUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348509AbiEPUvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EBA2A702
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIc-00066y-4b
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 353747FB31
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D19807FB24;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5058d906;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net-next 1/9] can: raw: raw_sendmsg(): remove not needed setting of skb->sk
Date:   Mon, 16 May 2022 22:26:17 +0200
Message-Id: <20220516202625.1129281-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516202625.1129281-1-mkl@pengutronix.de>
References: <20220516202625.1129281-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb in raw_sendmsg() is allocated with sock_alloc_send_skb(),
which subsequently calls sock_alloc_send_pskb() -> skb_set_owner_w(),
which assigns "skb->sk = sk".

This patch removes the not needed setting of skb->sk.

Link: https://lore.kernel.org/all/20220502091946.1916211-2-mkl@pengutronix.de
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/raw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index b7dbb57557f3..1a68efae43c2 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -820,7 +820,6 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	skb_setup_tx_timestamp(skb, sk->sk_tsflags);
 
 	skb->dev = dev;
-	skb->sk = sk;
 	skb->priority = sk->sk_priority;
 
 	err = can_send(skb, ro->loopback);

base-commit: d887ae3247e022183f244cb325dca1dfbd0a9ed0
-- 
2.35.1


