Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08ED181368
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgCKIiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:50162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbgCKIiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 225BFB1C4;
        Wed, 11 Mar 2020 08:38:02 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>
Subject: [PATCH 6/7] sfc: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:44 +0100
Message-Id: <20200311083745.17328-7-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311083745.17328-1-tiwai@suse.de>
References: <20200311083745.17328-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc: Edward Cree <ecree@solarflare.com>
Cc: Martin Habets <mhabets@solarflare.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/sfc/mcdi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 2713300343c7..ac978e24644f 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -212,11 +212,11 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
 		 * progress on a NIC at any one time.  So no need for locking.
 		 */
 		for (i = 0; i < hdr_len / 4 && bytes < PAGE_SIZE; i++)
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
 					  " %08x", le32_to_cpu(hdr[i].u32[0]));
 
 		for (i = 0; i < inlen / 4 && bytes < PAGE_SIZE; i++)
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
 					  " %08x", le32_to_cpu(inbuf[i].u32[0]));
 
 		netif_info(efx, hw, efx->net_dev, "MCDI RPC REQ:%s\n", buf);
@@ -302,14 +302,14 @@ static void efx_mcdi_read_response_header(struct efx_nic *efx)
 		 */
 		for (i = 0; i < hdr_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr, (i * 4), 4);
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
 					  " %08x", le32_to_cpu(hdr.u32[0]));
 		}
 
 		for (i = 0; i < data_len && bytes < PAGE_SIZE; i++) {
 			efx->type->mcdi_read_response(efx, &hdr,
 					mcdi->resp_hdr_len + (i * 4), 4);
-			bytes += snprintf(buf + bytes, PAGE_SIZE - bytes,
+			bytes += scnprintf(buf + bytes, PAGE_SIZE - bytes,
 					  " %08x", le32_to_cpu(hdr.u32[0]));
 		}
 
@@ -1417,7 +1417,7 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 	}
 
 	ver_words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_OUT_VERSION);
-	offset = snprintf(buf, len, "%u.%u.%u.%u",
+	offset = scnprintf(buf, len, "%u.%u.%u.%u",
 			  le16_to_cpu(ver_words[0]), le16_to_cpu(ver_words[1]),
 			  le16_to_cpu(ver_words[2]), le16_to_cpu(ver_words[3]));
 
@@ -1427,7 +1427,7 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0) {
 		struct efx_ef10_nic_data *nic_data = efx->nic_data;
 
-		offset += snprintf(buf + offset, len - offset, " rx%x tx%x",
+		offset += scnprintf(buf + offset, len - offset, " rx%x tx%x",
 				   nic_data->rx_dpcpu_fw_id,
 				   nic_data->tx_dpcpu_fw_id);
 
-- 
2.16.4

