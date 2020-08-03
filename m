Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5D923AE48
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgHCUi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:38:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59616 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbgHCUi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 16:38:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 871C96008F;
        Mon,  3 Aug 2020 20:38:58 +0000 (UTC)
Received: from us4-mdac16-11.ut7.mdlocal (unknown [10.7.65.208])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 85B162009A;
        Mon,  3 Aug 2020 20:38:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 112131C005F;
        Mon,  3 Aug 2020 20:38:58 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BBD00BC0081;
        Mon,  3 Aug 2020 20:38:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 3 Aug 2020
 21:38:53 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 10/11] sfc_ef100: read pf_index at probe time
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
Message-ID: <97358bdb-b058-0a3e-58a6-8b0d78b1582f@solarflare.com>
Date:   Mon, 3 Aug 2020 21:38:49 +0100
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
X-TM-AS-Result: No-2.022600-8.000000-10
X-TMASE-MatchedRID: pD35TpP7QqL2up/bgDqTK7sHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc4mQHxxqFX9+VGHWGuC3y6xBzS99BLPiYrihJ3Xxt2bAqjxqhyDxmYjiWf
        FSmTuO0bi8zVgXoAltkWL4rBlm20vjaPj0W1qn0SujVRFkkVsm9ejvwm4UrWqZRS1XTSxf84Exp
        3k3Qabn7q6hvNbD+phqvUZ2QdpvkXBdeRSdOilz6GNb+eTJTi/TGzvxJYV1TPLrz3g8s4vX5BEc
        rkRxYJ4UjKnO1KVKKwSkbDwum07zqq0MV8nSMBvkLxsYTGf9c0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.022600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.002
X-MDID: 1596487138-003CWaBwEZsb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need it later, for VF representors.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 4 ++++
 drivers/net/ethernet/sfc/ef100_nic.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 90fc44052abf..10748efbf98e 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1096,6 +1096,10 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
+	rc = efx_get_pf_index(efx, &nic_data->pf_index);
+	if (rc)
+		goto fail;
+
 	rc = efx_ef100_init_datapath_caps(efx);
 	if (rc < 0)
 		goto fail;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 7c2d37490074..4a64c9438493 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -63,6 +63,7 @@ struct ef100_nic_data {
 	u32 datapath_caps;
 	u32 datapath_caps2;
 	u32 datapath_caps3;
+	unsigned int pf_index;
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);

