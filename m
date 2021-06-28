Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD03B6740
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhF1RJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:09:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55170 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232831AbhF1RJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:09:32 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SH6cn8029761;
        Mon, 28 Jun 2021 10:07:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=EjZsAdLIRrqAhmY4fqXvnkVpQXham+EAoT81lJMX9B4=;
 b=dZdbnTAnCd5oJHF/JjVs5DDGZbSskNraapygBquJVN75uPLNXeXlnJql3og8B837p6pM
 UU3GLOM1HE02gA/fpdWR6pSNn4fpXdEPdDFbk9qZMsmjeMJF/1BQ97dlROus8G27B2hx
 6MKJ7VDSzaJbPEDErhtA8pkbijbZ45e8W09yidpc/yBGHZQ0Qx4iqambacRcuamT6x5C
 lHbFTZgJQg0613eISet2pSBJTpGwGTE64J8dPTO7U4ZoCvNPZpLJubAEsf7EwSeiRcaU
 gns9dmhDwT9K/sKYKa0oxIoAmwASFgPIIIufukhl8+FUYkZ/hDkSS1ZCTIlwCjKPyLux zg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39f11y3bpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Jun 2021 10:07:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Jun
 2021 10:06:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 28 Jun 2021 10:06:59 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id F1A253F7097;
        Mon, 28 Jun 2021 10:06:55 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net-next 0/3] DMAC based packet filtering
Date:   Mon, 28 Jun 2021 22:36:51 +0530
Message-ID: <20210628170654.22995-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 7l4TTB2t9FSWt119Ou74ZJRT7I2VR9Uu
X-Proofpoint-ORIG-GUID: 7l4TTB2t9FSWt119Ou74ZJRT7I2VR9Uu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each MAC block supports 32 DMAC filters which can be
configured to accept or drop packets based on address match
This patch series adds mbox handlers and extends ntuple filter
callbacks to accomdate DMAC filters such that user can install
DMAC based filters on interface from ethtool.

Patch1 adds necessary mbox handlers such that mbox consumers
like PF netdev can add/delete/update DMAC filters and Patch2 adds
debugfs support to dump current list of installed filters.
Patch3 adds support to call mbox handlers upon receiving DMAC
filters from ethtool ntuple commans.

Hariprasad Kelam (2):
  octeontx2-af: Debugfs support for DMAC filters
  octeontx2-pf: offload DMAC filters to CGX/RPM block

Sunil Kumar Kori (1):
  octeontx2-af: DMAC filter support in MAC block

 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 291 +++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  10 +
 .../marvell/octeontx2/af/lmac_common.h        |   5 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  48 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 111 ++++++-
 .../marvell/octeontx2/af/rvu_debugfs.c        |  87 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   3 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |   2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |   3 +
 .../marvell/octeontx2/nic/otx2_common.h       |  11 +
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     | 173 +++++++++++
 .../marvell/octeontx2/nic/otx2_flows.c        | 225 +++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
 14 files changed, 945 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c

--
2.17.1
