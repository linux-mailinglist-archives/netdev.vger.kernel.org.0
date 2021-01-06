Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CE22EBCCE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbhAFKxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:53:08 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:37614 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbhAFKxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=kac8Op8JKO4gkXnod9
        2DPX6leg0btALZxe/OkgtHHE8=; b=goVI9g/mYj213ySnAQEVPrfEKFAE6WWIS1
        P8R0k5qNYMU+ocgtLr0qHIIpBFV+SM1jYz3jFhw+Rx3Ic+d2ae3z9g4u29adN7y1
        OodG8cozsos/hP6NRnsxSggFEsrabtdhr9MErQ5IhnnjhfdWNHj8vGcM1c6ZRLYB
        yRQthOuFQ=
Received: from localhost.localdomain (unknown [43.250.200.43])
        by smtp10 (Coremail) with SMTP id NuRpCgAn46dvXfVfSxsJjA--.31892S2;
        Wed, 06 Jan 2021 14:49:20 +0800 (CST)
From:   wangyingjie55@126.com
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Date:   Tue,  5 Jan 2021 22:49:17 -0800
Message-Id: <1609915757-4282-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NuRpCgAn46dvXfVfSxsJjA--.31892S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFWrKry5CFg_yoW8Xryxpw
        40y34rZrs2kr4xC3yDJa18G3yjva1DtFWktryUu3s5CFn5uF13XFs8Ka1jk3WUCrWrC3y7
        tF1jkan3CF1DGrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b2FALUUUUU=
X-Originating-IP: [43.250.200.43]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbifhASp1pEB+qgBwAAsP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

Fixes: 85482bb ("af/rvu_cgx: Fix missing check bugs in rvu_cgx.c")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index d298b93..6c6b411 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -469,6 +469,9 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 	int pf = rvu_get_pf(req->hdr.pcifunc);
 	u8 cgx_id, lmac_id;
 
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	cgx_lmac_addr_set(cgx_id, lmac_id, req->mac_addr);
@@ -485,6 +488,9 @@ int rvu_mbox_handler_cgx_mac_addr_get(struct rvu *rvu,
 	int rc = 0, i;
 	u64 cfg;
 
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
 	rsp->hdr.rc = rc;
-- 
2.7.4

