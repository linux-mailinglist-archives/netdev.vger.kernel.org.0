Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE93213C99
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGCPcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:32:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36284 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgGCPcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:32:51 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DD2AA2006C;
        Fri,  3 Jul 2020 15:32:50 +0000 (UTC)
Received: from us4-mdac16-64.at1.mdlocal (unknown [10.110.50.158])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DB8A96009B;
        Fri,  3 Jul 2020 15:32:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 713DA220064;
        Fri,  3 Jul 2020 15:32:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3AC26140069;
        Fri,  3 Jul 2020 15:32:50 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:32:45 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 06/15] sfc_ef100: don't call efx_reset_down()/up() on
 EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Message-ID: <be1d33ee-4a31-f2d2-d4f8-77380a07dcc9@solarflare.com>
Date:   Fri, 3 Jul 2020 16:32:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-2.547200-8.000000-10
X-TMASE-MatchedRID: m5YRaeAMZa4Ovl7WFhImCyZm6wdY+F8Keouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5qnJ7eS8LcE2bYgup2PqxmgGhRbJzT/dqP1+9bO3CCbk6SIGrjDxszFo8W
        MkQWv6iUD0yuKrQIMCD3Al4zalJpFWBd6ltyXuvvt17WRaOPSwEPD8J69E4Q/DTWUy+N2L0FxcV
        zmbOOssapyFli3cLIq1vQyrPL7RsCJwkaAxSQmIb+e5c0dhykMePWiPm9/kwIxwqle67/WNUAzB
        bitj/RY7aFmrxFux0RN2fIyiQnUdOJqixYeb35sftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.547200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790370-rPEmuJr9XoVF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We handle everything ourselves in ef100_reset(), rather than relying on
 the generic down/up routines.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 5667694c6514..1bccd1f2cfa6 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -821,7 +821,11 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
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

