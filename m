Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BF530B53A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhBBCZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:25:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:11679 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231128AbhBBCZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:25:26 -0500
IronPort-SDR: WtGidEPe52GAS8K7qAlY9F0CE7b387Q1OXgUNAIucktdYikZu6ZcoivDiD9HJ1NDc6rvnm6K5a
 ALHUuiBgeDBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180929272"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180929272"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:23:40 -0800
IronPort-SDR: qIAJuSV0FgCqFATnuenuxbpURWRXkPB/8PJAkzG3pxjn+UWDo8R/negCpTRa1MTgDIDf82mGz9
 LMas1nSpqekw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="581782148"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2021 18:23:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Eryk Rybak <eryk.roch.rybak@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 6/6] i40e: Log error for oversized MTU on device
Date:   Mon,  1 Feb 2021 18:24:20 -0800
Message-Id: <20210202022420.1328397-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

When attempting to link XDP prog with MTU larger than supported,
user is not informed why XDP linking fails. Adding proper
error message: "MTU too large to enable XDP".
Due to the lack of support for non-static variables in netlinks
extended ACK feature, additional information has been added to dmesg
to better inform about invalid MTU setting.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f35bd9164106..b52a324a9f28 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12448,9 +12448,10 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
  * i40e_xdp_setup - add/remove an XDP program
  * @vsi: VSI to changed
  * @prog: XDP program
+ * @extack: netlink extended ack
  **/
-static int i40e_xdp_setup(struct i40e_vsi *vsi,
-			  struct bpf_prog *prog)
+static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
+			  struct netlink_ext_ack *extack)
 {
 	int frame_size = vsi->netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	struct i40e_pf *pf = vsi->back;
@@ -12459,8 +12460,13 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	int i;
 
 	/* Don't allow frames that span over multiple buffers */
-	if (frame_size > vsi->rx_buf_len)
+	if (frame_size > vsi->rx_buf_len) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
+		dev_info(&pf->pdev->dev,
+			 "MTU of %u bytes is too large to enable XDP (maximum: %u bytes)\n",
+			 vsi->netdev->mtu, vsi->rx_buf_len);
 		return -EINVAL;
+	}
 
 	if (!i40e_enabled_xdp_vsi(vsi) && !prog)
 		return 0;
@@ -12772,7 +12778,7 @@ static int i40e_xdp(struct net_device *dev,
 
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return i40e_xdp_setup(vsi, xdp->prog);
+		return i40e_xdp_setup(vsi, xdp->prog, xdp->extack);
 	case XDP_SETUP_XSK_POOL:
 		return i40e_xsk_pool_setup(vsi, xdp->xsk.pool,
 					   xdp->xsk.queue_id);
-- 
2.26.2

