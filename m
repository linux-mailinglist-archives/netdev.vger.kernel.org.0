Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD5468AD
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfFNUP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:15:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:59939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfFNUPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:54 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:53 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/12][pull request] 40GbE Intel Wired LAN Driver Updates 2019-06-14
Date:   Fri, 14 Jun 2019 13:15:58 -0700
Message-Id: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e only.

Aleksandr adds stub functions for Energy Efficient Ethernet (EEE) to
currently report that it is not supported in i40e.  Fixed up the Link
Layer Detection Protocol (LLDP) code to ensure we do not set the LLDP
flag too early before we ensure that we have a successful start.  This
also will prevent needles restarting of the device if LLDP did not
change its state with an unsuccessful start.

Piotr bumps up the amount of VLANs that an untrusted VF can implement,
from 8 VLANs to 16.  Adds checks to the Virtual Embedded Bridge (VEB)
and channel arrays so access does not exceed the boundary and ensure the
index is below the maximum.  Fixed an issue in the driver where we were
not checking the response from the LLDP flag and were returned success
no matter what the value of the response was.

Mitch fixes a variable counter, which can be negative in value so make
it an integer instead of an unsigned-integer.

Doug improves the admin queue log granularity by making it possible to
log only the admin queue descriptors without the entire admin queue
message buffers.

Sergey fixes up the virtchnl code by removing duplicate checks, ensure
the variable type is correct when comparing integers, enhance error and
warning messages to include useful information.

Adam fixes a potential kernel panic when the i40e driver was being bound
to a non-i40e port by adding a check on the BAR size to ensure it is
large enough by reading the highest register.

Jake fixes a statistics error in the "transmit errors" stat, which was
being calculated twice.

Gustavo A. R. Silva adds a fall-through code comment to help with
compiler checks.

v2: Fixed the return values wrapped in parenthesis in patch 8 and
    cleaned up the commit message in patch 12 so the Gustavo does
    not repeat himself.

The following are changes since commit 733f0766c3dea0a92573e38acb62ace3cf4e58c6:
  sched: act_ctinfo: use extack error reporting
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Adam Ludkiewicz (1):
  i40e: Check if the BAR size is large enough before writing to
    registers

Aleksandr Loktionov (2):
  i40e: add functions stubs to support EEE
  i40e: Missing response checks in driver when starting/stopping FW LLDP

Doug Dziggel (1):
  i40e: Improve AQ log granularity

Gustavo A. R. Silva (1):
  i40e: mark expected switch fall-through

Jacob Keller (1):
  i40e: remove duplicate stat calculation for tx_errors

Mitch Williams (1):
  i40e: Use signed variable

Piotr Kwapulinski (3):
  i40e: let untrusted VF to create up to 16 VLANs
  i40e: add constraints for accessing veb array
  i40e: Add bounds check for ch[] array

Piotr Marczak (1):
  i40e: Missing response checks in driver when starting/stopping FW LLDP

Sergey Nemov (1):
  i40e: add input validation for virtchnl handlers

 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  8 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 40 +++++----
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 82 ++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 27 ++++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 87 +++++++++----------
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  1 +
 7 files changed, 147 insertions(+), 100 deletions(-)

-- 
2.21.0

