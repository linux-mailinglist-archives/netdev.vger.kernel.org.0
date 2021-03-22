Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00373450D1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhCVUbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:31:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:5512 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhCVUbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:19 -0400
IronPort-SDR: mcj+hC53M52BS5iZa33IuquzeD5aXDROKkvweW8H0zFSeRNFu+T8JpfXLdjI9mpF3oM69IrYja
 vMxY3D7tQUhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438209"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438209"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:18 -0700
IronPort-SDR: AdqdhKi8GPaq3tlLHnWwVIpPx+xFICp33k7b9OrA5NXZNrHcFDhWEjQ8zLEDdjL6rYCcndtM/I
 vzqZhpkxVgrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810567"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, haiyue.wang@intel.com, qi.z.zhang@intel.com
Subject: [PATCH net-next 00/18][pull request] 100GbE Intel Wired LAN Driver Updates 2021-03-22
Date:   Mon, 22 Mar 2021 13:32:26 -0700
Message-Id: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Haiyue Wang says:

The Intel E810 Series supports a programmable pipeline for a domain
specific protocols classification, for example GTP by Dynamic Device
Personalization (DDP) profile.

The E810 PF has introduced flex-bytes support by ethtool user-def option
allowing for packet deeper matching based on an offset and value for DDP
usage.

For making VF also benefit from this flexible protocol classification,
some new virtchnl messages are defined and handled by PF, so VF can
query this new flow director capability, and use ethtool with extending
the user-def option to configure Rx flow classification.

The new user-def 0xAAAABBBBCCCCDDDD: BBBB is the 2 byte pattern while
AAAA corresponds to its offset in the packet. Similarly DDDD is the 2
byte pattern with CCCC being the corresponding offset. The offset ranges
from 0x0 to 0x1F7 (up to 504 bytes into the packet). The offset starts
from the beginning of the packet.

This feature can be used to allow customers to set flow director rules
for protocols headers that are beyond standard ones supported by
ethtool (e.g. PFCP or GTP-U).

Like for matching GTP-U's TEID value 0x10203040:
ethtool -N ens787f0v0 flow-type udp4 dst-port 2152 \
    user-def 0x002e102000303040 action 13

The following are changes since commit a1e6f641e3075fa83403c699e64623ae272080e2:
  Revert "net: dsa: sja1105: Clear VLAN filtering offload netdev feature"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Haiyue Wang (5):
  iavf: Add framework to enable ethtool ntuple filters
  iavf: Support IPv4 Flow Director filters
  iavf: Support IPv6 Flow Director filters
  iavf: Support Ethernet Type Flow Director filters
  iavf: Enable flex-bytes support

Qi Zhang (13):
  ice: Add more basic protocol support for flow filter
  ice: Support non word aligned input set field
  ice: Add more advanced protocol support in flow filter
  ice: Support to separate GTP-U uplink and downlink
  ice: Enhanced IPv4 and IPv6 flow filter
  ice: Add support for per VF ctrl VSI enabling
  ice: Enable FDIR Configure for AVF
  ice: Add FDIR pattern action parser for VF
  ice: Add new actions support for VF FDIR
  ice: Add non-IP Layer2 protocol FDIR filter for AVF
  ice: Add GTPU FDIR filter for AVF
  ice: Add more FDIR filter type for AVF
  ice: Check FDIR program status for AVF

 drivers/net/ethernet/intel/iavf/Makefile      |    2 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   12 +
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  631 +++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.c   |  773 ++++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.h   |  113 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   29 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  192 ++
 drivers/net/ethernet/intel/ice/Makefile       |    2 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |    4 +
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  486 +++-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |   58 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  528 +++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |    3 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   78 +
 drivers/net/ethernet/intel/ice/ice_flow.c     |  725 +++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |  160 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   18 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   22 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   64 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   11 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |   10 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |    5 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   18 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 2204 +++++++++++++++++
 .../ethernet/intel/ice/ice_virtchnl_fdir.h    |   55 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   78 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |    8 +
 include/linux/avf/virtchnl.h                  |  278 +++
 29 files changed, 6488 insertions(+), 84 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_fdir.c
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_fdir.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h

-- 
2.26.2

