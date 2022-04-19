Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E884C507817
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357079AbiDSSZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357077AbiDSSWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:22:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6E43EBB8;
        Tue, 19 Apr 2022 11:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 098FCB81865;
        Tue, 19 Apr 2022 18:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E5DC385AB;
        Tue, 19 Apr 2022 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392110;
        bh=M1sk34xlYCQpQot+7xmeV9IzI73vVdZ8Sw1Ikj2J5Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpbQbjAnIaVoQpB+wWg/Z6WE1GMw+PgI7WBzWhAI9uTnsB5iQGYeT+5lRjZoTrbw8
         nkk71W1VS7Lk95BMX8QlUQur1eCH94NjklYqn0QQu0VmN2jCiT7BoLmidpvN3mbg+l
         FKLkXO075ziUfkQbGbSFfRUVmBhkgSiQxB0P0UZYYoDvp1ATG3dkuMQIWa7XOu5bzn
         ZjZZZ1Xy0jhYV2tgc8PWxJg8VHQdPM6pDy4fJOryvFP4FSuQv2+0bQkQpDeC9dsBEo
         Z6NTtwDNHN1YmZT7n+n8k6j277A1Jp0oPCMd6yTD9GJHG7wAFrARqhDveBm2mJmkbw
         c/jZ+2FrnnOOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, madalin.bucur@nxp.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/14] dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
Date:   Tue, 19 Apr 2022 14:14:38 -0400
Message-Id: <20220419181444.485959-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181444.485959-1-sashal@kernel.org>
References: <20220419181444.485959-1-sashal@kernel.org>
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
index 7ce2e99b594d..0a186d16e73f 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -506,11 +506,15 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
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

