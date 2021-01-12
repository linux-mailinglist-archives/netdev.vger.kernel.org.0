Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2012F2B04
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbhALJRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:17:03 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:35878 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389835AbhALJQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:16:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=j7CTXn0CSO6Io9Hyy6
        wM1LDDSYoCM52vgjrRjpTaAAQ=; b=lx0ykLw1NxiisFecRzfnxRTbCRWs16oxPY
        IjRkkWOo4iar+L93cTARUW3iCkOEMAahQG2frT6eKTuji4LDruF42yKB8p/FXjSw
        099tvAmOcOiXfZPVPMWsjpeU8uK4pf8Z7wqTPo/bbRC5rHe+VwBWv/M0Hu+IViWL
        1kJubs9fY=
Received: from localhost.localdomain (unknown [116.162.2.182])
        by smtp10 (Coremail) with SMTP id NuRpCgBXhLzuBP1fOSTWjA--.6710S2;
        Tue, 12 Jan 2021 10:09:52 +0800 (CST)
From:   wangyingjie55@126.com
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Date:   Mon, 11 Jan 2021 18:09:49 -0800
Message-Id: <1610417389-9051-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NuRpCgBXhLzuBP1fOSTWjA--.6710S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFWrKry5CFg_yoW8XF1Upw
        40y34fZrs7Cw4xC3yDJa18GrWjva1DtFWkt34Uu3s5uFn5uF13XFs8Ka1jk3WUurZ5G3y7
        tF1jkws3CF1DCrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b7eOJUUUUU=
X-Originating-IP: [116.162.2.182]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiJRAYp13WF9BFigAAsJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

In rvu_mbox_handler_cgx_mac_addr_get()
and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping,
so we add the is_cgx_config_permitted() in the functions.

Fixes: 289e20bc1ab5 ("af/rvu_cgx: Fix missing check bugs in rvu_cgx.c")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
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

