Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1665974D5
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbiHQRNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiHQRNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:13:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8868E9C2CF
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660756418; x=1692292418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xH9WhM4IQUO8eobRJYtgdn9NHjpU7SJJLQtxuORMhLo=;
  b=CNPHrVqxW/nZIqYJR7Q8VdmmXHEl4/9WT9v4w8xYIX7/+KiMKIi0Btc0
   goX458Z1QGnDm6j+jQsKxObklhrUM8IKcxsnFphp1nD71529dNnpxb3Qf
   2ZWu2doYKgwIWb4uMfvIpjCKArhALoQelAqUgoyQdSrW2TvqR/M10RtWE
   R/6/tv2SSsZm/zB3GhiCwdN8RSdZVEZN73JYC+JvQHpQMwLh8IvQqPKtC
   Voy402vyefW1JGBM2JjmS2Rup4/chenp4wJbEgaeZwrr6ok8jh59YLLtF
   6CQlBfNV6dJ5AIDXuWfbmeajJiJhXJ4FGDDkWyvnSVmPTtUHS3BPIibzu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="291307372"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="291307372"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 10:13:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="558204988"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2022 10:13:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Benjamin Mikailenko <benjamin.mikailenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        ivecera@redhat.com, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 4/5] ice: Ignore error message when setting same promiscuous mode
Date:   Wed, 17 Aug 2022 10:13:28 -0700
Message-Id: <20220817171329.65285-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
References: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Mikailenko <benjamin.mikailenko@intel.com>

Commit 1273f89578f2 ("ice: Fix broken IFF_ALLMULTI handling")
introduced new checks when setting/clearing promiscuous mode. But if the
requested promiscuous mode setting already exists, an -EEXIST error
message would be printed. This is incorrect because promiscuous mode is
either on/off and shouldn't print an error when the requested
configuration is already set.

This can happen when removing a bridge with two bonded interfaces and
promiscuous most isn't fully cleared from VLAN VSI in hardware.

Fix this by ignoring cases where requested promiscuous mode exists.

Fixes: 1273f89578f2 ("ice: Fix broken IFF_ALLMULTI handling")
Signed-off-by: Benjamin Mikailenko <benjamin.mikailenko@intel.com>
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Link: https://lore.kernel.org/all/CAK8fFZ7m-KR57M_rYX6xZN39K89O=LGooYkKsu6HKt0Bs+x6xQ@mail.gmail.com/
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index 85a94483c2ed..40e678cfb507 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -62,7 +62,7 @@ ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
 	int result;
 
 	result = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
-	if (result)
+	if (result && result != -EEXIST)
 		dev_err(ice_pf_to_dev(pf),
 			"Error setting promisc mode on VSI %i (rc=%d)\n",
 			vsi->vsi_num, result);
@@ -86,7 +86,7 @@ ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
 	int result;
 
 	result = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
-	if (result)
+	if (result && result != -EEXIST)
 		dev_err(ice_pf_to_dev(pf),
 			"Error clearing promisc mode on VSI %i (rc=%d)\n",
 			vsi->vsi_num, result);
@@ -109,7 +109,7 @@ ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 	int result;
 
 	result = ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
-	if (result)
+	if (result && result != -EEXIST)
 		dev_err(ice_pf_to_dev(pf),
 			"Error clearing promisc mode on VSI %i for VID %u (rc=%d)\n",
 			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
@@ -132,7 +132,7 @@ ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 	int result;
 
 	result = ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
-	if (result)
+	if (result && result != -EEXIST)
 		dev_err(ice_pf_to_dev(pf),
 			"Error setting promisc mode on VSI %i for VID %u (rc=%d)\n",
 			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
-- 
2.35.1

