Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A023A1E3B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 22:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhFIUrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 16:47:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:64104 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFIUra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 16:47:30 -0400
IronPort-SDR: 2GSgUEGofj60V17hUocb89SDbf+8Yqm8vIYgdj65vlvpPQLwXqro3j7TYlJqn4krQQO+BBems/
 zAaEJiGdxMYg==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="266318586"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="266318586"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 13:45:30 -0700
IronPort-SDR: SsIo+ri/xY/U50BX1NBraheCxKHJFmfebnn9dbodyKVCjIrNPA5srQ742wgb8zcQZGj9si5x7Y
 Eso5XBSNlVXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="413861108"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2021 13:45:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 1/2] ice: add ndo_bpf callback for safe mode netdev ops
Date:   Wed,  9 Jun 2021 13:48:02 -0700
Message-Id: <20210609204803.234983-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
References: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

ice driver requires a programmable pipeline firmware package in order to
have a support for advanced features. Otherwise, driver falls back to so
called 'safe mode'. For that mode, ndo_bpf callback is not exposed and
when user tries to load XDP program, the following happens:

$ sudo ./xdp1 enp179s0f1
libbpf: Kernel error message: Underlying driver does not support XDP in native mode
link set xdp fd failed

which is sort of confusing, as there is a native XDP support, but not in
the current mode. Improve the user experience by providing the specific
ndo_bpf callback dedicated for safe mode which will make use of extack
to explicitly let the user know that the DDP package is missing and
that's the reason that the XDP can't be loaded onto interface currently.

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Fixes: efc2214b6047 ("ice: Add support for XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4ee85a217c6f..0eb2307325d3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2555,6 +2555,20 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	return (ret || xdp_ring_err) ? -ENOMEM : 0;
 }
 
+/**
+ * ice_xdp_safe_mode - XDP handler for safe mode
+ * @dev: netdevice
+ * @xdp: XDP command
+ */
+static int ice_xdp_safe_mode(struct net_device __always_unused *dev,
+			     struct netdev_bpf *xdp)
+{
+	NL_SET_ERR_MSG_MOD(xdp->extack,
+			   "Please provide working DDP firmware package in order to use XDP\n"
+			   "Refer to Documentation/networking/device_drivers/ethernet/intel/ice.rst");
+	return -EOPNOTSUPP;
+}
+
 /**
  * ice_xdp - implements XDP handler
  * @dev: netdevice
@@ -6937,6 +6951,7 @@ static const struct net_device_ops ice_netdev_safe_mode_ops = {
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
 	.ndo_tx_timeout = ice_tx_timeout,
+	.ndo_bpf = ice_xdp_safe_mode,
 };
 
 static const struct net_device_ops ice_netdev_ops = {
-- 
2.26.2

