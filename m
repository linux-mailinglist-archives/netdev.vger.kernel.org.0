Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597766469AE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 08:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLHHXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 02:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLHHXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 02:23:35 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9188A46646;
        Wed,  7 Dec 2022 23:23:32 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NSQcM0rSdz8R041;
        Thu,  8 Dec 2022 15:23:31 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl1.zte.com.cn with SMTP id 2B87NPXn058403;
        Thu, 8 Dec 2022 15:23:25 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Thu, 8 Dec 2022 15:23:27 +0800 (CST)
Date:   Thu, 8 Dec 2022 15:23:27 +0800 (CST)
X-Zmail-TransId: 2af9639190efffffffff94be3eda
X-Mailer: Zmail v1.0
Message-ID: <202212081523277319144@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <kuba@kernel.org>
Cc:     <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <wangxiang@cdjrlc.com>, <dossche.niels@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBzZmM6IENvbnZlcnQgdG8gdXNlIHN5c2ZzX2VtaXRfYXQoKSBBUEk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B87NPXn058403
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 639190F3.000 by FangMail milter!
X-FangMail-Envelope: 1670484211/4NSQcM0rSdz8R041/639190F3.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 639190F3.000/4NSQcM0rSdz8R041
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/ethernet/sfc/mcdi.c       | 14 ++++----------
 drivers/net/ethernet/sfc/siena/mcdi.c | 14 ++++----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index af338208eae9..73269db3ca39 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -210,14 +210,10 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 		 * progress on a NIC at any one time.  So no need for locking.
 		 */
 		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x",
-					   le32_to_cpu(hdr[i].u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr[i].u32[0]));

 		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x",
-					   le32_to_cpu(inbuf[i].u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(inbuf[i].u32[0]));

 		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
 	}
@@ -302,15 +298,13 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
 		 */
 		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x", le32_to_cpu(hdr.u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
 		}

 		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr,
 					mcdi->resp_hdr_len + (i * 4), 4);
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x", le32_to_cpu(hdr.u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
 		}

 		netif_info(efx, hw, efx->net_dev, "MCDI RPC RESP:%s\n", buf);
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 3f7899daa86a..4e10d4594c3a 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -213,14 +213,10 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 		 * progress on a NIC at any one time.  So no need for locking.
 		 */
 		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x",
-					   le32_to_cpu(hdr[i].u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr[i].u32[0]));

 		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x",
-					   le32_to_cpu(inbuf[i].u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(inbuf[i].u32[0]));

 		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
 	}
@@ -305,15 +301,13 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
 		 */
 		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x", le32_to_cpu(hdr.u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
 		}

 		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr,
 					mcdi->resp_hdr_len + (i * 4), 4);
-			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
-					   " %08x", le32_to_cpu(hdr.u32[0]));
+			bytes += sysfs_emit_at(buf, bytes, " %08x", le32_to_cpu(hdr.u32[0]));
 		}

 		netif_info(efx, hw, efx->net_dev, "MCDI RPC RESP:%s\n", buf);
-- 
2.25.1
