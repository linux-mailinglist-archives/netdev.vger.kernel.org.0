Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FDF6E4409
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjDQJhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjDQJhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:37:03 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E514165A7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681724192; x=1713260192;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vuW0wz+O7zcEpcd8ZWQSik+qd6XqX8nuuqdf6+EcAjA=;
  b=KaGJO4D0moilTlvD0OfhZ6SXchAVDuNFf//RgmVS7qFYYJauBOd7DnTb
   c0fBtsRl4CioIX9ruEHjGo1OXIMk33dDtor8CuAzsAqRBweVOoLtFKug7
   j9SiZDjZWIqiGXUPagKU8Ac5/5mqx6LWoXK4SlMCwVXshQXPNACWc8Y6D
   CXRyGJ/91TrT7fhGZ4odf9iUl9UVT07Pwj2Jo+inzCnJ9qZJz/Qik4LPi
   D+AuSjyi8ROULqtIFI5mlKQ+APV9ZEeM/MZfLtYjXqf/b85xDfTgOY3QT
   x4bNNA2WD1qzC/0bqr8rYNp940WNw11bS1bZW/oC8pQaKxaKbwcsfotgc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333644080"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333644080"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 02:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640899243"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="640899243"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 02:35:18 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 2848037E2A;
        Mon, 17 Apr 2023 10:35:17 +0100 (IST)
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        david.m.ertman@intel.com, michal.swiatkowski@linux.intel.com,
        marcin.szycik@linux.intel.com, pawel.chmielewski@intel.com,
        sridhar.samudrala@intel.com
Subject: [PATCH net-next 00/12] ice: switchdev bridge offload
Date:   Mon, 17 Apr 2023 11:34:00 +0200
Message-Id: <20230417093412.12161-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux bridge provides ability to learn MAC addresses and vlans
detected on bridge's ports. As a result of this, FDB (forward data base)
entries are created and they can be offloaded to the HW. By adding
VF's port representors to the bridge together with the uplink netdev,
we can learn VF's and link partner's MAC addresses. This is achieved
by slow/exception-path, where packets that do not match any filters
(FDB entries in this case) are send to the bridge ports.

Driver keeps track of the netdevs added to the bridge
by listening for NETDEV_CHANGEUPPER event. We distinguish two types
of bridge ports: uplink port and VF's representor port. Linux
bridge always learns src MAC of the packet on rx path. With the
current slow-path implementation, it means that we will learn
VF's MAC on port repr (when the VF transmits the packet) and
link partner's MAC on uplink (when we receive it on uplink from LAN).

The driver is notified about learning of the MAC/VLAN by
SWITCHDEV_FDB_{ADD|DEL}_TO_DEVICE events. This is followed by creation
of the HW filter. The direction of the filter is based on port
type (uplink or VF repr). In case of the uplink, rule forwards
the packets to the LAN (matching on link partner's MAC). When the
notification is received on VF repr then the rule forwards the
packets to the associated VF (matching on VF's MAC).

This approach would not work on its own however. This is because if
one of the directions is offloaded, then the bridge would not be able
to learn the other one. If the egress rule is added (learned on uplink)
then the response from the VF will be sent directly to the LAN.
The packet will not got through slow-path, it would not be seen on
VF's port repr. Because of that, the bridge would not learn VF's MAC.

This is solved by introducing guard rule. It prevents forward rule from
working until the opposite direction is offloaded.

Aging is not fully supported yet, aging time is static for now. The
follow up submissions will introduce counters that will allow us to
keep track if the rule is actually being used or not.

A few fixes/changes are needed for this feature to work with ice driver.
These are introduced in first 3 patches.

Dave Ertman (1):
  ice: Remove exclusion code for RDMA+SRIOV

Marcin Szycik (2):
  ice: Add guard rule when creating FDB in switchdev
  ice: Add VLAN FDB support in switchdev mode

Michal Swiatkowski (2):
  ice: implement bridge port vlan
  ice: implement static version of ageing

Pawel Chmielewski (1):
  ice: add tracepoints for the switchdev bridge

Wojciech Drewek (6):
  ice: Minor switchdev fixes
  ice: Unset src prune on uplink VSI
  ice: Implement basic eswitch bridge setup
  ice: Switchdev FDB events support
  ice: Accept LAG netdevs in bridge offloads
  ice: Ethtool fdb_cnt stats

 drivers/net/ethernet/intel/ice/Makefile       |    2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   26 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |   43 +-
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 1350 +++++++++++++++++
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  112 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |    1 +
 drivers/net/ethernet/intel/ice/ice_lag.c      |   12 -
 drivers/net/ethernet/intel/ice/ice_lag.h      |   50 -
 drivers/net/ethernet/intel/ice/ice_lib.c      |   26 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |    4 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |    2 +-
 drivers/net/ethernet/intel/ice/ice_repr.h     |    3 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    |    4 -
 drivers/net/ethernet/intel/ice/ice_switch.c   |   45 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |    5 +
 drivers/net/ethernet/intel/ice/ice_trace.h    |   90 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |  195 ++-
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.h  |    3 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c |   84 +-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |    8 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |    1 +
 23 files changed, 1876 insertions(+), 192 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.h

-- 
2.39.2

