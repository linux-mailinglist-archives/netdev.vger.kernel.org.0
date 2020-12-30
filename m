Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F562E79FA
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 15:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgL3OeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 09:34:07 -0500
Received: from m15114.mail.126.com ([220.181.15.114]:49877 "EHLO
        m15114.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgL3OeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 09:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=1gchJpU8bfd0BMDKdU
        dClPjrbgLRU4OAMTKosT06I0I=; b=FiHuZYJEuOQmfs+dYJ9qLsV30XuTmkT1oN
        VNT3wwoqrkpfcYQoA4YZuePM09LCUdpgCM6vAWM8l0aYPkC/UutVSoxF+C3sSqDC
        +YRbamqfE1qLmbBGRU3+f5M8bIRiet6KhLZ6ve+gxh0oPi/l/Gw7Y8tuzz4mbt/V
        StEx6pjRY=
Received: from localhost.localdomain (unknown [106.19.102.208])
        by smtp7 (Coremail) with SMTP id DsmowACHjm4uK+xfI5fvMg--.1134S2;
        Wed, 30 Dec 2020 15:24:34 +0800 (CST)
From:   wangyingjie55@126.com
To:     kuba@kernel.org, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v1] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
Date:   Tue, 29 Dec 2020 23:24:26 -0800
Message-Id: <1609313066-5353-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DsmowACHjm4uK+xfI5fvMg--.1134S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFW7Jw47Jwb_yoW8GFyfpw
        40yryrZrs2kw4xCw4DJa18G3yYqa1DtFWkt34Uu3s5uFn5uF13XFs8Ka1UK3WUCrWrC3y7
        tF1Fka93CF1DArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jZa93UUUUU=
X-Originating-IP: [106.19.102.208]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiVxgLp1pECU+JPQAAsP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

In rvu_mbox_handler_cgx_mac_addr_get() and rvu_mbox_handler_cgx_mac_addr_set(),
the msg is expected only from PFs that are mapped to CGX LMACs.
It should be checked before mapping, so we add the is_cgx_config_permitted() in the functions.

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

