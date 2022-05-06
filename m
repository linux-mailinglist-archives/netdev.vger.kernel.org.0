Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0014751DFDF
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392392AbiEFUES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238593AbiEFUER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:04:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC60224F37
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2867621FE
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 20:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8483C385AC;
        Fri,  6 May 2022 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651867232;
        bh=v96SX/IKJerDHD9AOiqmePLyVxcToQXlfEVLW6ntjRw=;
        h=From:To:Cc:Subject:Date:From;
        b=jknCyzMcvoCu13hN4aozddigXIWdc48/Dgkx410dzVg0Xc9BxvneHQc18vZR4uJZA
         zxINdts+tr2/h3PIce36Qw3+5QJqxiL3nHRWdphH7mtS/5tWwSHKa72ujbgZ2Svoyn
         mLDRKL4+R6vKa4qMWQRCxmVipVjiRTBDBHiKaiV48ZWaY8a2sD8qJgVElWwjx7q7a4
         GmKHkA8De5POnTvR1LKRl2XXNJB/A7fmN6lE9laJ8G/PiqYGJI6NAzgksVWcFljIif
         3GlkNSyo53rVkjfk7r6zBUAUH8/uaPBk39Kn+fHQ1OJfrPjEoYaNSsnZz5/j4WZkaI
         +fVYjwzudLaRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, ioana.ciornei@nxp.com
Subject: [PATCH net-next] eth: dpaa2-mac: remove a dead-code NULL check on fwnode parent
Date:   Fri,  6 May 2022 13:00:29 -0700
Message-Id: <20220506200029.852310-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
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

Since commit 4e30e98c4b4c ("dpaa2-mac: return -EPROBE_DEFER from dpaa2_mac_open in case the fwnode is not set")
@parent can't be NULL after the if. It's either the address
of the ->fwnode of @dpmacs or @fwnode in case of ACPI.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Right, Ioana? Let's clean this up so the of_node_put() bots
go away.

CC: ioana.ciornei@nxp.com
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c48811d3bcd5..c9bee9a0c9b2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -108,9 +108,6 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	if (!parent)
-		return NULL;
-
 	fwnode_for_each_child_node(parent, child) {
 		err = -EINVAL;
 		if (is_acpi_device_node(child))
-- 
2.34.1

