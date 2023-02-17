Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B4F69A9C5
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBQLIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjBQLIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:08:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DE85B75B
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676632066; x=1708168066;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FXlizv0AbHk0WG3hx2Ag3u/2UpnWpDsyVSAhEf9y++4=;
  b=nEpR5nezqlDPGKcUNEWRZzFhca/Lh3eRputwQp1OLY89J3NCeUouBsmM
   R8r3f0djjIdT+Om757PkIUNK0FDwEewOFvF2aReI37NR8pCLXzvErykYG
   xxY0/uvGFtD+Y4QVnB01SDTleFeBSM6dF7wSoo9lgoKrOmQsVKerPfw0w
   iTipCGwYImBPohdwkPLWPdbqFM+zvV7BRLhvyV0zx20Po10pDSuQc95u9
   zQ5ftbbMqKeUg+dnJAvGQweFJyXGzjvL7HjPuO0ONI6uhR8kMICeSSDF/
   0dBW9EvK+xsNtvyFh67ejYiUJVLKI1J+t+XOTb5Y5/ztnH4+CkqDLD0h1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333323320"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="333323320"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 03:07:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="844538024"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="844538024"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga005.jf.intel.com with ESMTP; 17 Feb 2023 03:07:12 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next v1] ice: properly alloc ICE_VSI_LB
Date:   Fri, 17 Feb 2023 11:50:17 +0100
Message-Id: <20230217105017.21057-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink reload patchset introduced regression. ICE_VSI_LB wasn't
taken into account when doing default allocation. Fix it by adding a
case for ICE_VSI_LB in ice_vsi_alloc_def().

Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5e81f7ae252c..3c41ebfc23d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -627,6 +627,7 @@ ice_vsi_alloc_def(struct ice_vsi *vsi, struct ice_channel *ch)
 		vsi->next_base_q = ch->base_q;
 		break;
 	case ICE_VSI_VF:
+	case ICE_VSI_LB:
 		break;
 	default:
 		ice_vsi_free_arrays(vsi);
-- 
2.36.1

