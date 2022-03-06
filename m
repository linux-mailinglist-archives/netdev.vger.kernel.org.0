Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987104CEE06
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiCFV66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiCFV65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1CB1C109
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:03 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+8slx61Q8ToDW/o7PkKsmbPNBa/MZR5vMCzY38Lg1o=;
        b=vUJZxxDBgM2VdN+goCbz4yIobXy4EQgbm2MLvmROnqEbgh43Vb42YKYNixYiNnLCXCXt/9
        el1Av0rlAuyIeAIVL6rV+91AG+L3vZ6IvgySMmYPt/H87Ig/lxLSQ0J8hhtAgC5LcdQUPP
        KpRwAeszXQU48C2Ld4aUmY5lvjavnvglphtD51CT7GQRZE92oSkC1EiEMohuLdpQoHxQi9
        Fhg8DhVjYv4aNLL0sI7NjiYD97obUGprsdBFYlV0jyFfEHL/500OfXNY933ztlu602N8in
        KBTzziTLBAI3ZVUaw/8AV4r+xq+x8LUIZzJmgrqRECOS0A6nS9f7t+s4XDOzeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+8slx61Q8ToDW/o7PkKsmbPNBa/MZR5vMCzY38Lg1o=;
        b=nDXUPYWsiHR6mBDu90JfZc4ZVCJtFHHkVaT+NfY43fAFi4X6phsuZMFSVL6rhrLzeNeTpH
        6C8rWOUmy7LGGUAw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-staging@lists.linux.dev
Subject: [PATCH net-next 02/10] staging: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:45 +0100
Message-Id: <20220306215753.3156276-3-bigeasy@linutronix.de>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/staging/gdm724x/gdm_lte.c      | 2 +-
 drivers/staging/wlan-ng/p80211netdev.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gd=
m_lte.c
index 493ed4821515b..2587309da766a 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -78,7 +78,7 @@ static int gdm_lte_rx(struct sk_buff *skb, struct nic *ni=
c, int nic_type)
 {
 	int ret;
=20
-	ret =3D netif_rx_ni(skb);
+	ret =3D netif_rx(skb);
 	if (ret =3D=3D NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-=
ng/p80211netdev.c
index 255500448ad3e..e04fc666d218e 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -255,7 +255,7 @@ static int p80211_convert_to_ether(struct wlandevice *w=
landev,
 	if (skb_p80211_to_ether(wlandev, wlandev->ethconv, skb) =3D=3D 0) {
 		wlandev->netdev->stats.rx_packets++;
 		wlandev->netdev->stats.rx_bytes +=3D skb->len;
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		return 0;
 	}
=20
@@ -290,7 +290,7 @@ static void p80211netdev_rx_bh(struct tasklet_struct *t)
=20
 				dev->stats.rx_packets++;
 				dev->stats.rx_bytes +=3D skb->len;
-				netif_rx_ni(skb);
+				netif_rx(skb);
 				continue;
 			} else {
 				if (!p80211_convert_to_ether(wlandev, skb))
--=20
2.35.1

