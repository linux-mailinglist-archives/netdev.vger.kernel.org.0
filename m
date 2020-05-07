Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B31C9AD1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgEGTUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgEGTUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 15:20:40 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1730C208D6;
        Thu,  7 May 2020 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588879240;
        bh=ghifpifTV9Rkgth0xg+/OPnqO8C7ujrV3AOGLvxsFjo=;
        h=Date:From:To:Cc:Subject:From;
        b=i3XWUVmdPNza+f4FZYASq/bAHlSB4YDEpjVyWpmF+gGX+ortRqmDygQFiFhc0IuVy
         mB6o448L/xY1bIdgPr0sxczGP0ap7YQ3ys2TVWhhHDrSJak8kyZeoDxX3b4F5ippnh
         ZSEYI5vkNRO+7+xZk2luTe8vk7huQWlyiTdE2KgM=
Date:   Thu, 7 May 2020 14:25:07 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] team: Replace zero-length array with flexible-array
Message-ID: <20200507192507.GA16516@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/linux/if_team.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index ec7e4bd07f82..c9bdccd67ffb 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -67,7 +67,7 @@ struct team_port {
 	u16 queue_id;
 	struct list_head qom_list; /* node in queue override mapping list */
 	struct rcu_head	rcu;
-	long mode_priv[0];
+	long mode_priv[];
 };
 
 static inline struct team_port *team_port_get_rcu(const struct net_device *dev)

