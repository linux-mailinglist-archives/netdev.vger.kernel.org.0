Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7662334A2
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgG3Okw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:40:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53762 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgG3Okw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 10:40:52 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 86EED60056;
        Thu, 30 Jul 2020 14:40:51 +0000 (UTC)
Received: from us4-mdac16-56.ut7.mdlocal (unknown [10.7.64.50])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 79DC88009B;
        Thu, 30 Jul 2020 14:40:51 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E8DA228005F;
        Thu, 30 Jul 2020 14:40:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9807E1C0068;
        Thu, 30 Jul 2020 14:40:50 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 15:40:37 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 11/12] sfc_ef100: read pf_index at probe time
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Message-ID: <33169027-ade5-05a8-94f1-8dab09eb682b@solarflare.com>
Date:   Thu, 30 Jul 2020 15:40:34 +0100
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
X-TM-AS-Result: No-2.022600-8.000000-10
X-TMASE-MatchedRID: pD35TpP7QqL2up/bgDqTK7sHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc4mQHxxqFX9+VGHWGuC3y6xBzS99BLPiYrihJ3Xxt2bAqjxqhyDxmYjiWf
        FSmTuO0bi8zVgXoAltkWL4rBlm20vjaPj0W1qn0SujVRFkkVsm9ejvwm4UrWqZRS1XTSxf84Exp
        3k3Qabn7q6hvNbD+phhx05io/SMa5vu1Dao2GUrOZYlVa7IGAaMjtF0lC3NHH6Fp1qm4L4vZBEc
        rkRxYJ4UjKnO1KVKKwSkbDwum07zqq0MV8nSMBvkLxsYTGf9c0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.022600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596120051-mgHdsksJcM5T
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
index f2eb6ce0760d..48083ae52db1 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1082,6 +1082,10 @@ static int ef100_probe_main(struct efx_nic *efx)
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

