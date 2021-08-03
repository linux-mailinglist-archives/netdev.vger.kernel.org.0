Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0C43DE74C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhHCHiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:38:07 -0400
Received: from out0.migadu.com ([94.23.1.103]:37007 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234261AbhHCHiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 03:38:06 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627976274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zWQprHgFLy2Swuc7XTiEVWHCCdnu54Q8VsmuPdFf8PU=;
        b=Xvt32lVP0qHcWrTinrjt9QtEhP9qjJrjbk03yDjBrBtcfD7PKgMtNmzKgUNSmsvHJuJbnl
        O8vae1jwICWLxqHxS3Y9tqnVBl1y0I2CD9IanfbS85YjQ06376mUqqXDUfc1D97D7A5Jqe
        JRfNtYP6ED6+ehSvqaoZ02Yst/gOC2Q=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: decnet: Fix refcount warning for new dn_fib_info
Date:   Tue,  3 Aug 2021 15:37:39 +0800
Message-Id: <20210803073739.22339-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fib_treeref needs to be set after kzalloc. The old code had a ++ which
led to the confusion when the int was replaced by a refcount_t.

Fixes: 79976892f7ea ("net: convert fib_treeref from int to refcount_t")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/decnet/dn_fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
index 387a7e81dd00..153a5fc1bdde 100644
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -389,7 +389,7 @@ struct dn_fib_info *dn_fib_create_info(const struct rtmsg *r, struct nlattr *att
 		return ofi;
 	}
 
-	refcount_inc(&fi->fib_treeref);
+	refcount_set(&fi->fib_treeref, 1);
 	refcount_set(&fi->fib_clntref, 1);
 	spin_lock(&dn_fib_info_lock);
 	fi->fib_next = dn_fib_info_list;
-- 
2.32.0

