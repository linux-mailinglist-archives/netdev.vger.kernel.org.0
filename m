Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5C153054
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgBEMG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:06:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:56042 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgBEMG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 07:06:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 04:06:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="254742591"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2020 04:06:24 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maximmi@mellanox.com
Subject: [PATCH bpf 0/3] XSK related fixes
Date:   Wed,  5 Feb 2020 05:58:31 +0100
Message-Id: <20200205045834.56795-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cameron reported [0] that on fresh bpf-next he could not run multiple
xdpsock instances in Tx-only mode on single network interface with i40e
driver.

Turns out that Maxim's series [1] which was adding RCU protection around
ndo_xsk_wakeup added check against the __I40E_CONFIG_BUSY being set on
pf->state within i40e_xsk_wakeup() - if it's set, return -ENETDOWN.
Since this bit is set per PF when UMEM is being enabled/disabled, the
situation Cameron stumbled upon was that when he launched second xdpsock
instance, second UMEM was being registered, hence set __I40E_CONFIG_BUSY
which is now observed by first xdpsock and therefore xdpsock's kick_tx()
gets -ENETDOWN as errno.

-ENETDOWN currently is not allowed in kick_tx(), so we were exiting the
first application. Such exit means also XDP program being unloaded and
its dedicated resources, which caused an -ENXIO being return in the
second xdpsock instance.

Let's fix the issue from both sides - protect ourselves from future
xdpsock crashes by allowing for -ENETDOWN errno being set in kick_tx()
(patch 3) and from driver side, return -EAGAIN for the case where PF is
busy (patch 1).

Remove also doubled variable from xdpsock_user.c (patch 2).

Note that ixgbe seems not to be affected since UMEM registration sets
the busy/disable bit per ring, not per PF.

Thanks!
Maciej

[0]: https://www.spinics.net/lists/xdp-newbies/msg01558.html
[1]: https://lore.kernel.org/netdev/20191217162023.16011-1-maximmi@mellanox.com/

Maciej Fijalkowski (3):
  i40e: Relax i40e_xsk_wakeup's return value when PF is busy
  samples: bpf: drop doubled variable declaration in xdpsock
  samples: bpf: allow for -ENETDOWN in xdpsock

 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 samples/bpf/xdpsock_user.c                 | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.20.1

