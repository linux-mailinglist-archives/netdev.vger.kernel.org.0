Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291F5233487
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgG3OeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:34:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55844 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729477AbgG3OeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 10:34:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A496560157;
        Thu, 30 Jul 2020 14:34:04 +0000 (UTC)
Received: from us4-mdac16-55.ut7.mdlocal (unknown [10.7.66.26])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A2B412009B;
        Thu, 30 Jul 2020 14:34:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2FFAB22006A;
        Thu, 30 Jul 2020 14:34:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DCA56800060;
        Thu, 30 Jul 2020 14:34:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 15:33:58 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 01/12] sfc_ef100: check firmware version at
 start-of-day
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Message-ID: <a5cd9e75-1784-bef3-72c3-15efebfd08f6@solarflare.com>
Date:   Thu, 30 Jul 2020 15:33:56 +0100
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
X-TM-AS-Result: No-4.241600-8.000000-10
X-TMASE-MatchedRID: HGvy3W1xOqYl1ruS1vtrJUmSRRbSc9s3lS5IbQ8u3ToaV9cxC+J6t8iT
        Wug2C4DNl1M7KT9/aqAnsasxq4/76mJZXQNDzktSGjzBgnFZvQ7+NefZIdSZXEW2O0jPXSPlyKM
        XhR45RlM81ox4QBrGHcf/eH1BJXalEGrGKgXI3I8ovbifIQL7GvngX/aL8PCN/+uCP2dxbP3CNK
        ZBYz4NARXS+gzjJyCYKGOt1f2p0PrMPzXfw9h+jp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTt+gmVy5VdZkn05eyXDxC5z63nBrgz8bymFl419byyyWvSHfKcI5IPgrRBY7MmjU8nbCMa
        P1KjecbZRZn+CljuraOnNRTSeDrlwSq/eMb//Md85uoYr0mmWaKdpX90rRoSErdW3Lyhe2SmzZh
        Wcml82A==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.241600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596119644-L8a8gXrOJeOT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Early in EF100 development there was a different format of event
 descriptor; if the NIC is somehow running the very old firmware
 which will use that format, fail the probe.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 40 ++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 6a00f2a2dc2b..75131bcf4f1a 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -485,6 +485,36 @@ const struct efx_nic_type ef100_pf_nic_type = {
 
 };
 
+static int compare_versions(const char *a, const char *b)
+{
+	int a_major, a_minor, a_point, a_patch;
+	int b_major, b_minor, b_point, b_patch;
+	int a_matched, b_matched;
+
+	a_matched = sscanf(a, "%d.%d.%d.%d", &a_major, &a_minor, &a_point, &a_patch);
+	b_matched = sscanf(b, "%d.%d.%d.%d", &b_major, &b_minor, &b_point, &b_patch);
+
+	if (a_matched == 4 && b_matched != 4)
+		return +1;
+
+	if (a_matched != 4 && b_matched == 4)
+		return -1;
+
+	if (a_matched != 4 && b_matched != 4)
+		return 0;
+
+	if (a_major != b_major)
+		return a_major - b_major;
+
+	if (a_minor != b_minor)
+		return a_minor - b_minor;
+
+	if (a_point != b_point)
+		return a_point - b_point;
+
+	return a_patch - b_patch;
+}
+
 /*	NIC probe and remove
  */
 static int ef100_probe_main(struct efx_nic *efx)
@@ -492,6 +522,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 	unsigned int bar_size = resource_size(&efx->pci_dev->resource[efx->mem_bar]);
 	struct net_device *net_dev = efx->net_dev;
 	struct ef100_nic_data *nic_data;
+	char fw_version[32];
 	int i, rc;
 
 	if (WARN_ON(bar_size == 0))
@@ -562,6 +593,15 @@ static int ef100_probe_main(struct efx_nic *efx)
 		goto fail;
 	efx->port_num = rc;
 
+	efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
+	netif_dbg(efx, drv, efx->net_dev, "Firmware version %s\n", fw_version);
+
+	if (compare_versions(fw_version, "1.1.0.1000") < 0) {
+		netif_info(efx, drv, efx->net_dev, "Firmware uses old event descriptors\n");
+		rc = -EINVAL;
+		goto fail;
+	}
+
 	rc = ef100_phy_probe(efx);
 	if (rc)
 		goto fail;

