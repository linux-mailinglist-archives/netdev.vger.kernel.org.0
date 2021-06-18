Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF9E3AC318
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 08:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhFRGJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 02:09:37 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:57214 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232425AbhFRGJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 02:09:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id DA4C63D8F0;
        Thu, 17 Jun 2021 23:07:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com DA4C63D8F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1623996447;
        bh=xTq1+5bLRkyh6MWHFA7DZoD0Z1UQX+nZa6lKOXHGU+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHjBiG4U62FLoFNsARfZGyJDhu9mx5vKJE/T1DhpAohzedyyN9JKoSjE9wODYWBgX
         o6zTDJSWIRafMe6NuTvavYSkAuUARtljEkYU7hcAd5y8/8tsKSvKf+tlrfP4n8qDnO
         NOZIxA/1UjrSgJVXtdlqEwoLL5hsfjbSsKIJJ9I8=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 1/3] bnxt_en: Rediscover PHY capabilities after firmware reset
Date:   Fri, 18 Jun 2021 02:07:25 -0400
Message-Id: <1623996447-28958-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
References: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a missing bnxt_probe_phy() call in bnxt_fw_init_one() to
rediscover the PHY capabilities after a firmware reset.  This can cause
some PHY related functionalities to fail after a firmware reset.  For
example, in multi-host, the ability for any host to configure the PHY
settings may be lost after a firmware reset.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fcc729d52b17..3685db6dc93d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11750,6 +11750,8 @@ static void bnxt_fw_init_one_p3(struct bnxt *bp)
 	bnxt_hwrm_coal_params_qcaps(bp);
 }
 
+static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt);
+
 static int bnxt_fw_init_one(struct bnxt *bp)
 {
 	int rc;
@@ -11764,6 +11766,9 @@ static int bnxt_fw_init_one(struct bnxt *bp)
 		netdev_err(bp->dev, "Firmware init phase 2 failed\n");
 		return rc;
 	}
+	rc = bnxt_probe_phy(bp, false);
+	if (rc)
+		return rc;
 	rc = bnxt_approve_mac(bp, bp->dev->dev_addr, false);
 	if (rc)
 		return rc;
-- 
2.18.1

