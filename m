Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4A3159AA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhBIWrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:47:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53522 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234347AbhBIWXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:23:48 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119LA6kj008787;
        Tue, 9 Feb 2021 13:27:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=PU+EcWKknPZCQQKrVbAdFIu3ftCNbEOUaNTWKGoQyAY=;
 b=aKjkd8WeEQsbn3qTf8WO9WeNPoe8h03N+75hCJzmSIzsVXGK4k/TkzcgtlAW6iPKtb7B
 3nuqSa1tcv/Gd5O/GGmjHfAcWEVBL3IAANpzgDZadWmxXEpFeMOYf6Hiy3FYqSJmLzOH
 kbZxlJJ8VCg7EeGxfcE8z1THdYMdIOOCvMS2W3Omr4hiALbNMqMPMxYCfqhMc1z6rbYc
 hrzed09byyeVi0gc9VD0pTGuRNc3JMg5zq+25U6qzH9ByMx1B5RxoESgdvdo5BfKCAq0
 m3yZaX0JCQRz+A3ew3nlz16Gst2JIG/JwC64J5kS6nyTH2Iw5zU+SB7FysZtdmkKHrHV 1Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrj6bw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:27:12 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 13:27:11 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 13:27:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 13:27:10 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id A95FC3F703F;
        Tue,  9 Feb 2021 13:27:10 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH v2 net-next 0/3] qede: add netpoll and per-queue coalesce support
Date:   Tue, 9 Feb 2021 13:26:56 -0800
Message-ID: <1612906019-31724-1-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_07:2021-02-09,2021-02-09 signatures=0
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

v2: comments from jakub
 - p1: remove poll_controller ndo and add budget 0 support in qede_poll
 - p3: preserve coalesce parameters across interface up and down

Bhaskar Upadhaya (3):
  qede: add netpoll support for qede driver
  qede: add per queue coalesce support for qede driver
  qede: preserve per queue stats across up/down of interface

 drivers/net/ethernet/qlogic/qede/qede.h       |  10 ++
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 133 +++++++++++++++++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  29 +++-
 4 files changed, 170 insertions(+), 5 deletions(-)

-- 
2.17.1

