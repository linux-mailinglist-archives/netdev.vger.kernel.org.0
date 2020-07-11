Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879B221C422
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 14:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgGKMJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 08:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgGKMJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 08:09:03 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01812C08C5DD;
        Sat, 11 Jul 2020 05:09:02 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g2so4674420lfb.0;
        Sat, 11 Jul 2020 05:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwdLWNBKzdjz++dbZsOrtCanbz1z5iZ74y8YlMyxvhY=;
        b=UGiVgkX33zsA5zg0vtKXFB9vjLMYCixsqmKwVIAyiGdcpo6choVUzd6xPP6J6bFuTz
         6MxlNtF+DpPQm6QFcjQU1S8Ig1IpTTfdd8Ocp3wSIswgssUwy5IjT5tXDN4pH6TkO02n
         ofaySMRPnH9n4+v3v54U1DR3cI9dCiCb96zygDtQV6stl/sIxcd7ybG3pVX2sVXSgBqM
         GmHOs05qO+xyOoTMQB20DqOfOnrxOV6UXAj197EDRFvLm6jWUFoknT9+sRHaPsJ8phFn
         At18iW9JWc/iRLjtJtBxnnZzhREAEA5z12lTrv9WE8Ld5iAWQ6Jq1iJE31DGxxQeVvqr
         M4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwdLWNBKzdjz++dbZsOrtCanbz1z5iZ74y8YlMyxvhY=;
        b=r2aAr0zrlsqfW7wbVPA9bjBCvBJNU4Qjj3jZlVYRie04VckOG/myUvqa8PWYz4lWmO
         JxdOfOu67uxF4kdJt3EdQjedYnv0hP9v+HTX8XhECZfZRQwm48qxzfwgPDECohdgdgda
         ihY//2iuX022uzIrXliK8tsWW3JIgeOVLUfMuJPpBr4UBpmHWKQfBLEfKZnpiFP2mEGV
         peBZ286nTRpuzfCZSfhSFMiTlRfocwZNQuv9AAzKYWMWk+qXaBxo/AXPnGxm75plGIb+
         UyNChGQCg4IcvHK08A2odI/t7jlHStSlSf3hxzdeIWFVVtbBNnBmblZYFn6TMJhpZcrY
         nTTA==
X-Gm-Message-State: AOAM530lMmJ8jBtfxKtn432dDIUC4sIY2H9Jir2wQ+JtNDsaCDPXyFFL
        WlgrEtDDBRBq5V3iI0rtDQzXl+0m
X-Google-Smtp-Source: ABdhPJx1LyWwIM/u3ZPjJPXz8P5aMR+vzKzgS9s2fpe2mSR5vzSjEUou2b/dcazr263T8ozRRGBp9Q==
X-Received: by 2002:a05:6512:52a:: with SMTP id o10mr46421156lfc.137.1594469340841;
        Sat, 11 Jul 2020 05:09:00 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m14sm4581974lfp.18.2020.07.11.05.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2020 05:08:59 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH v2 net] net: fec: fix hardware time stamping by external devices
Date:   Sat, 11 Jul 2020 15:08:42 +0300
Message-Id: <20200711120842.2631-1-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706142616.25192-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix support for external PTP-aware devices such as DSA or PTP PHY:

Make sure we never time stamp tx packets when hardware time stamping
is disabled.

Check for PTP PHY being in use and then pass ioctls related to time
stamping of Ethernet packets to the PTP PHY rather than handle them
ourselves. In addition, disable our own hardware time stamping in this
case.

Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")
Signed-off-by: Sergey Organov <sorganov@gmail.com>
---

v2:
  - Extracted from larger patch series
  - Description/comments updated according to discussions
  - Added Fixes: tag

 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++++++++++------
 drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index d8d76da..832a217 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -590,6 +590,7 @@ struct fec_enet_private {
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
 void fec_ptp_stop(struct platform_device *pdev);
 void fec_ptp_start_cyclecounter(struct net_device *ndev);
+void fec_ptp_disable_hwts(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3982285..cc7fbfc 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1294,8 +1294,13 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 			ndev->stats.tx_bytes += skb->len;
 		}
 
-		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
-			fep->bufdesc_ex) {
+		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
+		 * are to time stamp the packet, so we still need to check time
+		 * stamping enabled flag.
+		 */
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS &&
+			     fep->hwts_tx_en) &&
+		    fep->bufdesc_ex) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
 
@@ -2723,10 +2728,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 		return -ENODEV;
 
 	if (fep->bufdesc_ex) {
-		if (cmd == SIOCSHWTSTAMP)
-			return fec_ptp_set(ndev, rq);
-		if (cmd == SIOCGHWTSTAMP)
-			return fec_ptp_get(ndev, rq);
+		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
+
+		if (cmd == SIOCSHWTSTAMP) {
+			if (use_fec_hwts)
+				return fec_ptp_set(ndev, rq);
+			fec_ptp_disable_hwts(ndev);
+		} else if (cmd == SIOCGHWTSTAMP) {
+			if (use_fec_hwts)
+				return fec_ptp_get(ndev, rq);
+		}
 	}
 
 	return phy_mii_ioctl(phydev, rq, cmd);
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 945643c..f8a592c 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -452,6 +452,18 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 	return -EOPNOTSUPP;
 }
 
+/**
+ * fec_ptp_disable_hwts - disable hardware time stamping
+ * @ndev: pointer to net_device
+ */
+void fec_ptp_disable_hwts(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	fep->hwts_tx_en = 0;
+	fep->hwts_rx_en = 0;
+}
+
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-- 
2.10.0.1.g57b01a3

