Return-Path: <netdev+bounces-4180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4B470B879
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D87841C209E0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034EB79F5;
	Mon, 22 May 2023 09:06:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2FA1115
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:06:57 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED74410FC
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 02:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684746411; x=1716282411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1FQoGNDpARgeG1EPEIPg2rtBEXs/uG1DPbQvKEjpTCk=;
  b=ms2aXx8sspXEM7HY/7xWy1NeLU6W8AWB64qIRfGdDfjLJ3vqMowkRxvP
   feuZFUiZKErzQI+5EgJPdJtbh7Hjhrdj2jIx4WkpejpYnDp6PvY4ML1xI
   DR85WYeydHTRPMA2IO6C6n87g9rYapVyu61WsatTgvtte2Smjl/SENuJE
   ni5h0Rg5fHy2+qquU+VvFGjp+xt8a+q8zKvtF+TSXG2B+VP4HnbpsKx9G
   0nVb9ph8sihbEp9vwfpGJqeLZm7Ia6pGIlcBHD93tgGh9r+LMLB+eTpcs
   m8TsJJX+fllHZzOVSk+8nfkj4aAcvn2b1D62q0ltlnCRGizKoFWZDcXPC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="352892165"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="352892165"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 02:06:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815601784"
X-IronPort-AV: E=Sophos;i="6.00,183,1681196400"; 
   d="scan'208";a="815601784"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 02:06:49 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 864AB3372E;
	Mon, 22 May 2023 10:06:48 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com
Subject: [PATCH iwl-next v3 00/10] ice: switchdev bridge offload
Date: Mon, 22 May 2023 11:05:32 +0200
Message-Id: <20230522090542.45679-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
---
v2: two patches were droped from the series:
    - "ice: Remove exclusion code for RDMA+SRIOV" was sent as separate
      patch: https://lore.kernel.org/netdev/20230516113055.7336-1-wojciech.drewek@intel.com/
    - "ice: Ethtool fdb_cnt stats" was dropped because of the comments
      suggesting that ethtool is not a good option for such statistic.
      An alternative will be send as a separate patch.
v3: small changes in patch 5, 7 and 8 including kdoc, style fixes.

Marcin Szycik (2):
  ice: Add guard rule when creating FDB in switchdev
  ice: Add VLAN FDB support in switchdev mode

Michal Swiatkowski (2):
  ice: implement bridge port vlan
  ice: implement static version of ageing

Pawel Chmielewski (1):
  ice: add tracepoints for the switchdev bridge

Wojciech Drewek (5):
  ice: Minor switchdev fixes
  ice: Unset src prune on uplink VSI
  ice: Implement basic eswitch bridge setup
  ice: Switchdev FDB events support
  ice: Accept LAG netdevs in bridge offloads

 drivers/net/ethernet/intel/ice/Makefile       |    2 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |   43 +-
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 1346 +++++++++++++++++
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  121 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |   25 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |    1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |    6 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |    2 +-
 drivers/net/ethernet/intel/ice/ice_repr.h     |    3 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   97 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |    5 +
 drivers/net/ethernet/intel/ice/ice_trace.h    |   90 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  |  186 ++-
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.h  |    3 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c |   84 +-
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |    8 +
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |    1 +
 19 files changed, 1896 insertions(+), 133 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch_br.h

-- 
2.40.1


