Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115B23AC31B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 08:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhFRGJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 02:09:45 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:57232 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232781AbhFRGJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 02:09:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 31FCF3D8F2;
        Thu, 17 Jun 2021 23:07:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 31FCF3D8F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1623996448;
        bh=wDPRwxwJrPNm1leww09a5NDpNSRJaIfRTNdHfBQWK6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kluKq94leUaPB3RMH5KUIpY7jtdfvMie6L7AadS/vp6wXyWxEvLF6fOePLR+BsdaL
         314dxDAvUmfLKbnh0A3FYuourVk2ZhCEs1iIpimUTrQ8VTH3v26JDZIifoqLie5602
         cr5HAa3coII0Zonbi8nAAzxk7Vi0KSWXGO7uFHGc=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 3/3] bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path
Date:   Fri, 18 Jun 2021 02:07:27 -0400
Message-Id: <1623996447-28958-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
References: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

bnxt_ethtool_init() may have allocated some memory and we need to
call bnxt_ethtool_free() to properly unwind if bnxt_init_one()
fails.

Fixes: 7c3809181468 ("bnxt_en: Refactor bnxt_init_one() and turn on TPA support on 57500 chips.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c913cb1f2a72..aef3fccc27a9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13160,6 +13160,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
+	bnxt_ethtool_free(bp);
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
-- 
2.18.1

