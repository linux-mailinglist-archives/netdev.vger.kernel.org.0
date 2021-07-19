Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABE73CCFCC
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhGSIUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:20:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235746AbhGSIUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:20:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J8u6aK031979;
        Mon, 19 Jul 2021 01:59:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bnXwzbkYisR+CUT3Al1+dmncM52e2m0gNdoou5CdWjs=;
 b=j+8tppmY0CfzGuISJapN2n8A8bjtnopWhqjwV52tf24TcMx0Kat5FTLu2GnD75PlXV9K
 v8OQdxgDghU+XqNKAzr51Di5LEYa7bSHSP6Cj6z7hodtemv0psMsYJGMIFtJbPLWFAkO
 tFxthIZ7eR7JEc3ms40MugzxKahCyiZ8UIj+q+1WvCpvPzUbatTllxKGBmi3+qjcrzWX
 HfmqTVKhnFZyGih9qISIOXOVXJfsBqbqknhPFm+VDigUP4P4LuEdeCQbcfxAnpuQ35t9
 cG78kr4uAhuNIsoSf3hhSOrmN01JZv/FJa+UFcK8apQ0BVw1sjb9rNuBZhqMiwD4ucI/ NA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39vysrs7cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 01:59:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 19 Jul
 2021 01:59:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 19 Jul 2021 01:59:52 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 52EA45E6861;
        Mon, 19 Jul 2021 01:59:50 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/3] octeontx2-af: Introduce DMAC based switching
Date:   Mon, 19 Jul 2021 14:29:31 +0530
Message-ID: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: n2GmsAc2JlyOBsdIdZZXslOZGT28W70U
X-Proofpoint-ORIG-GUID: n2GmsAc2JlyOBsdIdZZXslOZGT28W70U
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_02:2021-07-16,2021-07-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch set packets can be switched between
all CGX mapped PFs and VFs in the system based on
the DMAC addresses. To implement this:
AF allocates high priority rules from top entry(0) in MCAM.
Rules are allocated for all the CGX mapped PFs and VFs though
they are not active and with no NIXLFs attached.
Rules for a PF/VF will be enabled only after they are brought up.
Two rules one for TX and one for RX are allocated for each PF/VF.

A packet sent from a PF/VF with a destination mac of another
PF/VF will be hit by TX rule and sent to LBK channel 63. The
same returned packet will be hit by RX rule whose action is
to forward packet to PF/VF with that destination mac.

Implementation of this for 98xx is tricky since there are
two NIX blocks and till now a PF/VF can install rule for
an NIX0/1 interface only if it is mapped to corresponding NIX0/1 block.
Hence Tx rules are modified such that TX interface in MCAM
entry can be either NIX0-TX or NIX1-TX.

Testing:

1. Create two VFs over PF1(on NIX0) and assign two VFs to two VMs
2. Assign ip addresses to two VFs in VMs and PF2(on NIX1) in host.
3. Assign static arp entries in two VMs and PF2.
4. Ping between VMs and host PF2.


Thanks,
Sundeep


Subbaraya Sundeep (3):
  octeontx2-af: Enable transmit side LBK link
  octeontx2-af: Prepare for allocating MCAM rules for AF
  octeontx2-af: Introduce internal packet switching

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  21 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   5 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  48 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  36 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  47 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  29 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_switch.c | 258 +++++++++++++++++++++
 10 files changed, 427 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c

-- 
2.7.4

