Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C16865E9
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbjBAM03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjBAM02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:26:28 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D72E47EFD
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:26:27 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311BIfPd005332;
        Wed, 1 Feb 2023 04:26:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=GsFY9frapWILAn6DtHllLFeDZASXQN3lT0O3T8HMZvY=;
 b=hzHy5chgBxlpP01Oub+WKMYtN+b328pv0FnC1sqvM+uzp0LVLifmWtM3W1krjjsHc6uW
 2hstxGfmxvyM8FDKDeZy3DHRMy5d5/Ejcn0wOrdoossDalfQ8cMvQWyXRR05W7lRCZ+n
 9Bm2pA4Y6Zc8Ydw87CDVi0djTSRNJsFNj2294exrZY4xrpkuMsRhvbeFX32BSYj6SWAb
 co0iBaKRJ3tMozDFepVpTHiMNnwtpXaRBz3n3PsSLa865bXD3XGFAuBK5llM68wwGi5y
 aQ07qLai+cJCJcBomm5RY0EMM8jxsy1mCGmg8c2ZN4XlA8GOTqrO8/XJ4BP/AHSZabV/ YQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nfq3brbvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Feb 2023 04:26:16 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server id
 15.1.2507.17; Wed, 1 Feb 2023 04:26:14 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Tariq Toukan" <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "Saeed Mahameed" <saeed@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net v4 0/2] mlx5: ptp fifo bugfixes
Date:   Wed, 1 Feb 2023 04:26:03 -0800
Message-ID: <20230201122605.1350664-1-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: 6f-btB5k3IRRMnDF_1gL7cFMxMTUGK6Q
X-Proofpoint-GUID: 6f-btB5k3IRRMnDF_1gL7cFMxMTUGK6Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
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

 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 25 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++--
 2 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.30.2

