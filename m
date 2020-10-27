Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFCC29CC66
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832552AbgJ0W4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:56:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50078 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1822300AbgJ0Wzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:54 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mqMN4ct9VbfHqkFKNiMKAw2F6YYZ02CQk7qh9a7Lg6A=;
        b=fx5mIpQNf24U4OKtffNf9Wx02FQrkLRTetizyvfAXrbeWdNEOAM2YgkMLanZFK51opIXP/
        ht8Cb1LUWkJGi7cSpliYshIYT52WrVcVf/0Gox0l1wlFcE53nKSX+2CokYhxqgpt9vXhO8
        ENu95JqaoJDpxG1oTteDugBZtS33STVYV8JgCFBnkF6MCFgR83L00HjjJptOf900x1oadV
        s8ku6a2pCLtC6oySCmxKF5sWmw5RL76lfGGuvX1wXRcGO0gD0GTOHN6qHf/5SsS7Q78lMy
        lEtbvwp5O/rXYrGfai16ntN90coQz052mVktHDfiKLm8Xc3tFycNvJ7AvxuPbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mqMN4ct9VbfHqkFKNiMKAw2F6YYZ02CQk7qh9a7Lg6A=;
        b=4fdK0Siy7UlwpuqDN1Jmg/r5/WOGzHcjo/YM4lJ802RgjezqZ/22VTwf/TimbgjRPnzsTk
        V9/4+4XMOa9YvSAw==
To:     netdev@vger.kernel.org
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 06/15] net: airo: Invoke airo_read_wireless_stats() directly
Date:   Tue, 27 Oct 2020 23:54:45 +0100
Message-Id: <20201027225454.3492351-7-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

airo_get_wireless_stats() is the iw_handler_if::get_wireless_stats()
callback of this driver. This callback was not allowed to sleep until
commit a160ee69c6a46 ("wext: let get_wireless_stats() sleep") in v2.6.32.

airo still delegates the readout to a thread, which is not longer
necessary.

Invoke airo_read_wireless_stats() directly from the callback and remove
the now unused JOB_WSTATS handling.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/cisco/airo.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco=
/airo.c
index 87b9398b03fd4..ca423f3b6b3ea 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -1144,7 +1144,6 @@ static int airo_thread(void *data);
 static void timer_func(struct net_device *dev);
 static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static struct iw_statistics *airo_get_wireless_stats(struct net_device *de=
v);
-static void airo_read_wireless_stats(struct airo_info *local);
 #ifdef CISCO_EXT
 static int readrids(struct net_device *dev, aironet_ioctl *comp);
 static int writerids(struct net_device *dev, aironet_ioctl *comp);
@@ -1200,7 +1199,6 @@ struct airo_info {
 #define JOB_MIC	5
 #define JOB_EVENT	6
 #define JOB_AUTOWEP	7
-#define JOB_WSTATS	8
 #define JOB_SCAN_RESULTS  9
 	unsigned long jobs;
 	int (*bap_read)(struct airo_info*, __le16 *pu16Dst, int bytelen,
@@ -3155,8 +3153,6 @@ static int airo_thread(void *data)
 			airo_end_xmit11(dev);
 		else if (test_bit(JOB_STATS, &ai->jobs))
 			airo_read_stats(dev);
-		else if (test_bit(JOB_WSTATS, &ai->jobs))
-			airo_read_wireless_stats(ai);
 		else if (test_bit(JOB_PROMISC, &ai->jobs))
 			airo_set_promisc(ai);
 		else if (test_bit(JOB_MIC, &ai->jobs))
@@ -7732,15 +7728,12 @@ static void airo_read_wireless_stats(struct airo_in=
fo *local)
 	__le32 *vals =3D stats_rid.vals;
=20
 	/* Get stats out of the card */
-	clear_bit(JOB_WSTATS, &local->jobs);
-	if (local->power.event) {
-		up(&local->sem);
+	if (local->power.event)
 		return;
-	}
+
 	readCapabilityRid(local, &cap_rid, 0);
 	readStatusRid(local, &status_rid, 0);
 	readStatsRid(local, &stats_rid, RID_STATS, 0);
-	up(&local->sem);
=20
 	/* The status */
 	local->wstats.status =3D le16_to_cpu(status_rid.mode);
@@ -7783,15 +7776,10 @@ static struct iw_statistics *airo_get_wireless_stat=
s(struct net_device *dev)
 {
 	struct airo_info *local =3D  dev->ml_priv;
=20
-	if (!test_bit(JOB_WSTATS, &local->jobs)) {
-		/* Get stats out of the card if available */
-		if (down_trylock(&local->sem) !=3D 0) {
-			set_bit(JOB_WSTATS, &local->jobs);
-			wake_up_interruptible(&local->thr_wait);
-		} else
-			airo_read_wireless_stats(local);
+	if (!down_interruptible(&local->sem)) {
+		airo_read_wireless_stats(local);
+		up(&local->sem);
 	}
-
 	return &local->wstats;
 }
=20
--=20
2.28.0

