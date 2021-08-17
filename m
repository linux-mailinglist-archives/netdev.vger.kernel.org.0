Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473B3EE5C5
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhHQEpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:45:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13786 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230272AbhHQEpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:45:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2lprh006897;
        Mon, 16 Aug 2021 21:45:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=SwK+Nu2iWjxnzrQmZpRv+TfoJ0VdMuqFFDQ7WnGfdhk=;
 b=Czu93O7Y1ouNdvzUNlU9Vf86muEiMgmYS9zzh81uIZLoRlZSU1wM+MI3mEHQ4YBKj8m/
 cpUuzuO9PmEjtq21DGX9HqWHC0OWHe93zAYAAPDJl8cPDnVgCxGSt1ajGXc/43no9EHi
 4bZGT3h96W8vCNT0yl6tvabdkn/BlLi4QRSMkQpJnwZPo2aKQT4Wfea2rtSd/Mk7qrqB
 fDs+GVe4kdUaU4j1JMS8omF7fDQWSnnr1CC7g4onH5T9uANN2l4KJznB0IN9tKLU4wrT
 qBNx4b5paKexKpCZ6vTcudAmNdvLGJ7rL0FOSqX5UilqRKm04ZQ26amc01AECJc/A+Yw oA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:07 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id B98903F70A8;
        Mon, 16 Aug 2021 21:44:57 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 00/11] octeontx2: Rework MCAM flows management for VFs
Date:   Tue, 17 Aug 2021 10:14:42 +0530
Message-ID: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: B20b2seUQF886vXVKwr8-qlkjtLkm2vd
X-Proofpoint-ORIG-GUID: B20b2seUQF886vXVKwr8-qlkjtLkm2vd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Octeontx2 hardware point of view there is no
difference between PFs and VFs. Hence with refactoring
in driver the packet classification features or offloads
can be supported by VFs also. This patchset unifies the
mcam flows management so that VFs can also support
ntuple filters. Since there are MCAM allocations by
all PFs and VFs in the system it is required to have
the ability to modify number of mcam rules count
for a PF/VF in runtime. This is achieved by using devlink.
Below is the summary of patches:

Patch 1,2,3 are trivial patches which helps in debugging
in case of errors by using custom error codes and
displaying proper error messages.

Patches 4,5 brings rx-all and ntuple support
for CGX mapped VFs and LBK VFs.

Patches 6,7,8 brings devlink support to
PF netdev driver so that mcam entries count
can be changed at runtime.
To change mcam rule count at runtime where multiple rule
allocations are done sorting is required.
Also both ntuple and TC rules needs to be unified.

Patch 9 is related to AF NPC where a PF
allocated entries are allocated at bottom(low priority).

On CN10K there is slight change in reading
NPC counters which is handled by patch 10.

Patch 11 is to allow packets from CPT for
NPC parsing on CN10K.


Thanks,
Sundeep


Hariprasad Kelam (1):
  octeontx2-af: cn10K: Get NPC counters value

Naveen Mamindlapalli (1):
  octeontx2-af: add proper return codes for AF mailbox handlers

Rakesh Babu (1):
  octeontx2-pf: Ntuple filters support for VF netdev

Subbaraya Sundeep (2):
  octeontx2-af: Modify install flow error codes
  octeontx2-af: Allocate low priority entries for PF

Sunil Goutham (5):
  octeontx2-af: Add debug messages for failures
  octeontx2-pf: Enable NETIF_F_RXALL support for VF driver
  octeontx2-pf: Sort the allocated MCAM entry indices
  octeontx2-pf: Unify flow management variables
  octeontx2-pf: devlink params support to set mcam entry count

Vidya (1):
  octeontx2-af: configure npc for cn10k to allow packets from cpt

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  16 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  92 +++++++++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  12 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  45 ++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  51 +++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  36 +++--
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   5 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  32 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 156 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.h  |  20 +++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  52 ++-----
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    | 110 +++++++++++----
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  44 +++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  50 ++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  36 ++++-
 16 files changed, 585 insertions(+), 173 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.h

-- 
2.7.4

