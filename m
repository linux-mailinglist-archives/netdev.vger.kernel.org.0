Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451F224C980
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 03:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHUBXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 21:23:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:42858 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgHUBXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 21:23:51 -0400
IronPort-SDR: szAwauAVycUXtagWZYmw/+a1dPIZMwhWd9QYhrz2yPK3+NYfPcVX6RWaIygI+zNso/x6cbTf+g
 IV6USvmtNx1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="216974387"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="216974387"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 18:23:51 -0700
IronPort-SDR: flgtG/jy81D1apjJOw9rfs8clzkUo3eIDUcSOONGp0DTiTMs8xJqVRmxenQYjdrpMrpe7PN4Xx
 SUGjcbD3zr5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="371770902"
Received: from cmw-fedora32-wp.jf.intel.com ([10.166.17.61])
  by orsmga001.jf.intel.com with ESMTP; 20 Aug 2020 18:23:51 -0700
Subject: [RFC PATCH net-next 0/2] Granular VF Trust Flags for SR-IOV
From:   Carolyn Wyborny <carolyn.wyborny@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        tom.herbert@intel.com
Date:   Thu, 20 Aug 2020 21:16:59 -0400
Message-ID: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proposal for Granular VF Trust Flags for SR-IOV

I would like to propose extending the concept of VF trust in a more
granular way by creating VF trust flags. VF Trust Flags would allow more
flexibility in assigning privileges to VF's administratively in SR-IOV.
Users are asking for more configuration to be available in the VF.
Features for one use case like a firewall are not always wanted in a
different type of privilegd VF.  If a base set of generic privileges could be
configured in a more granular way, they can be combined in a more flexible
way by the user.

The implementation would do this by by adding a new iflattribute for trust
flags which defines the flags in an nla_bitfield32.  The changes `would
also include changes to .ndo_set_vf_trust parameters, different or converted
settings in .ndo_get_vf_config, kernel validation of the trust flags and
driver changes for those that implement .ndo_set_vf_trust. There will also
be changes proposed for ip link in the iproute2 toolset.

This patchset provides an example implementation that is not complete.
It does not include the full validation of the feature flags in the kernel,
all the helper macros likely needed for the trust flags nor all the driver
changes needed. It also needs a method for advertising supported privileges
and validation to ensure unsupported privileges are not being set.
It does have a simple example driver implementation in igb.  The full
patchset will include all these things.

I'd like to start the discussion about the general idea and then begin the
dicussion about a base set of VF privleges that would be generic across the
device vendors.

---

Carolyn Wyborny (2):
      net:  Implement granular VF trust flags
      igb: Implement granular VF trust flags


 drivers/net/ethernet/intel/igb/igb.h      |    2 +
 drivers/net/ethernet/intel/igb/igb_main.c |   21 ++++++-----
 include/linux/if_link.h                   |    2 +
 include/linux/netdevice.h                 |    4 +-
 include/uapi/linux/if_link.h              |   53 ++++++++++++++++++++++++++++-
 net/core/rtnetlink.c                      |   41 +++++++++++++++++++++-
 tools/include/uapi/linux/if_link.h        |   53 ++++++++++++++++++++++++++++-
 7 files changed, 157 insertions(+), 19 deletions(-)

--
Signature

