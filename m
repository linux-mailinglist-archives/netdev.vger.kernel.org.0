Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B76C2F81FC
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbhAORRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:17:25 -0500
Received: from mail-m964.mail.126.com ([123.126.96.4]:55906 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbhAORRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=bWFFo4adEeRjhOoRH4
        Jacj17hKzJ2ydg4soThbYz5qA=; b=WvvnIAmUTeu9pCqhZ47vTHqDCnRwpQ9tZ7
        PTTB+d4L4D+HSPtUsAoxEy2LHew0CDOePzzv7I8EmsgGPMsTZR/1EXDp8geeW30y
        oEBrtK0uBhSacQE3oFXz+lA7u2VDp5KKjg+9ymaXUJFVmSk8b8S6ddvQK4AL9kYL
        iw3d6fy0c=
Received: from localhost.localdomain (unknown [116.162.2.41])
        by smtp9 (Coremail) with SMTP id NeRpCgBndpc_ogFgm_vTQw--.4290S2;
        Fri, 15 Jan 2021 22:10:08 +0800 (CST)
From:   wangyingjie55@126.com
To:     davem@davemloft.net, kuba@kernel.org, vraman@marvell.com,
        skardach@marvell.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v3] octeontx2-af: Fix missing check bugs in rvu_cgx.c
Date:   Fri, 15 Jan 2021 06:10:04 -0800
Message-Id: <1610719804-35230-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NeRpCgBndpc_ogFgm_vTQw--.4290S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFW7XF4xWFg_yoW8Xw4Up3
        y0yryrZrn2ka1xCw4DJa18JrWUta1Dtaykt34UC3s5uFn5WF13XF4DKa1UK3WUCrWrC3y7
        tF1jk393uF1DJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-0edUUUUU=
X-Originating-IP: [116.162.2.41]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiVwEbp1pECd3elgAAso
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

Fixes: 96be2e0da85e ("octeontx2-af: Support for MAC address filters in CGX")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
Reviewed-by: Geetha sowjanya<gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index d298b9357177..6c6b411e78fd 100644
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

