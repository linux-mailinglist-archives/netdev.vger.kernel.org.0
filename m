Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F84F2B304C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKNTxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:53:13 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50156 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726156AbgKNTxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:53:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJphOf030021;
        Sat, 14 Nov 2020 11:53:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=NxPlYtZe1UT3xlztaXKC46YnaCsqmwL3Vilmo/ieHcc=;
 b=gjsjngGdpyL79mMzNhFdPSWOOYldjWumJ9Q0O75YyJgXE5RNOzOz7StikmsOYdtkktBD
 mC9htOjWB8FdtmvFo9EcEBIGsHT4JcC2WckXo5/Z4stTSr68jVrK/PaSfsU4CF3cG0nF
 io6SM5MwffLiilgErHtlAYf5Y8t93qhGhfR8mYRmToZNu7GUzhgB965vptBjMaTOldij
 LPOBVdTIJ57s+f3pzGpyY6ILwEwZI2canCUpqvl23yDdwI5WesWoKEU9UojcHjgqX4yJ
 yThlfMixPBMvrvCksB9QtJ/QKE0DPs2qXjoO294Avy1hrL+w2y5/XUChUWeKxffUgRSX pw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts03u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:08 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id C48613F703F;
        Sat, 14 Nov 2020 11:53:04 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 00/13] Add ethtool ntuple filters support
Date:   Sun, 15 Nov 2020 01:22:50 +0530
Message-ID: <20201114195303.25967-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for ethtool ntuple filters, unicast
address filtering, VLAN offload and SR-IOV ndo handlers. All of the
above features are based on the Admin Function(AF) driver support to
install and delete the low level MCAM entries. Each MCAM entry is
programmed with the packet fields to match and what actions to take
if the match succeeds. The PF driver requests AF driver to allocate
set of MCAM entries to be used to install the flows by that PF. The
entries will be freed when the PF driver is unloaded.

* The patches 1 to 4 adds AF driver infrastructure to install and
  delete the low level MCAM flow entries.
* Patch 5 adds ethtool ntuple filter support.
* Patch 6 adds unicast MAC address filtering.
* Patch 7 adds support for dumping the MCAM entries via debugfs.
* Patches 8 to 10 adds support for VLAN offload.
* Patch 10 to 11 adds support for SR-IOV ndo handlers.
* Patch 12 adds support to read the MCAM entries.

Misc:
* Removed redundant mailbox NIX_RXVLAN_ALLOC.

Change-log:
v4:
- Fixed review comments from Alexander Duyck on v3.
	- Added macros for KEX profile configuration values.
	- TCP/UDP SPORT+DPORT extracted using single entry.
	- Use eth_broadcast_addr() instead of memcpy to avoid one extra variable.
	- Fix "ether type" to "Ethertype" & "meta data" to "metadata" in comments.
	- Added more comments.
v3:
- Fixed Saeed's review comments on v2.
	- Fixed modifying the netdev->flags from driver.
	- Fixed modifying the netdev features and hw_features after register_netdev.
	- Removed unwanted ndo_features_check callback.
v2:
- Fixed the sparse issues reported by Jakub.

Hariprasad Kelam (3):
  octeontx2-pf: Add support for unicast MAC address filtering
  octeontx2-pf: Implement ingress/egress VLAN offload
  octeontx2-af: Handle PF-VF mac address changes

Naveen Mamindlapalli (2):
  octeontx2-pf: Add support for SR-IOV management functions
  octeontx2-af: Add new mbox messages to retrieve MCAM entries

Stanislaw Kardach (1):
  octeontx2-af: Modify default KEX profile to extract TX packet fields

Subbaraya Sundeep (6):
  octeontx2-af: Verify MCAM entry channel and PF_FUNC
  octeontx2-af: Generate key field bit mask from KEX profile
  octeontx2-af: Add mbox messages to install and delete MCAM rules
  octeontx2-pf: Add support for ethtool ntuple filters
  octeontx2-af: Add debugfs entry to dump the MCAM rules
  octeontx2-af: Delete NIX_RXVLAN_ALLOC mailbox message

Vamsi Attunuru (1):
  octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |    2 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  170 ++-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  137 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |   99 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   16 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   71 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  197 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  303 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  461 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 1334 ++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   11 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   59 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   58 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  820 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  307 ++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   16 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |    5 +
 20 files changed, 3909 insertions(+), 169 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c

-- 
2.16.5

