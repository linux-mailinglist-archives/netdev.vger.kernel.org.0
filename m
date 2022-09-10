Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD65B44FD
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 09:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIJHyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 03:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIJHyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 03:54:39 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D6E1836A;
        Sat, 10 Sep 2022 00:54:38 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28A7TaKr017048;
        Sat, 10 Sep 2022 00:54:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=7Pojo1qa9T5PJ7INTlUCzJBNw4Prt1EHBia1urgk1H4=;
 b=O+jc5CH4rIla8Pw1a9+UBwb9QEUz77deKdVdnQ+V+B4JLiKotneFJJGK6xAwjSVXtyuR
 hKLQlBTWgJgRvsRernPutxtsNLEYQMHJFdudCPM5Lg3BC9fTECktk540iTR5TrvklXq4
 CHez/km2OlQ2WGTFlJoYG/WuaVn3NAPxr7uEmb2kLXEcDVqtU+BAJcsdIFEi/en2fW0W
 FcO3Ie9AKz/OAX0AoMu6IHsMxN+8Zje0KRNnsvokRPh0sJFAfVZTA8MI1bakDasHyhOq
 kiDj6vPCU8D7nudqlOnXeENqxfULOaW61xMq7GE0LnHwCdgacMQsGeaCHn+f/VGr5bXB cQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jgk1hrfn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 10 Sep 2022 00:54:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 10 Sep
 2022 00:54:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 10 Sep 2022 00:54:22 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id A5E723F7064;
        Sat, 10 Sep 2022 00:54:19 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <hkelam@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 0/4] Add PTP support for CN10K silicon
Date:   Sat, 10 Sep 2022 13:24:12 +0530
Message-ID: <20220910075416.22887-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _uajkDbmu-xJ8NaovFQLEEPFO6xhAZul
X-Proofpoint-GUID: _uajkDbmu-xJ8NaovFQLEEPFO6xhAZul
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-10_04,2022-09-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

