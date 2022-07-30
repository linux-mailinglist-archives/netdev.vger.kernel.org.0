Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523DD585A4C
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiG3L6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 07:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3L6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 07:58:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368B21705F;
        Sat, 30 Jul 2022 04:58:12 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26UBrdGR005980;
        Sat, 30 Jul 2022 04:58:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=2hq4v0zZGr5choonWOGsqyjc44JQaXnSW6zw4VPzRic=;
 b=BcIKHljVWMq/6/CoTr2SC1IdZhWQy+qr2MBZymwmY1S52SaEBDbH6Ctoj9Mhknn0mtry
 vfK8OlWRHuhEHbGGdWDwM/wKLLofyOMcwHJrceeU1AfFrtDuFKadszo5R9nPxRemDlAd
 WYwPtqfZeS+ZoaO1yMzH6eM2QCPT49APa7nfIT5U8sOp4VsMXYdcVNrrL6y1kXEFo2xA
 bZXHpMfkb9KW1Zq09OrMHKl4AfbFosH1zuGZS9Yx7dPE7lBmettJbghLFj2trfXpEFMQ
 arMQeNznnWCUWHH6JXSFS1EABOqmEXsgER0d5iOEzprG4P4YbQfaR28Grbrs7KC0roVv WQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hn45m008n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jul 2022 04:58:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 30 Jul
 2022 04:58:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 30 Jul 2022 04:58:03 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 42E123F704A;
        Sat, 30 Jul 2022 04:58:00 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 0/4] Add PTP support for CN10K silicon
Date:   Sat, 30 Jul 2022 17:27:54 +0530
Message-ID: <20220730115758.16787-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8gXlNNs1CxBgYJBGhjNsx5XT5ll7BkWV
X-Proofpoint-ORIG-GUID: 8gXlNNs1CxBgYJBGhjNsx5XT5ll7BkWV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-30_07,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds PTP support for CN10K silicon, specifically
to workaround few hardware issues and to add 1-step mode.

Patchset overview:

Patch #1 returns correct ptp timestamp in nanoseconds captured
         when external timestamp event occurs.

Patch #2 adds 1-step mode support.

Patch #3 implements software workaround to generate PPS output properly.

Patch #4 provides a software workaround for the rollover register default
         value, which causes ptp to return the wrong timestamp.

v2 changes:
  no code changes, added PTP maintainer to CC list.

Hariprasad Kelam (1):
  octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon

Naveen Mamindlapalli (3):
  octeontx2-af: return correct ptp timestamp for CN10K silicon
  octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon
  octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 106 +++++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  19 +++-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   1 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  13 +++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  11 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 103 ++++++++++++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  11 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 110 ++++++++++++++++++++-
 13 files changed, 359 insertions(+), 41 deletions(-)

-- 
2.16.5

