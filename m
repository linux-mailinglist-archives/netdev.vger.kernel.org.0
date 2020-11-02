Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC37D2A2494
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgKBGNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:13:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54874 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbgKBGNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:13:04 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A261fOq017804;
        Sun, 1 Nov 2020 22:12:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=UPIzOibvaPM7EJyycpFqB/S2pzWiEQ63PZmxARAlG1A=;
 b=eIC5OHcqiWY8eg6BQD0lDeWUxeXt3dS1mdzjtIVuvqOengS2xP8O80rKB/Q+GnzM82ao
 Dp+1SfxMYnRA6oK7dT/lFZNtgOVya5lFCWCks+YuufuSLvyK8zmAcOLWMRsMyENRHgRL
 4/tguvJxfjWJp75I/H8uwXoguH6tvxZtj5yq79Ap/s3TjwacQXZQ/IDWsKU5E4mC6OsL
 s0t6TUAqqyt30Mc/Z05UzBxwlYlCkVz/FicvV+GhmFGUbGzNDM0pb6m4Xx+JoVKAeS+V
 G80iKkrmhatBrWCj7TG15lCMh1+47CyRnxGVU9N4IkaIPiopWfxHRTH/2HpiAcUuwvC1 +w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7enp50b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Nov 2020 22:12:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 22:12:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 1 Nov
 2020 22:12:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 1 Nov 2020 22:12:57 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 07B433F703F;
        Sun,  1 Nov 2020 22:12:50 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [PATCH net-next 00/13] Add ethtool ntuple filters support
Date:   Mon, 2 Nov 2020 11:41:09 +0530
Message-ID: <20201102061122.8915-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_01:2020-10-30,2020-11-02 signatures=0
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
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  189 ++-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   58 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |   71 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   16 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  102 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  197 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  305 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  462 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 1334 ++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   11 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    8 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   53 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   58 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  854 +++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  313 ++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   16 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   13 +
 20 files changed, 3906 insertions(+), 160 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c

-- 
2.16.5

