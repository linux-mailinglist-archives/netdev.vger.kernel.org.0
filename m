Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1947BE61
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 11:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhLUKru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 05:47:50 -0500
Received: from relay036.a.hostedemail.com ([64.99.140.36]:13133 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230089AbhLUKrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 05:47:49 -0500
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id BE3F320C16;
        Tue, 21 Dec 2021 10:47:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id AACBC60016;
        Tue, 21 Dec 2021 10:47:43 +0000 (UTC)
Message-ID: <3f89cfece748d661cc0dc32b29704a3c0fa17fe4.camel@perches.com>
Subject: Re: [PATCH -next] net/sched: use min() macro instead of doing it
 manually
From:   Joe Perches <joe@perches.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
Date:   Tue, 21 Dec 2021 02:47:44 -0800
In-Reply-To: <164008201003.19926.3019516223695943322.git-patchwork-notify@kernel.org>
References: <20211221011455.10163-1-yang.lee@linux.alibaba.com>
         <164008201003.19926.3019516223695943322.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i4qetnwc3jkcpp1wzyjjdbkwiy1bhoxh
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: AACBC60016
X-Spam-Status: No, score=-3.38
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19PyI4ue8fD55pNeJGQd5g2Br5l0PF3sps=
X-HE-Tag: 1640083663-484633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 10:20 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Tue, 21 Dec 2021 09:14:55 +0800 you wrote:
> > Fix following coccicheck warnings:
> > ./net/sched/cls_api.c:3333:17-18: WARNING opportunity for min()
> > ./net/sched/cls_api.c:3389:17-18: WARNING opportunity for min()
> > ./net/sched/cls_api.c:3427:17-18: WARNING opportunity for min()
> > 
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > 
> > [...]
> 
> Here is the summary with links:
>   - [-next] net/sched: use min() macro instead of doing it manually
>     https://git.kernel.org/netdev/net-next/c/c48c94b0ab75
> 
> You are awesome, thank you!

The patch contained instances like:

---
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
[]
@@ -3333,7 +3333,7 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
 	up_read(&block->cb_lock);
 	if (take_rtnl)
 		rtnl_unlock();
-	return ok_count < 0 ? ok_count : 0;
+	return min(ok_count, 0);
 }
---

I think all of these min uses are somewhat obfuscating and not the
typically used kernel pattern.

If count is negative, it's an error return.

I believe the code would be clearer and more typical if written as:

	if (ok_count < 0)
		return ok_count;

	return 0;
}

The compiler should produce the same object code.


