Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEF1513ADD
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350498AbiD1Ran (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350469AbiD1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FCA3DA57
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166836; x=1682702836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oQHF0MxRs02HmgOOIurAmhbq3IyojkMUdHe7Mbq0q1Q=;
  b=Zxq+wxwgzTORosavilBDKhT17xIAO6JchJgdEAnNHPB4bRuyrLN6ofsn
   7y+BSIB7X25rKkkutIH216LB+Y1WMbEonUyglxKYNfGGyX2duh0ah7Q28
   NPcwHNuWoT5JxlFeaBzXawDcjxSPD+cUxgHUof8tFc4PlxrdFqWSBXCgf
   ruPnHvCxlv8Bs0MtlQBjUdl5Zevp2+WVag9xDHUUrl9E5G2NZVOfOhJDv
   UsAvfAU3/4jJk0FKmcn3O4juXzJ65oGggwF6UjNBxehzYZNxqIG28J8sZ
   /64vTH56yQQDrX4S98umCkiJ2XW8YAq3OAT5ICDSd0X5NnkMKlslYYiDm
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306358"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306358"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497041"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 05/11] ice: get switch id on switchdev devices
Date:   Thu, 28 Apr 2022 10:24:24 -0700
Message-Id: <20220428172430.1004528-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Switch id should be the same for each netdevice on a driver.
The id must be unique between devices on the same system, but
does not need to be unique between devices on different systems.

The switch id is used to locate ports on a switch and to know if
aggregated ports belong to the same switch.

To meet this requirements, use pci_get_dsn as switch id value, as
this is unique value for each devices on the same system.

Implementing switch id is needed by automatic tools for kubernetes.

Set switch id by setting devlink port attribiutes and calling
devlink_port_attrs_set while creating pf (for uplink) and vf
(for representator) devlink port.

To get switch id (in switchdev mode):
cat /sys/class/net/$PF0/phys_switch_id

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 22 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_main.c    | 15 +++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index a230edb38466..d12852d698af 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -647,6 +647,23 @@ void ice_devlink_unregister(struct ice_pf *pf)
 	devlink_unregister(priv_to_devlink(pf));
 }
 
+/**
+ * ice_devlink_set_switch_id - Set unique switch id based on pci dsn
+ * @pf: the PF to create a devlink port for
+ * @ppid: struct with switch id information
+ */
+static void
+ice_devlink_set_switch_id(struct ice_pf *pf, struct netdev_phys_item_id *ppid)
+{
+	struct pci_dev *pdev = pf->pdev;
+	u64 id;
+
+	id = pci_get_dsn(pdev);
+
+	ppid->id_len = sizeof(id);
+	put_unaligned_be64(id, &ppid->id);
+}
+
 int ice_devlink_register_params(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
@@ -704,6 +721,9 @@ int ice_devlink_create_pf_port(struct ice_pf *pf)
 
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = pf->hw.bus.func;
+
+	ice_devlink_set_switch_id(pf, &attrs.switch_id);
+
 	devlink_port_attrs_set(devlink_port, &attrs);
 	devlink = priv_to_devlink(pf);
 
@@ -760,6 +780,8 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
 	attrs.pci_vf.pf = pf->hw.bus.func;
 	attrs.pci_vf.vf = vf->vf_id;
 
+	ice_devlink_set_switch_id(pf, &attrs.switch_id);
+
 	devlink_port_attrs_set(devlink_port, &attrs);
 	devlink = priv_to_devlink(pf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0666a9105871..c3413ddfd011 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -296,6 +296,20 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	return status;
 }
 
+/**
+ * ice_get_devlink_port - Get devlink port from netdev
+ * @netdev: the netdevice structure
+ */
+static struct devlink_port *ice_get_devlink_port(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	if (!ice_is_switchdev_running(pf))
+		return NULL;
+
+	return &pf->devlink_port;
+}
+
 /**
  * ice_vsi_sync_fltr - Update the VSI filter list to the HW
  * @vsi: ptr to the VSI
@@ -8923,4 +8937,5 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
+	.ndo_get_devlink_port = ice_get_devlink_port,
 };
-- 
2.31.1

