Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE26C495F1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfFQXdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:25830 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFQXdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:21 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/11][pull request] Intel Wired LAN Driver Updates 2019-06-17
Date:   Mon, 17 Jun 2019 16:33:25 -0700
Message-Id: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the iavf driver only.

Akeem updates the driver to change how VLAN tags are being populated and
programmed into the hardware by starting from the first member of the
list until the number of allowed VLAN tags is exhausted.

Mitch fixed the variable type since the variable counter starts out
negative and climbs to zero, so use a signed integer instead of
unsigned.  Also increase the timeout to avoid erroneous errors.  Fixed
the driver to be able to handle when the hardware hands us a null
receive descriptor with no data attached, yet is still valid.

Aleksandr fixes the driver to use GFP_ATOMIC when allocating memory in
atomic context.

Avinash updates the driver to fix a calculation error in virtchnl
regarding the valid length.

Jakub does some refactoring of the commands processing the watchdog
state machine to reduce the length and complexity of the function.  Also
decalre watchdog task as delayed work and use a dedicated work queue to
service the driver tasks.

Paul updated the iavf_process_aq_command to call the necessary functions
to be able to clear cloud filter bits that need to be cleared.

The following are changes since commit f517f2716c34087ca15a36e9f13dbca8bd2e3ffc:
  net: sched: cls_matchall: allow to delete filter
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Akeem G Abodunrin (1):
  iavf: Create VLAN tag elements starting from the first element

Aleksandr Loktionov (1):
  iavf: Change GFP_KERNEL to GFP_ATOMIC in kzalloc()

Avinash Dayanand (1):
  iavf: Fix the math for valid length for ADq enable

Jakub Pawlak (3):
  iavf: Move commands processing to the separate function
  iavf: Remove timer for work triggering, use delaying work instead
  iavf: Refactor init state machine

Jan Sokolowski (1):
  iavf: Refactor the watchdog state machine

Mitch Williams (3):
  iavf: use signed variable
  iavf: wait longer for close to complete
  iavf: allow null RX descriptors

Paul Greenwalt (1):
  iavf: add call to iavf_[add|del]_cloud_filter

 drivers/net/ethernet/intel/iavf/iavf.h        |   5 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 739 ++++++++++--------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  23 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   4 +-
 5 files changed, 440 insertions(+), 335 deletions(-)

-- 
2.21.0

