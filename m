Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78293649E03
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiLLLgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiLLLgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:36:05 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB517FD01
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670844796; x=1702380796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=unS16nVWy3isgLs85nEntpNArvPSZg+8ZBDHAbDTZtc=;
  b=XhpOirjxd5tOdkazSqCCvgh4ZH0zMnyRNMrXQy7Ootgzahux4OB2YGYW
   Q4iwoA01ZR0AeS8MP2c7Kvtmfh7ql1mIcANkha+GMDRQ3s0YUyAw4ZRTU
   4ycVTR/pZn3UpQ2Y7J8vJom90hbwcNnWnK2iVj4qBdo0oQEtHP7y1wNsl
   qD2Xe7+HXxysqoLPcB3yjV067cORuIQKwOKy+OntVf5zMhKz+TxmApSQV
   rTZPP7I80QOcfK8057dKsRG0TpSkMNb9aDguxa5G16U/8vnjCWTcuM9Ae
   rCC3+hdx29oYGwHfyDHcvkzkGckZajgkbbZnG6zsKw/SEu7ownwR4cY2j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317861515"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317861515"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 03:33:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="893459813"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="893459813"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by fmsmga006.fm.intel.com with ESMTP; 12 Dec 2022 03:33:12 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, leon@kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v1 07/10] ice: sync netdev filters after clearing VSI
Date:   Mon, 12 Dec 2022 12:16:42 +0100
Message-Id: <20221212111645.1198680-8-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In driver reload path the netdev isn't removed, but VSI is. Remove
filters on netdev right after removing them on VSI.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index 40e678cfb507..aff7a141c30d 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -208,6 +208,11 @@ static int ice_fltr_remove_eth_list(struct ice_vsi *vsi, struct list_head *list)
 void ice_fltr_remove_all(struct ice_vsi *vsi)
 {
 	ice_remove_vsi_fltr(&vsi->back->hw, vsi->idx);
+	/* sync netdev filters if exist */
+	if (vsi->netdev) {
+		__dev_uc_unsync(vsi->netdev, NULL);
+		__dev_mc_unsync(vsi->netdev, NULL);
+	}
 }
 
 /**
-- 
2.36.1

