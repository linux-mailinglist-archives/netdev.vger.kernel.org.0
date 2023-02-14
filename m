Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037ED696722
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbjBNOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbjBNOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:40:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7BD2B612
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:40:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1250616D5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2285C433EF;
        Tue, 14 Feb 2023 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676385576;
        bh=GsXGRd1wPWyEuyPN8KRdR8wexsvRYD/hXlrC0JnxNho=;
        h=From:To:Cc:Subject:Date:From;
        b=J/XRvoyq0JN2fbhHTasYR3tS1Wcz33z8vqsFNc+UtPvn254LwEsuB7CdKXnI8lls9
         CenKOcMETBJWLSCepr4ZVIRD0HdmsOPuSAycQxgwKLM9zUTPmFO8/v+ATktkkXn2ve
         bNLS69FdJ7I4uk2LHCMSpO+ApYhM9YyceE9GldqB3ULnIVeNjt6hDsi+1KFE758LDk
         xinKJ/7WZq1YwQhJT28p6MxJ20TmQU012GwtnPvTGIgnq0k6zZy8r8NVYrq/yxEix0
         5xW724FRoKFK3Z31JOpqRTbRjn4r4qiyR9fy/Iez1kd7Eps5njA7HRaAeFwHcymZZW
         6KOVR4PwpBY7A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] ice: update xdp_features with xdp multi-buff
Date:   Tue, 14 Feb 2023 15:39:27 +0100
Message-Id: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
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

Now ice driver supports xdp multi-buffer so add it to xdp_features.
Check vsi type before setting xdp_features flag.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rebase on top of net-next
- check vsi type before setting xdp_features flag
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0712c1055aea..4994a0e5a668 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2912,7 +2912,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			if (xdp_ring_err)
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 		}
-		xdp_features_set_redirect_target(vsi->netdev, false);
+		xdp_features_set_redirect_target(vsi->netdev, true);
 		/* reallocate Rx queues that are used for zero-copy */
 		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
 		if (xdp_ring_err)
@@ -3333,10 +3333,11 @@ static void ice_napi_add(struct ice_vsi *vsi)
 
 /**
  * ice_set_ops - set netdev and ethtools ops for the given netdev
- * @netdev: netdev instance
+ * @vsi: the VSI associated with the new netdev
  */
-static void ice_set_ops(struct net_device *netdev)
+static void ice_set_ops(struct ice_vsi *vsi)
 {
+	struct net_device *netdev = vsi->netdev;
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 
 	if (ice_is_safe_mode(pf)) {
@@ -3348,6 +3349,13 @@ static void ice_set_ops(struct net_device *netdev)
 	netdev->netdev_ops = &ice_netdev_ops;
 	netdev->udp_tunnel_nic_info = &pf->hw.udp_tunnel_nic;
 	ice_set_ethtool_ops(netdev);
+
+	if (vsi->type != ICE_VSI_PF)
+		return;
+
+	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
+			       NETDEV_XDP_ACT_RX_SG;
 }
 
 /**
@@ -4568,9 +4576,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	np->vsi = vsi;
 
 	ice_set_netdev_features(netdev);
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
-	ice_set_ops(netdev);
+	ice_set_ops(vsi);
 
 	if (vsi->type == ICE_VSI_PF) {
 		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
-- 
2.39.1

