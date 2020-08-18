Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15382484FD
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHRMoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:44:08 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35036 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbgHRMnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:43:53 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6D380200A8;
        Tue, 18 Aug 2020 12:43:38 +0000 (UTC)
Received: from us4-mdac16-58.at1.mdlocal (unknown [10.110.50.151])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6B6FA800A7;
        Tue, 18 Aug 2020 12:43:38 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 19AFC100071;
        Tue, 18 Aug 2020 12:43:38 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D63BA140079;
        Tue, 18 Aug 2020 12:43:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 13:43:33 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 1/4] sfc: really check hash is valid before using it
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Message-ID: <c91aa83a-edf1-8faa-2ca7-a8157cb99623@solarflare.com>
Date:   Tue, 18 Aug 2020 13:43:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25610.005
X-TM-AS-Result: No-2.799300-8.000000-10
X-TMASE-MatchedRID: UkY5AdpCN6itZmE9gjMaXbZ2jtVwgmbCSoCG4sefl8RXy6SPHzrw7lCj
        xJS0MG39GtPsII7bpSGkDD5lLhLDN6H2g9syPs888Kg68su2wyFLXPA26IG0hDdlsYL2g/87byq
        cWT4FZRcUyaPFavbVRfQgu+sh66zze/GSmEODdnKeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0
        ePs7A07cKVf7avePdYj15o1AJsS7bNAAi7isA5J9VSjWDXOfgZME3Y3famJazQ4FirKYjZMiOdk
        l8rRCU+BscG9cITe7smK5fGbFhsvM3P306JzlxZfObqGK9JplminaV/dK0aEhK3Vty8oXtk2SsL
        yY4gH4tVyvbTg/runA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.799300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25610.005
X-MDID: 1597754618-bh8D5qeD-m8y
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually hook up the .rx_buf_hash_valid method in EF100's nic_type.

Fixes: 068885434ccb ("sfc: check hash is valid before using it")
Reported-by: Martin Habets <mhabets@solarflare.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 206d70f9d95b..b8a7e9ed7913 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -739,6 +739,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = ef100_rx_write,
 	.rx_packet = __ef100_rx_packet,
+	.rx_buf_hash_valid = ef100_rx_buf_hash_valid,
 	.fini_dmaq = efx_fini_dmaq,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.filter_table_probe = ef100_filter_table_up,
@@ -820,6 +821,7 @@ const struct efx_nic_type ef100_vf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = ef100_rx_write,
 	.rx_packet = __ef100_rx_packet,
+	.rx_buf_hash_valid = ef100_rx_buf_hash_valid,
 	.fini_dmaq = efx_fini_dmaq,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.filter_table_probe = ef100_filter_table_up,

