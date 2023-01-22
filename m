Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CB467706D
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 17:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjAVQQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 11:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjAVQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 11:16:20 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CBB1DB84
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 08:16:19 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30MFWGB3032583;
        Sun, 22 Jan 2023 08:16:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=VqLPzb6Bwsdkw5XtAE8wiiUfZ682JpYFT7o8+eATjEk=;
 b=BIjuBqCTm3YdX4KCDH0v+74I6YWfGeJU/0kdLm6CS6y5BTY8M+v414nsE0xx8TxKZ2Dq
 Pc33q0xZPZskDvIvCBDlCxQLaGHp8z2OhMi3vvczqZQHX7bFqkkHWpufJSwqHHAaH7WV
 Ax78wkYjr2rMOQs2CVeNMmMLNHHjVFJV+sml0/W7g5Ms6yehXsmwYZAkeKag1FNqcL6M
 +2wpWPAWRMoxjkN6I56v2yJOR/JJ4rQ/JZscN7P6cKqEAOKfl10xnt2Dtx3xqakV4NP2
 VFQjbO53NuVf/k5Cq0r/6pG6Cqhq0bByThlwxLc/Iin2xS1P15kbrza1/Mq2V1d6a8ZJ CA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n8ep4dh86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Jan 2023 08:16:13 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server id
 15.1.2375.34; Sun, 22 Jan 2023 08:16:11 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net 0/2] mlx5: bugfixes for ptp fifo queue
Date:   Sun, 22 Jan 2023 08:16:00 -0800
Message-ID: <20230122161602.1958577-1-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: 0M6rPgppdbWrTh8vTs-o6QV_ISliHE52
X-Proofpoint-ORIG-GUID: 0M6rPgppdbWrTh8vTs-o6QV_ISliHE52
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_13,2023-01-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple FIFO implementation for PTP queue has several bug which lead to
use-after-free and skb leaks. This series fixes the issues and adds new
counters of out-of-order CQEs for this queue.

Vadim Fedorenko (2):
  mlx5: fix possible ptp queue fifo overflow
  mlx5: fix skb leak while fifo resync

 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 29 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 4 files changed, 31 insertions(+), 8 deletions(-)

-- 
2.30.2

