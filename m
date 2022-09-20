Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222775BEECA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiITUxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiITUxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:53:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515975AC5E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663707233; x=1695243233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MULWT9xJM4QCwvSlTqPiz8GIpFgVcFIZkCsxckDlomA=;
  b=BMv9bw4/PTS33WuzaISK51G2u2TrKxn0hVy6E+PM4l+9LddyNRVsXa1i
   s+H9Xki7LjykfTHBUqICWh0EwoPy5/w0Y1B0M+OGtxqKb3IANNzF0npfj
   fvOCCoOuW8g2oStxXlbGRHOEhEYN5NSd6VAlNEVERmkqryHxTSOSxaYD6
   PPK7f+sS0oHfMkKJmzhekjlwbRXKYCWWIrIEsF9DpX03JDPeG6Z6+l/DJ
   2tzPlE3MNMyucgml6b75XXsrNoqvsOj29X2cbslh4J5nFvTpElCvhlULT
   NEtHsNy1GkoNNZis9UQW7gzg23+jLeWfx8ol7FYsCG7p86a8QmNWbWi6u
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="386103559"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="386103559"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 13:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="722904468"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 20 Sep 2022 13:53:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/2] ice: config netdev tc before setting queues number
Date:   Tue, 20 Sep 2022 13:53:43 -0700
Message-Id: <20220920205344.1860934-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
References: <20220920205344.1860934-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

After lowering number of tx queues the warning appears:
"Number of in use tx queues changed invalidating tc mappings. Priority
traffic classification disabled!"
Example command to reproduce:
ethtool -L enp24s0f0 tx 36 rx 36

Fix this by setting correct tc mapping before setting real number of
queues on netdev.

Fixes: 0754d65bd4be5 ("ice: Add infrastructure for mqprio support via ndo_setup_tc")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 04836bbaf7d5..3042a76b848d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6858,6 +6858,8 @@ int ice_vsi_open(struct ice_vsi *vsi)
 	if (err)
 		goto err_setup_rx;
 
+	ice_vsi_cfg_netdev_tc(vsi, vsi->tc_cfg.ena_tc);
+
 	if (vsi->type == ICE_VSI_PF) {
 		/* Notify the stack of the actual queue counts. */
 		err = netif_set_real_num_tx_queues(vsi->netdev, vsi->num_txq);
-- 
2.35.1

