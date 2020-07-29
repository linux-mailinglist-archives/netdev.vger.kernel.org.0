Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4448231D75
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgG2Liz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:38:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57802 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgG2Liz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:38:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBZskw006475;
        Wed, 29 Jul 2020 04:38:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=aGS0FBGnaJ352AnYm0BVHQtdwyRkLztcr6BvPAe1VnQ=;
 b=BjV71i/vKptkdzFmH/xWaPE4KC8bChpi/Gy36i0ZocCa87Fh8BHSHc5NjgjERDaYb9ca
 ml3UNx9OYrCnRj8usrFlfZJKQPyCGDGh1FJJDiNnIPVzjhTttcSn+5I4bMrefzAH0s7c
 x2bt4/D5fN4QDyUTJkgsTXzg2zNgGKQ4tds0UMn/ei226Xh2F+OEAEuiNmWwT6lwb2GT
 u8YjYXaBXbyq7sg1US0A28s0l20B0JXDQjUmTdpG0VZQAzyMV284qWsiYENgJX5Cyh3q
 v4Wu5YeKFAIzaZSsqS1MMXAoUf0JLuLYR0npPMhz/49+Jz8rwlL+xgHr0SLyIt3FcEgI Jg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r0r4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:38:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:38:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:38:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:38:51 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 43B093F703F;
        Wed, 29 Jul 2020 04:38:49 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v3 net-next 00/11] qed: introduce devlink health support
Date:   Wed, 29 Jul 2020 14:38:35 +0300
Message-ID: <20200729113846.1551-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_04:2020-07-29,2020-07-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a followup implementation after series

https://patchwork.ozlabs.org/project/netdev/cover/20200514095727.1361-1-irusskikh@marvell.com/

This is an implementation of devlink health infrastructure.

With this we are now able to report HW errors to devlink, and it'll take
its own actions depending on user configuration to capture and store the
dump at the bad moment, and to request the driver to recover the device.

So far we do not differentiate global device failures or specific PCI
function failures. This means that some errors specific to one physical
function will affect an entire device. This is not yet fully designed
and verified, will followup in future.

Solution was verified with artificial HW errors generated, existing
tools for dump analysis could be used.

v3: fix uninit var usage in patch 11
v2: fix #include issue from kbuild test robot.

Igor Russkikh (11):
  qed: move out devlink logic into a new file
  qed/qede: make devlink survive recovery
  qed: swap param init and publish
  qed: fix kconfig help entries
  qed: implement devlink info request
  qed: health reporter init deinit seq
  qed: use devlink logic to report errors
  qed*: make use of devlink recovery infrastructure
  qed: implement devlink dump
  qed: align adjacent indent
  qede: make driver reliable on unload after failures

 drivers/net/ethernet/qlogic/Kconfig           |   5 +-
 drivers/net/ethernet/qlogic/qed/Makefile      |   1 +
 drivers/net/ethernet/qlogic/qed/qed.h         |   3 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |  10 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 256 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  20 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 116 +-------
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  39 ++-
 include/linux/qed/qed_if.h                    |  23 +-
 10 files changed, 345 insertions(+), 130 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

-- 
2.17.1

