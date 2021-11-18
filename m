Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB46C4551E6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242073AbhKRBDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:03:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:59858 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234120AbhKRBDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 20:03:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="221302862"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="221302862"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 17:00:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="646235520"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 17 Nov 2021 17:00:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] 10GbE Intel Wired LAN Driver Updates 2021-11-17
Date:   Wed, 17 Nov 2021 16:58:27 -0800
Message-Id: <20211118005832.245978-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Radoslaw Tyl says:

The change is a consequence of errors reported by the ixgbevf driver
while starting several virtual guests at the same time on ESX host.
During this, VF was not able to communicate correctly with the PF,
as a result reported "PF still in reset state. Is the PF interface up?"
and then goes to locked state. The only thing left was to reload
the VF driver on the guest OS.

The background of the problem is that the current PFU and VFU
semaphore locking mechanism between sender and receiver may cause
overriding Mailbox memory (VFMBMEM), in such scenario receiver of
the original message will read the invalid, corrupted or one (or more)
message may be lost.

This change is actually as a support for communication with PF ESX
driver and does not contains changes and support for ixgbe driver.
For maintain backward compatibility, previous communication method
has been preserved in the form of LEGACY functions.

In the future there is a plan to add a support for a 1.5 mailbox API
communication also to ixgbe driver.

The following are changes since commit 17a7555bf21ce755219bf575b8a83adbf19580bd:
  Merge branch 'dev_watchdog-less-intrusive'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Radoslaw Tyl (5):
  ixgbevf: Rename MSGTYPE to SUCCESS and FAILURE
  ixgbevf: Improve error handling in mailbox
  ixgbevf: Add legacy suffix to old API mailbox functions
  ixgbevf: Mailbox improvements
  ixgbevf: Add support for new mailbox communication between PF and VF

 drivers/net/ethernet/intel/ixgbevf/defines.h  |   4 +
 drivers/net/ethernet/intel/ixgbevf/ipsec.c    |  11 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   5 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  11 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.c      | 323 ++++++++++++++----
 drivers/net/ethernet/intel/ixgbevf/mbx.h      |  19 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c       |  62 ++--
 drivers/net/ethernet/intel/ixgbevf/vf.h       |   5 +-
 8 files changed, 327 insertions(+), 113 deletions(-)

-- 
2.31.1

