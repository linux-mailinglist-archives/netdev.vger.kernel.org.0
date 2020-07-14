Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B518D21F74F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgGNQ2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgGNQ2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 12:28:12 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD717C061755;
        Tue, 14 Jul 2020 09:28:11 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id y18so12189445lfh.11;
        Tue, 14 Jul 2020 09:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q/X/V3rNSVQo1zs/OIkLIXgP3ECAZ9pYuBB0XwYGJSk=;
        b=jCU/PAy0RRUtdHmQ5KGV4wutOmWEOZjx0fusGSx5GvB1T6hZp4UoRm/nqznCiZzjGe
         dU4yw24libFVKR7S9MFV8gkfIHrLoNrcJmhoXYY6voTjyYbpfXPAdfuVMoMKR30ybuLd
         pmsQLTiH3r4th0r4ZvgNRqwQzNjBjYn0hQpyexVbS3ckn5KssPEI18Q1NCnr4gFuoTOV
         p/aIlJzeaE4T0pjZ0fu9R3oMuBXel0b20dFX/FQifD0EFVewsvWAdrBgMatQ/GqpKD0K
         p9D/fQAYTEBuOLjOEZzMfRlm1zs1nIVOeTesgW1ybAmppDDRmpqsBoVxPET4x9HM/fIv
         tzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q/X/V3rNSVQo1zs/OIkLIXgP3ECAZ9pYuBB0XwYGJSk=;
        b=V1obA84dxn5wJ1OJ3VguJOrRU5uGzHMmn7/m/9S2U69kdW40kV5i+WavcVjLqCHE+u
         nf89FBlXPIpItKINSPzEDDJDPS7jfQnPhcvmXAsQtF/UA1M9rdDK0eBlXq+kSZTTaX2/
         emkGn3XmJ3+79xROkJ50EKcgWcLH+0a/JJi3UGD2H2eJ/2l6Voa8gWQq7LzXoFM6rh+R
         aVEWZ1kQ+t26vN9Chr73wGm6vmrxhmtmp/4Uu9Ssw7/H2V99qbwnIxmYTULtzIB/+9gu
         DrVHE3mNJrfU6nTuHklYbE73MfpMzhgNnua4BihMR+lvfwamJ0wltuNudnn+bwo1g53v
         inMA==
X-Gm-Message-State: AOAM533sJcdL/5h8X61vJ7DSV8cG9hRQNt6TJpjSfoOFkW9Vjq5jpNi/
        1rhnG+UpyqljbrRJ3CotGhB0PILv
X-Google-Smtp-Source: ABdhPJzuzZ0nj1a3eKwkyB5HWa7PXh0/DUqRTqp6HSkHm14zJAVkMzVysI69UTVvSF9CLuzHfGiEXA==
X-Received: by 2002:a19:6b16:: with SMTP id d22mr2560245lfa.111.1594744090092;
        Tue, 14 Jul 2020 09:28:10 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id z7sm4751787ljj.33.2020.07.14.09.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 09:28:09 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH v3 net] net: fec: fix hardware time stamping by external devices
Date:   Tue, 14 Jul 2020 19:28:02 +0300
Message-Id: <20200714162802.11926-1-sorganov@gmail.com>
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

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
Signed-off-by: Sergey Organov <sorganov@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Vladimir Oltean <olteanv@gmail.com>
---

v3:
  - Fixed SHA1 length of Fixes: tag
  - Added Acked-by: tags

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

