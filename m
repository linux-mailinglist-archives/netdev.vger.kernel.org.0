Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361292F825F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbhAORat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:30:49 -0500
Received: from mail-m964.mail.126.com ([123.126.96.4]:45598 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbhAORas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=NkKcJLt4ThG3LLnSMb
        RcwfL6SMK7zMcmCaQHYrdOndM=; b=gMD5dJfe28my/ziflxyrRXjJtWB+DKX36G
        pxjw2YL7INLEb7QGQzQcHD2JkFDdIp+VRk+izdtmjhT2bLGQFFluYdLxGm8L/16c
        LJRnqN6EtNAVT9WdNvPm6fNib8ObunHRC5KYIWc8rpeWHj2Qzpm59y8qqF9igyo5
        2bzSzd6jU=
Received: from localhost.localdomain (unknown [116.162.2.41])
        by smtp9 (Coremail) with SMTP id NeRpCgAHeHoSmAFgtpvSQw--.4294S2;
        Fri, 15 Jan 2021 21:26:44 +0800 (CST)
From:   wangyingjie55@126.com
To:     davem@davemloft.net, kuba@kernel.org, vraman@marvell.com,
        skardach@marvell.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yingjie Wang <wangyingjie55@126.com>
Subject: [PATCH v3] octeontx2-af: Fix missing check bugs in rvu_cgx.c
Date:   Fri, 15 Jan 2021 05:26:23 -0800
Message-Id: <1610717183-34425-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NeRpCgAHeHoSmAFgtpvSQw--.4294S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw13Cr4xJryDtFW7XF4xWFg_yoW8Zryfp3
        yvyryfCr1kGF4xCw4kJay8ZrWYga1Dta9Fg34UZas5uF1kGF1aqF1DKa1Yk3WUCrW8C3y7
        tF1akw4furn5GFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j21v3UUUUU=
X-Originating-IP: [116.162.2.41]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiKRUbp1pECc849AAAsU
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
 net/ipv4/igmp.c                                     | 3 +++
 2 files changed, 9 insertions(+)

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
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7b272bbed2b4..1b6f91271cfd 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2248,6 +2248,9 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 	u32 ifindex;
 	int ret = -EADDRNOTAVAIL;
 
+	if (!ipv4_is_multicast(group))
+		return -EINVAL;
+
 	ASSERT_RTNL();
 
 	in_dev = ip_mc_find_dev(net, imr);
-- 
2.7.4

