Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE9220F44D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbgF3MO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:14:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:41486 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732036AbgF3MOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:14:55 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D80B32007A;
        Tue, 30 Jun 2020 12:14:54 +0000 (UTC)
Received: from us4-mdac16-50.at1.mdlocal (unknown [10.110.50.133])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D5794800A3;
        Tue, 30 Jun 2020 12:14:54 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 73767100061;
        Tue, 30 Jun 2020 12:14:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 403B130006E;
        Tue, 30 Jun 2020 12:14:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:14:49 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 12/14] sfc: commonise efx->[rt]xq_entries
 initialisation
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <27c052be-940a-17e6-8508-0165d3c014dd@solarflare.com>
Date:   Tue, 30 Jun 2020 13:14:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-7.277900-8.000000-10
X-TMASE-MatchedRID: HVm0alLuP0TjtwtQtmXE5bsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2VMe
        5Blkpry7rdoLblq9S5ra/g/NGTW3MkFlFlwaEXyhKrDHzH6zmUX54F/2i/DwjRw0HKhKjTfpZeB
        4wkR7kKbz3tSgA3V7vIYF+7GPkV4SKHAKadh0NOWeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0
        ePs7A07SSyFhRNlxkTcBuINMfF1dQTh2keclpFkILS19y7Kkdy+TDyLiXKaWNWXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.277900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519294-9uaD4K31ilqY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 1 -
 drivers/net/ethernet/sfc/efx_common.c | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 41a2c972323e..028d826ab147 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -385,7 +385,6 @@ static int efx_probe_all(struct efx_nic *efx)
 		rc = -EINVAL;
 		goto fail3;
 	}
-	efx->rxq_entries = efx->txq_entries = EFX_DEFAULT_DMAQ_SIZE;
 
 #ifdef CONFIG_SFC_SRIOV
 	rc = efx->type->vswitching_probe(efx);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 251e37bc7048..822e9e147404 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1035,6 +1035,9 @@ int efx_init_struct(struct efx_nic *efx,
 	INIT_WORK(&efx->mac_work, efx_mac_work);
 	init_waitqueue_head(&efx->flush_wq);
 
+	efx->rxq_entries = EFX_DEFAULT_DMAQ_SIZE;
+	efx->txq_entries = EFX_DEFAULT_DMAQ_SIZE;
+
 	efx->mem_bar = UINT_MAX;
 
 	rc = efx_init_channels(efx);

