Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D3932ED1D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhCEO3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:29:24 -0500
Received: from m12-18.163.com ([220.181.12.18]:59793 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhCEO3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 09:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KzhyB
        nsVYnUhSOfd6PhuhP5B+5Mmhp9jN22Vts2dIoY=; b=i5OeG022sIcyGrnl/RZuL
        H0nHNHJY95dX0DTwVUO07Ur1TePg45EFfzRmEhqIN8ZEW4wsomd7+yvWOOXtt/Ej
        IXrTlhFec9RANur2fWN+I9Sl0Y6w4o4BfAuhhklpLHKOu6Df5IwzkNfuMl3wjXKy
        x+ocKuvhmFVugFpJsEkBuY=
Received: from yangjunlin.ccdomain.com (unknown [119.137.55.151])
        by smtp14 (Coremail) with SMTP id EsCowADn8hnAP0JgTzXQXA--.15144S2;
        Fri, 05 Mar 2021 22:27:13 +0800 (CST)
From:   angkery <angkery@163.com>
To:     leoyang.li@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Junlin Yang <yangjunlin@yulong.com>
Subject: [PATCH] ethernet: ucc_geth: Use kmemdup instead of kmalloc and memcpy
Date:   Fri,  5 Mar 2021 22:27:11 +0800
Message-Id: <20210305142711.3022-1-angkery@163.com>
X-Mailer: git-send-email 2.24.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowADn8hnAP0JgTzXQXA--.15144S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF1DGFyDKrW5GF4DGFyfJFb_yoWDAFcEkr
        WfZrWYgr4jgFn2vw4a9w47Z340k3WkXrn5X3WSgFW5Ar9rZr15Wrs7Zr1fJwnxWF4I9FyD
        Ar1xt34xA348tjkaLaAFLSUrUUUU0b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn3PEDUUUUU==
X-Originating-IP: [119.137.55.151]
X-CM-SenderInfo: 5dqjyvlu16il2tof0z/xtbBFAFMI1aD+lu31AAAst
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junlin Yang <yangjunlin@yulong.com>

Fixes coccicheck warnings:
./drivers/net/ethernet/freescale/ucc_geth.c:3594:11-18:
WARNING opportunity for kmemdup

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index ef4e2fe..2c079ad 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3591,10 +3591,9 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
 
-	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
+	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info), GFP_KERNEL);
 	if (ug_info == NULL)
 		return -ENOMEM;
-	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
-- 
1.9.1


