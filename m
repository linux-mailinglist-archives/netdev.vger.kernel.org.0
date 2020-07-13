Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94621DEEC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgGMRn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:43:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:39715 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgGMRn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:43:27 -0400
IronPort-SDR: wWQPf6Cl+0y+HQAWBIwGVssQFn2i8/wfc+a6lraMroXslSVpTgQzhM/veRIZ0wGfCZK+uSyinv
 WBIl7ZvF7Q5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147810206"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="147810206"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 10:43:26 -0700
IronPort-SDR: R+dUZetuvhWE5l6q6cVeKgL8AWQ/ydvKYn2JnBOxabpWcPcczQqxOd7ZzqLEWI2K04gmyaw+VA
 GJ/zZmg7g/Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="317450180"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2020 10:43:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next 0/5][pull request] 100GbE Intel Wired LAN Driver Updates 2020-07-13
Date:   Mon, 13 Jul 2020 10:43:15 -0700
Message-Id: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver and virtchnl header file.

The iproute2 and ethtool are evolving to expose the NIC hardware
capability. But these available orchestration methods in Linux kernel are
limited in their capability to exercise advanced functionality in the
hardware, since different vendors may have different data programming
method.

Intel Ethernet Adaptive Virtual Function (AVF) is the common hardware
interface for SR-IOV, it has the defined message format to talk with the
PF.

To make good use of the advanced functionality like Switch (Binary
Classifier). The ice PF driver introduces a DCF (Device Config Function)
mode to extend the AVF feature.

The DCF (Device Config Function) method wraps a raw flow admin queue
command in a virthcnl message and sends it to the PF to be executed. This
is required because it doesn't have the privilege level to issue the admin
queue commands, so it acts as a proxy PF. So that the user can customize
the AVF feature, and use their own programming language to translate the
flow rule management data into ice raw flow, these raw flows then can be
executed in PF's sandbox.

And the kernel PF driver fully controls the behavior of DCF for security,
like only the trusted VF with ID zero can run in DCF mode, and also for
being compatible with the common AVF feature, the VF needs to advertise and
acquire DCF capability first.

The following are changes since commit 94339443686b36d3223bc032b7947267474e2679:
  net: bridge: notify on vlan tunnel changes done via the old api
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Haiyue Wang (5):
  ice: add the virtchnl handler for AdminQ command
  ice: add DCF cap negotiation and state machine
  ice: support to get the VSI mapping
  ice: enable DDP package info querying
  ice: add switch rule management for DCF

 drivers/net/ethernet/intel/ice/Makefile       |   2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   6 +
 drivers/net/ethernet/intel/ice/ice_dcf.c      | 833 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcf.h      |  91 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |  16 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |  27 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 366 ++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   1 +
 include/linux/avf/virtchnl.h                  |  63 ++
 12 files changed, 1392 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcf.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcf.h

-- 
2.26.2

