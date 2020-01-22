Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC0145897
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgAVP0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:26:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgAVP0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 10:26:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MFQVxa024768;
        Wed, 22 Jan 2020 07:26:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=ad3dy6u/l4u5EygVtqHMxQloIH3Glg7r2CjX4Jb9CdI=;
 b=zGzqrQvTL3WUC5mwfsxLV3RTlGzA0Xz5L8VZZ/LWQMyxOUtsJFMe1efJAY9Bc3PQ6mdq
 dQ/aQsHsxC7W7Bf2kp4B5KsTieUH4NzsazbsOa2Ahw0pVl66Ef3sYyXlwkFdlk2bA/Gc
 pa/A43JcnrLf5JH48E07DwsEqKxsECXkp5m2j5lKh3ckOmsZMf+Avxuesa4OV9FWKVOs
 AN1MSHL/1MsyJsgXliTcyss7D1FZfIlB2eL4Ynh1u1CwfZXhax5mHaOtAkC2WR8SskjU
 xOiqPIjju7iJNeV2mckNLGflElIGNOGyCLtfnHydoma47+w4LaQonKBg7dIr6xN9wEvs 5A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xpm9015qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 07:26:31 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 07:26:29 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jan 2020 07:26:29 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2FE3E3F703F;
        Wed, 22 Jan 2020 07:26:27 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 00/14] qed*: Utilize FW 8.42.2.0
Date:   Wed, 22 Jan 2020 17:26:13 +0200
Message-ID: <20200122152627.14903-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
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

Michal Kalderon (14):
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
  qed: bump driver version

 drivers/net/ethernet/qlogic/qed/qed.h              |   77 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |  358 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |  130 +
 drivers/net/ethernet/qlogic/qed/qed_debug.c        | 4073 ++++++++++----------
 drivers/net/ethernet/qlogic/qed/qed_debug.h        |    6 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  140 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h      |   24 -
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c         |    2 +
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 2565 ++++++------
 drivers/net/ethernet/qlogic/qed/qed_hw.c           |   67 +-
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |  532 ++-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c     |   47 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.h     |    8 -
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c        |   36 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |    8 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |  149 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h          |   14 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |    7 +-
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
 30 files changed, 4380 insertions(+), 4152 deletions(-)

-- 
2.14.5

