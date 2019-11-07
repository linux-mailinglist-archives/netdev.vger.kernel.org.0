Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A02F3740
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKGSaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfKGSaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 13:30:04 -0500
Received: from localhost.localdomain (unknown [157.245.11.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC64206DF;
        Thu,  7 Nov 2019 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573151403;
        bh=6+R0SnyD9hijZNj7KMhlvP0o4HhbjTs5lk3TeDAs+jA=;
        h=From:To:Cc:Subject:Date:From;
        b=gutehmYSykPoooEuycwHImjdNxtjgn1ioY1Js05WagnlM6r5YEDqKt3ZLLnWiK6pr
         dDoCynaGrRjR92wu51NUbeyyGPGIdBRhMyISkNJTQYl/pffbBOxNQvuqyFrzwV2zN8
         dT6Lw/XTBnSpPtfTIt145j3fYGebK3cIAPBIeF0A=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     hd@os-cillation.de, mark.tomlinson@alliedtelesis.co.nz,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv4: Fix table id reference in fib_sync_down_addr
Date:   Thu,  7 Nov 2019 18:29:52 +0000
Message-Id: <20191107182952.4352-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hendrik reported routes in the main table using source address are not
removed when the address is removed. The problem is that fib_sync_down_addr
does not account for devices in the default VRF which are associated
with the main table. Fix by updating the table id reference.

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Reported-by: Hendrik Donner <hd@os-cillation.de>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 0913a090b2bf..f1888c683426 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1814,8 +1814,8 @@ int fib_sync_down_addr(struct net_device *dev, __be32 local)
 	int ret = 0;
 	unsigned int hash = fib_laddr_hashfn(local);
 	struct hlist_head *head = &fib_info_laddrhash[hash];
+	int tb_id = l3mdev_fib_table(dev) ? : RT_TABLE_MAIN;
 	struct net *net = dev_net(dev);
-	int tb_id = l3mdev_fib_table(dev);
 	struct fib_info *fi;
 
 	if (!fib_info_laddrhash || local == 0)
-- 
2.21.0

