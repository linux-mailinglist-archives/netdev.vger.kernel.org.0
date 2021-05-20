Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505F6389E2B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhETGsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:48:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:17784 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhETGsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 02:48:23 -0400
IronPort-SDR: AIBLLacH/nJpj0nrMIld7Z2IksPnQjeE3G0HilpsQ93mfjYqufK1ecvOokdqfVB8KX2kspOmda
 zvkHJLMEec1A==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="181437738"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181437738"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 23:47:02 -0700
IronPort-SDR: 8P4DFdf6+F4HAR97e8pCzDO9Zv/CWMo5+PhCCX9GcISp6jEUCB2pYytxGRIn2dlGl1NqkxDVGu
 /44KZldwInPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="543203135"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2021 23:47:00 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH v2 intel-net 1/2] ice: add ndo_bpf callback for safe mode netdev ops
Date:   Thu, 20 May 2021 08:34:59 +0200
Message-Id: <20210520063500.62037-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210520063500.62037-1-maciej.fijalkowski@intel.com>
References: <20210520063500.62037-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/ice/ice_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1033d7836891..dfd4f07837cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2571,6 +2571,20 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
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
@@ -6953,6 +6967,7 @@ static const struct net_device_ops ice_netdev_safe_mode_ops = {
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
 	.ndo_tx_timeout = ice_tx_timeout,
+	.ndo_bpf = ice_xdp_safe_mode,
 };
 
 static const struct net_device_ops ice_netdev_ops = {
-- 
2.20.1

