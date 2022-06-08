Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4E354387D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbiFHQMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245029AbiFHQME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:12:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702F636178
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654704722; x=1686240722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PxsINHEpd8b9IMZKDQUI8e/Ymowx9BIhD0vx0ZP2hQo=;
  b=ia9lg7POXD/klJq3o4FfyXlbkDxhX7mVx+O9xpikkKnn1OwrubXn0g6x
   BVvBvLxKKg54DSxg/nvwDGRnIEtN0K76kPJwhH3HophdzpEQku0iBq7Go
   zuRURDd5LiJoJOOt5vHH2m12kj1v4pUA2/b2LsWI4YG21+6rBkfKbh1eZ
   rTsSonTUKw5ZUlSwcQCUO5SyRtMD0JK6ouyJc8hMGrwrA0aCfORK5+dNG
   CZUgo0AqufxNLPJTRpoiyBq0mQelPBET2sMWPi7Ik/Ifd054MJTkbTunS
   NZ2mPaVBEcsppVQlNa5ngtXwJssRRnTcYyVMfDb2X1ww7bZggRG2QHXC4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="260099551"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="260099551"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 09:11:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="827049681"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2022 09:11:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/4] ice: Use correct order for the parameters of devm_kcalloc()
Date:   Wed,  8 Jun 2022 09:07:57 -0700
Message-Id: <20220608160757.2395729-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
References: <20220608160757.2395729-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

We should have 'n', then 'size', not the opposite.
This is harmless because the 2 values are just multiplied, but having
the correct order silence a (unpublished yet) smatch warning.

While at it use '*tun_seg' instead '*seg'. The both variable have the same
type, so the result is the same, but it lokks more logical.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 5d10c4f84a36..ead6d50fc0ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -852,7 +852,7 @@ ice_create_init_fdir_rule(struct ice_pf *pf, enum ice_fltr_ptype flow)
 	if (!seg)
 		return -ENOMEM;
 
-	tun_seg = devm_kcalloc(dev, sizeof(*seg), ICE_FD_HW_SEG_MAX,
+	tun_seg = devm_kcalloc(dev, ICE_FD_HW_SEG_MAX, sizeof(*tun_seg),
 			       GFP_KERNEL);
 	if (!tun_seg) {
 		devm_kfree(dev, seg);
@@ -1214,7 +1214,7 @@ ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp,
 	if (!seg)
 		return -ENOMEM;
 
-	tun_seg = devm_kcalloc(dev, sizeof(*seg), ICE_FD_HW_SEG_MAX,
+	tun_seg = devm_kcalloc(dev, ICE_FD_HW_SEG_MAX, sizeof(*tun_seg),
 			       GFP_KERNEL);
 	if (!tun_seg) {
 		devm_kfree(dev, seg);
-- 
2.35.1

