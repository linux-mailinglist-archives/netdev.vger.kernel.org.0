Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8B9262A24
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgIIIWt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Sep 2020 04:22:49 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45575 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgIIIWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:22:47 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-fBFSYcAiPF-74OjipI43Wg-1; Wed, 09 Sep 2020 04:22:42 -0400
X-MC-Unique: fBFSYcAiPF-74OjipI43Wg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F955801AE9;
        Wed,  9 Sep 2020 08:22:41 +0000 (UTC)
Received: from p50.redhat.com (ovpn-113-171.ams2.redhat.com [10.36.113.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 918E810013D0;
        Wed,  9 Sep 2020 08:22:39 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, lihong.yang@intel.com,
        sassmann@kpanic.de
Subject: [PATCH] i40e: report correct VF link speed when link state is set to enable
Date:   Wed,  9 Sep 2020 10:22:12 +0200
Message-Id: <20200909082212.67583-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sassmann@kpanic.de
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: kpanic.de
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8e133d6545bd..9c4b166f3346 100644
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
@@ -4404,6 +4404,7 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_pf *pf = np->vsi->back;
+	struct i40e_link_status *ls = &pf->hw.phy.link_info;
 	struct virtchnl_pf_event pfe;
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_vf *vf;
@@ -4441,7 +4442,7 @@ int i40e_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
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

