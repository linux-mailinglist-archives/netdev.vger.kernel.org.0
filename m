Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DCE1C6F63
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgEFLdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:33:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgEFLdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:33:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BWTOx010368;
        Wed, 6 May 2020 04:33:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Ry/No4PN990yCVjagTIHH8jObVBBDg7Mgh/tUP4DU1M=;
 b=KggNg2skuIY2BmDjiuIORcFICWGyXEyFeUgHweF+f+gnvthWiTID6fjAlxuNefdVMEhu
 stE0famr7NvVzFasetATTnUxWp+Y1Nv4lCMr5YFnvij2HClcu1rIr2oDB27eQwu2ovVA
 kcT9y+tWBKvXUbJS3n6GA6+ycqGjXG1tSfCZeXYJYcnHz2z/l7R40fBrErPqyPeuP/oy
 /1jz1qwnyBrT3xr5EWvc8WlpNpgrB+plmxWx3NVlbAEisrvwG2e+biC6P3kj3A2jUHl2
 gT7O/swYKOk540g9wpe2csTW/wVXSCVOmlrwmi9sfhvePgcdXx5yLQgj5rRDn9rTvhot BA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaukvqkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:33:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:33:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 May
 2020 04:33:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 6 May 2020 04:33:48 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id A21F63F703F;
        Wed,  6 May 2020 04:33:45 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 00/12] net: qed/qede: critical hw error handling
Date:   Wed, 6 May 2020 14:33:02 +0300
Message-ID: <cover.1588758463.git.irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_05:2020-05-05,2020-05-06 signatures=0
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

Denis Bolotin (1):
  net: qede: Implement ndo_tx_timeout

Igor Russkikh (11):
  net: qed: adding hw_err states and handling
  net: qede: add hw err scheduled handler
  net: qed: invoke err notify on critical areas
  net: qed: critical err reporting to management firmware
  net: qed: cleanup debug related declarations
  net: qed: gather debug data on hw errors
  net: qed: attention clearing properties
  net: qede: optional hw recovery procedure
  net: qed: introduce critical fan failure handler
  net: qed: introduce critical hardware error handler
  net: qed: fix bad formatting

 drivers/net/ethernet/qlogic/qed/qed.h         |  18 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c   | 102 ++++++-
 drivers/net/ethernet/qlogic/qed/qed_debug.h   |   1 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c     |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h     |  49 +++-
 drivers/net/ethernet/qlogic/qed/qed_hw.c      |  42 ++-
 drivers/net/ethernet/qlogic/qed/qed_hw.h      |  15 ++
 drivers/net/ethernet/qlogic/qed/qed_int.c     |  40 ++-
 drivers/net/ethernet/qlogic/qed/qed_int.h     |  11 +
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  35 +++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c     | 254 ++++++++++++++++++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h     |  28 ++
 drivers/net/ethernet/qlogic/qed/qed_spq.c     |  16 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |  14 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  24 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 150 ++++++++++-
 include/linux/qed/qed_if.h                    |  27 +-
 17 files changed, 784 insertions(+), 46 deletions(-)

-- 
2.25.1

