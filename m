Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E9622234A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgGPNBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:01:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59688 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgGPNBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:01:50 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3511960195;
        Thu, 16 Jul 2020 13:01:50 +0000 (UTC)
Received: from us4-mdac16-68.ut7.mdlocal (unknown [10.7.64.187])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 337EE2009A;
        Thu, 16 Jul 2020 13:01:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 641151C0090;
        Thu, 16 Jul 2020 13:01:49 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1B60194008B;
        Thu, 16 Jul 2020 13:01:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 14:01:44 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 07/16] sfc_ef100: don't call efx_reset_down()/up()
 on EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Message-ID: <82ceb0da-ec14-bcb2-dc5d-8cc0a0fd7586@solarflare.com>
Date:   Thu, 16 Jul 2020 14:01:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25544.003
X-TM-AS-Result: No-1.671700-8.000000-10
X-TMASE-MatchedRID: /2NGPvLZz+MOvl7WFhImCyZm6wdY+F8Keouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5rxcbfNPnIRGVqzqw/UFRAtimHWEC28pk2IrmqDVyayvznN32bY5BWlNiL
        P5F13qP7i8zVgXoAltkWL4rBlm20vjaPj0W1qn0SujVRFkkVsmywupUxjp+fTLAb4r3agiaeU7z
        +jSxjKXSPVhlGEQzY6u1zgoOrHTR7QrpgtxYfKhtc2jG1muaYbaigjD2Yf6h29Fpl1T8GMfpBEc
        rkRxYJ4UjKnO1KVKKwSkbDwum07zqq0MV8nSMBvkLxsYTGf9c0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.671700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904509-PDNKerABjVJn
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We handle everything ourselves in ef100_reset(), rather than relying on
 the generic down/up routines.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 5667694c6514..26b05ec4e712 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -814,14 +814,18 @@ int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
  */
 int efx_reset(struct efx_nic *efx, enum reset_type method)
 {
+	int rc, rc2 = 0;
 	bool disabled;
-	int rc, rc2;
 
 	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
 		   RESET_TYPE(method));
 
 	efx_device_detach_sync(efx);
-	efx_reset_down(efx, method);
+	/* efx_reset_down() grabs locks that prevent recovery on EF100.
+	 * EF100 reset is handled in the efx_nic_type callback below.
+	 */
+	if (efx_nic_rev(efx) != EFX_REV_EF100)
+		efx_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
 	if (rc) {
@@ -849,7 +853,8 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 	disabled = rc ||
 		method == RESET_TYPE_DISABLE ||
 		method == RESET_TYPE_RECOVER_OR_DISABLE;
-	rc2 = efx_reset_up(efx, method, !disabled);
+	if (efx_nic_rev(efx) != EFX_REV_EF100)
+		rc2 = efx_reset_up(efx, method, !disabled);
 	if (rc2) {
 		disabled = true;
 		if (!rc)

