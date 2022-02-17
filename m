Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702744BA38B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbiBQOto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:49:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242086AbiBQOtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:49:39 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD1A21FC63
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:49:24 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21H9IMHn006741;
        Thu, 17 Feb 2022 06:49:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=WzCY10Bjb2bB10CuhADHnFYu0/xAtn+qhkpf7qMa6vk=;
 b=KkOjmsjYBBdPWz9WUnc2dGDFTmLNnTUkUK7tqLMeFRnKQxO106eALrqQMuFknqLA9E+y
 K3dwtstGZtEPpxZYCKE7ZHUPC73AEdFwGHgtzkPipa4jT2x6jTIlJ+zYbAat59Q5kwdo
 +n/B7/vaOGxdMmb1O0XXtTpbidsBP/5i1yhkYiM6xBSRxcOHMk/ygj1m3d4m7wKPMz4T
 IGerkI+wbPpgaZCXHe5TezogIgd7Vg8WXjJ1tJxXfAhCpFGhGDh5Z7Til6/NXy9ZZl61
 C1qhgKI7bv+T3QvfxlbcKW1HrqOlA4NZjjIYbQmDHtz4YsExwgU0IKZSLuTB8a935hxI RA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e9kkts6ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 06:49:14 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Feb
 2022 06:49:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 17 Feb 2022 06:49:11 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 53B2E3F7045;
        Thu, 17 Feb 2022 06:49:09 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 0/2] Add ethtool support for completion event size 
Date:   Thu, 17 Feb 2022 20:19:04 +0530
Message-ID: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NU_JC_9EirgelX6AtdTCqsHAdETNbnrl
X-Proofpoint-GUID: NU_JC_9EirgelX6AtdTCqsHAdETNbnrl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
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
a completion event which consists of transmission status
(like send success or error) and received status(like
pointers to packet fragments). These completion events may
also use a ring similar to rx and tx rings. This patchset
introduces ce-size ethtool parameter to modify the size
of the completion event if NIC hardware has that capability.
A bigger completion event can have more receive buffer pointers
inturn NIC can transfer a bigger frame from wire as long as
hardware(MAC) receive frame size limit is not exceeded.

Patch 1 adds support setting/getting ce-size via
ethtool -G and ethtool -g.

Patch 2 includes octeontx2 driver changes to use
completion event size set from ethtool -G.

Thanks,
Sundeep

Subbaraya Sundeep (2):
  ethtool: add support to set/get completion event size
  octeontx2-pf: Vary completion queue event size

 Documentation/networking/ethtool-netlink.rst          |  2 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  |  4 ++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 17 ++++++++++++++---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c  |  2 ++
 include/linux/ethtool.h                               |  3 +++
 include/uapi/linux/ethtool_netlink.h                  |  1 +
 net/ethtool/netlink.h                                 |  2 +-
 net/ethtool/rings.c                                   | 19 +++++++++++++++++--
 10 files changed, 45 insertions(+), 8 deletions(-)

-- 
2.7.4

