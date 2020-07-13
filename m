Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457B321D510
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgGMLgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:36:18 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54424 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729043AbgGMLgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:36:18 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8F9DE6008C;
        Mon, 13 Jul 2020 11:36:17 +0000 (UTC)
Received: from us4-mdac16-65.ut7.mdlocal (unknown [10.7.66.64])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8E96B8009B;
        Mon, 13 Jul 2020 11:36:17 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2E2DE280053;
        Mon, 13 Jul 2020 11:36:17 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D8FAD70007C;
        Mon, 13 Jul 2020 11:36:16 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 12:36:12 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 13/16] sfc_ef100: actually perform resets
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Message-ID: <b180e7a9-2f66-ef5d-0de0-831d6284b0d6@solarflare.com>
Date:   Mon, 13 Jul 2020 12:36:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25538.003
X-TM-AS-Result: No-4.580800-8.000000-10
X-TMASE-MatchedRID: 6PuENcpAJhNUHLGrNupy0AlpVkdtt3Wu3V4UShoTXadjLp8Cm8vwFwoe
        RRhCZWIBxI0yMICTJDyPQi9XuOWoOHI/MxNRI7UkuoibJpHRrFmi8D/o42y/SlIxScKXZnK0E6+
        pYTgIYFSveSUy9VcQXJGTpe1iiCJq71zr0FZRMbALbigRnpKlKZx+7GyJjhAUYB8qaF6FmElEKX
        nzCy1vIkG+trJq68jeDPRSzWSLNahZ2JDbjtnNXNvQykS2aH2EzRCLzpuLfc0G8hfvifI15UspD
        AoSAGkW7X0NUj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+VfCOKFKuVYGg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.580800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25538.003
X-MDID: 1594640177-C-hMOIuP2l4c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ef100_reset(), make the MCDI call to do the reset.
Also, do a reset at start-of-day during probe, to put the function in
 a clean state.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index fe7a5c4bc291..f449960e5b02 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -335,6 +335,10 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 		__clear_bit(reset_type, &efx->reset_pending);
 		rc = dev_open(efx->net_dev, NULL);
 	} else if (reset_type == RESET_TYPE_ALL) {
+		rc = efx_mcdi_reset(efx, reset_type);
+		if (rc)
+			return rc;
+
 		netif_device_attach(efx->net_dev);
 
 		rc = dev_open(efx->net_dev, NULL);
@@ -467,6 +471,11 @@ static int ef100_probe_main(struct efx_nic *efx)
 	}
 	if (rc)
 		goto fail;
+	/* Reset (most) configuration for this function */
+	rc = efx_mcdi_reset(efx, RESET_TYPE_ALL);
+	if (rc)
+		goto fail;
+
 	rc = efx_ef100_init_datapath_caps(efx);
 	if (rc < 0)
 		goto fail;

