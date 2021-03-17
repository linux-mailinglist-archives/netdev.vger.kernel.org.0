Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBC333E2CB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhCQAcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhCQAbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:31:42 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7FBC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:42 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id h7so244369qtx.3
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=KyKOMMokP6jDQFUvlq0MosyUyH2Iv3Nr4lzzu8bCs5Y=;
        b=fEAQLmYeP3xS4Zgxq96Cv7EBn7DGMaxwY/XlHc0FzDFB4+Si8eIlLEMO5oj8A1mJLp
         Y3CrdW20oceVYTpV7cHblnbSICvqL9koNRvDH6XCW6BxX9tInqfsQzwK27g54ehQiOz/
         QGnpgcLz7c4FFU/zXCcTooPd4AbzdV2zhvUebGNBZQhP6uGTxzZX2hk3XCa9N95iSOvq
         Jz1SWehnqrZbAbUT6gQFTsPdNGGhskMqRYDx9gNTqajeC2tbGLlwIl+fN2rzwaSu2HNH
         s6ftFwAIW9m/9Q7fnup8VIB4dFafMhzKhpmXVrcKfvOZ4S/nBq9ASSeLqnuP1ZtZn3MB
         sKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KyKOMMokP6jDQFUvlq0MosyUyH2Iv3Nr4lzzu8bCs5Y=;
        b=l0Bfgfv2Y/StbVhysNY3RRJqgyQZCeH++SYXOOBrJKZWnJMpvhJd9FdPWfA+cEDwFQ
         qwUocMKSEGoXFMUEwRS6WcjOggsH8Sf03KGt+LCY8PpubNKVQ7xsTJINEO15vfJU/EwU
         ruQI2whuyt0x46OeTEhiKVk853qzpeUgdeaWo7QMPmjIV4mX94RX/9uj50VvGigiYVzY
         ZB5M6wql8Ju32gEBWF9LwE+6y7bqSFdfB8sht9bgzSI6oJpo7HMty2yEZN3gQ0ct7ms0
         GdaqejXffrouElsSof3MWtRaLCTVjQasZElivBh9u7KQ83XQBAlIY1hE9xsHrGn31ftT
         Y7DQ==
X-Gm-Message-State: AOAM533zuDs2kTQY+ef6jZ77XQPo4T15p62C3fKxACwl5otdYUAy+pYd
        o0WCLynx1VovcNnUve7Doms=
X-Google-Smtp-Source: ABdhPJyKCy0kx4bpO+dw7fxrC6LSnpUJ05P3TZR5KeIjnHGFzplfQvG0X6jaPuMAuv0jVRY6nhD0xw==
X-Received: by 2002:aed:3104:: with SMTP id 4mr1442269qtg.341.1615941101264;
        Tue, 16 Mar 2021 17:31:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r3sm16220658qkm.129.2021.03.16.17.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:31:40 -0700 (PDT)
Subject: [net-next PATCH v2 08/10] vmxnet3: Update driver to use
 ethtool_sprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
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
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Tue, 16 Mar 2021 17:31:37 -0700
Message-ID: <161594109782.5644.3951439442214973165.stgit@localhost.localdomain>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
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

Then finally it updates the code to use ethtool_sprintf rather than a
memcpy and pointer increment to write the ethtool strings.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c |   53 ++++++++++++---------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 7ec8652f2c26..c0bd9cbc43b1 100644
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
+			ethtool_sprintf(&buf, vmxnet3_tq_dev_stats[i].desc);
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_tq_driver_stats); i++)
+			ethtool_sprintf(&buf, vmxnet3_tq_driver_stats[i].desc);
+	}
+
+	for (j = 0; j < adapter->num_rx_queues; j++) {
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_rq_dev_stats); i++)
+			ethtool_sprintf(&buf, vmxnet3_rq_dev_stats[i].desc);
+		for (i = 0; i < ARRAY_SIZE(vmxnet3_rq_driver_stats); i++)
+			ethtool_sprintf(&buf, vmxnet3_rq_driver_stats[i].desc);
 	}
+
+	for (i = 0; i < ARRAY_SIZE(vmxnet3_global_stats); i++)
+		ethtool_sprintf(&buf, vmxnet3_global_stats[i].desc);
 }
 
 netdev_features_t vmxnet3_fix_features(struct net_device *netdev,


