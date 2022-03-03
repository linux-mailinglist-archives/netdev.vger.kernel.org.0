Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834B64CC37F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiCCRQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbiCCRQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B193197B58
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:19 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwygLdXkmKhmmrSQtJBJgNajuAtGjMghtrXBMYbmki4=;
        b=OOn+2InW0uZutIiZKF9FvTGEKyjVE8AH5DnSdqOzz701GppqsO/8k775Nxgn4vM1nQ4EhM
        Iw3BahTyxnuU2vcuMHjc8EKr/m9g1uG21fATL7Qfm6XbB8cLOLktKOA8memSHFDb0Ql1UL
        9r34FBvWNXbWyKDzUn/QY9OrPL/EFM6W8l5uLnhPqs59DzxlY8prIR3FETyX0fHT4USvsq
        wektw0VQoBgnosImiTVQQeSh3Jp6NfDFflaC1Wyq/+r2J06pp/cSYcTMlkjO8aOQ0gws3i
        +5dl7+NKJE2+HWLA9FkISiMfPbUvYpide2xD7U0WVzBivF7uSuEkOU+yibQbDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwygLdXkmKhmmrSQtJBJgNajuAtGjMghtrXBMYbmki4=;
        b=KCfReICS1CGplPZMe1l1rTpEnZxmUlTXbFHv/uPNG1Yx26cLZeqzFFUT4/jbJz0gbL0eEb
        0VmZKY3ZSmdAnLCQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/9] net: dsa: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:15:01 +0100
Message-Id: <20220303171505.1604775-6-bigeasy@linutronix.de>
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

Cc: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c | 2 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c            | 2 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c b/drivers/net/=
dsa/hirschmann/hellcreek_hwtstamp.c
index b3bc948d6145b..ffd06cf8c44f0 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
@@ -331,7 +331,7 @@ static void hellcreek_get_rxts(struct hellcreek *hellcr=
eek,
 		shwt =3D skb_hwtstamps(skb);
 		memset(shwt, 0, sizeof(*shwt));
 		shwt->hwtstamp =3D ns_to_ktime(ns);
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 }
=20
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6x=
xx/hwtstamp.c
index 389f8a6ec0ab3..331b4ca089ffa 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -301,7 +301,7 @@ static void mv88e6xxx_get_rxts(struct mv88e6xxx_chip *c=
hip,
 			shwt->hwtstamp =3D ns_to_ktime(ns);
 			status &=3D ~MV88E6XXX_PTP_TS_VALID;
 		}
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 }
=20
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja110=
5/sja1105_ptp.c
index be3068a935af5..30fb2cc40164b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -399,7 +399,7 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info=
 *ptp)
 		ts =3D sja1105_tstamp_reconstruct(ds, ticks, ts);
=20
 		shwt->hwtstamp =3D ns_to_ktime(sja1105_ticks_to_ns(ts));
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
=20
 	if (ptp_data->extts_enabled)
--=20
2.35.1

