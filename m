Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C5E6B86FB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCNAgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCNAg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:36:28 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E552A81CEB;
        Mon, 13 Mar 2023 17:36:17 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id c18so15209188qte.5;
        Mon, 13 Mar 2023 17:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zP6/6VellR9zpNG91XRLqE0O91bPnn3bDhnGg/ksvAE=;
        b=llJQtWjO2TuusC3nq4QIeeMkkvVsBTHnmTLu8mYb3F8h8petY2P5Ku5cZ5rKxjv0tr
         1LJvyCUpCjUaDkEjOv3P0HrgyfgL0KuWXWTqVD52lpcT8eP3cFk89PyTka5oFUOmyHr1
         8qMJUcjHGDPxh+kWq3r5zf8x67wZgMwuwWrhz070IgMlYgYocC7mzhML01pwKjysX8oo
         ZNd8tphQ9NwW5BrtPoMJg5RipM8O4W7mXDl5VBFBRsHLLe3qYrYK2cADPcQkRQFPrJdr
         Y4BY400icOkjQzrsu3bFEcCD5l+Ra5O32QWlUwG14vNGhN0uC3GAl5aQA58ijsTe9qcR
         DF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zP6/6VellR9zpNG91XRLqE0O91bPnn3bDhnGg/ksvAE=;
        b=ajWxDjZCzcp+L1djKCNKu0/8I0NytRdRldB/gYVSZ+HLmwyUkZatxVsOVEMOL/tP37
         Rgw1/ZHSpIXP+9EavDknw4NawkeChaNnusn5LwXfs/fPdtfVh/WqAMx2ZWDRxg4eauzV
         5cmJ8cjzU7wAtfh7WmZwdJWkTsJEkcSvfMTM1b2WEIw7ptrfRGq/NdAI4pb0Mom2LXMK
         MUyJlEFtJA4OzMFNa1w22TA5en+anDY/rMZ5wATwUPW8KodQqegQLMRYSGsC3y4u/Vij
         EPo2dpcQ/nToGLLmiG8vwGqejLhfDEuhjuIdo00Jfowa7rB3B9dibr0Dyjse0E5H1/Uj
         FbBA==
X-Gm-Message-State: AO0yUKX9ucL9H4F7E5B8t0LIucuj44KdCPgrsEVuSx01hEKsqXW1yR6+
        rLC3IVCyfXP0thOpG9fyWBE=
X-Google-Smtp-Source: AK7set8wRZ8VEWUH4Bi1e0FZFprHbxSbRHwSUYAgUQ50xJfgBUENbVDRtfNnZ74aqoB6Xa/wfzdnPw==
X-Received: by 2002:a05:622a:453:b0:3bf:d9ee:882d with SMTP id o19-20020a05622a045300b003bfd9ee882dmr64747995qtx.40.1678754176935;
        Mon, 13 Mar 2023 17:36:16 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id c13-20020ac87dcd000000b003b835e7e283sm836248qte.44.2023.03.13.17.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:16 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v3 1/9] net: sunhme: Just restart autonegotiation if we can't bring the link up
Date:   Mon, 13 Mar 2023 20:36:05 -0400
Message-Id: <20230314003613.3874089-2-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230314003613.3874089-1-seanga2@gmail.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we've tried regular autonegotiation and forcing the link mode, just
restart autonegotiation instead of reinitializing the whole NIC.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v2)

Changes in v2:
- Move happy_meal_begin_auto_negotiation earlier and remove forward declaration

 drivers/net/ethernet/sun/sunhme.c | 245 +++++++++++++++---------------
 1 file changed, 119 insertions(+), 126 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b0c7ab74a82e..65733ee5ddd9 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -589,8 +589,6 @@ static int set_happy_link_modes(struct happy_meal *hp, void __iomem *tregs)
 	return 1;
 }
 
-static int happy_meal_init(struct happy_meal *hp);
-
 static int is_lucent_phy(struct happy_meal *hp)
 {
 	void __iomem *tregs = hp->tcvregs;
@@ -606,6 +604,124 @@ static int is_lucent_phy(struct happy_meal *hp)
 	return ret;
 }
 
