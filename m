Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65464959F7
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378709AbiAUGfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42322 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378707AbiAUGfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05lpl029283;
        Thu, 20 Jan 2022 22:34:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=OfpFO0ji7j1g48ybvKAPki/bbA4ib9AGZ5ci5qAacO4=;
 b=cBCmpe3Y4UsaKlxrbJsb+xbmn9WlvvBiTWOd8xPmQ+OBYvonOK/kmsaVJFdEmeZ0N2TR
 sp8W2upbh156uFbCnYIrU8C0qnb7J//F5OL6rwvuffn7UGO2zxpGF6OvAEjl+z5AQqjY
 eaoNpP7v/Ai8a/ubk9WyXOMWFgtQtXHIpSkY/6bxyP5OnzZnc3g4LbFFPrlPNt/WzSle
 t3SI0NCsexHOe74QwGQPXtXMAi8/tBpQbOfCza8mpwwELmL2HwqpBBEcIwVQO+klVXXd
 xSmeC1AlBrB4NvHyxRv46ROT3vU/nFtN17d1uHdoxwOPTMoBbbbLo2UK5p8ZvWoYzvKK VQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:34:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Jan
 2022 22:34:53 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 22:34:53 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 98CE13F7095;
        Thu, 20 Jan 2022 22:34:50 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 0/9] Fixes for CN10K and CN9xxx platforms
Date:   Fri, 21 Jan 2022 12:04:38 +0530
Message-ID: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 5CZ_Hf3A_bi__PjWGi82ImdAxLD0jJ94
X-Proofpoint-ORIG-GUID: 5CZ_Hf3A_bi__PjWGi82ImdAxLD0jJ94
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset has consolidated fixes in Octeontx2 driver
handling CN10K and CN9xxx platforms. When testing the
new CN10K hardware some issues resurfaced like accessing
wrong register for CN10K and enabling loopback on not supported
interfaces. Some fixes are needed for CN9xxx platforms as well.

Below is the description of patches

Patch 1: AF sets RX RSS action for all the VFs when a VF is
brought up. But when a PF sets RX action for its VF like Drop/Direct
to a queue in ntuple filter it is not retained because of AF fixup.
This patch skips modifying VF RX RSS action if PF has already
set its action.

Patch 2: When configuring backpressure wrong register is being read for
LBKs hence fixed it.

Patch 3: Some RVU blocks may take longer time to reset but are guaranteed
to complete the reset. Hence wait till reset is complete.

Patch 4: For enabling LMAC CN10K needs another register compared
to CN9xxx platforms. Hence changed it.

Patch 5: Adds missing barrier before submitting memory pointer
to the aura hardware.

Patch 6: Increase polling time while link credit restore and also
return proper error code when timeout occurs.

Patch 7: Internal loopback not supported on LPCS interfaces like
SGMII/QSGMII so do not enable it.

Patch 8: When there is a error in message processing, AF sets the error
response and replies back to requestor. PF forwards a invalid message to
VF back if AF reply has error in it. This way VF lacks the actual error set
by AF for its message. This is changed such that PF simply forwards the
actual reply and let VF handle the error.

Patch 9: ntuple filter with "flow-type ether proto 0x8842 vlan 0x92e"
was not working since ethertype 0x8842 is NGIO protocol. Hardware
parser explicitly parses such NGIO packets and sets the packet as
NGIO and do not set it as tagged packet. Fix this by changing parser
such that it sets the packet as both NGIO and tagged by using
separate layer types.

Thanks,
Sundeep

Geetha sowjanya (5):
  octeontx2-af: Retry until RVU block reset complete
  octeontx2-af: cn10k: Use appropriate register for LMAC enable
  octeontx2-pf: cn10k: Ensure valid pointers are freed to aura
  octeontx2-af: Increase link credit restore polling timeout
  octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces

Kiran Kumar K (1):
  octeontx2-af: Add KPU changes to parse NGIO as separate layer

Subbaraya Sundeep (2):
  octeontx2-af: Do not fixup all VF action entries
  octeontx2-pf: Forward error codes to VF

Sunil Goutham (1):
  octeontx2-af: Fix LBK backpressure id count

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  2 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |  3 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  1 +
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 70 +++++++++++-----------
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 66 +++++++++++++++-----
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  7 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 14 ++++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 20 +++----
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 22 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 20 ++++---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  7 ++-
 15 files changed, 164 insertions(+), 76 deletions(-)

-- 
2.7.4

