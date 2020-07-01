Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46C210E23
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbgGAO4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:56:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49570 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731343AbgGAO4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:56:17 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D4AA7600CE;
        Wed,  1 Jul 2020 14:56:16 +0000 (UTC)
Received: from us4-mdac16-27.ut7.mdlocal (unknown [10.7.66.59])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C63FF2009B;
        Wed,  1 Jul 2020 14:56:16 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.42])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5254F220081;
        Wed,  1 Jul 2020 14:56:16 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 03D36A4005F;
        Wed,  1 Jul 2020 14:56:16 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:56:11 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 15/15] sfc_ef100: helper function to set default RSS
 table of given size
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <be8ae63e-4822-8983-9df9-10057c62aa23@solarflare.com>
Date:   Wed, 1 Jul 2020 15:56:08 +0100
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
X-TM-AS-Result: No-2.873300-8.000000-10
X-TMASE-MatchedRID: N75eWsF6AwhbbYRuf3nrh7sHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rITvVMSfL26Emoj6x6DaIOXW6DRXsV2c8pD3uYMxd01bcoOyQJh7uOKLqln+jYe7ZhKUX
        RcEsnY+rjJFPDNR1ufmD90UpKqvEIr78SC5iivxw5f9Xw/xqKXXJnzNw42kCxxEHRux+uk8ifEz
        J5hPndGVJZeo8QBQDK4JAPDnTolZN9W3GTvpUpYics8B5GyA0AlgQLrXX3QqqL3KAiAaxhcCzm8
        e0KpPrglJvWitpEfdPZZ2mps4Gk7RoQVhcDKUH1JRIzmbBpwaQgJCm6ypGLZ6Ol5oRXyhFEVlxr
        1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.873300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615376-lpGVMUPUrxrf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 21 +++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_filters.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 283f68264b66..5a74d880b733 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -2276,3 +2276,24 @@ int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 		return 0;
 	return efx_mcdi_filter_rx_push_shared_rss_config(efx, NULL);
 }
+
+int efx_mcdi_push_default_indir_table(struct efx_nic *efx,
+				      unsigned int rss_spread)
+{
+	int rc = 0;
+
+	if (efx->rss_spread == rss_spread)
+		return 0;
+
+	efx->rss_spread = rss_spread;
+	if (!efx->filter_state)
+		return 0;
+
+	efx_mcdi_rx_free_indir_table(efx);
+	if (rss_spread > 1) {
+		efx_set_default_rx_indir_table(efx, &efx->rss_context);
+		rc = efx->type->rx_push_rss_config(efx, false,
+				   efx->rss_context.rx_indir_table, NULL);
+	}
+	return rc;
+}
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index 23f9d08d071d..06426aa9f2f3 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -155,6 +155,8 @@ int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 				   __attribute__ ((unused)),
 				   const u8 *key
 				   __attribute__ ((unused)));
+int efx_mcdi_push_default_indir_table(struct efx_nic *efx,
+				      unsigned int rss_spread);
 int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx);
 int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 					struct efx_rss_context *ctx);
