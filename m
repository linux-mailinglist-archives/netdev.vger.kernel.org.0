Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D934F2053E1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732734AbgFWNxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:53:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732633AbgFWNxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDjJYi024426;
        Tue, 23 Jun 2020 06:53:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=grHYZIv6ZfuCT5ybHGHnt/3uylmwaf5P3hRiYBlmvp0=;
 b=D4/paavitxf6ys9gcfMiVJlWqrYUdgwOsypiBXol8DU8RopzuE5o6qJkCIq+c2+K7dvr
 pKh6n/mRPS1VnprfTKQiVUYHBfv3OMP2TjCnkBLuYJHQFP+goexzUCa27lsWQcpSBwh9
 CGRs45sdMVo6t8RT1iLKHvTxa10v12NG0m8ychBdfg5aYjPQ4RHU4bBeytj+C+TX63+Q
 S91F0M1Ki9l0LYlJkfwt7A8vKQbHDSmDLUb/G9SoxOfJV5eKJYUanx1OdmJdu+I+p1uN
 BcOHp+/nwcXScNAKUWAGK2kxoLxz8LAA/LPpRn3alNDsm0L03WsKSYi2oS3+SC0kvv0E WQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31ujw9r0w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:14 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 750D23F703F;
        Tue, 23 Jun 2020 06:53:10 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 0/9] net: qed/qede: various stability fixes
Date:   Tue, 23 Jun 2020 16:51:28 +0300
Message-ID: <20200623135136.3185-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set addresses several near-critical issues that were observed
and reproduced on different test and production configurations.

v2:
 - don't split the "Fixes:" tag across several lines in patch 9;
 - no functional changes.

Alexander Lobakin (9):
  net: qed: fix left elements count calculation
  net: qed: fix async event callbacks unregistering
  net: qede: stop adding events on an already destroyed workqueue
  net: qed: fix NVMe login fails over VFs
  net: qed: fix excessive QM ILT lines consumption
  net: qede: fix PTP initialization on recovery
  net: qede: fix use-after-free on recovery and AER handling
  net: qed: reset ILT block sizes before recomputing to fix crashes
  net: qed: fix "maybe uninitialized" warning

 drivers/net/ethernet/qlogic/qed/qed_cxt.c    | 21 ++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_dev.c    | 11 +++++--
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c  |  2 --
 drivers/net/ethernet/qlogic/qed/qed_roce.c   |  1 -
 drivers/net/ethernet/qlogic/qed/qed_vf.c     | 23 +++++++++++----
 drivers/net/ethernet/qlogic/qede/qede_main.c |  3 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c  | 31 ++++++++------------
 drivers/net/ethernet/qlogic/qede/qede_ptp.h  |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_rdma.c |  3 +-
 include/linux/qed/qed_chain.h                | 26 +++++++++-------
 10 files changed, 80 insertions(+), 43 deletions(-)

-- 
2.25.1

