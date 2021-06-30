Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6403B80AE
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 12:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhF3KNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 06:13:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21242 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhF3KNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 06:13:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15UA5TTE002637;
        Wed, 30 Jun 2021 03:11:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=fs09opRq/geNPzt49jP9ntkcEtT8fP8OX0tRcahqdGA=;
 b=Ru76czYmVfoGDVCAfK/eArtgUtG3v3q9ZGr3NwpTvJrztXlyTpGuCjeA8WsqNIwP8HHc
 hH21rr5UF5UrXiU7a5B3OWBOwamqhM+gW038FrAwx9X6cFDhjCvqJgUedXp/woxlb7SF
 RZLk8ebR0C11Cdhy9Xg14lca86EkeTltqGTfckUU6JoE8DpP9K26VgFB/+JKMZar5bjL
 ml6XGK8o8r7nXdk/KXeFFzDDl1gXpDc1tSP465kMx5QDWC175W7OS4EaPaPB+f4PPSy7
 J9HX0gBCTYRuuhuzqzrHc5DfS680qDd+5pVRdwvfWjGjsLS9eJoDiWfUsZKbRoXhnUBe Sg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39g93dtxw5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 03:11:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 30 Jun
 2021 03:11:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 30 Jun 2021 03:11:04 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 05F0D3F709C;
        Wed, 30 Jun 2021 03:11:00 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net-next Patch v3 0/3] DMAC based packet filtering
Date:   Wed, 30 Jun 2021 15:40:56 +0530
Message-ID: <20210630101059.27334-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: TMmsjte0XtRusHfbyvY2ZWUFibeY1HAd
X-Proofpoint-GUID: TMmsjte0XtRusHfbyvY2ZWUFibeY1HAd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_02:2021-06-29,2021-06-30 signatures=0
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
v3 -
   - fixed kdoc warnings

Hariprasad Kelam (2):
  octeontx2-af: Debugfs support for DMAC filters
  octeontx2-pf: offload DMAC filters to CGX/RPM block

Sunil Kumar Kori (1):
  octeontx2-af: DMAC filter support in MAC block

 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 292 +++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  10 +
 .../marvell/octeontx2/af/lmac_common.h        |  12 +-
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
 14 files changed, 955 insertions(+), 39 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c

--
2.17.1
