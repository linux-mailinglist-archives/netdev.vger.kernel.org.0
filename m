Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FD81D2BF4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgENJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:58:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbgENJ6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 05:58:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E9tvxR028123;
        Thu, 14 May 2020 02:57:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=AGO3TAxEgRQGRttJtOE4oxSuw3BCmdkdUrjSjQqZ0ZM=;
 b=it/H3C2Fjf17zH/8Wb5oFuARxgZxn0axPDbuDSZQLMba7sQpgj3CsrEyLs8iLCTkySpm
 33f0TUlDEwju14QSyJROR+nIoCMvKULzCITrxUcqeBrnCaRhI6vPyV9u1/8deBzXdIaB
 bxBqpq3abtxyt6LEGfQQgyoJcXSV+1kGebcLwXxS2/lVA3tCOZ4FwdEDE8a72xLVp6cs
 gGFomOf10Clmxx7xg/asBMV6w4GCQsLRkv0A/mvgQXBncAsFomgcbBrwcN5QNWuujFi6
 2boG2/RjiQ+KnQ8D3iC6RBvzAR0stxqExTPf4PJFh2eYckiGnIZfA7lk1EwGZn3jLciN Yw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1qv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 02:57:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 02:57:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 02:57:51 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id D57D83F703F;
        Thu, 14 May 2020 02:57:48 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 00/11] net: qed/qede: critical hw error handling
Date:   Thu, 14 May 2020 12:57:16 +0300
Message-ID: <20200514095727.1361-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FastLinQ devices as a complex systems may observe various hardware
level error conditions, both severe and recoverable.

Driver is able to detect and report this, but so far it only did
trace/dmesg based reporting.

Here we implement an extended hw error detection, service task
handler captures a dump for the later analysis.

I also resubmit a patch from Denis Bolotin on tx timeout handler,
addressing David's comment regarding recovery procedure as an extra
reaction on this event.

v2:

Removing the patch with ethtool dump and udev magic. Its quite isolated,
I'm working on devlink based logic for this separately.

v1:

https://patchwork.ozlabs.org/project/netdev/cover/cover.1588758463.git.irusskikh@marvell.com/

Denis Bolotin (1):
  net: qede: Implement ndo_tx_timeout

Igor Russkikh (10):
  net: qed: adding hw_err states and handling
  net: qede: add hw err scheduled handler
  net: qed: invoke err notify on critical areas
  net: qed: critical err reporting to management firmware
  net: qed: cleanup debug related declarations
  net: qed: attention clearing properties
  net: qede: optional hw recovery procedure
  net: qed: introduce critical fan failure handler
  net: qed: introduce critical hardware error handler
  net: qed: fix bad formatting

 drivers/net/ethernet/qlogic/qed/qed.h         |  16 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c   |  26 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  49 +++-
 drivers/net/ethernet/qlogic/qed/qed_hw.c      |  42 ++-
 drivers/net/ethernet/qlogic/qed/qed_hw.h      |  15 ++
 drivers/net/ethernet/qlogic/qed/qed_int.c     |  40 ++-
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  11 +
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  34 +++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 254 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |  28 ++
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |  16 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |  14 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  24 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 147 +++++++++-
 include/linux/qed/qed_if.h                    |  26 +-
 16 files changed, 700 insertions(+), 46 deletions(-)

-- 
2.17.1

