Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA0C146606
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAWK6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:58:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726099AbgAWK6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:58:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAw1XK022295;
        Thu, 23 Jan 2020 02:58:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=TPp+zWHJ/KprfYWUyltUJzNu7us7KS06sigAZ91aPNo=;
 b=ZWViI/mOtSMzAFsNr0Zy6MR9xZZ23KAJNIHvJRrKMLrDI7qTTvEH2558D1xw4a/8sjKT
 OdVL9ARo1AI9yMmCCnwWF/S4jSel+x/gHg0NBIbgmErM4WX7o/k5A+QzBL/Wkw3rtJDi
 UeqfxqISH22K9iPajRPkqnSqblv21glHcGlCD9iEgmDYnIca9NbGgO9AWGEObFYDffaQ
 ecUzL26CmYNQis1RskIFZOaWUcd7wOrSpGgpn3z/FQDQbv6htEqfpRY6/AbTwPFWtHX+
 A/A5nk0HBkQCYX7U4saWug+VqZTsmHq8tdhyyaOAgYTFSJhFPvygrZqR31M3n8tIjmP1 mQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xq4x4h2xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:58:45 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:58:44 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:58:43 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 552193F703F;
        Thu, 23 Jan 2020 02:58:42 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 00/13] qed*: Utilize FW 8.42.2.0
Date:   Thu, 23 Jan 2020 12:58:23 +0200
Message-ID: <20200123105836.15090-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_08:2020-01-23,2020-01-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This FW contains several fixes and features, main ones listed below.
We have taken into consideration past comments on previous FW versions
that were uploaded and tried to separate this one to smaller patches to
ease review.

- RoCE
	- SRIOV support
	- Fixes in following flows:
		- latency optimization flow for inline WQEs
		- iwarp OOO packed DDPs flow
		- tx-dif workaround calculations flow
		- XRC-SRQ exceed cache num

- iSCSI
	- Fixes:
		- iSCSI TCP out-of-order handling.
		- iscsi retransmit flow

- Fcoe
	- Fixes:
		- upload + cleanup flows

- Debug
	- Better handling of extracting data during traffic
	- ILT Dump -> dumping host memory used by chip
	- MDUMP -> collect debug data on system crash and extract after
	  reboot

Patches prefixed with FW 8.42.2.0 are required to work with binary
8.42.2.0 FW where as the rest are FW related but do not require the
binary.

Changes from V1
---------------
- Remove epoch + kernel version from device debug dump
- don't bump driver version


Michal Kalderon (13):
  qed: FW 8.42.2.0 Internal ram offsets modifications
  qed: FW 8.42.2.0 Expose new registers and change windows
  qed: FW 8.42.2.0 Queue Manager changes
  qed: FW 8.42.2.0 Parser offsets modified
  qed: Use dmae to write to widebus registers in fw_funcs
  qed: FW 8.42.2.0 Additional ll2 type
  qed: Add abstraction for different hsi values per chip
  qed: FW 8.42.2.0 iscsi/fcoe changes
  qed: FW 8.42.2.0 HSI changes
  qed: FW 8.42.2.0 Add fw overlay feature
  qed: Debug feature: ilt and mdump
  qed: rt init valid initialization changed
  qed: FW 8.42.2.0 debug features

 drivers/net/ethernet/qlogic/qed/qed.h              |   69 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |  358 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |  130 +
 drivers/net/ethernet/qlogic/qed/qed_debug.c        | 4055 +++++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_debug.h        |    4 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  128 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h      |   24 -
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c         |    2 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 2565 ++++++-------
 drivers/net/ethernet/qlogic/qed/qed_hw.c           |   67 +-
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |  532 ++-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c     |   47 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.h     |    8 -
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c        |   36 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |    8 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |  149 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h          |   14 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   10 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h     |   38 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_sp.h           |    2 -
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   19 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    8 +-
 include/linux/qed/common_hsi.h                     |   44 +-
 include/linux/qed/eth_common.h                     |   78 +-
 include/linux/qed/iscsi_common.h                   |   64 +-
 include/linux/qed/qed_if.h                         |   14 +-
 include/linux/qed/qed_ll2_if.h                     |    7 +
 include/linux/qed/storage_common.h                 |    3 +-
 30 files changed, 4336 insertions(+), 4151 deletions(-)

-- 
2.14.5

