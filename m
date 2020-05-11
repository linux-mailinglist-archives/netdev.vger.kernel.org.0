Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9D31CD9DF
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgEKM36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:29:58 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59278 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729022AbgEKM35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:29:57 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 173F26007B;
        Mon, 11 May 2020 12:29:57 +0000 (UTC)
Received: from us4-mdac16-42.ut7.mdlocal (unknown [10.7.64.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1610F2009A;
        Mon, 11 May 2020 12:29:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 88EA61C0055;
        Mon, 11 May 2020 12:29:56 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 37BD780079;
        Mon, 11 May 2020 12:29:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:29:49 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 7/8] sfc: make filter table probe caller responsible
 for adding VLANs
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <13c2c7e5-9989-237d-3ca6-fbc16cdadca4@solarflare.com>
Date:   Mon, 11 May 2020 13:29:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-1.679600-8.000000-10
X-TMASE-MatchedRID: K1T06JdS/ECfP0bGoIxVn1b0VO9AmFFdNV9S7O+u3KazU0R+5DbDbMiT
        Wug2C4DNl1M7KT9/aqA65JDztUKj+SHhSBQfglfsA9lly13c/gHYuVu0X/rOkAH6Rn3/TmOQF+j
        AV5A5r0NbdScq6YVMbuD1s559rHmydpvo/nKASz5tawJSSsDgSaeRyy08vvizXEqzvealB56jxY
        yRBa/qJQPTK4qtAgwIPcCXjNqUmkVYF3qW3Je6+2eURATc+6DV/KfnZZqAvSrHf6LrmLvmXfUB/
        5ydiXBL8f1CxEQQi2QHLHxTLrhUfmAA9s9qHiT580phQtnye4ZIi8tpVsTteTHCqV7rv9Y1QDMF
        uK2P9FjtoWavEW7HRE3Z8jKJCdR04mqLFh5vfmx+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.679600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200197-AQb1yhK9Xyp4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By making the caller of efx_mcdi_filter_table_probe() loop over the
 vlan_list calling efx_mcdi_filter_add_vlan(), instead of doing it in
 efx_mcdi_filter_table_probe(), the latter avoids looking in ef10-
 specific nic_data.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 10 ++++++++++
 drivers/net/ethernet/sfc/mcdi_filters.c | 12 ------------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 0779dda7d29f..d7d2edc4d81a 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2447,6 +2447,7 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	int rc = efx_ef10_probe_multicast_chaining(efx);
+	struct efx_mcdi_filter_vlan *vlan;
 
 	if (rc)
 		return rc;
@@ -2455,7 +2456,16 @@ static int efx_ef10_filter_table_probe(struct efx_nic *efx)
 	if (rc)
 		return rc;
 
+	list_for_each_entry(vlan, &nic_data->vlan_list, list) {
+		rc = efx_mcdi_filter_add_vlan(efx, vlan->vid);
+		if (rc)
+			goto fail_add_vlan;
+	}
 	return 0;
+
+fail_add_vlan:
+	efx_mcdi_filter_table_remove(efx);
+	return rc;
 }
 
 /* This creates an entry in the RX descriptor queue */
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index e99b3149c4ae..88de95a8c08c 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1285,10 +1285,8 @@ efx_mcdi_filter_table_probe_matches(struct efx_nic *efx,
 
 int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct net_device *net_dev = efx->net_dev;
 	struct efx_mcdi_filter_table *table;
-	struct efx_mcdi_filter_vlan *vlan;
 	int rc;
 
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
@@ -1337,17 +1335,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 
 	efx->filter_state = table;
 
-	list_for_each_entry(vlan, &nic_data->vlan_list, list) {
-		rc = efx_mcdi_filter_add_vlan(efx, vlan->vid);
-		if (rc)
-			goto fail_add_vlan;
-	}
-
 	return 0;
-
-fail_add_vlan:
-	efx_mcdi_filter_cleanup_vlans(efx);
-	efx->filter_state = NULL;
 fail:
 	kfree(table);
 	return rc;

