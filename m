Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D835317168
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhBJU35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:29:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233391AbhBJU3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:29:36 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AKP9CS020784;
        Wed, 10 Feb 2021 12:28:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=4U9Jc1s/zr4TaeKLtWC0IpludKHTWg4Mk68NSq7NMLA=;
 b=PMnVjQ1AUZoA0D4drkb1V/NsGpmKJIlrtTHt1nU3njln+mVtZYEnzWMAbFkKQWX1FxCE
 TKVfO2s0kKTNnaBeucHvOnPT5JppWPdxu4Qn5Zk6L1ohc3a5sGWzFAApK8DnepDf+v88
 r38+N76woN8DE42NKSM3icZqorOMh4WLvVOAEMSFbhEgbxxMi4qqNT5eVCp/lWYGPV+o
 YuPyLyMsSwrKMG3Kt4Fgy/ScnTvSV/O6Goa8T0TvR3Jpeq4S3KJURUfR5+SRxByH1mes
 gobKU4JrMV963aRyDvEJYB4CTGvLJOTNaOovLn3m2d98ZxhYcruiqmS/lUcj3UUxlz1p gA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqcwaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 12:28:47 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 12:28:43 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 12:28:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 12:28:42 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id B44313F7040;
        Wed, 10 Feb 2021 12:28:42 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH v3 net-next 0/3] qede: add netpoll and per-queue coalesce support
Date:   Wed, 10 Feb 2021 12:28:28 -0800
Message-ID: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a followup implementation after series

https://patchwork.kernel.org/project/netdevbpf/cover/1610701570-29496-1-git-send-email-bupadhaya@marvell.com/

Patch 1: Add net poll controller support to transmit kernel printks
         over UDP
Patch 2: QLogic card support multiple queues and each queue can be
         configured with respective coalescing parameters, this patch
         add per queue rx-usecs, tx-usecs coalescing parameters
Patch 3: set default per queue rx-usecs, tx-usecs coalescing parameters and
         preserve coalesce parameters across interface up and down

v3: fixed warnings reported by Dan Carpenter
v2: comments from jakub
 - p1: remove poll_controller ndo and add budget 0 support in qede_poll
 - p3: preserve coalesce parameters across interface up and down

Bhaskar Upadhaya (3):
  qede: add netpoll support for qede driver
  qede: add per queue coalesce support for qede driver
  qede: preserve per queue stats across up/down of interface

 drivers/net/ethernet/qlogic/qede/qede.h       |  10 ++
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 134 +++++++++++++++++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  29 +++-
 4 files changed, 171 insertions(+), 5 deletions(-)

-- 
2.17.1

