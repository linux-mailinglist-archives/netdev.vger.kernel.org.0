Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03535629FD5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiKORCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiKORCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:02:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A87275E3;
        Tue, 15 Nov 2022 09:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29348B819BA;
        Tue, 15 Nov 2022 17:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E0DC433C1;
        Tue, 15 Nov 2022 17:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668531758;
        bh=KABuRlXLh25sOol2t/UpXXI9wSIMYxFYsyTmlHopYp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qgtqPtdU9Hfq4ShGXnzpTVVDB72e/1/mX/bew2o7ePx7kkl/KWaX76KjMu2RNIuhz
         tWFVJ7nP48Rs1qwGkVJgNSE5g5AzaA1/xtjRKUyomkvDIVwLy6OLJOnACN9wajXEXE
         8dAeGF1mDP3CKp+uCzB9SFAPEeGLX9dRSiW4qnxy8KBdAPq7+8Zd/DY5QKu/IE7myu
         75jyR7Hp8csjUYPu1h3e5jJ8iI8AzonFAMmOZgGqOwj3vTN/oZzlAIkwvbOH6PjbKX
         gAHDKuPmWE18ilTd6WyzPi04C9nwP6uDZ25f/LOeKe+sU1yMJdBTKewLiueqCjBdBQ
         40F4mGZpYNt7g==
Date:   Tue, 15 Nov 2022 09:02:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, 18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <20221115090237.5d5988bb@kernel.org>
In-Reply-To: <20221113170507.8205-1-yin31149@gmail.com>
References: <20221113170507.8205-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 01:05:08 +0800 Hawkins Jiawei wrote:
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 1c9eeb98d826..d2fac9559d3e 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -338,6 +338,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	struct tcf_result cr = {};
>  	int err, balloc = 0;
>  	struct tcf_exts e;
> +	struct tcf_exts old_e = {};

This is not a valid way of initializing a structure.
tcf_exts_init() is supposed to be called.
If we add a list member to that structure this code will break, again.

>  	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
>  	if (err < 0)
> @@ -479,6 +480,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	}
>  
>  	if (old_r && old_r != r) {
> +		old_e = old_r->exts;
>  		err = tcindex_filter_result_init(old_r, cp, net);
>  		if (err < 0) {
>  			kfree(f);
> @@ -510,6 +512,12 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  		tcf_exts_destroy(&new_filter_result.exts);
>  	}
>  
> +	/* Note: old_e should be destroyed after the RCU grace period,
> +	 * to avoid possible use-after-free by concurrent readers.
> +	 */
> +	synchronize_rcu();
> +	tcf_exts_destroy(&old_e);

I don't think this dance is required, @cp is a copy of the original
data, and the original (@p) is destroyed in a safe manner below.

>  	if (oldp)
>  		tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
>  	return 0;
