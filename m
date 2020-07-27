Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E717722F7F1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgG0SnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:43:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33024 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727880AbgG0SnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:43:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIdfCS031426;
        Mon, 27 Jul 2020 11:43:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=nHW00hzpyAHXbB0A3uL7kKnUIYvs+c5xwu1Ge3VHp3A=;
 b=tPl7ke5zy/bGc/r0fVg4nyi8K5xoUFSgQJrkQLM/KQhMZb0rRqzClVmDJHMvMWq7M2r9
 KWEFjr1YTiJimWz/sQa/pc5+ehVjaJ0OwGj770EMc6PVRrOqrvIe4BNvRQ+UxbXdfydl
 PdsJUcQJmxC0dozqBbnUTNSTOzigPle/AbIgh2Cb1/zkKxc4gwU2PxQeqEatXDjX1XcT
 H8LksAwusIn0zEUFL2DkxdCu4D1DEYzaA79X043p+wDXvRgZpTzqkWCHgHl1eqdSVcIK
 Jjji9n6YsafxgpLW1hEAS8cGy3s130Vp5vywgt8v+IKJnf5YrGZ7kQw7XN0bRXO9/lhL mg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32gm8nfyyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 11:43:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 11:43:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 11:43:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jul 2020 11:43:16 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id A54BC3F703F;
        Mon, 27 Jul 2020 11:43:14 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 00/11] qed: introduce devlink health support
Date:   Mon, 27 Jul 2020 21:42:59 +0300
Message-ID: <20200727184310.462-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a followup implementation after series

https://patchwork.ozlabs.org/project/netdev/cover/20200514095727.1361-1-irusskikh@marvell.com/

This is an implementation of devlink health infrastructure.

With this we are now able to report HW errors to devlink, and it'll take
its own actions depending on user configuration to capture and store the dump
at the bad moment, and to request the driver to recover the device.

So far we do not differentiate global device failures or specific PCI function
failures. This means that some errors specific to one physical function will
affect an entire device. This is not yet fully designed and verified, will
followup in future.

Solution was verified with artificial HW errors generated, existing tools
for dump analysis could be used.

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
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 255 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  20 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 116 +-------
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  35 ++-
 include/linux/qed/qed_if.h                    |  23 +-
 10 files changed, 341 insertions(+), 129 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

-- 
2.17.1

