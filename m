Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34012E9BC
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgABSJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:09:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46424 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgABSJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:09:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I4F8b103272;
        Thu, 2 Jan 2020 18:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DN1aQFJ1BZKGuo1vG8wzfuFNTA0OjcXOkVlWp8x6y5c=;
 b=TYkFAj+sHOjVx/HZK3nUHXiOLOMwqQHkCAeIHP/pyAm3wBy3233zYTk3zxvDsX7VzmYq
 GciA/Hmlob2hP4EPBm85MsaAD0kdqGXtATBaARWm2hW0J2R1UX51PVm8Gar6CPelrMFn
 hZx43NDqNfm+JURl9bTGX4Hk/PIk4Bpib6krrMl6Ocl+A9EdlHLeanSAy6JwWA8jRAZU
 w+QkjeeaR7X8ss9GP9u68wqJfVeZHv4TdRmSaVQUQN3Ig9lcsYUZG4JUWOtf4dLuWq3D
 TRBBzRhEc98LCLSmfzV9ouh9DmUeEXrExSldFKywhDEZ8EWvVFbq6QY7dDYZHt4beY8L Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0prp6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:09:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I3btW091701;
        Thu, 2 Jan 2020 18:09:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gjauurt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:09:44 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 002I9hxC018576;
        Thu, 2 Jan 2020 18:09:43 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 10:09:42 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     netanel@amazon.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        igorch@amazon.com, akiyano@amazon.com, evgenys@amazon.com,
        gtzalik@amazon.com, ndagan@amazon.com, matua@amazon.com,
        galpress@amazon.com, Liran Alon <liran.alon@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail to doorbell
Date:   Thu,  2 Jan 2020 20:08:30 +0200
Message-Id: <20200102180830.66676-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200102180830.66676-1-liran.alon@oracle.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AWS ENA NIC supports Tx SQ in Low Latency Queue (LLQ) mode (Also
referred to as "push-mode"). In this mode, the driver pushes the
transmit descriptors and the first 128 bytes of the packet directly
to the ENA device memory space, while the rest of the packet payload
is fetched by the device from host memory. For this operation mode,
the driver uses a dedicated PCI BAR which is mapped as WC memory.

The function ena_com_write_bounce_buffer_to_dev() is responsible
to write to the above mentioned PCI BAR.

When the write of new SQ tail to doorbell is visible to device, device
expects to be able to read relevant transmit descriptors and packets
headers from device memory. Therefore, driver should ensure
write-combined buffers (WCBs) are flushed before the write to doorbell
is visible to the device.

For some CPUs, this will be taken care of by writel(). For example,
x86 Intel CPUs flushes write-combined buffers when a read or write
is done to UC memory (In our case, the doorbell). See Intel SDM section
11.3 METHODS OF CACHING AVAILABLE:
"If the WC buffer is partially filled, the writes may be delayed until
the next occurrence of a serializing event; such as, an SFENCE or MFENCE
instruction, CPUID execution, a read or write to uncached memory, an
interrupt occurrence, or a LOCK instruction execution.”

However, other CPUs do not provide this guarantee. For example, x86
AMD CPUs flush write-combined buffers only on a read from UC memory.
Not a write to UC memory. See AMD Software Optimisation Guide for AMD
Family 17h Processors section 2.13.3 Write-Combining Operations.

Therefore, modify ena_com_write_sq_doorbell() to flush write-combined
buffers with wmb() in case Tx SQ is in LLQ mode.

Note that this cause 2 theoretical unnecessary perf hits:
(1) On x86 Intel, this will execute unnecessary SFENCE.
But probably the perf impact is neglictable because it will also
cause the implciit SFENCE done internally by write to UC memory to do
less work.
(2) On ARM64 this will change from using dma_wmb() to using wmb()
which is more costly (Use DSB instead of DMB) even though DMB should be
sufficient to flush WCBs.

This patch will focus on making sure WCBs are flushed on all CPUs, and a
later future patch will be made to add a new macro to Linux such as
flush_wc_writeX() that does the right thing for all archs and CPU
vendors.

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.h b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
index 77986c0ea52c..f9bfaef08bfa 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.h
@@ -179,7 +179,22 @@ static inline int ena_com_write_sq_doorbell(struct ena_com_io_sq *io_sq)
 	pr_debug("write submission queue doorbell for queue: %d tail: %d\n",
 		 io_sq->qid, tail);
 
-	writel(tail, io_sq->db_addr);
+	/*
+	 * When Tx SQ is in LLQ mode, transmit descriptors and packet headers
+	 * are written to device-memory mapped as WC. Therefore, we need to
+	 * ensure write-combined buffers are flushed before writing new SQ
+	 * tail to doorbell.
+	 *
+	 * On some CPUs (E.g. x86 AMD) writel() doesn't guarantee this.
+	 * Therefore, prefer to explicitly flush write-combined buffers
+	 * with wmb() before writing to doorbell in case Tx SQ is in LLQ mode.
+	 */
+	if (io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) {
+		wmb();
+		writel_relaxed(tail, io_sq->db_addr);
+	} else {
+		writel(tail, io_sq->db_addr);
+	}
 
 	if (is_llq_max_tx_burst_exists(io_sq)) {
 		pr_debug("reset available entries in tx burst for queue %d to %d\n",
-- 
2.20.1

