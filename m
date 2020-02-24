Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4440616A08E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgBXIyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgBXIyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:54:06 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE072086A;
        Mon, 24 Feb 2020 08:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534445;
        bh=jyTuYbkOx/qFl/ghU7khrY1Sboh+eGIbH2DRwV3peeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGsg7GJZqiMJzCQGqK+jMAi+LsSkpS3MURNIW/WgjCKtog/6l1dfEP1AtfQ5va1rI
         eO4f8QZaTdQZLZpQKKKIVDWIZued0dVu8tIgk66RRxFsmwXSeLBLqFhwfAVNKN3Lk/
         mR6zaw20ZjTWclTRqVC16mxvJNd7N2ycZtZc3HAU=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next v1 15/18] net/apm: Properly mark absence of FW
Date:   Mon, 24 Feb 2020 10:53:08 +0200
Message-Id: <20200224085311.460338-16-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224085311.460338-1-leon@kernel.org>
References: <20200224085311.460338-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

There is no need to set "N/A" if FW is not available.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/apm/xgene-v2/ethtool.c         | 1 -
 drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/ethtool.c b/drivers/net/ethernet/apm/xgene-v2/ethtool.c
index da748beb7047..b78d1a99fe81 100644
--- a/drivers/net/ethernet/apm/xgene-v2/ethtool.c
+++ b/drivers/net/ethernet/apm/xgene-v2/ethtool.c
@@ -89,7 +89,6 @@ static void xge_get_drvinfo(struct net_device *ndev,
 	struct platform_device *pdev = pdata->pdev;

 	strcpy(info->driver, "xgene-enet-v2");
-	snprintf(info->fw_version, ETHTOOL_FWVERS_LEN, "N/A");
 	sprintf(info->bus_info, "%s", pdev->name);
 }

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
index 4e7a95bd83d7..ada70425b48c 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
@@ -103,7 +103,6 @@ static void xgene_get_drvinfo(struct net_device *ndev,
 	struct platform_device *pdev = pdata->pdev;

 	strcpy(info->driver, "xgene_enet");
-	snprintf(info->fw_version, ETHTOOL_FWVERS_LEN, "N/A");
 	sprintf(info->bus_info, "%s", pdev->name);
 }

--
2.24.1

