Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0953A7D5F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhFOLit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:38:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24206 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229989AbhFOLim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:38:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FBU6Pn009880;
        Tue, 15 Jun 2021 04:34:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=BkruHyKMeM7AVo26cbH3xt+PZt6pF5GOJDV+oVndyo0=;
 b=Be+Nq1i7qdFWe6/AZKANCnx/r+40nh6BCqOcZElvgV9vHWzyjatLBZXfR9ThC4kR6wfS
 gAHsL9yg8EHeC58bmMv+dlAbs5gpuDvR/Am2CBX+ZetVDdFLKEg+4x0NTDyBAk77qkDY
 X50RKUB/aG639eXvPmPWQ36H4flri1GXlNUB3Ks/vaZlXzhrDASQ+DVzNZczefPZwfmV
 kiGOKq3HqPJsOD7HVGRu3KJ4R9kJJ2Yiu27avShysYprmvRDvyPDUhmmpokxPhiBgKss
 wPnmb3PYz07W6XrQPWziy6KM/k7IjxZyDlPuVGQI0zDcXqNN2lYFRcVVNfzglY1bHZmy BQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 396tagr8mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 04:34:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 04:34:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 04:34:41 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 59F653F708E;
        Tue, 15 Jun 2021 04:34:39 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/6] Add ingress ratelimit offload
Date:   Tue, 15 Jun 2021 17:04:26 +0530
Message-ID: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -qUku0QHlzzecRFTom01hfkV3TWnK7Zw
X-Proofpoint-GUID: -qUku0QHlzzecRFTom01hfkV3TWnK7Zw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds ingress rate limiting hardware
offload support for CN10K silicons. Police actions
are added for TC matchall and flower filters.
CN10K has ingress rate limiting feature where
a receive queue is mapped to bandwidth profile
and the profile is configured with rate and burst
parameters by software. CN10K hardware supports
three levels of ingress policing or ratelimiting.
Multiple leaf profiles can  point to a single mid
level profile and multiple mid level profile can
point to a single top level one. Only leaf level
profiles are used for configuring rate limiting.

Patch 1 adds the new bandwidth profile contexts
in AF driver similar to other hardware contexts
Patch 2 adds the debugfs changes to dump bandwidth
profile contexts
Patch 3 adds support for police action with TC matchall filter
Patch 4 uses NL_SET_ERR_MSG_MOD for tc code
Patch 5 adds support for police action with TC flower filter


Subbaraya Sundeep (2):
  octeontx2-pf: Use NL_SET_ERR_MSG_MOD for TC
  octeontx2-pf: Add police action for TC flower

Sunil Goutham (3):
  octeontx2-af: cn10k: Bandwidth profiles config support
  octeontx2-af: cn10k: Debugfs support for bandwidth profiles
  octeontx2-pf: TC_MATCHALL ingress ratelimiting offload

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  40 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   8 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  16 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 163 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 619 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   8 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  85 ++-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 323 +++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  11 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   3 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   6 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 299 ++++++++--
 14 files changed, 1554 insertions(+), 35 deletions(-)

-- 
2.7.4

