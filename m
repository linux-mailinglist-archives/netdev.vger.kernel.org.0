Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E011185B88
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 10:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgCOJfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 05:35:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:57118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbgCOJfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 05:35:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B1AE0AC91;
        Sun, 15 Mar 2020 09:35:07 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Subject: [PATCH v2 5/6] net: sfc: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:35:02 +0100
Message-Id: <20200315093503.8558-6-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315093503.8558-1-tiwai@suse.de>
References: <20200315093503.8558-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: "David S . Miller" <davem@davemloft.net>
Cc: Edward Cree <ecree@solarflare.com>
Cc: Martin Habets <mhabets@solarflare.com>
Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Align the remaining lines to the open parenthesis

 drivers/net/ethernet/sfc/mcdi.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 2713300343c7..15c731d04065 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -212,12 +212,14 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 		 * progress on a NIC at any one time.  So no need for locking.
 		 */
 		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
-					  " %08x", le32_to_cpu(hdr[i].u32[0]));
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
+					   " %08x",
+					   le32_to_cpu(hdr[i].u32[0]));
 
 		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
-					  " %08x", le32_to_cpu(inbuf[i].u32[0]));
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
+					   " %08x",
+					   le32_to_cpu(inbuf[i].u32[0]));
 
 		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
 	}
@@ -302,15 +304,15 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
 		 */
 		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
-					  " %08x", le32_to_cpu(hdr.u32[0]));
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
+					   " %08x", le32_to_cpu(hdr.u32[0]));
 		}
 
 		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr,
 					mcdi->resp_hdr_len + (i * 4), 4);
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
-					  " %08x", le32_to_cpu(hdr.u32[0]));
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
+					   " %08x", le32_to_cpu(hdr.u32[0]));
 		}
 
 		netif_info(efx, hw, efx->net_dev, "MCDI RPC RESP:%s\n", buf);
@@ -1417,9 +1419,11 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 	}
 
 	ver_words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_OUT_VERSION);
-	offset = snprintf(buf, len, "%u.%u.%u.%u",
-			  le16_to_cpu(ver_words[0]), le16_to_cpu(ver_words[1]),
-			  le16_to_cpu(ver_words[2]), le16_to_cpu(ver_words[3]));
+	offset = scnprintf(buf, len, "%u.%u.%u.%u",
+			   le16_to_cpu(ver_words[0]),
+			   le16_to_cpu(ver_words[1]),
+			   le16_to_cpu(ver_words[2]),
+			   le16_to_cpu(ver_words[3]));
 
 	/* EF10 may have multiple datapath firmware variants within a
 	 * single version.  Report which variants are running.
@@ -1427,9 +1431,9 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0) {
 		struct efx_ef10_nic_data *nic_data = efx->nic_data;
 
-		offset += snprintf(buf + offset, len - offset, " rx%x tx%x",
-				   nic_data->rx_dpcpu_fw_id,
-				   nic_data->tx_dpcpu_fw_id);
+		offset += scnprintf(buf + offset, len - offset, " rx%x tx%x",
+				    nic_data->rx_dpcpu_fw_id,
+				    nic_data->tx_dpcpu_fw_id);
 
 		/* It's theoretically possible for the string to exceed 31
 		 * characters, though in practice the first three version
-- 
2.16.4

