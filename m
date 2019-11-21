Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1971058D2
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKURwW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 12:52:22 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40936 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfKURwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:52:21 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3976380094;
        Thu, 21 Nov 2019 17:52:20 +0000 (UTC)
Received: from mh-desktop.uk.solarflarecom.com (10.17.20.62) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 21 Nov 2019 17:52:16 +0000
Subject: [PATCH net] sfc: Only cancel the PPS workqueue if it exists
From:   Martin Habets <mhabets@solarflare.com>
To:     <davem@davemloft.net>, <linux-net-drivers@solarflare.com>
CC:     <netdev@vger.kernel.org>
Date:   Thu, 21 Nov 2019 17:52:15 +0000
Message-ID: <157435873481.1746063.7779522257910378266.stgit@mh-desktop.uk.solarflarecom.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25056.003
X-TM-AS-Result: No-3.282600-8.000000-10
X-TMASE-MatchedRID: tcTaF3INbPhMi6dAAjypohouoVvF2i0ZNV9S7O+u3KZjLp8Cm8vwFwoe
        RRhCZWIBI5Skl4cZDuybHAuQ1dUnuWJZXQNDzktSEhGH3CRdKUXxuhkRWK22GFAysP7gVGBabsR
        ChooNyl+jJuOOJcplEaLbzE92hJygEpkRdiT/iF6rm7DrUlmNkF+24nCsUSFNZiFQvkZhFu1q8/
        xv2Um1avoLR4+zsDTttrrTuahHzlGAebHfFEfxVqQc+4nD+W8JtKheR+9HkH78bmlCAKkscV+p9
        MCBG8FfJthbzeHwkmXlK8Z1XyQs2gsLr8bZ0c8qI4g9U3batJF8vVzzre9mnMW42NJBAYg7O1Er
        at895EGsG1nrQlbYWUuFvzEYSdV+
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.282600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25056.003
X-MDID: 1574358740-GmMyW50GUpnF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The workqueue only exists for the primary PF. For other functions
we hit a WARN_ON in kernel/workqueue.c.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Martin Habets <mhabets@solarflare.com>
---
 drivers/net/ethernet/sfc/ptp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 02ed6d1b716c..af15a737c675 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1531,7 +1531,8 @@ void efx_ptp_remove(struct efx_nic *efx)
 	(void)efx_ptp_disable(efx);
 
 	cancel_work_sync(&efx->ptp_data->work);
-	cancel_work_sync(&efx->ptp_data->pps_work);
+	if (efx->ptp_data->pps_workwq)
+		cancel_work_sync(&efx->ptp_data->pps_work);
 
 	skb_queue_purge(&efx->ptp_data->rxq);
 	skb_queue_purge(&efx->ptp_data->txq);


