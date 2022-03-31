Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7944ED554
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiCaIW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiCaIWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:22:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED2F1B84FD;
        Thu, 31 Mar 2022 01:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ECBBACE20FC;
        Thu, 31 Mar 2022 08:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F29CC340EE;
        Thu, 31 Mar 2022 08:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648714833;
        bh=iXTgKFinWeARny9umBHpFewtGh3ktJILaqMuf1C2Ki4=;
        h=From:To:Cc:Subject:Date:From;
        b=XlEjsUNMuFyGV1AFKM5uUXqTaQXIUNDx9OczEpSBAIwsFuh1k6rhL56wSNaAu2bMa
         XoIE9l96UgLY1rmvK4neZhttSkSh4gr26W3YlTn5KAWhoKCcibnRhEg9tWQNt+QbSG
         dV/VN4EZKtmcW5mAmIT0x4Pc0RV2uOVKrKX+TZiktpWWt74chiCass+fl6swsajFhP
         Az+NXH5p4qK34OR11g/xQZBxbadK7l+g79ZoM42BdAVyOpuxUPCNdLcHUnK0P+lUjQ
         rK9O8c1TogyMqZc7Y1wgfT7wpLeZoz407BRG6HK9OClSxlHngAul0DrTd2FWs6WQNe
         ctEOHb06wMD1w==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shannon Nelson <snelson@pensando.io>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v1] ixgbe: ensure IPsec VF<->PF compatibility
Date:   Thu, 31 Mar 2022 11:20:23 +0300
Message-Id: <737616899df2a482e4ec35aa4056c9ac608d2f50.1648714609.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
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

From: Leon Romanovsky <leonro@nvidia.com>

The VF driver can forward any IPsec flags and such makes the function
is not extendable and prone to backward/forward incompatibility.

If new software runs on VF, it won't know that PF configured something
completely different as it "knows" only XFRM_OFFLOAD_INBOUND flag.

Fixes: eda0333ac293 ("ixgbe: add VF IPsec management")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>a
---
Chaagelog:
v1:
 * Replaced bits arithmetic with more simple expression
v0: https://lore.kernel.org/all/3702fad8a016170947da5f3c521a9251cf0f4a22.1648637865.git.leonro@nvidia.com
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index e596e1a9fc75..69d11ff7677d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -903,7 +903,8 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	/* Tx IPsec offload doesn't seem to work on this
 	 * device, so block these requests for now.
 	 */
-	if (!(sam->flags & XFRM_OFFLOAD_INBOUND)) {
+	sam->flags = sam->flags & ~XFRM_OFFLOAD_IPV6;
+	if (sam->flags != XFRM_OFFLOAD_INBOUND) {
 		err = -EOPNOTSUPP;
 		goto err_out;
 	}
-- 
2.35.1

