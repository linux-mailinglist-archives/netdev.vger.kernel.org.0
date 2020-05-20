Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7FB1DB57B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgETNrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:47:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20816 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgETNrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:47:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KDf26b003644;
        Wed, 20 May 2020 06:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=wGYCw9VpqxzIVVNHDrGjAGNFmqy9WReyJIdnqJNQ4Ew=;
 b=E6YHC7zIlgGExKabWjeAcyq2VsqZACN5nP5p87kkl0mGL7wxHPbWQA8xtK4OgPIaOALt
 t9Hs2eoKvtpw0vgAFSg9l6mGx2lGmHUG/lOO9yRk3015Cb/8nRCD45nlkY3R8wB8tpTp
 BJq4bP/1/LqQHXGKo2NLgDAJdDaksYU56KmCGUSqeGEReCBCsG96PcvOyORjerRob8Jp
 rYzjM4bC65duj7VnLERFQjdFYYLmXJ81xoi7hHcq44dQH+XC07jS0g+r0LIO3ql+tPfo
 tEwJ9bTLdpoL+f4osnBJx14NyPEbkrYk0lTBl0VsLqvpoqI1/2wKJS2WmRlw3vniKUje uQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 312dhqs59e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 06:47:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 06:47:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 20 May 2020 06:47:39 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 158753F703F;
        Wed, 20 May 2020 06:47:36 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 00/12] net: atlantic: QoS implementation
Date:   Wed, 20 May 2020 16:47:22 +0300
Message-ID: <20200520134734.2014-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_09:2020-05-20,2020-05-20 signatures=0
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
due to hardware limitations consumes whole traffic class.
Patches below has more detailed description on how this coexist now.


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

 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   3 +
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  74 +++--
 .../ethernet/aquantia/atlantic/aq_filters.c   |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  20 +-
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |  26 ++
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |   2 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  72 ++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 266 ++++++++++++----
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
 26 files changed, 1200 insertions(+), 380 deletions(-)

-- 
2.25.1