+/* hp->happy_lock must be held */
+static void
+happy_meal_begin_auto_negotiation(struct happy_meal *hp,
+				  void __iomem *tregs,
+				  const struct ethtool_link_ksettings *ep)
+{
+	int timeout;
+
+	/* Read all of the registers we are interested in now. */
+	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
+	hp->sw_bmcr      = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
+	hp->sw_physid1   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID1);
+	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
+
+	/* XXX Check BMSR_ANEGCAPABLE, should not be necessary though. */
+
+	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
+	if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
+		/* Advertise everything we can support. */
+		if (hp->sw_bmsr & BMSR_10HALF)
+			hp->sw_advertise |= (ADVERTISE_10HALF);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_10HALF);
+
+		if (hp->sw_bmsr & BMSR_10FULL)
+			hp->sw_advertise |= (ADVERTISE_10FULL);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_10FULL);
+		if (hp->sw_bmsr & BMSR_100HALF)
+			hp->sw_advertise |= (ADVERTISE_100HALF);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_100HALF);
+		if (hp->sw_bmsr & BMSR_100FULL)
+			hp->sw_advertise |= (ADVERTISE_100FULL);
+		else
+			hp->sw_advertise &= ~(ADVERTISE_100FULL);
+		happy_meal_tcvr_write(hp, tregs, MII_ADVERTISE, hp->sw_advertise);
+
+		/* XXX Currently no Happy Meal cards I know off support 100BaseT4,
+		 * XXX and this is because the DP83840 does not support it, changes
+		 * XXX would need to be made to the tx/rx logic in the driver as well
+		 * XXX so I completely skip checking for it in the BMSR for now.
+		 */
+
+		ASD("Advertising [ %s%s%s%s]\n",
+		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
+		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
+		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
+		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
+
+		/* Enable Auto-Negotiation, this is usually on already... */
+		hp->sw_bmcr |= BMCR_ANENABLE;
+		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
+
+		/* Restart it to make sure it is going. */
+		hp->sw_bmcr |= BMCR_ANRESTART;
+		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
+
+		/* BMCR_ANRESTART self clears when the process has begun. */
+
+		timeout = 64;  /* More than enough. */
+		while (--timeout) {
+			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
+			if (!(hp->sw_bmcr & BMCR_ANRESTART))
+				break; /* got it. */
+			udelay(10);
+		}
+		if (!timeout) {
+			netdev_err(hp->dev,
+				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
+				   hp->sw_bmcr);
+			netdev_notice(hp->dev,
+				      "Performing force link detection.\n");
+			goto force_link;
+		} else {
+			hp->timer_state = arbwait;
+		}
+	} else {
+force_link:
+		/* Force the link up, trying first a particular mode.
+		 * Either we are here at the request of ethtool or
+		 * because the Happy Meal would not start to autoneg.
+		 */
+
+		/* Disable auto-negotiation in BMCR, enable the duplex and
+		 * speed setting, init the timer state machine, and fire it off.
+		 */
+		if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
+			hp->sw_bmcr = BMCR_SPEED100;
+		} else {
+			if (ep->base.speed == SPEED_100)
+				hp->sw_bmcr = BMCR_SPEED100;
+			else
+				hp->sw_bmcr = 0;
+			if (ep->base.duplex == DUPLEX_FULL)
+				hp->sw_bmcr |= BMCR_FULLDPLX;
+		}
+		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
+
+		if (!is_lucent_phy(hp)) {
+			/* OK, seems we need do disable the transceiver for the first
+			 * tick to make sure we get an accurate link state at the
+			 * second tick.
+			 */
+			hp->sw_csconfig = happy_meal_tcvr_read(hp, tregs,
+							       DP83840_CSCONFIG);
+			hp->sw_csconfig &= ~(CSCONFIG_TCVDISAB);
+			happy_meal_tcvr_write(hp, tregs, DP83840_CSCONFIG,
+					      hp->sw_csconfig);
+		}
+		hp->timer_state = ltrywait;
+	}
+
+	hp->timer_ticks = 0;
+	hp->happy_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
+	add_timer(&hp->happy_timer);
+}
+
 static void happy_meal_timer(struct timer_list *t)
 {
 	struct happy_meal *hp = from_timer(hp, t, happy_timer);
@@ -743,12 +859,7 @@ static void happy_meal_timer(struct timer_list *t)
 					netdev_notice(hp->dev,
 						      "Link down, cable problem?\n");
 
-					ret = happy_meal_init(hp);
-					if (ret) {
-						/* ho hum... */
-						netdev_err(hp->dev,
-							   "Error, cannot re-init the Happy Meal.\n");
-					}
+					happy_meal_begin_auto_negotiation(hp, tregs, NULL);
 					goto out;
 				}
 				if (!is_lucent_phy(hp)) {
@@ -1201,124 +1312,6 @@ static void happy_meal_init_rings(struct happy_meal *hp)
 	HMD("done\n");
 }
 
