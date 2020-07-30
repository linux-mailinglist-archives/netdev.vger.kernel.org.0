Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52323348B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgG3Oes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:34:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50590 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgG3Oer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 10:34:47 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 09B9260130;
        Thu, 30 Jul 2020 14:34:47 +0000 (UTC)
Received: from us4-mdac16-12.ut7.mdlocal (unknown [10.7.65.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 07041200AC;
        Thu, 30 Jul 2020 14:34:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 85F7D22006D;
        Thu, 30 Jul 2020 14:34:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3D11760007A;
        Thu, 30 Jul 2020 14:34:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 15:34:41 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 02/12] sfc_ef100: fail the probe if NIC uses unsol_ev
 credits
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Message-ID: <96a31c75-7f73-4a64-d0fb-6d3dda14ef23@solarflare.com>
Date:   Thu, 30 Jul 2020 15:34:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25572.005
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
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596119687-kID4Pp3Tw-50
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

