Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CE22F5C89
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbhANIiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:38:24 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:43298 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbhANIiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 03:38:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=NgBPPWMMzqmbqXH2qx
        haBHh/fidZtGOdFI9NeFL9S0Q=; b=LQKYFKncfElZm4gJCWeXZsg2qdQxTp4kDO
        xliYuIqImj7k3c5nnjgNekIrWC8HwVG++p5nVihz/BSzwY9qE5rMqSJP2hIbYcDS
        MCY5aOG+tTJ5ekS7DDu+2aE7NMRFNKJiEhV8o7MLhwarh8kLFqzsoUWApvv5oaKL
        JoYB+ErHo=
Received: from localhost.localdomain (unknown [119.39.248.55])
        by smtp10 (Coremail) with SMTP id NuRpCgAXHSES1_9fOGwyjQ--.4590S2;
        Thu, 14 Jan 2021 13:30:59 +0800 (CST)
From:   wangyingjie55@126.com
To:     davem@davemloft.net, kuba@kernel.org, vraman@marvell.com,
        skardach@marvell.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v3] octeontx2-af: Fix missing check bugs in rvu_cgx.c
Date:   Wed, 13 Jan 2021 21:30:40 -0800
Message-Id: <1610602240-23404-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NuRpCgAXHSES1_9fOGwyjQ--.4590S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFW7XF4xWFg_yoW8XF17p3
        y0yryfZrs2ka1xCw4DJa18J3yjya1Dtaykt34Uu3s5uFn5uF13XF4DKa15K3WUCrWrC3y7
        tF1jkws3uF1DJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jcuciUUUUU=
X-Originating-IP: [119.39.248.55]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbi7hMap1tC5mKhSwAAs3
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

