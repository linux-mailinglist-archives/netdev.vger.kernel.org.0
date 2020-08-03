Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A89223AE3F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgHCUgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:36:53 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38678 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728005AbgHCUgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:36:53 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2408460072;
        Mon,  3 Aug 2020 20:36:53 +0000 (UTC)
Received: from us4-mdac16-45.ut7.mdlocal (unknown [10.7.64.27])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 221B22009A;
        Mon,  3 Aug 2020 20:36:53 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B41D71C0059;
        Mon,  3 Aug 2020 20:36:52 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6A2A3B4005B;
        Mon,  3 Aug 2020 20:36:52 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 21:36:47 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 07/11] sfc_ef100: plumb in fini_dmaq
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Message-ID: <e4d4151a-c19c-f6bd-e3cc-451cbb006553@solarflare.com>
Date:   Mon, 3 Aug 2020 21:36:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25582.002
X-TM-AS-Result: No-1.026700-8.000000-10
X-TMASE-MatchedRID: K3RCjmPu4DbcQUtYchmLP2XaK3KHx/xpeouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5ruFC9g00HQc3FnJN0+hJldx5sgyUhLCNswA8NfeYPFBi2QO02vY1BNo8W
        MkQWv6iUD0yuKrQIMCCAtDqHg/4Qm0C1sQRfQzEHEQdG7H66TyJ8TMnmE+d0ZNcsyxcdDlXNTX/
        qgGxvQImUkdz9qc70etr5eSN+REiwJXR5sbLyHrqr+3uDgj71vBzJJEo9UaGjvkzxgsoCJrgEqM
        xDEb589GhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtno6XmhFfKEUTDyDYcE1wXmQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.026700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.002
X-MDID: 1596487013-xjDE4nKq3Lhx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bring down the TX and RX queues at ifdown, so that we can then fini the
 EVQs (otherwise the MC would return EBUSY because they're still in use).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index bb753856d88f..1953e16b2b96 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -528,6 +528,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = ef100_rx_write,
 	.rx_packet = __ef100_rx_packet,
+	.fini_dmaq = efx_fini_dmaq,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.filter_table_probe = ef100_filter_table_up,
 	.filter_table_restore = efx_mcdi_filter_table_restore,

