Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3D21595C
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgGFO0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbgGFO0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:26:41 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49964C061755;
        Mon,  6 Jul 2020 07:26:41 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so29755801ljj.10;
        Mon, 06 Jul 2020 07:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RwfdcJ+V6YCmfZsUtICSv5TzSNqm5bK3Y7NkVCxU1wA=;
        b=b1/kNmRHTrtRuQbfED8auzmOrMxhp6mWrdgGy+28KEavZI7g3kh/SYLeurx5t8x4jC
         iNfVEZHo8FTYeJP2PYwlYK9qdhsYAWpUG+6kOApd4jKgMV0Y6UzQFH616DpHp0vuk/UP
         YH8h6wcRJWQNRi1nsO046A4PO5ow56dcFHA56gr0uJCopqnZlPp4lSikhoMVy35f5WZ9
         wCiQY2lnmgRv1j4HEi3HKqUv6PF3659s+mdKr90QkQ8By/Gzeu0aU5kO2s7g21sI8ShD
         Xpxpn4dXJHuw+jf2w3jkVaQ5ekO5K+/XBQwLmlDtRPL50d7R7qhAZGhoWjAkyKOzwQju
         k4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RwfdcJ+V6YCmfZsUtICSv5TzSNqm5bK3Y7NkVCxU1wA=;
        b=WuQx/ItzxYuCIG8okBJOq1lPgvvk7xoTsUcsFwtgOyaFuYmGS3VI4O9oj+WxcVs4Ii
         HBA36fzfJdhv2dUa230mWK6vApKYrArNG5N7wslZ9YQx5oYrnBw+pAu+4Pv4/elS1lxL
         pA49ERbZuBFju/caEAmL0aUZ5Nnwwhg10+4AkCR+cgdTLmJ0GfJ4IUZh/Waf8MT6OuxM
         9b6qtnzhRQ+9P6ui4xjoQLZ7gl0qzzbBXNjS7etyXERzXBiv1T3djI0v5Af1v4OIM6gf
         ME2iMybN+ZChXIUnr3GhY5iuBlBy34big6cfzMALDpIygwhmeYjYf9dNf+XBOLrMv6ke
         VcJQ==
X-Gm-Message-State: AOAM533tsDItir5+HM22eASzv+GyAmjfkiuCfvo9R1/ZOUGh28k+EC6s
        pni/WXOsf+EElfrpjUyBSLRbYhCX
X-Google-Smtp-Source: ABdhPJx5mdwRnjOEf3xRjNDsLzw2JKTYfU5w2BgKDHCXCt3scMvU9o4o2b++Kck2BPcvCpewoOY4EA==
X-Received: by 2002:a2e:b8c2:: with SMTP id s2mr29262904ljp.368.1594045599506;
        Mon, 06 Jul 2020 07:26:39 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m14sm11744638lfp.18.2020.07.06.07.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:26:39 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH  1/5] net: fec: properly support external PTP PHY for hardware time stamping
Date:   Mon,  6 Jul 2020 17:26:12 +0300
Message-Id: <20200706142616.25192-2-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706142616.25192-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When external PTP-aware PHY is in use, it's that PHY that is to time
stamp network packets, and it's that PHY where configuration requests
of time stamping features are to be routed.

To achieve these goals:

1. Make sure we don't time stamp packets when external PTP PHY is in use

2. Make sure we redirect ioctl() related to time stamping of Ethernet
   packets to connected PTP PHY rather than handle them ourselves

Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 18 ++++++++++++++----
 drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index a6cdd5b6..de9f46a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -595,6 +595,7 @@ struct fec_enet_private {
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
 void fec_ptp_stop(struct platform_device *pdev);
 void fec_ptp_start_cyclecounter(struct net_device *ndev);
+void fec_ptp_disable_hwts(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 2d0d313..995ea2e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1298,7 +1298,11 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 			ndev->stats.tx_bytes += skb->len;
 		}
 
+		/* It could be external PHY that had set SKBTX_IN_PROGRESS, so
+		 * we still need to check it's we who are to time stamp
+		 */
 		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
+		    unlikely(fep->hwts_tx_en) &&
 			fep->bufdesc_ex) {
 			struct skb_shared_hwtstamps shhwtstamps;
 			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
@@ -2755,10 +2759,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
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

