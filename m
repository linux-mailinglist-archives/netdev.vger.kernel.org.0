Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE09C41CD40
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346548AbhI2UO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346475AbhI2UOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 16:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF386128C;
        Wed, 29 Sep 2021 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632946394;
        bh=RyKeFAgpxkweuswyRm0FenBC5z3yO2s3B2E+9+m39cc=;
        h=Date:From:To:Cc:Subject:From;
        b=pqd/LKe2ZUoJjX1ZvG6LVWdxMz9hgN2NeW0WtlK1ww5a8Vt7bcraqObvO1b0t+BR8
         rCYkjl6fWQdY5zjvRgRmlR0D46+YLpZLmG0iGgbUSlwMFobFSEblj3z6ZjCYWN9cHV
         d0Rq065wSLrJRaB1ARxTA6l+sNI4/BXhJvMGCXAfarlWO7UCxe82WtmoQYRuWujBuN
         H+RL5jQSJSKm10jmQV+OnmJN4kgqy7g1QzT39e7zqrJAIdlTY/mfvOhORP6C01N7MG
         +IQCaoB6BG8pVpyYW1q/q1aBm4gJPolL2ACsotSHLJcveUKofZ8vkQoALIjhOTRh3a
         6FlqHCHfyeFXg==
Date:   Wed, 29 Sep 2021 15:17:18 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: sched: Use struct_size() helper in kvmalloc()
Message-ID: <20210929201718.GA342296@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows
that, in the worst scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0c345e43a09a..ecbb10db1111 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -785,7 +785,7 @@ static int get_dist_table(struct Qdisc *sch, struct disttable **tbl,
 	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
-	d = kvmalloc(sizeof(struct disttable) + n * sizeof(s16), GFP_KERNEL);
+	d = kvmalloc(struct_size(d, table, n), GFP_KERNEL);
 	if (!d)
 		return -ENOMEM;
 
-- 
2.27.0

