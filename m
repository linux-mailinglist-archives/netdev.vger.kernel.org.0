Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8833D12E9BD
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgABSJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:09:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgABSJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:09:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I4UeF103402;
        Thu, 2 Jan 2020 18:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=7mFri1IvSbR2yII37pLPC48tNxELRWB3ByRsOG8tlYQ=;
 b=qhcmRs0/QQhxN2gVF4r5l5qW8ef2d7NZxRbTEoIEo+BrmlwVmKBOWbf0ZlNfYqAyI+DM
 wHyWXhWALkSTMxHzd7qiJpmkCR62AisX9t0iVHcuQ/hZ7K5lZNNZ79AgKm87wcssefrB
 BSgYqh5qo/4BK6GX0LTYj1cjI7iHyrUrgifHEJeftDWoft2lvO72wE3bdFiwejkubFeA
 XE65q1zmvH0G/Uy+XxBd177P769cEe43LyR6eDpPqMyVLsyIpYUHsksQ2dnumuXiMeKt
 yXnaDDgZ+EXQD0OrkayL1Zp9gOxBGN4ebolc10qUPOkAThOl4QlSFLZdHEa3B59rzz2O ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0prp6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:09:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I3RoQ013871;
        Thu, 2 Jan 2020 18:09:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x9jm6e8hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:09:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 002I9d9N022788;
        Thu, 2 Jan 2020 18:09:40 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 10:09:39 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     netanel@amazon.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        igorch@amazon.com, akiyano@amazon.com, evgenys@amazon.com,
        gtzalik@amazon.com, ndagan@amazon.com, matua@amazon.com,
        galpress@amazon.com, Liran Alon <liran.alon@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH 1/2] net: AWS ENA: Remove unncessary wmb() to flush bounce buffer
Date:   Thu,  2 Jan 2020 20:08:29 +0200
Message-Id: <20200102180830.66676-2-liran.alon@oracle.com>
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

Current code executes wmb() in order to flush writes to bounce buffer
before copying it to device-memory (PCI BAR mapped as WC) to ensure
consistent data is written to device-memory.

However, this wmb() is unnecessary. This is because all reads from the
buffer are guaranteed to be consistent with previous writes to the buffer
done from the same task (Which is the only one that writes to the buffer).

i.e. If a single CPU runs both the writes to the buffer and the reads
from the buffer, the reads are guaranteed to read most up-to-date data
in program order (E.g. Due to store-to-load-forwarding mechanism).
Otherwise, there is a context-switch, and that should make writes before
context-switch globally visible as-well.

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 2845ac277724..742578ac1240 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -93,11 +93,6 @@ static int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
 			 io_sq->qid, io_sq->entries_in_tx_burst_left);
 	}
 
-	/* Make sure everything was written into the bounce buffer before
-	 * writing the bounce buffer to the device
-	 */
-	wmb();
-
 	/* The line is completed. Copy it to dev */
 	__iowrite64_copy(io_sq->desc_addr.pbuf_dev_addr + dst_offset,
 			 bounce_buffer, (llq_info->desc_list_entry_size) / 8);
-- 
2.20.1

