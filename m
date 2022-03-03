Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1314B4CC385
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiCCRQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiCCRQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DB5199D44
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:20 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ma4J9ocKpCHf06EncgSsmQwBMmUomI5W80Q4vzDVqt4=;
        b=gBkasA8X12HzhBufYeEYVZ8eQ6FXI3N94zaNcv9rgy9vkSA4GJuacTZEWGLVSFhN2OrEjN
        ZWHGLlhn75XfWSJqminWviu+dV/0m3eItDVybJbIsTbhFC7R6IAM0Tom86NFU4MblV/U5z
        NFm8mqO9OL9f7Zx98cjhbM7pP8VPYB61YYiV99Jr7jwETPv5zuhAuAXPUhyRtOjFM99pUa
        rV76bcd+GER6i9lnFfZSR83kuQOVPAX7AV9wEsca7ZZGQ482O4bLxxHD5mTcm+0HHjt8D5
        QIt/OuOb0qo5ikZKI7ou7PGQQ9pjgC8/6OAXnbfKtUQcLktu5MDt4FhVe1U47Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ma4J9ocKpCHf06EncgSsmQwBMmUomI5W80Q4vzDVqt4=;
        b=euYUfly+1sCmj9kU9rxCHefUOZCAv/UeT3zkKFXUbkrjSHGnVM+mFDtydBzy/sYdiFlM1b
        f+jKNtdUr3O7YrCA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 7/9] net: macvlan: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:15:03 +0100
Message-Id: <20220303171505.1604775-8-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-1-bigeasy@linutronix.de>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
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

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d87c06c317ede..33753a2fde292 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -285,7 +285,7 @@ static void macvlan_broadcast(struct sk_buff *skb,
 		if (likely(nskb))
 			err =3D macvlan_broadcast_one(nskb, vlan, eth,
 					mode =3D=3D MACVLAN_MODE_BRIDGE) ?:
-			      netif_rx_ni(nskb);
+			      netif_rx(nskb);
 		macvlan_count_rx(vlan, skb->len + ETH_HLEN,
 				 err =3D=3D NET_RX_SUCCESS, true);
 	}
--=20
2.35.1

