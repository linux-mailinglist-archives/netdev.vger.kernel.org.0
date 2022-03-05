Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5519B4CE767
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiCEWOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbiCEWOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C1C54BCF;
        Sat,  5 Mar 2022 14:13:20 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhLge7rCtt5N/Hwi3zdBO4SqNA5FgQcg+0ubxgkiGDU=;
        b=O2qPXnm65kgWE1A9Q/3NTjmwxDPJoFHTYRVqpIT/G+4H4Ixk236WTu4EKOa3KXWnGWHQ3S
        HEVLzR4qNkKccNDXXBr69gW5SPvkBTsZgpjGKEA51y0Zvj47cmgYOgPmklMDIAJuVpSbg/
        h3NzIBh1ZtmC++b8v25Iw06fUlAVYAclhVIgGWHz1pMqdOP3UR8xYEnP+tRgti2CadHSLA
        og0gXb0z2Xg6Ww5sj6rk/HcplW24L0Gpe5IUGuSgMMTxfiRRlBx0luHsEHRP4K8S7LloSu
        3dpMnOKhOcH9K1iQdYnJ6mwWM4rwTsLO2+EFYHTp3mBJ5U30/6AB2WnGqL26/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhLge7rCtt5N/Hwi3zdBO4SqNA5FgQcg+0ubxgkiGDU=;
        b=tOlQYWZBEzcga002l3ORouw4Ql0NoLacDwumeFXhmZLQEAtfjOcGkinsoNfx960Cb6iWzq
        v/rHCkLqqRG0w8AA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next 8/8] wireless: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:52 +0100
Message-Id: <20220305221252.3063812-9-bigeasy@linutronix.de>
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

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index e02f1702806e4..63b37f421e102 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2153,7 +2153,7 @@ void cfg80211_send_layer2_update(struct net_device *d=
ev, const u8 *addr)
 	skb->dev =3D dev;
 	skb->protocol =3D eth_type_trans(skb, dev);
 	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
 EXPORT_SYMBOL(cfg80211_send_layer2_update);
=20
--=20
2.35.1

