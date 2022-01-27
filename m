Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7D49EA79
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 19:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245078AbiA0SnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 13:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbiA0SnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 13:43:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0B6C061714;
        Thu, 27 Jan 2022 10:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4433ACE233A;
        Thu, 27 Jan 2022 18:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFA3C340ED;
        Thu, 27 Jan 2022 18:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643308987;
        bh=16gPJmDfnjZqvmYtmaHShOw6gK4376y5onSHQtcvN60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itVzD4ziGDCCHHXqO47o3Mly0MoGz6OEZZYsBDzn6ZxZFN0W7cK9+/obVYjLyXQof
         K6cahBRgzzlrVHesDCEEvgnRRr+Ktmeaan6b9OajBg/VAAacodMSVu3Qv6Z/3z261C
         XemC/WepdfK47vAiCiF2moEBJgCdTkFoWUT4L86nVAAro/HbQqkR6pJezAmJbr9kIj
         34sSaSUxTAKqvUujMtDVCtmeCnP8c/cxQFRmHJbyF++FoAYPyf+Lr6lH61MjIRNJeX
         WvIK9wKc7AEmgeg5K0xHEL9yxlF36y+cxvYX/uvoWaoYW137yYNkJsGlfB5iratDO/
         zRwcLH2JwKS2A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        idosch@nvidia.com, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 2/2] bnxt: report header-data split state
Date:   Thu, 27 Jan 2022 10:43:00 -0800
Message-Id: <20220127184300.490747-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127184300.490747-1-kuba@kernel.org>
References: <20220127184300.490747-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aggregation rings imply header-data split.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 003330e8cd58..5edbee92f5c4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -11,6 +11,7 @@
 #include <linux/ctype.h>
 #include <linux/stringify.h>
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/linkmode.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
@@ -802,9 +803,11 @@ static void bnxt_get_ringparam(struct net_device *dev,
 	if (bp->flags & BNXT_FLAG_AGG_RINGS) {
 		ering->rx_max_pending = BNXT_MAX_RX_DESC_CNT_JUM_ENA;
 		ering->rx_jumbo_max_pending = BNXT_MAX_RX_JUM_DESC_CNT;
+		kernel_ering->tcp_data_split = ETHTOOL_TCP_DATA_SPLIT_ENABLED;
 	} else {
 		ering->rx_max_pending = BNXT_MAX_RX_DESC_CNT;
 		ering->rx_jumbo_max_pending = 0;
+		kernel_ering->tcp_data_split = ETHTOOL_TCP_DATA_SPLIT_DISABLED;
 	}
 	ering->tx_max_pending = BNXT_MAX_TX_DESC_CNT;
 
-- 
2.34.1

