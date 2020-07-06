Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC987215ADA
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgGFPip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:38:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4388 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729254AbgGFPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:38:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066Fa2iQ025471;
        Mon, 6 Jul 2020 08:38:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0818;
 bh=kbrcjkJmWfKDZ13FOr3lXXusLb6V6Y+RzmXQCd9TcRs=;
 b=cml+93NsmZgI6k2xHHSOnOSDLvZqrwmWJ4a2hyNpw0resE0lc6KtGxLVRG1r8EDP4uTL
 nlAGtGj+z94y8wuXZ5cmYSUb9q1qa+YMBkWXlon+hJgBxI3ek2IoFbzdFfr7kQ5zsPDO
 x3RAAEsTHD5CH9fbk+bt84Jj2OQ3zqe5q4f5x9tZAjuAR3K1m3StUlm3220fKudItHvB
 y7W2W7D5nJsgRyWgvANjG4ns0Gc+IYTY0+ljoga9G1V+7+GKEOJ2ufy2ZwSfCk+8/Jt+
 idG3CCFV/24cJzuXnrglVqjJ4TN1ctzS3lY+UefkgKDO7levovWIoheR2WxyWkZ4JJ/7 Yw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:38:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:38:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:38:41 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 48CDE3F703F;
        Mon,  6 Jul 2020 08:38:38 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/9] net: qed/qede: W=1 C=1 warnings cleanup
Date:   Mon, 6 Jul 2020 18:38:12 +0300
Message-ID: <20200706153821.786-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set cleans qed/qede build log under W=1 C=1 with GCC 8 and
sparse 0.6.2. The only thing left is "context imbalance -- unexpected
unlock" in one of the source files, which will be issued later during
the refactoring cycles.

The biggest part is handling the endianness warnings. The current code
often just assumes that both host and device operate in LE, which is
obviously incorrect (despite the fact that it's true for x86 platforms),
and makes sparse {s,m}ad.

The rest of the series is mostly random non-functional fixes
here-and-there.

Alexander Lobakin (9):
  net: qed: move static iro_arr[] out of header file
  net: qed: cleanup global structs declarations
  net: qed: correct qed_hw_err_notify() prototype
  net: qed: address kernel-doc warnings
  net: qed: improve indentation of some parts of code
  net: qed: use ptr shortcuts to dedup field accessing in some parts
  net: qed: sanitize BE/LE data processing
  net: qede: fix kernel-doc for qede_ptp_adjfreq()
  net: qede: fix BE vs CPU comparison

 drivers/net/ethernet/qlogic/qed/qed_cxt.c     |  14 +-
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c    |  27 +-
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h    |   2 +
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |  52 ++--
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c    |  54 ++--
 drivers/net/ethernet/qlogic/qed/qed_fcoe.h    |   5 -
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     | 267 +++++++-----------
 drivers/net/ethernet/qlogic/qed/qed_hw.c      |   5 +-
 drivers/net/ethernet/qlogic/qed/qed_hw.h      |   7 +-
 .../ethernet/qlogic/qed/qed_init_fw_funcs.c   | 128 +++++----
 .../net/ethernet/qlogic/qed/qed_init_ops.c    |  73 +++++
 drivers/net/ethernet/qlogic/qed/qed_int.c     | 123 ++++----
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c   |  48 ++--
 drivers/net/ethernet/qlogic/qed/qed_iscsi.h   |   4 -
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c   | 150 ++++++----
 drivers/net/ethernet/qlogic/qed/qed_l2.c      |  81 +++---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c     |   9 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h     |   2 +
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  16 +-
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_ptp.c     |   1 +
 drivers/net/ethernet/qlogic/qed/qed_ptp.h     |   9 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    |  52 ++--
 drivers/net/ethernet/qlogic/qed/qed_rdma.h    |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_roce.c    | 203 ++++++-------
 drivers/net/ethernet/qlogic/qed/qed_sp.h      |   9 +-
 .../net/ethernet/qlogic/qed/qed_sp_commands.c |  24 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |  16 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   |  27 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h   |   2 +
 .../net/ethernet/qlogic/qede/qede_filter.c    |   8 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c   |  10 +-
 include/linux/qed/qed_if.h                    |  15 +-
 33 files changed, 743 insertions(+), 706 deletions(-)
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_ptp.h

-- 
2.25.1

