Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0286821D508
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgGMLdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:33:43 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46254 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728950AbgGMLdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:33:42 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3655C60075;
        Mon, 13 Jul 2020 11:33:42 +0000 (UTC)
Received: from us4-mdac16-73.ut7.mdlocal (unknown [10.7.64.192])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 34B138009B;
        Mon, 13 Jul 2020 11:33:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.176])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 93CC1280054;
        Mon, 13 Jul 2020 11:33:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4ABC5680073;
        Mon, 13 Jul 2020 11:33:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 12:33:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 07/16] sfc_ef100: don't call efx_reset_down()/up()
 on EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Message-ID: <abe855ac-6737-235a-f57e-7828aebf6198@solarflare.com>
Date:   Mon, 13 Jul 2020 12:33:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25538.003
X-TM-AS-Result: No-1.671700-8.000000-10
X-TMASE-MatchedRID: /2NGPvLZz+MOvl7WFhImCyZm6wdY+F8Keouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5rxcbfNPnIRGVqzqw/UFRAtimHWEC28pk2IrmqDVyayvznN32bY5BWlNiL
        P5F13qP7i8zVgXoAltkWL4rBlm20vjaPj0W1qn0SujVRFkkVsmywupUxjp+fTLAb4r3agiaeU7z
        +jSxjKXSPVhlGEQzY6u1zgoOrHTR7QrpgtxYfKhtc2jG1muaYbaigjD2Yf6h29Fpl1T8GMfpBEc
        rkRxYJ4UjKnO1KVKKwSkbDwum07zqq0MV8nSMBvkLxsYTGf9c0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.671700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25538.003
X-MDID: 1594640022-Bjqk5ZQtRFG3
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

