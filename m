Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A936268985B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 13:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjBCMQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 07:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjBCMQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 07:16:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78D265F1C;
        Fri,  3 Feb 2023 04:15:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E8DBB82A91;
        Fri,  3 Feb 2023 12:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F27C4339B;
        Fri,  3 Feb 2023 12:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675426557;
        bh=bpsBfIP+WayDaYXAnzjXQUpZIfOqiX4IwY20qL1+qWI=;
        h=From:To:Cc:Subject:Date:From;
        b=Yxz6PlT5gTt/Whb6nIApqlbPy+k7RfxPTie1YnbROiauEnj/VS30emdyaNF/ih4jt
         QLyNMyB9tb8n8QqpS+FheiH5qXuO/zenEb3SycYoUktBzg1m7pgEbuH7ZfGvBZzMXk
         /rdNp7CJoplsXraaruvH0dDrjbICiuQqbQRMRiCx8VF+gdVb7RfsfrR161tdtrVjHF
         Gw/giAcmN0o4dHKcBrg0/CKGzNC4S4N+2+5CthXuY7yOEs0BVd0WWQZT88h9CSK7TF
         0F5yp64pOnpbVsVLaZSzJYzxD2GxaO2ikxSbrAcxQgcdxsUx+l1lQ9TyrxHlUIQbDJ
         SBv7ikFxdOhpg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] amd-xgbe: fix mismatched prototype
Date:   Fri,  3 Feb 2023 13:15:36 +0100
Message-Id: <20230203121553.2871598-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The forward declaration was introduced with a prototype that does
not match the function definition:

drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
 2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
  391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Ideally there should not be any forward declarations here, which
would make it easier to show that there is no unbounded recursion.
I tried fixing this but could not figure out how to avoid the
recursive call.

As a hotfix, address only the broken prototype to fix the build
problem instead.

Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 7d88caa4e623..16e7fb2c0dae 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -390,7 +390,8 @@ static DEFINE_MUTEX(xgbe_phy_comm_lock);
 static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata);
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata);
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
-					unsigned int cmd, unsigned int sub_cmd);
+					enum xgbe_mb_cmd cmd,
+					enum xgbe_mb_subcmd sub_cmd);
 
 static int xgbe_phy_i2c_xfer(struct xgbe_prv_data *pdata,
 			     struct xgbe_i2c_op *i2c_op)
-- 
2.39.0

