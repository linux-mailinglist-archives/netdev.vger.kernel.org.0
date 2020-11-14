Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C81C2B2989
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgKNALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:11:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:46586 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgKNALb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:11:31 -0500
IronPort-SDR: O3GogUxDgv0V8sK9/O+xpThM1dtH2zkWtmbOX1D8bmFq41QR/lTMeVWP98yP0D2l8jJ5hQpaoy
 vEbXxxEvjw1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="150397828"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="150397828"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 16:11:26 -0800
IronPort-SDR: oRdJZ6PM8Hd77677j92t1aYTCMCA/qjdYU5ZTdXcMyPOO7eM5gjxQJQKa4/ZVwKGIcMVh9judT
 ezF9tIxkjRxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="361505847"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 13 Nov 2020 16:11:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 3/4] i40e: report correct VF link speed when link state is set to enable
Date:   Fri, 13 Nov 2020 16:10:56 -0800
Message-Id: <20201114001057.2133426-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
References: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

When the virtual link state was set to "enable" ethtool would report
link speed as 40000Mb/s regardless of the underlying device.
Report the correct link speed.

Example from a XXV710 NIC.
Before:
$ ip link set ens3f0 vf 0 state auto
$  ethtool enp8s2 | grep Speed
        Speed: 25000Mb/s
$ ip link set ens3f0 vf 0 state enable
$ ethtool enp8s2 | grep Speed
        Speed: 40000Mb/s
After:
$ ip link set ens3f0 vf 0 state auto
$  ethtool enp8s2 | grep Speed
        Speed: 25000Mb/s
$ ip link set ens3f0 vf 0 state enable
$ ethtool enp8s2 | grep Speed
        Speed: 25000Mb/s

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 4919d22d7b6b..2532f8eed6a8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -63,7 +63,7 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 	} else if (vf->link_forced) {
 		pfe.event_data.link_event.link_status = vf->link_up;
 		pfe.event_data.link_event.link_speed =
-			(vf->link_up ? VIRTCHNL_LINK_SPEED_40GB : 0);
+			(vf->link_up ? i40e_virtchnl_link_speed(ls->link_speed) : 0);
 	} else {
 		pfe.event_data.link_event.link_status =
 			ls->link_info & I40E_AQ_LINK_UP;
@@ -4437,6 +4437,7 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
+	struct i40e_link_status *ls = &pf->hw.phy.link_info;
 	struct virtchnl_pf_event pfe;
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_vf *vf;
@@ -4474,7 +4475,7 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 		vf->link_forced = true;
 		vf->link_up = true;
 		pfe.event_data.link_event.link_status = true;
-		pfe.event_data.link_event.link_speed = VIRTCHNL_LINK_SPEED_40GB;
+		pfe.event_data.link_event.link_speed = i40e_virtchnl_link_speed(ls->link_speed);
 		break;
 	case IFLA_VF_LINK_STATE_DISABLE:
 		vf->link_forced = true;
-- 
2.26.2

