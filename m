Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F9968852E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjBBRQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBBRQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:16:24 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304986384A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:16:24 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312H4v7n011062;
        Thu, 2 Feb 2023 09:14:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=3lDBKQSGQEd0WkaVANSUp8qMd34VSOS5n5bIccgXZ14=;
 b=AuEAraIProwCJFRkm+5iNJ8wjWeRbfuaFPjPKXRru19bpMKPDbOq1AcsGiNmgbdXYqNe
 5fmxSJaM97cKkJqog8zMyXpfK1Pia9VB+etoZO9X+m6W5JM2rUr5gfeG6OvmRZV+1uwG
 XllinfH3/aucrvFFZKvxcjNTDsGI+LvP3/o6Z6Z6hTTK9zzHdMbaJMjpovJlee5ut+LR
 cYzN8PDsHD2p6Lr+aSbvURdUorlDbvbK3gMibGw1ORY0RL8eQQhZ5mlTy4vQP71U9j5Q
 QrZzTSGy5KyUYcz8DTyDYma3zKv7UBODnHEcRo+uEpMOuNPwxAO3VzuAxK2kP8/z6Kq6 7w== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nfq36b322-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Feb 2023 09:14:06 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server id
 15.1.2507.17; Thu, 2 Feb 2023 09:14:03 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Tariq Toukan" <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "Saeed Mahameed" <saeed@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net v5 0/2] mlx5: ptp fifo bugfixes
Date:   Thu, 2 Feb 2023 09:13:53 -0800
Message-ID: <20230202171355.548529-1-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-ORIG-GUID: mBZ74_WAFSJ8lH1bnaIl0cvRuM2kAKWX
X-Proofpoint-GUID: mBZ74_WAFSJ8lH1bnaIl0cvRuM2kAKWX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_11,2023-02-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple FIFO implementation for PTP queue has several bugs which lead to
use-after-free and skb leaks. This series fixes the issues and adds new
checks for this FIFO implementation to uncover the same problems in
future.

v4 -> v5:
  Change check to WARN_ON_ONCE() in mlx5e_skb_fifo_pop()
  Change the check of OOO cqe as Jakub provided corner case
  Move OOO logic into separate function and add counter
v3 -> v4:
  Change pr_err to mlx5_core_err_rl per suggest
  Removed WARN_ONCE on fifo push because has_room() should catch the
  issue
v2 -> v3:
  Rearrange patches order and rephrase commit messages
  Remove counters as Gal confirmed FW bug, use KERN_ERR message instead
  Provide proper budget to napi_consume_skb as Jakub suggested
v1 -> v2:
  Update Fixes tag to proper commit.
  Change debug line to avoid double print of function name

Vadim Fedorenko (2):
  mlx5: fix skb leak while fifo resync and push
  mlx5: fix possible ptp queue fifo use-after-free

 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 25 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  1 +
 4 files changed, 27 insertions(+), 4 deletions(-)

-- 
2.30.2

