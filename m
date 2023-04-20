Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB696EA00A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDTXeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjDTXeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA26525A;
        Thu, 20 Apr 2023 16:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE6163FBC;
        Thu, 20 Apr 2023 23:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C95C433EF;
        Thu, 20 Apr 2023 23:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682033585;
        bh=44fALB1gyCAVWw/ps3sUDunYe/woUgIEQAkGTnp+U58=;
        h=From:To:Cc:Subject:Date:From;
        b=QBoaVwtl/RJ8pFwsutBKHX18kkwVQc5EcLJ6/3XbFNL2gxwogTXN3f+2KCUiIgNtO
         8CV7z9GIGUAoqE5iwAMACr8RgUrxDbeeMe7Hgjit2eeiliu7mC2KSed+/1cAgHhCdh
         NQTtD54+EstzcyIvaFNoF4qDLRxBgQ7BUsjizhO/Kk/E3rl21EDotUUZqnyUEqUtNo
         t0S6AEzE4oclPAVkv4sTZHSTF0fRzqOBgR591ao65YUIjrpcjLs3ElCSHhTWLo1m47
         j2QMogpavIH20EPE+dCvTD8eouMu3ureZL7HDuRG+gJpG246dMYMWc9XMSjOKYPatm
         KMIdEfgOE1ang==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        dnlplm@gmail.com, linux-doc@vger.kernel.org, saeedm@nvidia.com,
        tariqt@nvidia.com, leonro@nvidia.com
Subject: [PATCH net-next] net: ethtool: coalesce: try to make user settings stick twice
Date:   Thu, 20 Apr 2023 16:33:02 -0700
Message-Id: <20230420233302.944382-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SET_COALESCE may change operation mode and parameters in one call.
Changing operation mode may cause the driver to reset the parameter
values to what is a reasonable default for new operation mode.

Since driver does not know which parameters come from user and which
are echoed back from ->get, driver may ignore the parameters when
switching operation modes.

This used to be inevitable for ioctl() but in netlink we know which
parameters are actually specified by the user.

We could inform which parameters were set by the user but this would
lead to a lot of code duplication in the drivers. Instead try to call
the drivers twice if both mode and params are changed. The set method
already checks if any params need updating so in case the driver did
the right thing the first time around - there will be no second call
to it's ->set method (only an extra call to ->get()).

For mlx5 for example before this patch we'd see:

 # ethtool -C eth0 adaptive-rx on  adaptive-tx on
 # ethtool -C eth0 adaptive-rx off adaptive-tx off \
		   tx-usecs 123 rx-usecs 123
 Adaptive RX: off  TX: off
 rx-usecs: 3
 rx-frames: 32
 tx-usecs: 16
 tx-frames: 32
 [...]

After the change:

 # ethtool -C eth0 adaptive-rx on  adaptive-tx on
 # ethtool -C eth0 adaptive-rx off adaptive-tx off \
		   tx-usecs 123 rx-usecs 123
 Adaptive RX: off  TX: off
 rx-usecs: 123
 rx-frames: 32
 tx-usecs: 123
 tx-frames: 32
 [...]

This only works for netlink, so it's a small discrepancy between
netlink and ioctl(). Since we anticipate most users to move to
netlink I believe it's worth making their lives easier.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
mlx5 folks, LMK if you have a good idea of fixing this in the driver
instead, that may be cleaner, but I can't think of a good way :(

CC: corbet@lwn.net
CC: dnlplm@gmail.com
CC: linux-doc@vger.kernel.org

CC: saeedm@nvidia.com
CC: tariqt@nvidia.com
CC: leonro@nvidia.com
---
 Documentation/networking/ethtool-netlink.rst |  4 ++
 net/ethtool/coalesce.c                       | 54 ++++++++++++++++----
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index cd0973d4ba01..2540c70952ff 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1099,6 +1099,10 @@ such that the corresponding bit in ``ethtool_ops::supported_coalesce_params``
 is not set), regardless of their values. Driver may impose additional
 constraints on coalescing parameters and their values.
 
+Compared to requests issued via the ``ioctl()`` netlink version of this request
+will try harder to make sure that values specified by the user have been applied
+and may call the driver twice.
+
 
 PAUSE_GET
 =========
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 443e7e642c96..01a59ce211c8 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -254,13 +254,14 @@ ethnl_set_coalesce_validate(struct ethnl_req_info *req_info,
 }
 
 static int
-ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
+__ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info,
+		     bool *dual_change)
 {
 	struct kernel_ethtool_coalesce kernel_coalesce = {};
 	struct net_device *dev = req_info->dev;
 	struct ethtool_coalesce coalesce = {};
+	bool mod_mode = false, mod = false;
 	struct nlattr **tb = info->attrs;
-	bool mod = false;
 	int ret;
 
 	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
@@ -268,6 +269,7 @@ ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 
+	/* Update values */
 	ethnl_update_u32(&coalesce.rx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS], &mod);
 	ethnl_update_u32(&coalesce.rx_max_coalesced_frames,
@@ -286,10 +288,6 @@ ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], &mod);
 	ethnl_update_u32(&coalesce.stats_block_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS], &mod);
-	ethnl_update_bool32(&coalesce.use_adaptive_rx_coalesce,
-			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX], &mod);
-	ethnl_update_bool32(&coalesce.use_adaptive_tx_coalesce,
-			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX], &mod);
 	ethnl_update_u32(&coalesce.pkt_rate_low,
 			 tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], &mod);
 	ethnl_update_u32(&coalesce.rx_coalesce_usecs_low,
@@ -312,17 +310,25 @@ ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
 	ethnl_update_u32(&coalesce.rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
-	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_tx,
-			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
-	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
-			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
 	ethnl_update_u32(&kernel_coalesce.tx_aggr_max_bytes,
 			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES], &mod);
 	ethnl_update_u32(&kernel_coalesce.tx_aggr_max_frames,
 			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES], &mod);
 	ethnl_update_u32(&kernel_coalesce.tx_aggr_time_usecs,
 			 tb[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS], &mod);
-	if (!mod)
+
+	/* Update operation modes */
+	ethnl_update_bool32(&coalesce.use_adaptive_rx_coalesce,
+			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX], &mod_mode);
+	ethnl_update_bool32(&coalesce.use_adaptive_tx_coalesce,
+			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX], &mod_mode);
+	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_tx,
+			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod_mode);
+	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
+			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod_mode);
+
+	*dual_change = mod && mod_mode;
+	if (!mod && !mod_mode)
 		return 0;
 
 	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce, &kernel_coalesce,
@@ -330,6 +336,32 @@ ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
 	return ret < 0 ? ret : 1;
 }
 
+static int
+ethnl_set_coalesce(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	bool dual_change;
+	int err, ret;
+
+	/* SET_COALESCE may change operation mode and parameters in one call.
+	 * Changing operation mode may cause the driver to reset the parameter
+	 * values, and therefore ignore user input (driver does not know which
+	 * parameters come from user and which are echoed back from ->get).
+	 * To not complicate the drivers if user tries to change both the mode
+	 * and parameters at once - call the driver twice.
+	 */
+	err = __ethnl_set_coalesce(req_info, info, &dual_change);
+	if (err < 0)
+		return err;
+	ret = err;
+
+	if (ret && dual_change) {
+		err = __ethnl_set_coalesce(req_info, info, &dual_change);
+		if (err < 0)
+			return err;
+	}
+	return ret;
+}
+
 const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 	.request_cmd		= ETHTOOL_MSG_COALESCE_GET,
 	.reply_cmd		= ETHTOOL_MSG_COALESCE_GET_REPLY,
-- 
2.39.2

