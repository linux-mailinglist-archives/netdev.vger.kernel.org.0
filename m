Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7B5DA1BD
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394949AbfJPWu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:50:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393551AbfJPWu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:57 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMopkH009294
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:56 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnmy2e4nf-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:56 -0700
Received: from 2401:db00:2120:81dc:face:0:23:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 16 Oct 2019 15:50:30 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id B87DD4A2BD52; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 00/10 net-next] page_pool cleanups
Date:   Wed, 16 Oct 2019 15:50:18 -0700
Message-ID: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 mlxlogscore=768 bulkscore=0
 clxscore=1034 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch combines work from various people:
- part of Tariq's work to move the DMA mapping from
  the mlx5 driver into the page pool.  This does not
  include later patches which remove the dma address
  from the driver, as this conflicts with AF_XDP.

- Saeed's changes to check the numa node before
  including the page in the pool, and flushing the
  pool on a node change.

- Statistics and cleanup for page pool.

Jonathan Lemon (5):
  page_pool: Add page_pool_keep_page
  page_pool: allow configurable linear cache size
  page_pool: Add statistics
  net/mlx5: Add page_pool stats to the Mellanox driver
  page_pool: Cleanup and rename page_pool functions.

Saeed Mahameed (2):
  page_pool: Add API to update numa node and flush page caches
  net/mlx5e: Rx, Update page pool numa node when changed

Tariq Toukan (3):
  net/mlx5e: RX, Remove RX page-cache
  net/mlx5e: RX, Manage RX pages only via page pool API
  net/mlx5e: RX, Internal DMA mapping in page_pool

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 128 ++--------
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  39 ++--
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  19 +-
 include/net/page_pool.h                       | 216 +++++++++--------
 net/core/page_pool.c                          | 221 +++++++++++-------
 8 files changed, 319 insertions(+), 353 deletions(-)

-- 
2.17.1

