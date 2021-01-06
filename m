Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E671E2EBC3D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAFKTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:19:08 -0500
Received: from mail-m964.mail.126.com ([123.126.96.4]:50106 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAFKTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:19:08 -0500
X-Greylist: delayed 9001 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 05:19:07 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=OF9POBaPY3+x5j8IpO
        riCUUknBWvdWjdtwrGHdeDPzw=; b=fMKpHVWnSwjUy8Agok67ZkC/v7LOz9QHzJ
        UQm8KVDB1WkSHRtpphruLy3Z8QJqO8yk6cZAAEPMBZ4AZGUA50DlItSkiv71YZkV
        wYfBIrour5BtNyMrEN3ATAm5KE/UU05QOm5ZLWMWKjG1k7ZYKomeKDPTllqxS/61
        0ymC8fOLo=
Received: from localhost.localdomain (unknown [43.250.200.43])
        by smtp9 (Coremail) with SMTP id NeRpCgCnwXTxP_VfeZZjQg--.48208S2;
        Wed, 06 Jan 2021 12:43:31 +0800 (CST)
From:   wangyingjie55@126.com
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Date:   Tue,  5 Jan 2021 20:43:19 -0800
Message-Id: <1609908199-3690-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NeRpCgCnwXTxP_VfeZZjQg--.48208S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFW7Jw47Jwb_yoW8GFyfpw
        40yryrZrs2kw4xCw4DJa18G3yYqa1DtFWkt34Uu3s5uFn5uF13XFs8Ka1UK3WUCrWrC3y7
        tF1Fka93CF1DArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bwE__UUUUU=
X-Originating-IP: [43.250.200.43]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiHBMSp1pEB+ifvQAAsp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

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

