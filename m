Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27D1DE1A9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 10:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgEVIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 04:20:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728208AbgEVIUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 04:20:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M8FoDn019591;
        Fri, 22 May 2020 01:19:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=kJzYYdUviX9ravlfbbUUycQrFHc6P3zSI7HEmEUHAOk=;
 b=SzhOVk7d/lQFvQmDLZ5VDER2Z6H7Qe5dtnWArvLoZKLyhSiRqxQhNgwjgelRA+WSGV1o
 6w9M/0o52CiOt9PgLTH4UnwwlFuoPnmLz5UuQ0jvBvazQc+NyWivHEepm7iNmMLoZIVJ
 I2w7tY2y4VOM96nqn7wDY3NwnrqeY4XsR0suByJD8EyG0g6w1y2CNAyUnIxj8JV3ydVM
 crwaMfH6yqik196sSYl0ZOBovXyfaA1oFsM5aZvpEiqezKDfSnXgvelLNLjf+xRJ5zOO
 4PMYlh6iqMxVQLcQjYAnZ3Bxq+Gqp7rqkbqFwBG2yWwSsDB4aTQ/g2cGBv8KGZWWc6Hr qg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fpphew2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 May 2020 01:19:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 22 May
 2020 01:19:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 01:19:54 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 5B16F3F703F;
        Fri, 22 May 2020 01:19:52 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 00/12] net: atlantic: QoS implementation
Date:   Fri, 22 May 2020 11:19:36 +0300
Message-ID: <20200522081948.167-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_04:2020-05-21,2020-05-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for mqprio rate limiters and multi-TC:
 * max_rate is supported on both A1 and A2;
 * min_rate is supported on A2 only;

This is a joint work of Mark and Dmitry.

To implement this feature, a couple of rearrangements and code
improvements were done, in areas of TC/ring management, allocation
control, etc.

One of the problems we faced is conflicting ptp functionality, which
consumes a whole traffic class due to hardware limitations.
Patches below have a more detailed description on how PTP and multi-TC
co-exist right now.

v2:
 * accommodated review comments (-Wmissing-prototypes and
   -Wunused-but-set-variable findings);
 * added user notification in case of conflicting multi-TC<->PTP
   configuration;
 * added automatic PTP disabling, if a conflicting configuration is
   detected;
 * removed module param, which was used for PTP disabling in v1;

v1: https://patchwork.ozlabs.org/cover/1294380/

Dmitry Bezrukov (4):
  net: atlantic: changes for multi-TC support
  net: atlantic: move PTP TC initialization to a separate function
  net: atlantic: changes for multi-TC support
  net: atlantic: QoS implementation: multi-TC support

Mark Starovoytov (8):
  net: atlantic: per-TC queue statistics
  net: atlantic: make TCVEC2RING accept nic_cfg
  net: atlantic: QoS implementation: max_rate
  net: atlantic: automatically downgrade the number of queues if
    necessary
  net: atlantic: always use random TC-queue mapping for TX on A2.
  net: atlantic: change the order of arguments for TC weight/credit
    setters
  net: atlantic: QoS implementation: min_rate
  net: atlantic: proper rss_ctrl1 (54c0) initialization

 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  74 +++--
 .../ethernet/aquantia/atlantic/aq_filters.c   |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  20 +-
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |  26 ++
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |   2 +
 .../ethernet/aquantia/atlantic/aq_macsec.c    |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  72 ++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 265 +++++++++++----
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  27 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |   3 +
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  27 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  19 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  72 +++--
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |   8 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  10 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 255 ++++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_b0.h      |   2 +
 .../atlantic/hw_atl/hw_atl_b0_internal.h      |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  65 +++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  32 +-
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 101 +++++-
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 301 +++++++++++++-----
 .../atlantic/hw_atl2/hw_atl2_internal.h       |  12 +-
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |  36 ++-
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  19 +-
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 111 +++++--
 26 files changed, 1197 insertions(+), 381 deletions(-)

-- 
2.25.1

