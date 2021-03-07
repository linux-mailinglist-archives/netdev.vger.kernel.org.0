Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABD532FFB0
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 09:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCGIlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 03:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhCGIkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 03:40:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8787CC06174A;
        Sun,  7 Mar 2021 00:40:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so1442806pjg.5;
        Sun, 07 Mar 2021 00:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zb+I3SxrI5NPVoptwXvVDUa4Jf+lOBb6Yh3g24lzCNM=;
        b=uglPs/SKwundv7PMctDtGocRd/BtZsAiyM2AR8CgZIqvzwSkYI8PCK3LgXWMyhUShq
         si1drAi4H1PmIpNsUOSYjNg7pzMOaqnGFMP50eThVWWcTHnQA4dYnscF6kgGMCq0K3ye
         n2E1E4R0XM5DGxJTsXOUijvdkBg7zfhVL8lNQ8VehFUAmQs7Hz3dBSd0vW6xQHp1c9aP
         uuNz4L5YaYK+1dT+GRdFIYPgdRydZwUqrhpk/mhknb5iAw9lr70aQezcgiZFKNWgd9CJ
         hdQbgq/M0qvvt52YKw+MuicFga2dkuXlV3n0LrYN1w47fndIPmsVz9O83LR010Zw4l2e
         dLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zb+I3SxrI5NPVoptwXvVDUa4Jf+lOBb6Yh3g24lzCNM=;
        b=cpZZSrVLHL3d8vtHIwXlhRkCpoBVPvivcqC/7LFR6VzxTZuk9DK9h0eEwKLwNwQ6+A
         dBdYTRJMm72WGUoRZ4JP1pnV8tQW4gyJR4ApZxXvDqiTs9zlM7idRkm7p3hn1xuoS7u2
         geE/nU5bKyO0VfRtMdM1ssGCx4HFV+0LXHTrdHpng8rC+KXRdjCjZ37PxMZz7ZBlBpah
         eMyCAgvZ0BzWbmm4sWSCuRLDuNFIfGGR+oTS7sHsXRScNYJOFfWG4kNZFVvwHTA+fMBf
         LkGTetZAvZgFo4wgIMFx7jL+VzJUXnZbe2Ugc6qVLUMleIKykXpvXNS9z6cUSuYWaLo0
         L6Ug==
X-Gm-Message-State: AOAM533ZDZsq61RWkgXb2OOYeV2SM/BxmWkLbso9otnyQ6l9KAuSk72K
        CoJhTtbKygokLRVD+sVCPrE=
X-Google-Smtp-Source: ABdhPJzcDXahAJOxVGl/ts9d1lX+DEFqBSF5YNgG5t/5A2HBhMwE3dsvQq3wf7+bncAE94BgYCSoBA==
X-Received: by 2002:a17:90a:c902:: with SMTP id v2mr19408878pjt.144.1615106437140;
        Sun, 07 Mar 2021 00:40:37 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.66])
        by smtp.gmail.com with ESMTPSA id q10sm6438043pfc.190.2021.03.07.00.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 00:40:36 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tariqt@mellanox.com,
        jesse.brandeburg@intel.com, dinghao.liu@zju.edu.cn,
        trix@redhat.com, song.bao.hua@hisilicon.com, Jason@zx2c4.com,
        wanghai38@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
Date:   Sun,  7 Mar 2021 00:40:12 -0800
Message-Id: <20210307084012.21584-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hns_assemble_skb() returns NULL to skb, no error return code of
hns_nic_clear_all_rx_fetch() is assigned.
To fix this bug, ret is assigned with -ENOMEM in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 5d7824d2b4d4..c66a7a51198e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1663,8 +1663,10 @@ static int hns_nic_clear_all_rx_fetch(struct net_device *ndev)
 			for (j = 0; j < fetch_num; j++) {
 				/* alloc one skb and init */
 				skb = hns_assemble_skb(ndev);
-				if (!skb)
+				if (!skb) {
+					ret = -ENOMEM;
 					goto out;
+				}
 				rd = &tx_ring_data(priv, skb->queue_mapping);
 				hns_nic_net_xmit_hw(ndev, skb, rd);
 
-- 
2.17.1

