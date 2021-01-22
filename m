Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923E6301169
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbhAWALk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:11:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:38713 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbhAVX7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:59:49 -0500
IronPort-SDR: wLN+hezA/z70W885I5lcF83+DMoKazMF2VTf/iN8XaB/YiYa8/4pp0M4oEALaPKW2iHAHAgTmn
 R807ab6xXXYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670510"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670510"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: btU7ewvKMAETKDwnCIoXE1JW81j2fQmqLtINFxWw8aCll4yD74KqwcnJLr9kGD/mKY3/pn96Qe
 hgLnc5nejZEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258676"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/7][pull request] Intel Wired LAN Driver Updates 2021-01-22
Date:   Fri, 22 Jan 2021 15:57:27 -0800
Message-Id: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice and i40e driver.

Henry corrects setting an unspecified protocol to IPPROTO_NONE instead of
0 for IPv6 flexbytes filters for ice.

Nick fixes the IPv6 extension header being processed incorrectly and
updates the netdev->dev_addr if it exists in hardware as it may have been
modified outside the ice driver.

Piotr fixes the XDP ring used for XDP_TX as it was being used
inconsistently which could cause packets to not be transmitted for the ice
driver.

Brett ensures a user cannot request more channels than available LAN MSI-X
and fixes the minimum allocation logic as it was incorrectly trying to use
more MSI-X than allocated for ice.

Stefan Assmann minimizes the delay between getting and using the VSI
pointer to prevent a possible crash for i40e.

The following are changes since commit 35c715c30b95205e64311c3bb3525094cd3d7236:
  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (2):
  ice: Don't allow more channels than LAN MSI-X available
  ice: Fix MSI-X vector fallback logic

Henry Tieman (1):
  ice: fix FDir IPv6 flexbyte

Nick Nunley (2):
  ice: Implement flow for IPv6 next header (extension header)
  ice: update dev_addr in ice_set_mac_address even if HW filter exists

Piotr Raczynski (1):
  ice: use correct xdp_ring with XDP_TX action

Stefan Assmann (1):
  i40e: acquire VSI pointer only after VF is initialized

 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c   | 11 ++++-------
 drivers/net/ethernet/intel/ice/ice.h             |  4 +++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c     |  8 ++++----
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c    |  8 +++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c         | 14 +++++++++-----
 drivers/net/ethernet/intel/ice/ice_main.c        | 16 +++++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx.c        | 11 +++++++----
 7 files changed, 43 insertions(+), 29 deletions(-)

-- 
2.26.2

