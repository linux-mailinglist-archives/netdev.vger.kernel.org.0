Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9503339580
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhCLRtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhCLRss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3099AC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:48 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id 30so7709333ple.4
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UXrWznHuIl+tqYiybmBsTSLzzGjACP8HTfz1pnH9pxw=;
        b=byAxpKvHZ3OT/LGeCtFD3N9y4uw/UZcOk6xHGdWjd34G5wBasIds0YTbvWF7tcO63g
         VPD+Pzj435hBx84sz3JKw9xTeqW9O98C6OEOY9IIs7GencJhONUn6IWoTqUMZx7IZjPf
         H5CvGwBgCi+8+LFeSPsh1ytMEO2BYLcW8mjp+spzXevRt2hM0tAlL9Y6A9ZK11t7YK7N
         GdrBlgq5qlplqhSGr7ftlJvl8X0AoTg5jEDpUTuFmpnB6YZBdIrIRZyJQgNSpdjnYeaF
         LrClWWti9XTlXhwlxtGli90LmoCdlALS/L/UXFVt/hIdE3u9Kta3YtxVTgimPZAIcuH9
         IWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UXrWznHuIl+tqYiybmBsTSLzzGjACP8HTfz1pnH9pxw=;
        b=P9ECQsNBq4LVdmZ54w4utwrlu/HoGjXCjwVUzrd1xTKamqaKnflV2ciAhw+wxlA210
         eRvHea7JnlKcub0w1066dqcjNJdU1Z69Np5jjUlwFSMmWRSbw83w+iTzeBlt86cZOuRC
         eDuXmRRo5nRr0efUzK9u4tu8P7h8l/DqGU7zQj/Ek1qwGtUw6yn7c2+hpeP98RfEtSV6
         6W0K6iiDZjDTUbUShyVkAJTUV/6j2Leb70HSTg5W1165EWcyOwnE8wK3wVSJQcJlDg50
         x3STHrtJlYlutA6w4Az2znwPoal9+lfyieceg1Xi0tbcrfd6g74FB/F5g/eC5eVA+56q
         uHDQ==
X-Gm-Message-State: AOAM531/tINrFG2Q3HU+eCDMTQxKSKouSMDJTzTlcETrAv4cud6NRiuT
        esItj8SLav7i7JQtnqeWXE4=
X-Google-Smtp-Source: ABdhPJwZSjWQsls2IMEYwvM9JrjmAVryGVyFnp6LHoIwAnzCGeOKQBOenkK0Ycq2pwxHM7Gj2oGGPA==
X-Received: by 2002:a17:902:bd0b:b029:e5:f913:8c95 with SMTP id p11-20020a170902bd0bb02900e5f9138c95mr192406pls.84.1615571327729;
        Fri, 12 Mar 2021 09:48:47 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id t12sm5932407pfe.203.2021.03.12.09.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:47 -0800 (PST)
Subject: [net-next PATCH 07/10] virtio_net: Update driver to use
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
Date:   Fri, 12 Mar 2021 09:48:46 -0800
Message-ID: <161557132651.10304.9382850626606060019.stgit@localhost.localdomain>
In-Reply-To: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the code to replace instances of snprintf and a pointer update with
just calling ethtool_sprintf.

Also replace the char pointer with a u8 pointer to avoid having to recast
the pointer type.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/virtio_net.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e97288dd6e5a..77ba8e2fc11c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2138,25 +2138,21 @@ static int virtnet_set_channels(struct net_device *dev,
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
+				ethtool_sprintf(&p, "rx_queue_%u_%s", i,
+						virtnet_rq_stats_desc[j].desc);
 		}
 
 		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_%s",
-					 i, virtnet_sq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
+						virtnet_sq_stats_desc[j].desc);
 		}
 		break;
 	}


