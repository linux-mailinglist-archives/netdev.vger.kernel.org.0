Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E371D4C0180
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiBVSju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiBVSjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:39:49 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9538295483
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:39:23 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21M9YwY4019940;
        Tue, 22 Feb 2022 10:39:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=qPr1BEyEqrrtV9jX4AJ5VZDZNJTXZ0dMyrmN97TOd5I=;
 b=BMzWOPyRPVfs69VGMMu7eAdmy4LYKOJL36h+UzP1XnkFv21K5KBuEI2zRWZF3rAlFv+b
 J0u9aLkwMQRvGRhBPS02xEq90UE1pNx1MeNHcVEhCGAn+UiUDhz8Gm4XpT3W1YVr0wB7
 Z0h7TZyVwl5F3RcIt50qz+HADsAbGOm0LGaSZR5oxZEilNvyp4rhpO316JOWS1RQYzg8
 wzQ4kkBETPTlVD5O6O9qZt9lp1pKTP3YJZnFDgk/ZP+RmLsRmV62VODGg7GbQxK9A4B2
 2Y44+/4+Axa66wTJ+tpobFiq1qDeM1FIh8ubJqfIXELFol6R05ljzCLrnlpsnmGeHxJg dw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ecwaxag1j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 10:39:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Feb
 2022 10:39:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 22 Feb 2022 10:39:18 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id CAC363F70A2;
        Tue, 22 Feb 2022 10:39:15 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [v2 net-next PATCH 0/2] Add ethtool support for completion queue event size
Date:   Wed, 23 Feb 2022 00:09:11 +0530
Message-ID: <1645555153-4932-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LPyVsDmr3kd7BQF46fAgJ3a9jtbU-3zM
X-Proofpoint-ORIG-GUID: LPyVsDmr3kd7BQF46fAgJ3a9jtbU-3zM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_06,2022-02-21_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a packet is sent or received by NIC then NIC posts
a completion queue event which consists of transmission status
(like send success or error) and received status(like
pointers to packet fragments). These completion events may
also use a ring similar to rx and tx rings. This patchset
introduces cqe-size ethtool parameter to modify the size
of the completion queue event if NIC hardware has that capability.
A bigger completion queue event can have more receive buffer pointers
inturn NIC can transfer a bigger frame from wire as long as
hardware(MAC) receive frame size limit is not exceeded.

Patch 1 adds support setting/getting cqe-size via
ethtool -G and ethtool -g.

Patch 2 includes octeontx2 driver changes to use
completion queue event size set from ethtool -G.

v2 changes:
	As per Jakub suggestions renamed ce size to cqe size
	Added documentation for cqe size

Thanks,
Sundeep

Subbaraya Sundeep (2):
  ethtool: add support to set/get completion queue event size
  octeontx2-pf: Vary completion queue event size

 Documentation/networking/ethtool-netlink.rst          | 11 +++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  |  4 ++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 17 ++++++++++++++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c  |  2 ++
 include/linux/ethtool.h                               |  4 ++++
 include/uapi/linux/ethtool_netlink.h                  |  1 +
 net/ethtool/netlink.h                                 |  2 +-
 net/ethtool/rings.c                                   | 19 +++++++++++++++++--
 10 files changed, 55 insertions(+), 8 deletions(-)

-- 
2.7.4

