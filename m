Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36843293ED3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408221AbgJTOfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:35:31 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49942 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731020AbgJTOfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:35:30 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 84F3520168;
        Tue, 20 Oct 2020 14:35:29 +0000 (UTC)
Received: from us4-mdac16-45.at1.mdlocal (unknown [10.110.48.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7364F800D2;
        Tue, 20 Oct 2020 14:35:29 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E04B740081;
        Tue, 20 Oct 2020 14:35:28 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9491A14005A;
        Tue, 20 Oct 2020 14:35:28 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Oct
 2020 15:35:19 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] sfc: move initialisation of efx->filter_sem to
 efx_init_struct()
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Message-ID: <24fad43e-887d-051e-25e3-506f23f63abf@solarflare.com>
Date:   Tue, 20 Oct 2020 15:35:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25736.003
X-TM-AS-Result: No-2.311800-8.000000-10
X-TMASE-MatchedRID: Ll6vM9Ck4lBBZRZcGhF8ocGNvKPnBgOapys9s25Gmbo6Vn8xMTQihXi8
        nIGQFeXxPEoGb8keCDpTvVffeIwvQwUcfW/oedmqnFVnNmvv47uWODD/yzpvdwdkFovAReUoilv
        Ab18i4hODTRo8xmcmTo2nDYlsf+ksLPVNKiCZUVNtawJSSsDgSX0tCKdnhB58vqq8s2MNhPCZMP
        CnTMzfOiq2rl3dzGQ1NhgPeftSrBXhUxVrz8SuFTuaf+OlDslhVdG9MruYqeAy9rLAeKIrd6rii
        IUVji5eqzEv7+9/x+/5XoQ0xrtUjO7RDmnKgNnfbVz7QXEKhl1Dgw2OfwbhLKMa5OkNpiHkifsL
        +6CY4RlXTTnZwS8L+e90JQgW5qyr
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.311800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25736.003
X-MDID: 1603204529-KNovId6pO0Qt
X-PPE-DISP: 1603204529;KNovId6pO0Qt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

efx_probe_filters() has not been called yet when EF100 calls into
 efx_mcdi_filter_table_probe(), for which it wants to take the
 filter_sem.

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 1 +
 drivers/net/ethernet/sfc/rx_common.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 72a3f0e09f52..de797e1ac5a9 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1014,6 +1014,7 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->num_mac_stats = MC_CMD_MAC_NSTATS;
 	BUILD_BUG_ON(MC_CMD_MAC_NSTATS - 1 != MC_CMD_MAC_GENERATION_END);
 	mutex_init(&efx->mac_lock);
+	init_rwsem(&efx->filter_sem);
 #ifdef CONFIG_RFS_ACCEL
 	mutex_init(&efx->rps_mutex);
 	spin_lock_init(&efx->rps_hash_lock);
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 5e29284c89c9..19cf7cac1e6e 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -797,7 +797,6 @@ int efx_probe_filters(struct efx_nic *efx)
 {
 	int rc;
 
-	init_rwsem(&efx->filter_sem);
 	mutex_lock(&efx->mac_lock);
 	down_write(&efx->filter_sem);
 	rc = efx->type->filter_table_probe(efx);
