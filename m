Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AFB350A83
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhCaXHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:62991 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCaXHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:23 -0400
IronPort-SDR: wfVYaSprI1v3sD4V3SxLJ2IsPdYv3gbd2NJaUyd4oJS5OW9sV/sniaH56/UvC3QMKJAwD9wfu8
 rja9G0FGUM+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587966"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587966"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:22 -0700
IronPort-SDR: wM+URKwsP4mBuvgFr4nXrPyQwGjpGXqYXD7VWxEDWxXxblJuSqYD1NnTrQ/lu2iK6F6jJtINEw
 uksWmK9sGVBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680085"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2021-03-31
Date:   Wed, 31 Mar 2021 16:08:43 -0700
Message-Id: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Benita adds support for XPS.

Ani moves netdev registration to the end of probe to prevent use before
the interface is ready and moves up an error check to possibly avoid
an unneeded call. He also consolidates the VSI state and flag fields to
a single field.

Dan changes the segment where package information is pulled.

Paul S ensures correct ITR values are set when increasing ring size.

Paul G rewords a link misconfiguration message as this could be
expected.

Bruce removes setting an unnecessary AQ flag and corrects a memory
allocation call. Also fixes checkpatch issues for 'COMPLEX_MACRO'.

Qi aligns PTYPE bitmap naming by adding 'ptype' prefix to the bitmaps
missing it.

Brett removes limiting Rx queue mapping to RSS size as there is not a
dependency on this. He also refactors RSS configuration by introducing
individual functions for LUT and key configuration and by passing a
structure containing pertinent information instead of individual
arguments.

Tony corrects a comment block to follow netdev style.

The following are changes since commit 28110056f2d07a576ca045a38f80de051b13582a:
  net: ethernet: Fix typo of 'network' in comment
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (3):
  ice: Delay netdev registration
  ice: Check for bail out condition early
  ice: Consolidate VSI state and flags

Benita Bose (1):
  ice: Add Support for XPS

Brett Creeley (3):
  ice: Change ice_vsi_setup_q_map() to not depend on RSS
  ice: Refactor get/set RSS LUT to use struct parameter
  ice: Refactor ice_set/get_rss into LUT and key specific functions

Bruce Allan (3):
  ice: remove unnecessary duplicated AQ command flag setting
  ice: correct memory allocation call
  ice: cleanup style issues

Dan Nowlin (1):
  ice: Update to use package info from ice segment

Paul Greenwalt (1):
  ice: change link misconfiguration message

Paul M Stillwell Jr (1):
  ice: handle increasing Tx or Rx ring sizes

Qi Zhang (1):
  ice: rename ptype bitmap

Tony Nguyen (1):
  ice: Correct comment block style

 drivers/net/ethernet/intel/ice/ice.h          |  28 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   4 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c     |   6 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  23 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  56 ++--
 drivers/net/ethernet/intel/ice/ice_common.h   |   6 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  50 ++--
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  40 +--
 .../net/ethernet/intel/ice/ice_flex_type.h    |  13 +-
 drivers/net/ethernet/intel/ice/ice_flow.c     |  22 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 224 +++++++-------
 drivers/net/ethernet/intel/ice/ice_main.c     | 278 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_switch.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   6 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   8 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  16 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   4 +-
 18 files changed, 445 insertions(+), 345 deletions(-)

-- 
2.26.2

