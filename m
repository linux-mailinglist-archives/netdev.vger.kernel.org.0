Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15103685E5
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhDVRaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:60039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237414AbhDVRaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:11 -0400
IronPort-SDR: B+5m9K/+NnuTS/J6RZhO2lWZoK6dLEiW0fWIvjmg3iBkRXXoWVLhYjby7KAQ2NMw1e/O1AB5c5
 cfRklLuL01yQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991476"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991476"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:35 -0700
IronPort-SDR: x2d70pDipYsOhupZvGLtPX0QTFgJHHIdCgoWoFC2Q5dX/oUKbEnhwJ+UJvPIP59xhe84z3qFV8
 pCoZ0aNViFXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286258"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver Updates 2021-04-22
Date:   Thu, 22 Apr 2021 10:31:18 -0700
Message-Id: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to virtchnl header file, ice, and iavf
drivers.

Vignesh adds support to warn about potentially malicious VFs; those that
are overflowing the mailbox for the ice driver.

Michal adds support for an allowlist/denylist of VF commands based on
supported capabilities for the ice driver.

Brett adds support for iavf UDP segmentation offload by adding the
capability bit to virtchnl, advertising support in the ice driver, and
enabling it in the iavf driver. He also adds a helper function for
getting the VF VSI for ice.

Colin Ian King removes an unneeded pointer assignment.

Qi enables support in the ice driver to support virtchnl requests from
the iavf to configure its own RSS input set. This includes adding new
capability bits, structures, and commands to virtchnl header file.

Haiyue enables configuring RSS flow hash via ethtool to support TCP, UDP
and SCTP protocols in iavf.

The following are changes since commit 5d869070569a23aa909c6e7e9d010fc438a492ef:
  net: phy: marvell: don't use empty switch default case
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (3):
  ice: Advertise virtchnl UDP segmentation offload capability
  iavf: add support for UDP Segmentation Offload
  ice: Add helper function to get the VF's VSI

Colin Ian King (1):
  ice: remove redundant assignment to pointer vsi

Haiyue Wang (4):
  iavf: Add framework to enable ethtool RSS config
  iavf: Support for modifying TCP RSS flow hashing
  iavf: Support for modifying UDP RSS flow hashing
  iavf: Support for modifying SCTP RSS flow hashing

Michal Swiatkowski (1):
  ice: Allow ignoring opcodes on specific VF

Qi Zhang (2):
  ice: Enable RSS configure for AVF
  ice: Support RSS configure removal for AVF

Vignesh Sridhar (1):
  ice: warn about potentially malicious VFs

 drivers/net/ethernet/intel/iavf/Makefile      |   1 +
 drivers/net/ethernet/intel/iavf/iavf.h        |  10 +
 .../net/ethernet/intel/iavf/iavf_adv_rss.c    | 218 ++++++
 .../net/ethernet/intel/iavf/iavf_adv_rss.h    |  95 +++
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 252 ++++++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  29 +
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  15 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 164 +++++
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_flow.c     |  88 +++
 drivers/net/ethernet/intel/ice/ice_flow.h     |   6 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   7 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 400 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  20 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  75 ++
 .../intel/ice/ice_virtchnl_allowlist.c        | 171 +++++
 .../intel/ice/ice_virtchnl_allowlist.h        |  13 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 663 ++++++++++++++++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  13 +
 include/linux/avf/virtchnl.h                  |  27 +-
 21 files changed, 2214 insertions(+), 55 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.h

-- 
2.26.2

