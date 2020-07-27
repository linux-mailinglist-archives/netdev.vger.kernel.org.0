Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E9722EBA8
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgG0MFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:05:08 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58212 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgG0MFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:05:06 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 682EE60060;
        Mon, 27 Jul 2020 12:05:06 +0000 (UTC)
Received: from us4-mdac16-72.ut7.mdlocal (unknown [10.7.64.191])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 663C5200A3;
        Mon, 27 Jul 2020 12:05:06 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4FDC1C0055;
        Mon, 27 Jul 2020 12:05:05 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9D43A940078;
        Mon, 27 Jul 2020 12:05:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 13:05:01 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 13/16] sfc_ef100: actually perform resets
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <a5e95ccc-2899-fe52-c5c0-ea49d51abe28@solarflare.com>
Date:   Mon, 27 Jul 2020 13:04:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-4.580800-8.000000-10
X-TMASE-MatchedRID: 6PuENcpAJhNUHLGrNupy0AlpVkdtt3Wu3V4UShoTXadjLp8Cm8vwFwoe
        RRhCZWIBxI0yMICTJDyPQi9XuOWoOHI/MxNRI7UkuoibJpHRrFmi8D/o42y/SlIxScKXZnK0E6+
        pYTgIYFSveSUy9VcQXJGTpe1iiCJq71zr0FZRMbALbigRnpKlKZx+7GyJjhAULnoF2g/NZYolnE
        HBI0l+X79QBggUWGuAA845vAlR7nfBa9dMXAuKPWphMoiYL3P8MTM6luaFSL5xhHe8czYwQmEvu
        VMBERPc7X0NUj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+VfCOKFKuVYGg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.580800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595851506-Awjq_YUd2Ppz
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
index bb246acca574..5e6a8337a336 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -332,6 +332,10 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 		__clear_bit(reset_type, &efx->reset_pending);
 		rc = dev_open(efx->net_dev, NULL);
 	} else if (reset_type == RESET_TYPE_ALL) {
+		rc = efx_mcdi_reset(efx, reset_type);
+		if (rc)
+			return rc;
+
 		netif_device_attach(efx->net_dev);
 
 		rc = dev_open(efx->net_dev, NULL);
@@ -466,6 +470,11 @@ static int ef100_probe_main(struct efx_nic *efx)
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

