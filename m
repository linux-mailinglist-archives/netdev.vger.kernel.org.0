Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84793369C5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhCKBgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCKBgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:36:06 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432F3C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:06 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id l2so12618448pgb.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=d4YFnDPS6NroPhjQrx8F6bp+0knVok/iG5b32FqCjOM=;
        b=MTxHgVBJzfOyF26VNWYwKA/avXyYB1azHbsAxKVZMIv7rGzYeunTQRuMuXTs22eo2i
         WhvDrROk7eaJlUsXbayHX3kThv35uRa5NqnjqtOhAdOItJ1ohISNt2jvUuz0ei6QfoUw
         rrdCktU72iXJ2y8D7lP+EJMuXBi8MR/DekxFrn+rwFroluvho13P82/JEi6LtnnedHT8
         q5r/yU576arRtcwjccVnb3GS9wdst2pb2R3JZza7f1BR4LwxIcytid/dLAMz5exuo9p9
         /kk5/rRLqSzNETQDOEBr+3kphEnd+sBdPQK9TYOz1oJ9tWx+HqFj/j+Kgd+WNQCYCvYs
         xffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=d4YFnDPS6NroPhjQrx8F6bp+0knVok/iG5b32FqCjOM=;
        b=lPRIGAR/O7PkKfRBnz3tFg2o0578ORw0c4xVeJ+a5/M3fdJyCyouedrBvddm65tbfM
         XM6uVGtdeiAuny9Gxb/4AJNPRZUT/pSEqUM/dxT9JXtR2cn8HhckgQngMb9iRk2czr7Q
         GTl6hGVDMRv2960LfNM714TzfRK5YQ9KMn9xujI0KjsFQaEJIpyUyjfWtViH5tAoqmeA
         yJH23RuW7BAKYDNbubRJAVsfb4rXGJkFCC0Lay7OpPt8r/0O+TtLmdTizdMSdcXZSlAX
         vbtdTgrS93DDqhMpOJ7nnVrrBsTMXV2WDyoHr/OaBUh67acjxP+WLQi7W/LbuTaLH2FO
         59Wg==
X-Gm-Message-State: AOAM5324rL3xJrb6EJx8JrmnGe1CmcGuo9/fbn5XixQtT6TuAOEJaem1
        tbOBWsDaSxLfxw2YUDCUD+w=
X-Google-Smtp-Source: ABdhPJzINJzrtYbdjGhlQeGB2A3yvooP0Bn8O3A2gT2en5QOTXW3gMoax9U5xrcQ1AHnKm7ofi7g8w==
X-Received: by 2002:a63:c65:: with SMTP id 37mr5273967pgm.186.1615426565817;
        Wed, 10 Mar 2021 17:36:05 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id b14sm646417pfi.74.2021.03.10.17.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:36:05 -0800 (PST)
Subject: [RFC PATCH 08/10] vmxnet3: Update driver to use ethtool_gsprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com
Date:   Wed, 10 Mar 2021 17:36:04 -0800
Message-ID: <161542656461.13546.474867975442613938.stgit@localhost.localdomain>
In-Reply-To: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

So this patch actually does 3 things.

First it removes a stray white space at the start of the variable
declaration in vmxnet3_get_strings.

Second it flips the logic for the string test so that we exit immediately
if we are not looking for the stats strings. Doing this we can avoid
unnecessary indentation and line wrapping.

Then finally it updates the code to use ethtool_gsprintf rather than a
memcpy and pointer increment to write the ethtool strings.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c |   53 ++++++++++++---------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 7ec8652f2c26..4ec674380a91 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -218,43 +218,28 @@ vmxnet3_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 static void
 vmxnet3_get_strings(struct net_device *netdev, u32 stringset, u8 *buf)
 {
-	 struct vmxnet3_adapter *adapter = netdev_priv(netdev);
-	if (stringset == ETH_SS_STATS) {
-		int i, j;
-		for (j = 0; j < adapter->num_tx_queues; j++) {
-			for (i = 0; i < ARRAY_SIZE(vmxnet3_tq_dev_stats); i++) {
-				memcpy(buf, vmxnet3_tq_dev_stats[i].desc,
-				       ETH_GSTRING_LEN);
-				buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < ARRAY_SIZE(vmxnet3_tq_driver_stats);
-			     i++) {
-				memcpy(buf, vmxnet3_tq_driver_stats[i].desc,
-				       ETH_GSTRING_LEN);
-				buf += ETH_GSTRING_LEN;
-			}
-		}
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	int i, j;
 
-		for (j = 0; j < adapter->num_rx_queues; j++) {
-			for (i = 0; i < ARRAY_SIZE(vmxnet3_rq_dev_stats); i++) {
-				memcpy(buf, vmxnet3_rq_dev_stats[i].desc,
-				       ETH_GSTRING_LEN);
-				buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < ARRAY_SIZE(vmxnet3_rq_driver_stats);
-			     i++) {
-				memcpy(buf, vmxnet3_rq_driver_stats[i].desc,
-				       ETH_GSTRING_LEN);
-				buf += ETH_GSTRING_LEN;
-			}
-		}
+	if (stringset != ETH_SS_STATS)
+		return;
 
-		for (i = 0; i < ARRAY_SIZE(vmxnet3_global_stats); i++) {
-			memcpy(buf, vmxnet3_global_stats[i].desc,
-				ETH_GSTRING_LEN);
-			buf += ETH_GSTRING_LEN;
-		}
+	for (j = 0; j < adapter->num_tx_queues; j++) {
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_tq_dev_stats); i++)
+			ethtool_gsprintf(&buf, vmxnet3_tq_dev_stats[i].desc);
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_tq_driver_stats); i++)
+			ethtool_gsprintf(&buf, vmxnet3_tq_driver_stats[i].desc);
+	}
+
+	for (j = 0; j < adapter->num_rx_queues; j++) {
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_rq_dev_stats); i++)
+			ethtool_gsprintf(&buf, vmxnet3_rq_dev_stats[i].desc);
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_rq_driver_stats); i++)
+			ethtool_gsprintf(&buf, vmxnet3_rq_driver_stats[i].desc);
 	}
+
+	for (i = 0; i < ARRAY_SIZE(vmxnet3_global_stats); i++)
+		ethtool_gsprintf(&buf, vmxnet3_global_stats[i].desc);
 }
 
 netdev_features_t vmxnet3_fix_features(struct net_device *netdev,


