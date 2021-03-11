Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D963369C6
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhCKBgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCKBgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:36:00 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010E0C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z5so9432828plg.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4BA8bY8lW0soxmFw6y9gJo0Qf+WroUwWFLtWhIeGuxE=;
        b=MOSbPSAbIJuFkuaS1h71CmOP0ISteAYhnQnsaQkZfapXlF28sNdzh8dCHP5cVjPjOh
         fxTgbxJPxxVD5x1kKH6plMYROOtYap5wJJ0yS00glsFE0GHVQqtPzUTQHJ9Qk/3ZUwfE
         4+p8QI92ZsoCZeAQ4Ss5b47AsQyB//GE28tlxHC5y9FMnJsJ3XhIHffcL4lcPsbZ8Awd
         G5sbzCq51Xl9PfaBher+6avERsfjz/bUWji9kR6BR5czbbNcdNayn3UJS+D01onsVzCh
         h15reSH9ffYYgwMcf9DzDWuEbFza/N7pbMyxDgXr+MvVk8Ok35Th99Sz9Z9k1DRNOreQ
         OwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4BA8bY8lW0soxmFw6y9gJo0Qf+WroUwWFLtWhIeGuxE=;
        b=GpD20Bk0xEcAHtHofxaUkGSmlwETA8GtGawZvIWuIMQqIPSXeY191UtylgpOf1RKn4
         rRlaaoe6ubS6Gfo+meW9/kAAJMAkijKU2KTIS50h40Y/Ml/QyhzW5rKv5Ui3T7GnZ3cu
         KhX72J8BCjDHW31GSNVIwPMJu/bVpwbeVF4xky55SU4fBnkVUeW62QEa8gihZMPe+g2c
         dFC3f79DomM+nXOoAUQFiVMDVTZYzfLjfpMHsJu94ysG8y22e0Ve7hAHGdLI3fjAld7Q
         j3oyX+LfT5ZziwJkB9eC6zP2Sp70WjkxyLGp1QMke+zlHKPWfdFFeVO2CGNQXCsS9p8v
         RVqQ==
X-Gm-Message-State: AOAM531T7pDxI6DPt1vOrWtVeOpyUFE476j3FX57kKEMQpfEULzOSZ5a
        lpTCHHaQBeTJGrm7Gsx3OcA=
X-Google-Smtp-Source: ABdhPJwVn+fQZjyQ6TNPpCSKHLaMl+AtJxMEPvkjzY7hpr/MdI/TF0icwGCsDHoKHp3EHsdp0UMQ/w==
X-Received: by 2002:a17:90a:9f8c:: with SMTP id o12mr2870941pjp.215.1615426559468;
        Wed, 10 Mar 2021 17:35:59 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id mz11sm548496pjb.6.2021.03.10.17.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:59 -0800 (PST)
Subject: [RFC PATCH 07/10] virtio_net: Update driver to use ethtool_gsprintf
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
Date:   Wed, 10 Mar 2021 17:35:58 -0800
Message-ID: <161542655816.13546.114000517042800369.stgit@localhost.localdomain>
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

Update the code to replace instances of snprintf and a pointer update with
just calling ethtool_gsprintf.

Also replace the char pointer with a u8 pointer to avoid having to recast
the pointer type.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/virtio_net.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82e520d2cb12..f1a05b43dde7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2104,25 +2104,21 @@ static int virtnet_set_channels(struct net_device *dev,
 static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	char *p = (char *)data;
 	unsigned int i, j;
+	u8 *p = data;
 
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
-					 i, virtnet_rq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++)
+				ethtool_gsprintf(&p, "rx_queue_%u_%s", i,
+						 virtnet_rq_stats_desc[j].desc);
 		}
 
 		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_%s",
-					 i, virtnet_sq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
+				ethtool_gsprintf(&p, "tx_queue_%u_%s", i,
+						 virtnet_sq_stats_desc[j].desc);
 		}
 		break;
 	}


