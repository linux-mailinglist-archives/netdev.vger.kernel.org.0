Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8B21866F
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgGHLyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbgGHLye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:34 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD803C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:33 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l17so2695432wmj.0
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2lgGhWm/oJuw47XOXOHbRgrseJqHuXdyPFaBeSlAbrI=;
        b=LAWiPTW7ImfD6RbMdJS9+EtTpJsmpvzgGr5gytcZZCFC/NjI2lvES/5MO2F3d0onK5
         MfwnQ9BRke/uqbVqzaUt+4skjt+GCFdRwU7pG+pQjymsNnzKWXHUU7uZRFgWIBk0f81y
         Fxmc8FKiIz+qU5CNv2JxFD18pClG1DrVpYMlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2lgGhWm/oJuw47XOXOHbRgrseJqHuXdyPFaBeSlAbrI=;
        b=hclZOKRaUEdbF9weeMXx2f9L/CeYucZ22aKpCWNL2mNiFStW08IJI5euQxnoxiGDnL
         4QuH5SiabUb75Z/iCLjqE211afSI/vp7qvap429nGubQ69fpi7UK4AS/VEKUQUnFjgor
         g/tO7rfpQP4MZE4l4x2hotPH/CbzUt5JA4raehoeaKfej3wDAQPmiUw7sIHWbShOQzug
         K9t7DOYY43gkYoK4FxNSHt1wS7/WlR41DevUISHosX6xQrHpxSeBUo6EL1+UXnyOKpoN
         zxoPmLWqlYrMB+71qdaKEjNhhnRChZ6XCE6zDvoPxX5jDicEd0CVcFVkbPYi7kip0bhF
         mWnw==
X-Gm-Message-State: AOAM5338S7EkXAGOZyXDzTy41k/mvD3lfQGpCguWy/O5O6KVYj5Md1PX
        XMWx+QNaqpPkYbwmiUerT8q8jw==
X-Google-Smtp-Source: ABdhPJw9G+lbpOj7fzbFt+U44O6r1SMKCsFaQ7uCDwMrddbrkRJdaU6W5TOHvrqDBQp2jpmpFzLT1Q==
X-Received: by 2002:a1c:f609:: with SMTP id w9mr8981390wmc.150.1594209272355;
        Wed, 08 Jul 2020 04:54:32 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:31 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 7/9] bnxt_en: Implement ethtool -X to set indirection table.
Date:   Wed,  8 Jul 2020 07:53:59 -0400
Message-Id: <1594209241-1692-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new infrastructure in place, we can now support the setting of
the indirection table from ethtool.

When changing channels, in a rare case that firmware cannot reserve the
rings that were promised, we will still try to keep the RSS map and only
revert to default when absolutely necessary.

v4: Revert RSS map to default during ring change only when absolutely
    necessary.

v3: Add warning messages when firmware cannot reserve the requested RX
    rings, and when the RSS table entries have to change to default.

v2: When changing channels, if the RSS table size changes and RSS map
    is non-default, return error.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 31 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 37 +++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fcb7bf2..f3e45f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4869,6 +4869,19 @@ static void bnxt_set_dflt_rss_indir_tbl(struct bnxt *bp)
 		memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
 }
 
+static u16 bnxt_get_max_rss_ring(struct bnxt *bp)
+{
+	u16 i, tbl_size, max_ring = 0;
+
+	if (!bp->rss_indir_tbl)
+		return 0;
+
+	tbl_size = bnxt_get_rxfh_indir_size(bp->dev);
+	for (i = 0; i < tbl_size; i++)
+		max_ring = max(max_ring, bp->rss_indir_tbl[i]);
+	return max_ring;
+}
+
 int bnxt_get_nr_rss_ctxs(struct bnxt *bp, int rx_rings)
 {
 	if (bp->flags & BNXT_FLAG_CHIP_P5)
@@ -6058,6 +6071,21 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		rx = rx_rings << 1;
 	cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
 	bp->tx_nr_rings = tx;
+
+	/* If we cannot reserve all the RX rings, reset the RSS map only
+	 * if absolutely necessary
+	 */
+	if (rx_rings != bp->rx_nr_rings) {
+		netdev_warn(bp->dev, "Able to reserve only %d out of %d requested RX rings\n",
+			    rx_rings, bp->rx_nr_rings);
+		if ((bp->dev->priv_flags & IFF_RXFH_CONFIGURED) &&
+		    (bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) !=
+		     bnxt_get_nr_rss_ctxs(bp, rx_rings) ||
+		     bnxt_get_max_rss_ring(bp) >= rx_rings)) {
+			netdev_warn(bp->dev, "RSS table entries reverting to default\n");
+			bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
+		}
+	}
 	bp->rx_nr_rings = rx_rings;
 	bp->cp_nr_rings = cp;
 
@@ -8262,7 +8290,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	}
-	bnxt_set_dflt_rss_indir_tbl(bp);
+	if (!netif_is_rxfh_configured(bp->dev))
+		bnxt_set_dflt_rss_indir_tbl(bp);
 
 	if (rc) {
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 1fe7c61..538c976 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -926,6 +926,13 @@ static int bnxt_set_channels(struct net_device *dev,
 		return rc;
 	}
 
+	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
+	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
+	    (dev->priv_flags & IFF_RXFH_CONFIGURED)) {
+		netdev_warn(dev, "RSS table size change required, RSS table entries must be default to proceed\n");
+		return -EINVAL;
+	}
+
 	if (netif_running(dev)) {
 		if (BNXT_PF(bp)) {
 			/* TODO CHIMP_FW: Send message to all VF's
@@ -1313,6 +1320,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 	return 0;
 }
 
+static int bnxt_set_rxfh(struct net_device *dev, const u32 *indir,
+			 const u8 *key, const u8 hfunc)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	int rc = 0;
+
+	if (hfunc && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	if (key)
+		return -EOPNOTSUPP;
+
+	if (indir) {
+		u32 i, pad, tbl_size = bnxt_get_rxfh_indir_size(dev);
+
+		for (i = 0; i < tbl_size; i++)
+			bp->rss_indir_tbl[i] = indir[i];
+		pad = bp->rss_indir_tbl_entries - tbl_size;
+		if (pad)
+			memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
+	}
+
+	if (netif_running(bp->dev)) {
+		bnxt_close_nic(bp, false, false);
+		rc = bnxt_open_nic(bp, false, false);
+	}
+	return rc;
+}
+
 static void bnxt_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
@@ -3619,6 +3655,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
 	.get_rxfh_indir_size    = bnxt_get_rxfh_indir_size,
 	.get_rxfh_key_size      = bnxt_get_rxfh_key_size,
 	.get_rxfh               = bnxt_get_rxfh,
+	.set_rxfh		= bnxt_set_rxfh,
 	.flash_device		= bnxt_flash_device,
 	.get_eeprom_len         = bnxt_get_eeprom_len,
 	.get_eeprom             = bnxt_get_eeprom,
-- 
1.8.3.1

