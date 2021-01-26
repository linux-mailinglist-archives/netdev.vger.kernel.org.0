Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BD1304DAC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbhAZXNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:62462 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbhAZWKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:10:53 -0500
IronPort-SDR: wC4o29CiUaCHxEU1TaGtjoJoCcGkhn6cAtsGEOSI7dAHW6kQkTUbmA+61OvvlxW61PXUcfF3zq
 YBsNZGbOYpyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179198672"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="179198672"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:10:00 -0800
IronPort-SDR: efX/uAAEsIz3h6js7MbOw/Dn6Ph+VF3GW09tozS5ehMWHdd4Cl8MB4y/e7iMxfXudqik4dtNYB
 uRy6P+BmHBTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472908301"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2021 14:10:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net v2 0/7][pull request] Intel Wired LAN Driver Updates 2021-01-26
Date:   Tue, 26 Jan 2021 14:10:28 -0800
Message-Id: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice, i40e, and igc driver.

Henry corrects setting an unspecified protocol to IPPROTO_NONE instead of
0 for IPv6 flexbytes filters for ice.

Nick fixes the IPv6 extension header being processed incorrectly and
updates the netdev->dev_addr if it exists in hardware as it may have been
modified outside the ice driver.

Brett ensures a user cannot request more channels than available LAN MSI-X
and fixes the minimum allocation logic as it was incorrectly trying to use
more MSI-X than allocated for ice.

Stefan Assmann minimizes the delay between getting and using the VSI
pointer to prevent a possible crash for i40e.

Corinna Vinschen fixes link speed advertising for igc.

v2: Dropped patch 4 (ice XDP). Added igc link speed advertisement patch
(patch 7).

The following are changes since commit 07d46d93c9acdfe0614071d73c415dd5f745cc6e:
  uapi: fix big endian definition of ipv6_rpl_sr_hdr
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (2):
  ice: Don't allow more channels than LAN MSI-X available
  ice: Fix MSI-X vector fallback logic

Corinna Vinschen (1):
  igc: fix link speed advertising

Henry Tieman (1):
  ice: fix FDir IPv6 flexbyte

Nick Nunley (2):
  ice: Implement flow for IPv6 next header (extension header)
  ice: update dev_addr in ice_set_mac_address even if HW filter exists

Stefan Assmann (1):
  i40e: acquire VSI pointer only after VF is initialized

 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 11 ++++-----
 drivers/net/ethernet/intel/ice/ice.h          |  4 +++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  8 +++----
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  8 ++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 14 +++++++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 16 +++++++------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  9 ++++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 24 ++++++++++++++-----
 8 files changed, 60 insertions(+), 34 deletions(-)

-- 
2.26.2

