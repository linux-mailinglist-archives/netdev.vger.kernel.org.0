Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467EE23569C
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 13:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgHBLQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 07:16:18 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:53166 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728224AbgHBLPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 07:15:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0U4TpvXs_1596366939;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4TpvXs_1596366939)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:39 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@alibaba.com
Subject: [PATCH] net/enetc: Fix wrong return value in enetc_psfp_parse_clsflower()
Date:   Sun,  2 Aug 2020 19:15:38 +0800
Message-Id: <20200802111538.5338-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of invalid rule, a positive value EINVAL is returned here.
I think this is a typo error. It is necessary to return an error value.

Cc: Po Liu <Po.Liu@nxp.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fd3df19eaa32..4b3f1b60a24b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1017,7 +1017,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 		    !is_zero_ether_addr(match.mask->src)) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Cannot match on both source and destination MAC");
-			err = EINVAL;
+			err = -EINVAL;
 			goto free_filter;
 		}
 
@@ -1025,7 +1025,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 			if (!is_broadcast_ether_addr(match.mask->dst)) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Masked matching on destination MAC not supported");
-				err = EINVAL;
+				err = -EINVAL;
 				goto free_filter;
 			}
 			ether_addr_copy(filter->sid.dst_mac, match.key->dst);
@@ -1036,7 +1036,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 			if (!is_broadcast_ether_addr(match.mask->src)) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Masked matching on source MAC not supported");
-				err = EINVAL;
+				err = -EINVAL;
 				goto free_filter;
 			}
 			ether_addr_copy(filter->sid.src_mac, match.key->src);
@@ -1044,7 +1044,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 		}
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported, must include ETH_ADDRS");
-		err = EINVAL;
+		err = -EINVAL;
 		goto free_filter;
 	}
 
-- 
2.26.2

