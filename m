Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D855D2C30B3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390971AbgKXTYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:24:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390919AbgKXTYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 14:24:32 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D11206B5;
        Tue, 24 Nov 2020 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606245871;
        bh=26bRg9JP+0a2d2OvPj8wlUn5vRsch0gJj3neTfcrD0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1Q71YsNAx5T+3j5Air2cYa/uJZvuWZglGVBIM0cL7ZR8lIV06ITl5JBwlmCB9GOld
         8WyTkvN+7JpZr4v67NJeTuUuPlfyxnWfV5GeNPqcQQpbOtTtzsIrdCN++Nq0IIb+Yx
         /j41Iabd/GBwS8M87/IQcZgaCfXew2Te7x2it08M=
Date:   Tue, 24 Nov 2020 11:24:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     marcelo.leitner@gmail.com, vladbu@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
Message-ID: <20201124112430.64143482@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605829116-10056-4-git-send-email-wenxu@ucloud.cn>
References: <1605829116-10056-1-git-send-email-wenxu@ucloud.cn>
        <1605829116-10056-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 07:38:36 +0800 wenxu@ucloud.cn wrote:
> +int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
> +{
> +	xmit_hook_func *xmit_hook;
> +
> +	xmit_hook = rcu_dereference(tcf_xmit_hook);
> +	if (xmit_hook)
> +		return xmit_hook(skb, xmit);
> +	else
> +		return xmit(skb);
> +}
> +EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);

I'm concerned about the performance impact of these indirect calls.

Did you check what code compiler will generate? What the impact with
retpolines enabled is going to be?

Now that sch_frag is no longer a module this could be simplified.

First of all - xmit_hook can only be sch_frag_xmit_hook, so please use
that directly. 

	if (READ_ONCE(tcf_xmit_hook_count)) 
		sch_frag_xmit_hook(...
	else
		dev_queue_xmit(...

The abstraction is costly and not necessary right now IMO.

Then probably the counter should be:

	u32 __read_mostly tcf_xmit_hook_count;

To avoid byte loads and having it be places in an unlucky cache line.

You could also make the helper a static inline in a header.


Unless I'm not giving the compiler enough credit and the performance
impact of this patch with retpolines on is indiscernible, but that'd
need to be proven by testing...
