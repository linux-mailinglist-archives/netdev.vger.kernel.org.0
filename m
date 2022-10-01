Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832F15F1890
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 04:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiJACDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 22:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiJACDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 22:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4AA17CCF8
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 19:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD42862597
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 02:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F9C433D6;
        Sat,  1 Oct 2022 02:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664589813;
        bh=0Pecv06KjZgh5/mAgY7eaXVNYZgahRIL3+rSbSTEfg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fNr/X7SZwn+cCZNXg1O6FurURCr2W9hKAOzeILUgSicED0ZwWL1S411cAHNii+BBC
         tcc0xts/u8JIhZmhF3V5+IfI32CHthkJ68VFnBfPRj1rXOMHc7pV4ZlGjqB3dPxqxv
         gIdkRre+yKWAXyDKhyESOtVALkX3oi5pauO7Wvd4ijVX8+lRbBPq1kgHe9leR+2YcR
         a/YCG5LWq+HxuO01sMhJmGgglwyG9bnFAafLjHvPdlVqlRz3gZcABSO7z8mb618SmY
         nZJBCmadDvuggzTtO00oUawkgFzewGiUZYsyapMSguprrFvMXzC5G0Y20Wx2UiIbQ3
         dA/A4MD13Vn6A==
Date:   Fri, 30 Sep 2022 19:03:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <20220930190331.3b830b2a@kernel.org>
In-Reply-To: <20220929033505.457172-1-liuhangbin@gmail.com>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 11:35:05 +0800 Hangbin Liu wrote:
> In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> made cls could log verbose info for offloading failures, which helps
> improving Open vSwitch debuggability when using flower offloading.
> 
> It would also be helpful if "tc monitor" could log this message, as it
> doesn't require vswitchd log level adjusment. Let's add the extack message
> in tfilter_notify so the monitor program could receive the failures.
> e.g.

The title read as "just another extack addition" but this is much 
more than that :S 

Jamal, you may want to take a look.

>   # tc monitor
>   added chain dev enp3s0f1np1 parent ffff: chain 0
>   added filter dev enp3s0f1np1 ingress protocol all pref 49152 flower chain 0 handle 0x1
>     ct_state +trk+new
>     not_in_hw
>           action order 1: gact action drop
>            random type none pass val 0
>            index 1 ref 1 bind 1
> 
>   Warning: mlx5_core: matching on ct_state +new isn't supported.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> 
> Rebase the patch to latest net-next as the previous could not
> apply to net-next.

> +	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*tcm),
> +			(extack && extack->_msg) ? flags | NLM_F_MULTI : flags);

> +
> +	if (extack && extack->_msg) {
> +		nlh = nlmsg_put(skb, portid, seq, NLMSG_DONE, 0, flags | NLM_F_ACK_TLVS);
> +		if (!nlh)
> +			goto out_nlmsg_trim;
> +
> +		if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
> +			goto nla_put_failure;
> +
> +		nlmsg_end(skb, nlh);
> +	}
> +

So you're adding a fake* _F_MULTI on the notification just so you
can queue a NLMSG_DONE after and not break the "NLMSG_DONE terminates 
a _F_MUTLI" sequence rule?

* fake as in there's only one message, there's no multi-ness here.

I don't think _F_MULTI should be treated lightly and I don't think
NLMSG_DONE as part of notification sequences is a good idea either :(

(1) does the tracepoint not give you want you need?
    (netlink:netlink_extack), failing that -
(2) why not wrap the extack msg in an attribute
