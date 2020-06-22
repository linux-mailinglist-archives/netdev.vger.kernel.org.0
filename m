Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8520356D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgFVLOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:14:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14392 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728037AbgFVLO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB87Or013048;
        Mon, 22 Jun 2020 04:14:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=b3PntQKBqtZ3GatNaLsuAv2mZADAUCw5SRw2SUSm3BE=;
 b=veA55006wCV4Fg9Gm+A6kYWt6xtrdxdVia9qf57wN12BldisGJ1i6wiAC1mWi3YUYSjd
 DpoGveng2A1djV0wR6lSBvfaceVg96P5Vd/XhRzhs9eKmgKZ2jyeWpwb4D330kngN9Pg
 DBphqFTkqJ7PaEex1IogLT+d6gugLCMF8f2lRl/n0NcHaqdTeVViHc19FHcRRm9X4nYj
 XhkIXUoeBlxeslXZz3R1XtuZIaL2/mAIqHxCzRh5PAOgT+Lx6sDZb06QO7s0pqjtOecN
 0eiSYbEGQvIG1utEFWc/9DGBZIsvvJoJkVMrLhnY/o1TYf3xHLgHai8I+it4OUTLx6mF KQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynqp9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:21 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 2E0A93F703F;
        Mon, 22 Jun 2020 04:14:16 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/9] net: qed/qede: various stability fixes
Date:   Mon, 22 Jun 2020 14:14:04 +0300
Message-ID: <20200622111413.7006-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set addresses several near-critical issues that were observed
and reproduced on different test and production configurations.

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
2.21.0

