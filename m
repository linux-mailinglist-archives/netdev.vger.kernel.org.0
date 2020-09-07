Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701DA25FE65
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgIGQOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:14:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:37302 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730467AbgIGQOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:14:40 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B9BD560061;
        Mon,  7 Sep 2020 16:14:28 +0000 (UTC)
Received: from us4-mdac16-17.ut7.mdlocal (unknown [10.7.65.241])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B748C80094;
        Mon,  7 Sep 2020 16:14:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.176])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4660D280059;
        Mon,  7 Sep 2020 16:14:28 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 01CA668007A;
        Mon,  7 Sep 2020 16:14:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep 2020
 17:14:23 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/6] sfc: don't double-down() filters in
 ef100_reset()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Message-ID: <ef0a8665-39e1-fd8f-32ce-4c597f54a8c8@solarflare.com>
Date:   Mon, 7 Sep 2020 17:14:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25650.007
X-TM-AS-Result: No-6.841500-8.000000-10
X-TMASE-MatchedRID: 5oY9ed+hvriB/JMJRMiHSlVeGWZmxN2MB7lMZ4YsZk+en0qBdy7fjEEG
        k2B6vtWSe+mKeDhtWwcfWekSZjAGESHdfLUqdAhEqJSK+HSPY+/Uk/02d006RQdkFovAReUoaUX
        s6FguVy02dnVybJBziTgexM+PeB3dTj/OlUrKzKyCcy0L3uMdVDFcf92WG8u/TESeGl8TP/aYx8
        Fo24xcvOqjnB98KgqAkZOl7WKIImrvXOvQVlExsAtuKBGekqUpbGVEmIfjf3uPNIyd81KMRzR+f
        e4FD/CyRO+RhtPMFWVkI7TQwxsyI341WoAYNSTaHyGba7ubbf25/gi12MGPC9kA4cM1dvXK+RSM
        1pwmeRE=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-6.841500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25650.007
X-MDID: 1599495268-FXUUDZ_XYpXG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_close(), by way of ef100_net_stop(), already brings down the filter
 table, so there's no need to do it again (which just causes lots of
 WARN_ONs).
Similarly, don't bring it up ourselves, as dev_open() -> ef100_net_open()
 will do it, and will fail if it's already been brought up.

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 19fe86b3b316..9cf5b8f8fab9 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -428,24 +428,12 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 		__clear_bit(reset_type, &efx->reset_pending);
 		rc = dev_open(efx->net_dev, NULL);
 	} else if (reset_type == RESET_TYPE_ALL) {
-		/* A RESET_TYPE_ALL will cause filters to be removed, so we remove filters
-		 * and reprobe after reset to avoid removing filters twice
-		 */
-		down_write(&efx->filter_sem);
-		ef100_filter_table_down(efx);
-		up_write(&efx->filter_sem);
 		rc = efx_mcdi_reset(efx, reset_type);
 		if (rc)
 			return rc;
 
 		netif_device_attach(efx->net_dev);
 
-		down_write(&efx->filter_sem);
-		rc = ef100_filter_table_up(efx);
-		up_write(&efx->filter_sem);
-		if (rc)
-			return rc;
-
 		rc = dev_open(efx->net_dev, NULL);
 	} else {
 		rc = 1;	/* Leave the device closed */

