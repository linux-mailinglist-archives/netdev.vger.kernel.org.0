Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C943A696E44
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 21:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjBNUHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 15:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjBNUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 15:07:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93C610CF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 12:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 507CA61841
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 20:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26802C433D2;
        Tue, 14 Feb 2023 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676405261;
        bh=Nk2634DMel1lCzoLAlhYhfLwocNl9MJMXAOkjiIjTa8=;
        h=From:To:Cc:Subject:Date:From;
        b=c4Oqr1CkmSfq9q34m1WUWwfmaN91A5FTEFRVH9YHbxLbWQPC18L6+lptY91F2Wv7O
         cSur+yM4f2SVw33x8q/Vb/UMEYLKVTFm6pG+3Xm9DtedVrGc+yWjOHcqdW/sQQ6NoE
         AAmm8ocD+mInAbmAM62wKyzaBI9zh3nURxfD+g6XHDLmLREjC6fLObvfKma2U/AHTR
         dE7qwLTcRbaQAkOD41JEzmZpbksB41xPfRhwOlwY8qhtZ7NR24C6SCRJAUHI2SGZbV
         BB5r/B1mi0f432RrxeYN2/Uj0b51BBz7OkNmycR0mJOLGStLqUb1JlB0aFUCn6p7q7
         lDUilJAKdjo/g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] i40e: check vsi type before setting xdp_features flag
Date:   Tue, 14 Feb 2023 21:07:33 +0100
Message-Id: <f2b537f86b34fc176fbc6b3d249b46a20a87a2f3.1676405131.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set xdp_features flag just for I40E_VSI_MAIN vsi type since XDP is
supported just in this configuration.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3667ad6493d6..11711886c3be 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13787,8 +13787,6 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev->features &= ~NETIF_F_HW_TC;
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
@@ -13807,6 +13805,10 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 		spin_lock_bh(&vsi->mac_filter_hash_lock);
 		i40e_add_mac_filter(vsi, mac_addr);
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
+
+		netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				       NETDEV_XDP_ACT_REDIRECT |
+				       NETDEV_XDP_ACT_XSK_ZEROCOPY;
 	} else {
 		/* Relate the VSI_VMDQ name to the VSI_MAIN name. Note that we
 		 * are still limited by IFNAMSIZ, but we're adding 'v%d\0' to
-- 
2.39.1

