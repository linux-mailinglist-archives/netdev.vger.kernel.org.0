Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED2B18DEA0
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgCUIKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:33281 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgCUIKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:34 -0400
IronPort-SDR: O8bp8wfrchz3OeIT3v6y5WkstcLSvnx312dWJ40RKtTzMiO494jo/rBVlw2WXuz+e0AR7eiG+s
 geyFGlAMrKTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:31 -0700
IronPort-SDR: 9HjMcdhEFJEQ8lWtMFo13ygNm7MJCaiVRuSptNntYBMdvh26KkjpKa75Ul3YYmefUJlMxfVI9G
 M0LTL9dGlHRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737975"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2020-03-21
Date:   Sat, 21 Mar 2020 01:10:19 -0700
Message-Id: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement basic support for the devlink interface in the ice driver.
Additionally pave some necessary changes for adding a devlink region that
exposes the NVM contents.

This series first contains 5 patches for enabling and implementing full NVM
read access via the ETHTOOL_GEEPROM interface. This includes some cleanup of
endian-types, a new function for reading from the NVM and Shadow RAM as a flat
addressable space, a function to calculate the available flash size during
load, and a change to how some of the NVM version fields are stored in the
ice_nvm_info structure.

Following this is 3 patches for implementing devlink support. First, one patch
which implements the basic framework and introduces the ice_devlink.c file.
Second, a patch to implement basic .info_get support. Finally, a patch which
reads the device PBA identifier and reports it as the `board.id` value in the
.info_get response.

The following are changes since commit 0d7043f355d0045bd38b025630a7defefa3ec07f:
  Merge tag 'mac80211-next-for-net-next-2020-03-20' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Jacob Keller (8):
  ice: use __le16 types for explicitly Little Endian values
  ice: create function to read a section of the NVM and Shadow RAM
  ice: store NVM version info in extracted format
  ice: discover and store size of available flash
  ice: enable initial devlink support
  devlink: promote "fw.bundle_id" to a generic info version
  ice: add basic handler for devlink .info_get
  ice: add board identifier info to devlink .info_get

Jesse Brandeburg (1):
  ice: implement full NVM read from ETHTOOL_GEEPROM

 .../networking/devlink/devlink-info.rst       |   5 +
 Documentation/networking/devlink/ice.rst      |  71 +++
 Documentation/networking/devlink/index.rst    |   1 +
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  89 ----
 drivers/net/ethernet/intel/ice/ice_common.h   |   9 -
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 320 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |  14 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  46 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  33 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 484 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  12 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  32 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |   2 +-
 include/net/devlink.h                         |   2 +
 18 files changed, 826 insertions(+), 304 deletions(-)
 create mode 100644 Documentation/networking/devlink/ice.rst
 create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.h

-- 
2.25.1

