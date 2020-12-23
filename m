Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4263C2E1511
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgLWCWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbgLWCWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E6002332A;
        Wed, 23 Dec 2020 02:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690121;
        bh=1GB7BcDW3+Z6TwsT32Um4FgaMlGnJC75DeJMDOCwtb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPPQ27kM8WT+HWJnNWsIV3kFGDRWp2Iy98dwKmKB1WhRFt4qUwmd3d2HWquVFl+Dn
         w52FCNUMTdCRHuCVuGYtFtaq3kZG+Gcy210iQ+cDLZNOGpsd5/YuOBKpiP70fbSCYx
         kMQOSjib+0oMI55I4FTiy/AHXQtD7Kraymbx8vKov08PxLa+csZt+G8Q4U9kTgwq6B
         AjM/UE2jHTMay1rE0DUBXeVfyU/eLwgzcIRrdmLH/iX6Ckwjgcct5lCh1F+ZLFFbjf
         nJ8VypBhzfQxVerEUkSrgkjMCf7mS2EGti3oIuczJNEzBsHwkEhVVsy8U4hszb37tF
         ByLEsY1aTmCwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 47/87] i40e: report correct VF link speed when link state is set to enable
Date:   Tue, 22 Dec 2020 21:20:23 -0500
Message-Id: <20201223022103.2792705-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 6ec12e1e9404acb27a7434220bbe5f75e7bb2859 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index dd0c9604d3c92..bf2a1ae428610 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -58,7 +58,7 @@ static void i40e_vc_notify_vf_link_state(struct i40e_vf *vf)
 	if (vf->link_forced) {
 		pfe.event_data.link_event.link_status = vf->link_up;
 		pfe.event_data.link_event.link_speed =
-			(vf->link_up ? VIRTCHNL_LINK_SPEED_40GB : 0);
+			(vf->link_up ? i40e_virtchnl_link_speed(ls->link_speed) : 0);
 	} else {
 		pfe.event_data.link_event.link_status =
 			ls->link_info & I40E_AQ_LINK_UP;
@@ -4204,6 +4204,7 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
+	struct i40e_link_status *ls = &pf->hw.phy.link_info;
 	struct virtchnl_pf_event pfe;
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_vf *vf;
@@ -4236,7 +4237,7 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 		vf->link_forced = true;
 		vf->link_up = true;
 		pfe.event_data.link_event.link_status = true;
-		pfe.event_data.link_event.link_speed = VIRTCHNL_LINK_SPEED_40GB;
+		pfe.event_data.link_event.link_speed = i40e_virtchnl_link_speed(ls->link_speed);
 		break;
 	case IFLA_VF_LINK_STATE_DISABLE:
 		vf->link_forced = true;
-- 
2.27.0

