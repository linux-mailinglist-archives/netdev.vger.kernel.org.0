Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B550E2427A6
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 11:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgHLJdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 05:33:00 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53282 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726755AbgHLJc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 05:32:59 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8E1F820068;
        Wed, 12 Aug 2020 09:32:58 +0000 (UTC)
Received: from us4-mdac16-38.at1.mdlocal (unknown [10.110.51.53])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8D113800A4;
        Wed, 12 Aug 2020 09:32:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 24A4940060;
        Wed, 12 Aug 2020 09:32:58 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D58EA8005C;
        Wed, 12 Aug 2020 09:32:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Aug
 2020 10:32:53 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] sfc: fix ef100 design-param checking
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Guenter Roeck <linux@roeck-us.net>
Message-ID: <311d8274-9c6f-4614-552f-b1d3da64f368@solarflare.com>
Date:   Wed, 12 Aug 2020 10:32:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25598.005
X-TM-AS-Result: No-8.119900-8.000000-10
X-TMASE-MatchedRID: nYkN/oNa446Hvv2Q/gYTGsyttF/1TyphqUdpDBnLMO1axK9TNhutRcZz
        CC0RExuZUWfQB6uxN/vZOO0M1+XC7n9TsvwMa49yiPIR0a1i6heg8867bIwmU72uIcc7lRe4DJj
        E/zycvqSOOPvGaFbq+BqIR3CWJWT8uYmOdMz4AhKolIr4dI9j7+lUxvXGcRIycBqXYDUNCaxTHu
        QZZKa8u63aC25avUua2v4PzRk1tzJSf7xxJkrXKQlpVkdtt3Wub1LDDl05bRso6/BioTjbkKPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRSAHAopEd76voLdQQTMFyraZ7ozskl4v5cZ9os+R5/yY5Tnu
        mu/STsN6/7blo7AixQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.119900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25598.005
X-MDID: 1597224778-TxpHVKFwmhr4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The handling of the RXQ/TXQ size granularity design-params had two
 problems: it had a 64-bit divide that didn't build on 32-bit platforms,
 and it could divide by zero if the NIC supplied 0 as the value of the
 design-param.  Fix both by checking for 0 and for a granularity bigger
 than our min-size; if the granularity <= EFX_MIN_DMAQ_SIZE then it fits
 in 32 bits, so we can cast it to u32 for the divide.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
I've only build-tested this, and then only on 64-bit, since our lab's
 cooling system can't cope with the heatwave and we keep having to shut
 everything down :(

 drivers/net/ethernet/sfc/ef100_nic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 36598d0542ed..206d70f9d95b 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -979,7 +979,8 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		 * EFX_MIN_DMAQ_SIZE is divisible by GRANULARITY.
 		 * This is very unlikely to fail.
 		 */
-		if (EFX_MIN_DMAQ_SIZE % reader->value) {
+		if (!reader->value || reader->value > EFX_MIN_DMAQ_SIZE ||
+		    EFX_MIN_DMAQ_SIZE % (u32)reader->value) {
 			netif_err(efx, probe, efx->net_dev,
 				  "%s size granularity is %llu, can't guarantee safety\n",
 				  reader->type == ESE_EF100_DP_GZ_RXQ_SIZE_GRANULARITY ? "RXQ" : "TXQ",
