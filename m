Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAC5145073
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbgAVJnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:43:47 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387769AbgAVJnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 04:43:46 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00M9eqDY015237;
        Wed, 22 Jan 2020 01:43:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=Hw+jQFnSqpOEA8dohIC3ojSBr5j/92Lw59zTAsp3zXg=;
 b=yqqlI7RXfMeHY7i+CH/ol2q2Gp0vdjIX97ZZyd0fsqE1kBziEwygmEUWwofJ8Z77wwY2
 hAHnLlYL48eae5tHFFCzmN1peNps2L1O84TVM3cqPMV0qRJwuROu7ZBIWxser/804fVR
 6GHM6jxtPzH0BxplPWJ/vtSd3BpJqzxGyBqMs5IdVH/q2fmvb/O4Vu5i2KlEAKo2GcuB
 faK4neQmuizraOhsMnrQ7SPK69mmXZVib19b5jjDjsJqku4Ug8RK4+8DJbNo4D3Rl1Vl
 hyOq9d5dNc2ZyWE9Rb+e18B+5yR2tb5nR8cW0hArYcg0mN5uyBh5djoA1lQkoBxK81kv XA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dt6a40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 01:43:43 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 01:43:41 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jan 2020 01:43:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 243903F703F;
        Wed, 22 Jan 2020 01:43:41 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 00M9heV3014199;
        Wed, 22 Jan 2020 01:43:40 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 00M9heGS014198;
        Wed, 22 Jan 2020 01:43:40 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <GR-Linux-NIC-Dev@marvell.com>
Subject: [PATCH net 1/1] qlcnic: Fix CPU soft lockup while collecting firmware dump
Date:   Wed, 22 Jan 2020 01:43:38 -0800
Message-ID: <20200122094338.14153-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver while collecting firmware dump takes longer time to
collect/process some of the firmware dump entries/memories.
Bigger capture masks makes it worse as it results in larger
amount of data being collected and results in CPU soft lockup.
Place cond_resched() in some of the driver flows that are
expectedly time consuming to relinquish the CPU to avoid CPU
soft lockup panic.

Signed-off-by: Shahed Shaikh <shshaikh@marvell.com>
Tested-by: Yonggen Xu <Yonggen.Xu@dell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index a496390b8632..07f9067affc6 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2043,6 +2043,7 @@ static void qlcnic_83xx_exec_template_cmd(struct qlcnic_adapter *p_dev,
 			break;
 		}
 		entry += p_hdr->size;
+		cond_resched();
 	}
 	p_dev->ahw->reset.seq_index = index;
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
index afa10a163da1..f34ae8c75bc5 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c
@@ -703,6 +703,7 @@ static u32 qlcnic_read_memory_test_agent(struct qlcnic_adapter *adapter,
 		addr += 16;
 		reg_read -= 16;
 		ret += 16;
+		cond_resched();
 	}
 out:
 	mutex_unlock(&adapter->ahw->mem_lock);
@@ -1383,6 +1384,7 @@ int qlcnic_dump_fw(struct qlcnic_adapter *adapter)
 		buf_offset += entry->hdr.cap_size;
 		entry_offset += entry->hdr.offset;
 		buffer = fw_dump->data + buf_offset;
+		cond_resched();
 	}
 
 	fw_dump->clr = 1;
-- 
2.18.1

