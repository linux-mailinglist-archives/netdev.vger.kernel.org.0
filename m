Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF12485459
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbiAEOZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:24 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17326 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbiAEOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:20 -0500
Received: from kwepemi100002.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JTWvH1wHXz9s0D;
        Wed,  5 Jan 2022 22:24:11 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100002.china.huawei.com (7.221.188.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 00/15] net: hns3: refactor rss/tqp stats functions
Date:   Wed, 5 Jan 2022 22:20:00 +0800
Message-ID: <20220105142015.51097-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently, hns3 PF and VF module have two sets of rss and tqp stats APIs
to provide get and set functions. Most of these APIs are the same. There is
no need to keep these two sets of same functions for double development and
bugfix work.

This series refactor the rss and tqp stats APIs in hns3 PF and VF by
implementing one set of common APIs for PF and VF reuse and deleting the
old APIs.

Jie Wang (15):
  net: hns3: create new rss common structure hclge_comm_rss_cfg
  net: hns3: refactor hclge_comm_send function in PF/VF drivers
  net: hns3: create new set of common rss get APIs for PF and VF rss
    module
  net: hns3: refactor PF rss get APIs with new common rss get APIs
  net: hns3: refactor VF rss get APIs with new common rss get APIs
  net: hns3: create new set of common rss set APIs for PF and VF module
  net: hns3: refactor PF rss set APIs with new common rss set APIs
  net: hns3: refactor VF rss set APIs with new common rss set APIs
  net: hns3: create new set of common rss init APIs for PF and VF reuse
  net: hns3: refactor PF rss init APIs with new common rss init APIs
  net: hns3: refactor VF rss init APIs with new common rss init APIs
  net: hns3: create new set of common tqp stats APIs for PF and VF reuse
  net: hns3: refactor PF tqp stats APIs with new common tqp stats APIs
  net: hns3: refactor VF tqp stats APIs with new common tqp stats APIs
  net: hns3: create new common cmd code for PF and VF modules

 drivers/net/ethernet/hisilicon/hns3/Makefile  |   5 +-
 .../hns3/hns3_common/hclge_comm_cmd.c         |  80 +--
 .../hns3/hns3_common/hclge_comm_cmd.h         | 277 +++++++-
 .../hns3/hns3_common/hclge_comm_rss.c         | 525 ++++++++++++++
 .../hns3/hns3_common/hclge_comm_rss.h         | 136 ++++
 .../hns3/hns3_common/hclge_comm_tqp_stats.c   | 115 ++++
 .../hns3/hns3_common/hclge_comm_tqp_stats.h   |  39 ++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         | 278 +-------
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 632 ++---------------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  65 +-
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  71 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 646 ++----------------
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  60 +-
 16 files changed, 1243 insertions(+), 1697 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h

-- 
2.33.0

