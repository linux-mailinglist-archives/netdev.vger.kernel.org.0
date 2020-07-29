Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFA232291
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgG2QYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:44892 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgG2QYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:13 -0400
IronPort-SDR: bWyWxlhvOXUhrm5bB7gpLDfm+dkC7elsruQ53ae2kfVPeWFpqkzLdwUV4uSE+WMOGQ4QMP4so7
 Eah/jjoNNHiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="169570873"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="169570873"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:12 -0700
IronPort-SDR: RgNRqCQr1dna+B4wG4fDuqxwqNjIZ06SIZxa1OrRwoP/OI6FJa1sjYiW0KoLRgTgJ+npvWsHSj
 IOYNwlZuP5Aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087543"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-07-29
Date:   Wed, 29 Jul 2020 09:23:50 -0700
Message-Id: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Dave works around LFC settings not being preserved through link events.
Fixes link issues with GLOBR reset and handling of multiple link events.

Nick restores VF MSI-X after PCI reset.

Kiran corrects the error code returned in ice_aq_sw_rules if the rule
does not exist.

Paul prevents overwriting of user set descriptors.

Tarun adds masking before accessing rate limiting profile types and
corrects queue bandwidth configuration.

Victor modifies Tx queue scheduler distribution to spread more evenly
across queue group nodes.

Krzysztof sets need_wakeup flag for Tx AF_XDP.

Brett allows VLANs in safe mode.

Marcin cleans up VSIs on probe failure.

Bruce reduces the scope of a variable.

Ben removes a FW workaround.

Tony fixes an unused parameter warning.

The following are changes since commit 490ed0b908d371cd9ab63fc142213e5d02d810ee:
  Merge branch 'net-stmmac-improve-WOL'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Ben Shelton (1):
  ice: disable no longer needed workaround for FW logging

Brett Creeley (1):
  ice: Allow all VLANs in safe mode

Bruce Allan (1):
  ice: reduce scope of variable

Dave Ertman (3):
  ice: Implement LFC workaround
  ice: Fix link broken after GLOBR reset
  ice: fix link event handling timing

Kiran Patil (1):
  ice: return correct error code from ice_aq_sw_rules

Krzysztof Kazimierczak (1):
  ice: need_wakeup flag might not be set for Tx

Marcin Szycik (1):
  ice: cleanup VSI on probe fail

Nick Nunley (1):
  ice: restore VF MSI-X state during PCI reset

Paul M Stillwell Jr (1):
  ice: fix overwriting TX/RX descriptor values when rebuilding VSI

Tarun Singh (2):
  ice: Add RL profile bit mask check
  ice: Adjust scheduler default BW weight

Tony Nguyen (1):
  ice: fix unused parameter warning

Victor Raj (1):
  ice: distribute Tx queues evenly

 drivers/net/ethernet/intel/ice/ice_common.c   |  48 ++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_controlq.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  33 ----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   6 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  11 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 185 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_sched.c    |  66 ++++++-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  30 +++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  10 +-
 15 files changed, 346 insertions(+), 78 deletions(-)

-- 
2.26.2

