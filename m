Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F5B14A4EF
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgA0N0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:26:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20404 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgA0N0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:26:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RDP39X006196;
        Mon, 27 Jan 2020 05:26:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=1U7f5/ABf2s+ONHVm/4zYew7hk1QWA/Z1enYrETLVnA=;
 b=W7ng3wfKwi1hAxHOspUKu2mhTHi/UbG48XF9hGLWSG8ZNrNmx+cmksOO6TowFCjre3Dy
 cxeMQq56tHicLWg9D2cW0GLQX9+0GF5CUzDkU4QKS0QnCIYYlXpUcIFpPSjsXgDyPfhF
 oil6cHTqbmWjgIDF2K646sjlrrM3x67RJG0Dr1KxslmPnq7hJG5iysOwnbOu5cThaBAj
 UgxQ3N0VxU5JHqMuKqVoZpuIj+oGU39GiszyDNpr+yTU6ponT/DK4z7ODICTnUW8awcq
 dGP6EJz9lfRytWxuTme/OCF5WT6POWQleVCINtx2JoGPFOxGESvzBTSDMVaz/2jWSplD Aw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xrkwufdtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 05:26:29 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jan
 2020 05:26:28 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jan 2020 05:26:28 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id A60893F703F;
        Mon, 27 Jan 2020 05:26:26 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 net-next 00/13] qed*: Utilize FW 8.42.2.0
Date:   Mon, 27 Jan 2020 15:26:06 +0200
Message-ID: <20200127132619.27144-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_02:2020-01-24,2020-01-27 signatures=0
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

Changes from V2
---------------
- Move FW version to the start of the series to maintain minimal compatibility
- Fix some kbuild errors:
	- frame size larger than 1024 (Queue Manager patch - remove redundant
	  field from struct)
	- sparse warning on endianity (Dmae patch fix - wrong use of __le32 for field
	  used only on host, should be u32)
	- static should be used for some functions (Debug feature ilt and mdump)

Reported-by: kbuild test robot <lkp@intel.com>

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
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 2564 ++++++-------
 drivers/net/ethernet/qlogic/qed/qed_hw.c           |   67 +-
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |  521 ++-
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
 30 files changed, 4324 insertions(+), 4151 deletions(-)

-- 
2.14.5

