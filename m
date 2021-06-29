Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14CF3B71FA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhF2MXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 08:23:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32104 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233221AbhF2MXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 08:23:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TCGUbq007482;
        Tue, 29 Jun 2021 05:20:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=j4uAdjkKKnyixzXuXbXDEZCfX1xPp728dEMQevzfq5Q=;
 b=UnSXSt7Bp0SSS2WkbmuUUPgHkz1C+hCgP3XcQ287PdIoCoNt/xZnUL4p92qKG2HdkVpK
 4nrLLGTzxLhZkrdQfwv4KE+6Z2x0nbC2GLIRdnnLYnpLz7p3B+l1W6m0gFOJexslVWVV
 tdiROHiNhr48E/cQuAizxxsMukIGJUGH+aGh+aWhfPngjyrfwyb+71ZBdasJRx3IaNut
 kF8nugfgL2iyXaMUn/xylMkQ+Kkg+Ns+zT8NNCKMy0Vk2d/1DFw/GrBMyoP6n5buSG+M
 t4H0AV+KAiFeP3wWQi0g8Tl8Ce6nWQdnktfY9TKZhAYJM14IYbgfR+viUDKZwO0cx0TI AQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39fuw51tbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 05:20:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Jun
 2021 05:20:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Jun 2021 05:20:38 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 86ABD5B6928;
        Tue, 29 Jun 2021 05:20:34 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net-next Patch v2 0/3] DMAC based packet filtering
Date:   Tue, 29 Jun 2021 17:50:30 +0530
Message-ID: <20210629122033.10051-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0vPksT3phHTeam83w11URhpzaNOTi1K-
X-Proofpoint-GUID: 0vPksT3phHTeam83w11URhpzaNOTi1K-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each MAC block supports 32 DMAC filters which can be configured to accept
or drop packets based on address match This patch series adds mbox
handlers and extends ntuple filter callbacks to accomdate DMAC filters
such that user can install DMAC based filters on interface from ethtool.

Patch1 adds necessary mbox handlers such that mbox consumers like PF netdev
can add/delete/update DMAC filters and Patch2 adds debugfs support to dump
current list of installed filters. Patch3 adds support to call mbox
handlers upon receiving DMAC filters from ethtool ntuple commands.

Change-log:
v2 -
   - fixed indentation issues.

Hariprasad Kelam (2):
  octeontx2-af: Debugfs support for DMAC filters
  octeontx2-pf: offload DMAC filters to CGX/RPM block

Sunil Kumar Kori (1):
  octeontx2-af: DMAC filter support in MAC block

 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 292 +++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  10 +
 .../marvell/octeontx2/af/lmac_common.h        |   5 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  48 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 111 ++++++-
 .../marvell/octeontx2/af/rvu_debugfs.c        |  88 +++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   3 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |   2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |   3 +
 .../marvell/octeontx2/nic/otx2_common.h       |  11 +
 .../marvell/octeontx2/nic/otx2_dmac_flt.c     | 173 +++++++++++
 .../marvell/octeontx2/nic/otx2_flows.c        | 229 +++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
 14 files changed, 951 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c

--
2.17.1
