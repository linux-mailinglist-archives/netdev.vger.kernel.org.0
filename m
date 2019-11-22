Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E402106419
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbfKVGOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:14:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfKVGOI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:14:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F402070E;
        Fri, 22 Nov 2019 06:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403247;
        bh=JaxSkdQU9drF9NAFcq84ecGj6j1VMqzal0aXjbJtgIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zk+xVB3HI8OVAzq+GMCbvajsPdaImNXqgaLBWVRTHluIKSwIrpxubfzHIgr6Ypzm3
         5OJxYVCeQBkboF1DhV1p4E1QWbbMtM5Hr5Ypo2MvKWjoTIdFa/6Wa/49G2OoPtVaHB
         LvdXJ/VTO3rXbU5TuWbk4KEJ8zzsPjqMfxn2xe1M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Cree <ecree@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 58/68] sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe
Date:   Fri, 22 Nov 2019 01:12:51 -0500
Message-Id: <20191122061301.4947-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 3366463513f544c12c6b88c13da4462ee9e7a1a1 ]

Use a bitmap to keep track of which partition types we've already seen;
 for duplicates, return -EEXIST from efx_ef10_mtd_probe_partition() and
 thus skip adding that partition.
Duplicate partitions occur because of the A/B backup scheme used by newer
 sfc NICs.  Prior to this patch they cause sysfs_warn_dup errors because
 they have the same name, causing us not to expose any MTDs at all.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 063aca17e698b..79a1031c3ef77 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4433,22 +4433,25 @@ static const struct efx_ef10_nvram_type_info efx_ef10_nvram_types[] = {
 	{ NVRAM_PARTITION_TYPE_LICENSE,		   0,    0, "sfc_license" },
 	{ NVRAM_PARTITION_TYPE_PHY_MIN,		   0xff, 0, "sfc_phy_fw" },
 };
+#define EF10_NVRAM_PARTITION_COUNT	ARRAY_SIZE(efx_ef10_nvram_types)
 
 static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 					struct efx_mcdi_mtd_partition *part,
-					unsigned int type)
+					unsigned int type,
+					unsigned long *found)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_METADATA_OUT_LENMAX);
 	const struct efx_ef10_nvram_type_info *info;
 	size_t size, erase_size, outlen;
+	int type_idx = 0;
 	bool protected;
 	int rc;
 
-	for (info = efx_ef10_nvram_types; ; info++) {
-		if (info ==
-		    efx_ef10_nvram_types + ARRAY_SIZE(efx_ef10_nvram_types))
+	for (type_idx = 0; ; type_idx++) {
+		if (type_idx == EF10_NVRAM_PARTITION_COUNT)
 			return -ENODEV;
+		info = efx_ef10_nvram_types + type_idx;
 		if ((type & ~info->type_mask) == info->type)
 			break;
 	}
@@ -4461,6 +4464,13 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 	if (protected)
 		return -ENODEV; /* hide it */
 
+	/* If we've already exposed a partition of this type, hide this
+	 * duplicate.  All operations on MTDs are keyed by the type anyway,
+	 * so we can't act on the duplicate.
+	 */
+	if (__test_and_set_bit(type_idx, found))
+		return -EEXIST;
+
 	part->nvram_type = type;
 
 	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
@@ -4489,6 +4499,7 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 static int efx_ef10_mtd_probe(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX);
+	DECLARE_BITMAP(found, EF10_NVRAM_PARTITION_COUNT);
 	struct efx_mcdi_mtd_partition *parts;
 	size_t outlen, n_parts_total, i, n_parts;
 	unsigned int type;
@@ -4517,11 +4528,13 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 	for (i = 0; i < n_parts_total; i++) {
 		type = MCDI_ARRAY_DWORD(outbuf, NVRAM_PARTITIONS_OUT_TYPE_ID,
 					i);
-		rc = efx_ef10_mtd_probe_partition(efx, &parts[n_parts], type);
-		if (rc == 0)
-			n_parts++;
-		else if (rc != -ENODEV)
+		rc = efx_ef10_mtd_probe_partition(efx, &parts[n_parts], type,
+						  found);
+		if (rc == -EEXIST || rc == -ENODEV)
+			continue;
+		if (rc)
 			goto fail;
+		n_parts++;
 	}
 
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
-- 
2.20.1