-/* hp->happy_lock must be held */
-static void
-happy_meal_begin_auto_negotiation(struct happy_meal *hp,
-				  void __iomem *tregs,
-				  const struct ethtool_link_ksettings *ep)
-{
-	int timeout;
-
-	/* Read all of the registers we are interested in now. */
-	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
-	hp->sw_bmcr      = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-	hp->sw_physid1   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID1);
-	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
-
-	/* XXX Check BMSR_ANEGCAPABLE, should not be necessary though. */
-
-	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
-	if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
-		/* Advertise everything we can support. */
-		if (hp->sw_bmsr & BMSR_10HALF)
-			hp->sw_advertise |= (ADVERTISE_10HALF);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_10HALF);
-
-		if (hp->sw_bmsr & BMSR_10FULL)
-			hp->sw_advertise |= (ADVERTISE_10FULL);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_10FULL);
-		if (hp->sw_bmsr & BMSR_100HALF)
-			hp->sw_advertise |= (ADVERTISE_100HALF);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_100HALF);
-		if (hp->sw_bmsr & BMSR_100FULL)
-			hp->sw_advertise |= (ADVERTISE_100FULL);
-		else
-			hp->sw_advertise &= ~(ADVERTISE_100FULL);
-		happy_meal_tcvr_write(hp, tregs, MII_ADVERTISE, hp->sw_advertise);
-
-		/* XXX Currently no Happy Meal cards I know off support 100BaseT4,
-		 * XXX and this is because the DP83840 does not support it, changes
-		 * XXX would need to be made to the tx/rx logic in the driver as well
-		 * XXX so I completely skip checking for it in the BMSR for now.
-		 */
-
-		ASD("Advertising [ %s%s%s%s]\n",
-		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
-		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
-		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
-		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
-
-		/* Enable Auto-Negotiation, this is usually on already... */
-		hp->sw_bmcr |= BMCR_ANENABLE;
-		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-		/* Restart it to make sure it is going. */
-		hp->sw_bmcr |= BMCR_ANRESTART;
-		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-		/* BMCR_ANRESTART self clears when the process has begun. */
-
-		timeout = 64;  /* More than enough. */
-		while (--timeout) {
-			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-			if (!(hp->sw_bmcr & BMCR_ANRESTART))
-				break; /* got it. */
-			udelay(10);
-		}
-		if (!timeout) {
-			netdev_err(hp->dev,
-				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
-				   hp->sw_bmcr);
-			netdev_notice(hp->dev,
-				      "Performing force link detection.\n");
-			goto force_link;
-		} else {
-			hp->timer_state = arbwait;
-		}
-	} else {
-force_link:
-		/* Force the link up, trying first a particular mode.
-		 * Either we are here at the request of ethtool or
-		 * because the Happy Meal would not start to autoneg.
-		 */
-
-		/* Disable auto-negotiation in BMCR, enable the duplex and
-		 * speed setting, init the timer state machine, and fire it off.
-		 */
-		if (!ep || ep->base.autoneg == AUTONEG_ENABLE) {
-			hp->sw_bmcr = BMCR_SPEED100;
-		} else {
-			if (ep->base.speed == SPEED_100)
-				hp->sw_bmcr = BMCR_SPEED100;
-			else
-				hp->sw_bmcr = 0;
-			if (ep->base.duplex == DUPLEX_FULL)
-				hp->sw_bmcr |= BMCR_FULLDPLX;
-		}
-		happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-		if (!is_lucent_phy(hp)) {
-			/* OK, seems we need do disable the transceiver for the first
-			 * tick to make sure we get an accurate link state at the
-			 * second tick.
-			 */
-			hp->sw_csconfig = happy_meal_tcvr_read(hp, tregs,
-							       DP83840_CSCONFIG);
-			hp->sw_csconfig &= ~(CSCONFIG_TCVDISAB);
-			happy_meal_tcvr_write(hp, tregs, DP83840_CSCONFIG,
-					      hp->sw_csconfig);
-		}
-		hp->timer_state = ltrywait;
-	}
-
-	hp->timer_ticks = 0;
-	hp->happy_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
-	add_timer(&hp->happy_timer);
-}
-
 /* hp->happy_lock must be held */
 static int happy_meal_init(struct happy_meal *hp)
 {
-- 
2.37.1

