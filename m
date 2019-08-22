Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF59119679B
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgC1QpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 12:45:23 -0400
Received: from mx.sdf.org ([205.166.94.20]:49978 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbgC1Qnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 12:43:41 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SGhOjk028101
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 16:43:24 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SGhN8L003837;
        Sat, 28 Mar 2020 16:43:23 GMT
Message-Id: <202003281643.02SGhN8L003837@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Wed, 21 Aug 2019 20:15:22 -0400
Subject: [RFC PATCH v1 43/50] drivers/isdn: Use get_random_u32()
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to get_random_bytes() into a temporary buffer.

This is not a no-brainer change; get_random_u32() has slightly weaker
security guarantees, but they're fine for applications like these where
the random value is stored in the kernel for as long as it's
valuable.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: isdn4linux@listserv.isdn4linux.de
Cc: netdev@vger.kernel.org
---
 drivers/isdn/mISDN/tei.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 59d28cb19738e..8135e20a667cc 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -404,10 +404,7 @@ dl_unit_data(struct manager *mgr, struct sk_buff *skb)
 static unsigned int
 random_ri(void)
 {
-	u16 x;
-
-	get_random_bytes(&x, sizeof(x));
-	return x;
+	return get_random_u32() & 0xffff;
 }
 
 static struct layer2 *
-- 
2.26.0

