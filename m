Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A80F52E1AE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344314AbiETBQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344331AbiETBQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:16:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F33369EF
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009359; x=1684545359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2oGbbUjYj0E3aAlL81he4Ni36pw6OBr/I251pMEuLHY=;
  b=b46yZrq3U6OrbKxN+Am29jEUkzyKlUJnRVbW90oPo7f2xl0k9WUAy8S9
   FWB5syvd4ZMSO9qJOti48kjwnqhs1AOOeDjy0Qkm75GWapqvZGm4JVtso
   TZ40iPkDYPcCS9FTC5lc+wvYctCg0PccyqznfQL46kOYyhFQvsnLeW7Dt
   6dqdXB2qbNgA96DLr5Ziior69gjQ435vL3o1cPumNF0DZVkY82dXyt+Dv
   Nudto9AZyMZOqNqnXTwOL2Yxtn16isYMXjIRCd/aEpkPuPG2DU95CG3c5
   5euFYHrgnDxsYOGbam4yv8uMi+kk7EcprSBsGjDJbYW/oCaEq5bpN+wiz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064154"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064154"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534542"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:53 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 03/11] igc: Add support for receiving frames with all zeroes address
Date:   Thu, 19 May 2022 18:15:30 -0700
Message-Id: <20220520011538.1098888-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The frame preemption verification (as defined by IEEE 802.3-2018
Section 99.4.3) handshake is done by the driver, the default
configuration of the driver is to only receive frames with the driver
address.

So, in preparation for that add a second address to the list of
acceptable addresses.

Because the frame preemption "disable verify" toggle only affects the
transmission of verification frames, this needs to always be enabled.
As that address is invalid, the impact in practical scenarios should
be minimal. But still a bummer that we have to do this.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      | 2 ++
 drivers/net/ethernet/intel/igc/igc_main.c | 7 +++++++
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 7 +++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 1e7e7071f64d..31e7b4c72894 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -622,6 +622,8 @@ struct igc_nfc_rule *igc_get_nfc_rule(struct igc_adapter *adapter,
 int igc_add_nfc_rule(struct igc_adapter *adapter, struct igc_nfc_rule *rule);
 void igc_del_nfc_rule(struct igc_adapter *adapter, struct igc_nfc_rule *rule);
 
+int igc_enable_empty_addr_recv(struct igc_adapter *adapter);
+
 void igc_ptp_init(struct igc_adapter *adapter);
 void igc_ptp_reset(struct igc_adapter *adapter);
 void igc_ptp_suspend(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ae17af44fe02..bcbf35b32ef3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3586,6 +3586,13 @@ static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 	return 0;
 }
 
+int igc_enable_empty_addr_recv(struct igc_adapter *adapter)
+{
+	u8 empty[ETH_ALEN] = { };
+
+	return igc_add_mac_filter(adapter, IGC_MAC_FILTER_TYPE_DST, empty, -1);
+}
+
 /**
  * igc_set_rx_mode - Secondary Unicast, Multicast and Promiscuous mode set
  * @netdev: network interface device structure
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 0fce22de2ab8..270a08196f49 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -235,6 +235,13 @@ int igc_tsn_reset(struct igc_adapter *adapter)
 	unsigned int new_flags;
 	int err = 0;
 
+	/* Frame preemption verification requires that packets with
+	 * the all zeroes MAC address are allowed to be received. Add
+	 * the all zeroes destination address to the list of
+	 * acceptable addresses.
+	 */
+	igc_enable_empty_addr_recv(adapter);
+
 	new_flags = igc_tsn_new_flags(adapter);
 
 	if (!(new_flags & IGC_FLAG_TSN_ANY_ENABLED))
-- 
2.35.3

