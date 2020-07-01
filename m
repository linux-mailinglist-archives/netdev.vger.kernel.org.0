Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A0D210E22
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgGAOz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:55:58 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43456 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730941AbgGAOz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:55:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D4AC8600C0;
        Wed,  1 Jul 2020 14:55:57 +0000 (UTC)
Received: from us4-mdac16-8.ut7.mdlocal (unknown [10.7.65.76])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D3803200A0;
        Wed,  1 Jul 2020 14:55:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 371801C006D;
        Wed,  1 Jul 2020 14:55:57 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DE8B080007A;
        Wed,  1 Jul 2020 14:55:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:55:51 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 14/15] sfc_ef100: NVRAM selftest support code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <4033cb0d-5dee-b369-8dbb-1ad1578ca011@solarflare.com>
Date:   Wed, 1 Jul 2020 15:55:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-6.226100-8.000000-10
X-TMASE-MatchedRID: PNGnErQK3eV09yt1Yp3gn6iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5qq24siXERPcYgPQuqHpFiEGjzBgnFZvQ5KRaXN2yYjHmww+4tkH8hHwv9
        AibJlKnA5ZnFyGLAQwHqZ7YfJvYp/zD8138PYfo6Ev7VboZWYm+HCwRwMNQUWOK4yXNWF4bALxV
        psU9MI5NyDhrL0dj2eb44manJ1+nJjAM4vu3dHIfXG/YkcGRwfI5rZlsanIIWa+dyjmvhrc6PFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRSAHAopEd76vRz6j+v+cepKk3UH1IPKZIm6xNzGXas/iAEN3
        nQXTk+AVwGJ6wzwqPQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.226100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615357-7bTcUgl2V-pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have yet another new scheme for NVRAM, and a corresponding new MCDI.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi.c | 62 +++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 244fb621d17b..6c49740a178e 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1621,6 +1621,35 @@ int efx_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out)
 	return rc;
 }
 
+/* This function finds types using the new NVRAM_PARTITIONS mcdi. */
+static int efx_new_mcdi_nvram_types(struct efx_nic *efx, u32 *number,
+				    u32 *nvram_types)
+{
+	efx_dword_t *outbuf = kzalloc(MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2,
+				      GFP_KERNEL);
+	size_t outlen;
+	int rc;
+
+	if (!outbuf)
+		return -ENOMEM;
+
+	BUILD_BUG_ON(MC_CMD_NVRAM_PARTITIONS_IN_LEN != 0);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_PARTITIONS, NULL, 0,
+			  outbuf, MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2, &outlen);
+	if (rc)
+		goto fail;
+
+	*number = MCDI_DWORD(outbuf, NVRAM_PARTITIONS_OUT_NUM_PARTITIONS);
+
+	memcpy(nvram_types, MCDI_PTR(outbuf, NVRAM_PARTITIONS_OUT_TYPE_ID),
+	       *number * sizeof(u32));
+
+fail:
+	kfree(outbuf);
+	return rc;
+}
+
 int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
 			size_t *size_out, size_t *erase_size_out,
 			bool *protected_out)
@@ -1674,6 +1703,39 @@ static int efx_mcdi_nvram_test(struct efx_nic *efx, unsigned int type)
 	}
 }
 
+/* This function tests nvram partitions using the new mcdi partition lookup scheme */
+int efx_new_mcdi_nvram_test_all(struct efx_nic *efx)
+{
+	u32 *nvram_types = kzalloc(MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2,
+				   GFP_KERNEL);
+	unsigned int number;
+	int rc, i;
+
+	if (!nvram_types)
+		return -ENOMEM;
+
+	rc = efx_new_mcdi_nvram_types(efx, &number, nvram_types);
+	if (rc)
+		goto fail;
+
+	/* Require at least one check */
+	rc = -EAGAIN;
+
+	for (i = 0; i < number; i++) {
+		if (nvram_types[i] == NVRAM_PARTITION_TYPE_PARTITION_MAP ||
+		    nvram_types[i] == NVRAM_PARTITION_TYPE_DYNAMIC_CONFIG)
+			continue;
+
+		rc = efx_mcdi_nvram_test(efx, nvram_types[i]);
+		if (rc)
+			goto fail;
+	}
+
+fail:
+	kfree(nvram_types);
+	return rc;
+}
+
 int efx_mcdi_nvram_test_all(struct efx_nic *efx)
 {
 	u32 nvram_types;
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 10f064f761a5..e053adfe82b0 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -345,6 +345,7 @@ int efx_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out);
 int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
 			size_t *size_out, size_t *erase_size_out,
 			bool *protected_out);
+int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
 int efx_mcdi_nvram_test_all(struct efx_nic *efx);
 int efx_mcdi_handle_assertion(struct efx_nic *efx);
 void efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);

