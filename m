Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B6A23562F
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgHBKI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 06:08:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17602 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbgHBKI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 06:08:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 072A19EX003208;
        Sun, 2 Aug 2020 03:08:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=j1sqcAl/MjCahmJUR9UG+78MePj0HH/TnCiyu8tipeE=;
 b=ymdq4DEVIYEmJVn2UjwP0nFC0QiT4wos78xAlhGIuJ0/8EKwcSkndS6HWgq/WDIvSD+F
 e2DhSIdhgmJMipu6GrLVtyWM082BPJeT3Dqs8XylYQdb/Zokj0XUorMz+LTjBYH//0bO
 LDfWBOsrPRq8uj4cix3RJoj7Qy/tpvtgH08B5AC1pgc/O6+stLJoU0YG6db7MfD/kPHp
 W9RJ3/UHRtxkQt+4wivt3FAyfIqTyF4pnjMfbpS9wo4P6tdAn4wb0hQQqk1+OTHbDmnl
 BpNny0vGWXvhibRPgEXd3Up5LSaUen9U54CY18Plo4Leu+RIDElX3aWZmLjH7Ckhvigi HA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fejkvf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 02 Aug 2020 03:08:51 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 2 Aug
 2020 03:08:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 2 Aug
 2020 03:08:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 2 Aug 2020 03:08:49 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 7AE813F703F;
        Sun,  2 Aug 2020 03:08:46 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v5 net-next 00/10] qed: introduce devlink health support
Date:   Sun, 2 Aug 2020 13:08:24 +0300
Message-ID: <20200802100834.383-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_06:2020-07-31,2020-08-02 signatures=0
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

v5: improved patch 4 description
v4:
 - commit message and other fixes after Jiri's comments
 - removed one patch (will send to net)
v3: fix uninit var usage in patch 11
v2: fix #include issue from kbuild test robot.

Igor Russkikh (10):
  qed: move out devlink logic into a new file
  qed/qede: make devlink survive recovery
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
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |   9 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 259 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h |  20 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c    | 116 +-------
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  38 ++-
 include/linux/qed/qed_if.h                    |  23 +-
 10 files changed, 347 insertions(+), 129 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h

-- 
2.17.1

