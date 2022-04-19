Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7D6507803
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356708AbiDSST2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356711AbiDSSTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:19:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD813D4AC;
        Tue, 19 Apr 2022 11:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E890B819A9;
        Tue, 19 Apr 2022 18:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312D1C385AD;
        Tue, 19 Apr 2022 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392002;
        bh=qmlk7RokZF/lJHMgXkXxFzwtYZ21SxX7MjgtQRqnqr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoqUs6DT4ML4kwvGp5QHXL1MzNYGXcyGSDO2/QMyvfAmXi+EEWxVkCzgNXFpa3/Pa
         dgfDW3F8MZY0ENmUJtCXaH5m+vWwowNDi71zmrHGoMghZ7yhBz8E9vkjrkMWv7wyRb
         8v8y74M84gb2cU46kt4aHIr3Z5oh6QrxmtnzD55jVLrQAom5wQa0HklR+w9HXbTccf
         5TS52nFO3Wb07crJRdqTdZI9yLvXzMVarrcPKUPzE3aztfxeO1tyXkqpWq2AxPW5nF
         50+NcJCbzVGoMCJzQYLM8zirb9wsfDyyEfZ8eS5i5DtY8FS7u4U7zH0bfRCAt0jL58
         jHjWbzwHSWMKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, madalin.bucur@nxp.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/27] dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
Date:   Tue, 19 Apr 2022 14:12:28 -0400
Message-Id: <20220419181242.485308-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 1a7eb80d170c28be2928433702256fe2a0bd1e0f ]

Both of of_get_parent() and of_parse_phandle() return node pointer with
refcount incremented, use of_node_put() on it to decrease refcount
when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 763d2c7b5fb1..5750f9a56393 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -489,11 +489,15 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
 	info->phc_index = -1;
 
 	fman_node = of_get_parent(mac_node);
-	if (fman_node)
+	if (fman_node) {
 		ptp_node = of_parse_phandle(fman_node, "ptimer-handle", 0);
+		of_node_put(fman_node);
+	}
 
-	if (ptp_node)
+	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
+	}
 
 	if (ptp_dev)
 		ptp = platform_get_drvdata(ptp_dev);
-- 
2.35.1

