Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CACA234659
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgGaM61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:58:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37716 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728047AbgGaM60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:58:26 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 13DD2200A7;
        Fri, 31 Jul 2020 12:58:26 +0000 (UTC)
Received: from us4-mdac16-54.at1.mdlocal (unknown [10.110.50.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 12160800A9;
        Fri, 31 Jul 2020 12:58:26 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8D21C40071;
        Fri, 31 Jul 2020 12:58:25 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 52731980067;
        Fri, 31 Jul 2020 12:58:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 31 Jul
 2020 13:58:20 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 02/11] sfc_ef100: fail the probe if NIC uses
 unsol_ev credits
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Message-ID: <aaf74922-6a26-1e2b-17e1-4ca91f12f6b6@solarflare.com>
Date:   Fri, 31 Jul 2020 13:58:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25574.002
X-TM-AS-Result: No-0.606800-8.000000-10
X-TMASE-MatchedRID: EFPczIV9tKZp/zLbvfZFcgnrFN4j4jQseouvej40T4jg91xayX4L8xMn
        vir+JcmKSBikKFCcMRT6wmhTzhzfaA6gJpgNlY65/ccgt/EtX/0Ea8g1x8eqF8AkyHiYDAQbRph
        daShSOy2ZVDMg0+EjQG/wGiT7VEgKBRx9b+h52ao/ApMPW/xhXkyQ5fRSh265VWQnHKxp38i58j
        tXvakYs2N0QIsgYVNZlxnSJwunsOpNfs8n85Te8oMbH85DUZXy3QfwsVk0UbsIoUKaF27lxZ9+O
        7OKWZRiRgIdG7+dqviRh4BnCzxrLp0ZfIQ7mdiIsxcq7tI0164Ay6Ks/pNrLkIIM5/rv/e4J1kF
        RdkdemqfCOQwlijpzFrMCKBXF1d6I2VNggMWJCP4LggrmsRgvTwNB+BE7Pnlnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.606800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25574.002
X-MDID: 1596200306-f9xxSesQ7eiI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the future, EF100 is planned to have a credit-based scheme for
 handling unsolicited events, which drivers will need to use in order
 to function correctly.  However, current EF100 hardware does not yet
 generate unsolicited events and the credit scheme has not yet been
 implemented in firmware.  To prevent compatibility problems later if
 the current driver is used with future firmware which does implement
 it, we check for the corresponding capability flag (which that
 future firmware will set), and if found, we refuse to probe.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 75131bcf4f1a..c2bec2bdbc1f 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -602,6 +602,12 @@ static int ef100_probe_main(struct efx_nic *efx)
 		goto fail;
 	}
 
+	if (efx_has_cap(efx, UNSOL_EV_CREDIT_SUPPORTED)) {
+		netif_info(efx, drv, efx->net_dev, "Firmware uses unsolicited-event credits\n");
+		rc = -EINVAL;
+		goto fail;
+	}
+
 	rc = ef100_phy_probe(efx);
 	if (rc)
 		goto fail;

