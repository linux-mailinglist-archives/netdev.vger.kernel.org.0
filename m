Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE75482334
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhLaKT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:19:56 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29316 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhLaKTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:19:55 -0500
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JQLj74fcpzbjgS;
        Fri, 31 Dec 2021 18:19:23 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 00/10] net: hns3: refactor cmdq functions in PF/VF
Date:   Fri, 31 Dec 2021 18:14:49 +0800
Message-ID: <20211231101459.56083-1-huangguangbin2@huawei.com>
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

Currently, hns3 PF and VF module have two sets of cmdq APIs to provide
cmdq message interaction functions. Most of these APIs are the same. The
only differences are the function variables and names with pf and vf
suffixes. These two sets of cmdq APIs are redundent and add extra bug fix
work.

This series refactor the cmdq APIs in hns3 PF and VF by implementing one
set of common cmdq APIs for PF and VF reuse and deleting the old APIs.

Jie Wang (10):
  net: hns3: create new set of unified hclge_comm_cmd_send APIs
  net: hns3: refactor hclge_cmd_send with new hclge_comm_cmd_send API
  net: hns3: refactor hclgevf_cmd_send with new hclge_comm_cmd_send API
  net: hns3: create common cmdq resource allocate/free/query APIs
  net: hns3: refactor PF cmdq resource APIs with new common APIs
  net: hns3: refactor VF cmdq resource APIs with new common APIs
  net: hns3: create common cmdq init and uninit APIs
  net: hns3: refactor PF cmdq init and uninit APIs with new common APIs
  net: hns3: refactor VF cmdq init and uninit APIs with new common APIs
  net: hns3: delete the hclge_cmd.c and hclgevf_cmd.c

 drivers/net/ethernet/hisilicon/hns3/Makefile  |   9 +-
 .../hns3/hns3_common/hclge_comm_cmd.c         | 626 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_cmd.h         | 172 +++++
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 591 -----------------
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         | 153 +----
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  10 +-
 .../hisilicon/hns3/hns3pf/hclge_err.c         |  25 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 170 ++---
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  23 +-
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |  16 +-
 .../hisilicon/hns3/hns3pf/hclge_mdio.c        |   4 +-
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 556 ----------------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       | 140 +---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 133 ++--
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  30 +-
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  19 +-
 17 files changed, 1046 insertions(+), 1633 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c

-- 
2.33.0

