Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D604CE761
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiCEWOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiCEWOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE7951E78
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 14:13:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtQim/nei+2kqf2tAqTQ+q11Bv6YQqqqJWVJe39idxw=;
        b=GfKa6w7cjhs2+nYmWz5sTNB2uUaKWL/si8E8sj7CFtKS4PXoZu37mysYYVHBxfl6hbdPEG
        cT451GgfieeHbGGSk5lFRM8UUt7hus64oYuw3FtH7LRBhb8wpf318FXOWePEwlI5b48gOi
        1ZpPn+BNFG/DVkT+t5Kap6hxeT7uZCG+LDJIoHyve5CZk5ifZXuEM8mkpsflzYW2MsJcB+
        Y0IfABdogHAEo2ZblO04KdXhANt8t7TOWx7dAui12gsG9v3cvFbUhAonMqI4liD6fYN8bh
        6Asy8I2ZZ00vdKwqUAYGTgK/r08/FFnAwMoCd1wKvP8S6BYWP9abLClInotHSA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtQim/nei+2kqf2tAqTQ+q11Bv6YQqqqJWVJe39idxw=;
        b=Pc0hwWWr1IrRFBi6p3MJcdWctJyMzfEUbwa4kdmPqJlX71Pams+ZFW8gyr1t7c8/K3qc6i
        HDfGj9CU1bbVyMDA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH net-next 3/8] mctp: serial: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:47 +0100
Message-Id: <20220305221252.3063812-4-bigeasy@linutronix.de>
In-Reply-To: <20220305221252.3063812-1-bigeasy@linutronix.de>
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
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

Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/mctp/mctp-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 62723a7faa2d1..7cd103fd34ef7 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -286,7 +286,7 @@ static void mctp_serial_rx(struct mctp_serial *dev)
 	cb =3D __mctp_cb(skb);
 	cb->halen =3D 0;
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 	dev->netdev->stats.rx_packets++;
 	dev->netdev->stats.rx_bytes +=3D dev->rxlen;
 }
--=20
2.35.1

