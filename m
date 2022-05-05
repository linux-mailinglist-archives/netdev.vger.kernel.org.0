Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB11751B649
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiEEDIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiEEDIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8F41D0E5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61A3A618BC
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83614C385A5;
        Thu,  5 May 2022 03:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651719873;
        bh=RjnjmVyjDRLuuz8SGGT2V82aAv0NnBNl6iQZFYjsZVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FJTUngUhBMYla3+x4/5jRvJUPWWWkPcLjs4j/Ih/dQArPEmw/V4Zb+VNj9ImcUe6r
         UV8/4P5+Sp/4fvHGxFJG9JH0YCE9r1UfcIJq9IjySwAnPkTvW69FGNLRcJ6T26EEI1
         47PYNUuhX6/j3pwmCDLlo2jIOpQazec4Mgz9/JmphdlJjjrTIUMfLRdufpLoh1SV6t
         rG9WY4pNVRZ8sAM0Ah4Y7rGx4gtepOQvP/48XKbNI3XmaHVq25SxDQ4z/2D2+Q9hXw
         or89FLrENzeZNs9y+UDINV2QpA11I/jKU0o0YbEzN88TQrW4ewy0wNnUsdcln+6gLm
         xC9ihS/MRYBkw==
Date:   Wed, 4 May 2022 20:04:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
Message-ID: <20220504200432.47205429@kernel.org>
In-Reply-To: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 May 2022 16:05:42 +0200 Paolo Abeni wrote:
> Currently pedit tries to ensure that the accessed skb offset
> is writeble via skb_unclone(). The action potentially allows
> touching any skb bytes, so it may end-up modifying shared data.
> 
> The above causes some sporadic MPTCP self-test failures.
> 
> Address the issue keeping track of a rough over-estimate highest skb
> offset accessed by the action and ensure such offset is really
> writable.
> 
> Note that this may cause performance regressions in some scenario,
> but hopefully pedit is not critical path.
> 
> Fixes: db2c24175d14 ("act_pedit: access skb->data safely")
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Tested-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> Note: AFAICS the issue is present since 1da177e4c3f4
> ("Linux-2.6.12-rc2"), but before the "Fixes" commit this change
> is irrelevant, because accessing any data out of the skb head
> will cause an oops.
> ---
>  include/net/tc_act/tc_pedit.h |  1 +
>  net/sched/act_pedit.c         | 23 +++++++++++++++++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
> index 748cf87a4d7e..3e02709a1df6 100644
> --- a/include/net/tc_act/tc_pedit.h
> +++ b/include/net/tc_act/tc_pedit.h
> @@ -14,6 +14,7 @@ struct tcf_pedit {
>  	struct tc_action	common;
>  	unsigned char		tcfp_nkeys;
>  	unsigned char		tcfp_flags;
> +	u32			tcfp_off_max_hint;
>  	struct tc_pedit_key	*tcfp_keys;
>  	struct tcf_pedit_key_ex	*tcfp_keys_ex;
>  };
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index 31fcd279c177..a8ab6c3f1ea2 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -149,7 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  	struct nlattr *pattr;
>  	struct tcf_pedit *p;
>  	int ret = 0, err;
> -	int ksize;
> +	int i, ksize;
>  	u32 index;
>  
>  	if (!nla) {
> @@ -228,6 +228,20 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>  		p->tcfp_nkeys = parm->nkeys;
>  	}
>  	memcpy(p->tcfp_keys, parm->keys, ksize);
> +	p->tcfp_off_max_hint = 0;

This gets zeroed here... [1]

> +	for (i = 0; i < p->tcfp_nkeys; ++i) {
> +		u32 cur = p->tcfp_keys[i].off;
> +
> +		/* The AT option can read a single byte, we can bound the actual
> +		 * value with uchar max. Each key touches 4 bytes starting from
> +		 * the computed offset
> +		 */
> +		if (p->tcfp_keys[i].offmask) {
> +			cur += 255 >> p->tcfp_keys[i].shift;

Could be written as:

		cur += (0xff & p->tcfp_keys[i].offmask) >>
			p->tcfp_keys[i].shift;

without the if? That would be closer to the:

		offset += (*d & tkey->offmask) >> tkey->shift;

which ends up getting executed.

> +			cur = max(p->tcfp_keys[i].at, cur);

We never write under ->at, tho, so this shouldn't be needed?

> +		}
> +		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
> +	}
>  
>  	p->tcfp_flags = parm->flags;
>  	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> @@ -308,9 +322,14 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
>  			 struct tcf_result *res)
>  {
>  	struct tcf_pedit *p = to_pedit(a);
> +	u32 max_offset;
>  	int i;
>  
> -	if (skb_unclone(skb, GFP_ATOMIC))
> +	max_offset = (skb_transport_header_was_set(skb) ?
> +		      skb_transport_offset(skb) :
> +		      skb_network_offset(skb)) +
> +		     p->tcfp_off_max_hint;

[1] ... and used here outside of the lock. Isn't it racy?

> +	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
>  		return p->tcf_action;
>  
>  	spin_lock(&p->tcf_lock);

