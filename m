Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A382F617500
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiKCD07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiKCD0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C2314D3F;
        Wed,  2 Nov 2022 20:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2555561D18;
        Thu,  3 Nov 2022 03:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04528C433C1;
        Thu,  3 Nov 2022 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667445965;
        bh=ss5XMPEO4DJkaHVmd6WcJ5qHvoIGjaX796w84IJFBq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jbldjuy5aX7uCkVh4sCgzHXdSXnOySGSu4R/wRo1BKS4v16F0SDDnTqZ42AeOmL3F
         hiYN/cuduEtWgtNpb9OTLt3lJEfN76MT9b+hp8b2nQaO703N8oaD0VIrIgib2xDbXP
         ktFU6eGCRgTbNZ2V6Gsorx9ZGvzeBNXVBPG6qHB7izj0shl7w1JogCEpZDbSuQij1J
         qLNqW8fVSvCfIWeBzCW5/x5mmsKo7aX/n2rex33tIXkLZeE72EQ/fsZDhOcpqyCNQ4
         HfKJOpNn7/sGRQWtI7c/VkUYRWtNJ8GpfDDRsr1b+/RmxjnyfJ2xbowLKRdztymtMQ
         p9yYCwcnJBWsw==
Date:   Wed, 2 Nov 2022 20:26:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, 18801353760@163.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <20221102202604.0d316982@kernel.org>
In-Reply-To: <20221031060835.11722-1-yin31149@gmail.com>
References: <20221031060835.11722-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 14:08:35 +0800 Hawkins Jiawei wrote:
> Kernel will uses tcindex_change() to change an existing

s/will//

> traffic-control-indices filter properties. During the
> process of changing, kernel will clears the old

s/will//

> traffic-control-indices filter result, and updates it
> by RCU assigning new traffic-control-indices data.
> 
> Yet the problem is that, kernel will clears the old

s/will//

> traffic-control-indices filter result, without destroying
> its tcf_exts structure, which triggers the above
> memory leak.
> 
> This patch solves it by using tcf_exts_destroy() to
> destroy the tcf_exts structure in old
> traffic-control-indices filter result.
> 

Please provide a Fixes tag to where the problem was introduced 
(or the initial git commit).

> Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
> Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
>  net/sched/cls_tcindex.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 1c9eeb98d826..dc872a794337 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -338,6 +338,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	struct tcf_result cr = {};
>  	int err, balloc = 0;
>  	struct tcf_exts e;
> +#ifdef CONFIG_NET_CLS_ACT
> +	struct tcf_exts old_e = {};
> +#endif

Why all the ifdefs?

>  	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
>  	if (err < 0)
> @@ -479,6 +482,14 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	}
>  
>  	if (old_r && old_r != r) {
> +#ifdef CONFIG_NET_CLS_ACT
> +		/* r->exts is not copied from old_r->exts, and
> +		 * the following code will clears the old_r, so
> +		 * we need to destroy it after updating the tp->root,
> +		 * to avoid memory leak bug.
> +		 */
> +		old_e = old_r->exts;
> +#endif

Can't you localize all the changes to this if block?

Maybe add a function called tcindex_filter_result_reinit()
which will act more appropriately?

>  		err = tcindex_filter_result_init(old_r, cp, net);
>  		if (err < 0) {
>  			kfree(f);
> @@ -510,6 +521,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  		tcf_exts_destroy(&new_filter_result.exts);
>  	}
>  
> +#ifdef CONFIG_NET_CLS_ACT
> +	tcf_exts_destroy(&old_e);
> +#endif
>  	if (oldp)
>  		tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
>  	return 0;
