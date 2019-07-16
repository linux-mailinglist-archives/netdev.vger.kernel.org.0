Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25B56A1F2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 07:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfGPFsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 01:48:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45668 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfGPFsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 01:48:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so9493013plr.12;
        Mon, 15 Jul 2019 22:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0vlCsSn+3rPZrG2gXfU9KjLnAiVX9Fk1eqROmZ2aV48=;
        b=anvFP2Vrzq1vOHL2WOTGGwzkwG9xztVvRtiiFlmAIJcDDLTOeqBFwNhuMIitS06EN9
         B8d7pZ1hLuwai9dxh0JKvjx1f3eZsgeqLxJoFX21ACuIxvcRPwUDmzB45oH65RMbelwK
         1ZoxcNk9GGclO10j/m7wrrQUrvW/b4dhI6bakXgwVvg/mujQDMNDYK7/hH6vG7UIfxfI
         TSjUbQcUDqcA9sUzGCZCCJEyrcpm4yrMVMLXjbOkPHtLQGr7wmZ9o7AKJ0HTktLnzrTt
         apCXrIuHu9ag4QgOoabu5ssjiobzqsNGFBBXjuM1UdXcArLHOo/2G9dKexbEqVSIzM6J
         TotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0vlCsSn+3rPZrG2gXfU9KjLnAiVX9Fk1eqROmZ2aV48=;
        b=a+I4DfFqnYjU7cfdh64YTrbS4LbP8BvRseDwxQz3CnxQy48tLW3tLthajMf0XKKNkT
         hlMUialvNfSviOnXHt68Ewqtk00HgQz1VaIqxIuEHKIvNAwfxlZ2p6bZxRB0UPI/5ni7
         vY37+zyEV7FDLFAn9r+5SpS2ssPiFVsLodV47rxEuahwuhjDH62RPSUDP4sr+ukuzSzW
         awaqUBgDdcOIvxsDFhQMvN0/OYBP2yfUGGaM30Ul7eK70UrB0rggzaHK09/bXON6vTq6
         taGIed5sz00j8aZhoDsYbQfIZQcvPn664YJjvdTA7SZDl+41Wy3Iv7y5F49LRPRQExhr
         6lXw==
X-Gm-Message-State: APjAAAViAnMAcLiLDTgA81v6Pksfg8xT5hFRnLkMRA7Am5LK1wLzRhd1
        p37Uq2UMXuXfgHCdiQM99Xg=
X-Google-Smtp-Source: APXvYqy1W/sWFz9TPl+NAKtyOd6R6kP5PcxLwYdqBq2M2pmBNCh6pD/KvOQQsMI0zSBQbi10SxfRCw==
X-Received: by 2002:a17:902:7c96:: with SMTP id y22mr33656700pll.39.1563256134460;
        Mon, 15 Jul 2019 22:48:54 -0700 (PDT)
Received: from localhost.localdomain ([110.227.64.207])
        by smtp.gmail.com with ESMTPSA id l4sm18925314pff.50.2019.07.15.22.48.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 22:48:53 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     grygorii.strashko@ti.com, davem@davemloft.net,
        ivan.khoronzhuk@linaro.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: ethernet: ti: cpsw: Add of_node_put() before return and break
Date:   Tue, 16 Jul 2019 11:18:43 +0530
Message-Id: <20190716054843.2957-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each iteration of for_each_available_child_of_node puts the previous
node, but in the case of a return or break from the middle of the loop,
there is no put, thus causing a memory leak.
Hence, for function cpsw_probe_dt, create an extra label err_node_put
that puts the last used node and returns ret; modify the return
statements in the loop to save the return value in ret and goto this new
label.
For function cpsw_remove_dt, add an of_node_put before the break.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/ethernet/ti/cpsw.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index f320f9a0de8b..32a89744972d 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2570,7 +2570,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			ret = PTR_ERR(slave_data->ifphy);
 			dev_err(&pdev->dev,
 				"%d: Error retrieving port phy: %d\n", i, ret);
-			return ret;
+			goto err_node_put;
 		}
 
 		slave_data->slave_node = slave_node;
@@ -2589,7 +2589,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			if (ret) {
 				if (ret != -EPROBE_DEFER)
 					dev_err(&pdev->dev, "failed to register fixed-link phy: %d\n", ret);
-				return ret;
+				goto err_node_put;
 			}
 			slave_data->phy_node = of_node_get(slave_node);
 		} else if (parp) {
@@ -2607,7 +2607,8 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			of_node_put(mdio_node);
 			if (!mdio) {
 				dev_err(&pdev->dev, "Missing mdio platform device\n");
-				return -EINVAL;
+				ret = -EINVAL;
+				goto err_node_put;
 			}
 			snprintf(slave_data->phy_id, sizeof(slave_data->phy_id),
 				 PHY_ID_FMT, mdio->name, phyid);
@@ -2622,7 +2623,8 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 		if (slave_data->phy_if < 0) {
 			dev_err(&pdev->dev, "Missing or malformed slave[%d] phy-mode property\n",
 				i);
-			return slave_data->phy_if;
+			ret = slave_data->phy_if;
+			goto err_node_put;
 		}
 
 no_phy_slave:
@@ -2633,7 +2635,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 			ret = ti_cm_get_macid(&pdev->dev, i,
 					      slave_data->mac_addr);
 			if (ret)
-				return ret;
+				goto err_node_put;
 		}
 		if (data->dual_emac) {
 			if (of_property_read_u32(slave_node, "dual_emac_res_vlan",
@@ -2648,11 +2650,17 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 		}
 
 		i++;
-		if (i == data->slaves)
-			break;
+		if (i == data->slaves) {
+			ret = 0;
+			goto err_node_put;
+		}
 	}
 
 	return 0;
+
+err_node_put:
+	of_node_put(slave_node);
+	return ret;
 }
 
 static void cpsw_remove_dt(struct platform_device *pdev)
@@ -2675,8 +2683,10 @@ static void cpsw_remove_dt(struct platform_device *pdev)
 		of_node_put(slave_data->phy_node);
 
 		i++;
-		if (i == data->slaves)
+		if (i == data->slaves) {
+			of_node_put(slave_node);
 			break;
+		}
 	}
 
 	of_platform_depopulate(&pdev->dev);
-- 
2.19.1

