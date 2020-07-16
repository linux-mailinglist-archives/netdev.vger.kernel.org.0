Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B9222368
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgGPNDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:03:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42696 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728237AbgGPNDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:03:51 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E387960061;
        Thu, 16 Jul 2020 13:03:50 +0000 (UTC)
Received: from us4-mdac16-5.ut7.mdlocal (unknown [10.7.65.73])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E19AD8009E;
        Thu, 16 Jul 2020 13:03:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6DF498005C;
        Thu, 16 Jul 2020 13:03:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 256E548006A;
        Thu, 16 Jul 2020 13:03:50 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 14:03:45 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 13/16] sfc_ef100: actually perform resets
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Message-ID: <f38e4e2d-235c-7fba-8991-6d2e76f73bd7@solarflare.com>
Date:   Thu, 16 Jul 2020 14:03:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25544.003
X-TM-AS-Result: No-4.580800-8.000000-10
X-TMASE-MatchedRID: 6PuENcpAJhNUHLGrNupy0AlpVkdtt3Wu3V4UShoTXadjLp8Cm8vwFwoe
        RRhCZWIBxI0yMICTJDyPQi9XuOWoOHI/MxNRI7UkuoibJpHRrFmi8D/o42y/SlIxScKXZnK0E6+
        pYTgIYFSveSUy9VcQXJGTpe1iiCJq71zr0FZRMbALbigRnpKlKZx+7GyJjhAUYB8qaF6FmElEKX
        nzCy1vIkG+trJq68jeDPRSzWSLNahZ2JDbjtnNXNvQykS2aH2EzRCLzpuLfc0G8hfvifI15UspD
        AoSAGkW7X0NUj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+VfCOKFKuVYGg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.580800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904630-xdeyr-serZ1F
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

