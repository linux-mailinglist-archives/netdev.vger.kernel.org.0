Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC91F343245
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCUMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:10:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63742 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229874AbhCUMKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:10:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12LC5G3v023747;
        Sun, 21 Mar 2021 05:10:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bkpsK+IigyeEXfiNw5e28SUQTFzKvOTRritcb6gcc1Q=;
 b=WKu03SpLejE+kNeDkoCm8H2VDik3ICrFwtXo5NTFYB0pKfvsrJoGIKkBkquPmPxV3AkH
 2kmXLIDeiIzhsWiHJlLPF5a1ZbfUDKxKoiB9B09BTZBXH/FF6qE2BnWJh13HYPwHHWxW
 mXqoPgW3KkcmJXKAR3TA6vpf/+ajbLTWtNwJM4ug+cQJ5D2Lp8asEARA8eIIJ4zcTcOl
 bttQ1DXXLUgwdWSOKSwTB2SkBZDRHwzk/Qz0mdWCGKItG7S3NdZPzA9e04mwf5cNKg1j
 c0GmuBBqFKHJDgRmjlqK2TGWeB+DJk7gLHir4EhpiYnWppIuUaAALMC+WuhZGijyWhFe QA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrab2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 05:10:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 21 Mar
 2021 05:10:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 21 Mar 2021 05:10:04 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 4D6CF3F703F;
        Sun, 21 Mar 2021 05:10:00 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 0/8] configuration support for switch headers & phy
Date:   Sun, 21 Mar 2021 17:39:50 +0530
Message-ID: <20210321120958.17531-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-21_01:2021-03-19,2021-03-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for parsing switch headers and
configuration support for phy modulation type(NRZ or PAM4).

PHYs that support changing modulation type ,user can configure it
through private flags pam4.

Marvell switches support DSA(distributed switch architecture) with
different switch headers like FDSA and EDSA. This patch series adds
private flags to enable user to configure interface in fdsa/edsa
mode such that flow steering (forwading packets to pf/vf depending on
switch header fields) and packet parsing can be acheived.

Also adds support for HIGIG2 protocol, user can configure interface
in higig mode through higig private flage, such that packet classification
and flow sterring achieved on packets with higig header


Felix Manlunas (2):
  octeontx2-af: Add new CGX_CMDs to set and get PHY modulation type
  octeontx2-pf: Add ethtool priv flag to control PAM4 on/off

Hariprasad Kelam (6):
  octeontx2-af: Support for parsing pkts with switch headers
  octeontx2-af: Do not allow VFs to overwrite PKIND config
  octeontx2-af: Put CGX LMAC also in Higig2 mode
  octeontx2-pf: Support to enable EDSA/Higig2 pkts parsing
  octeontx2-af: Add flow steering support for FDSA tag
  octeontx2-pf: Add ntuple filter support for FDSA

 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 177 ++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  19 +-
 .../ethernet/marvell/octeontx2/af/cgx_fw_if.h |   6 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  39 ++-
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  14 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   9 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 103 +++++++-
 .../marvell/octeontx2/af/rvu_debugfs.c        |   3 +-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  44 +++-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  76 ++++++
 .../marvell/octeontx2/af/rvu_npc_fs.c         |  14 +-
 .../marvell/octeontx2/nic/otx2_common.c       |   2 +
 .../marvell/octeontx2/nic/otx2_common.h       |  36 ++-
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 244 ++++++++++++++++++
 .../marvell/octeontx2/nic/otx2_flows.c        |  58 ++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  21 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  10 +
 18 files changed, 832 insertions(+), 44 deletions(-)

--
2.17.1
