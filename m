Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B07514F446
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 23:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgAaWI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 17:08:59 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52758 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgAaWI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 17:08:58 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ixeTA-000610-Ss; Fri, 31 Jan 2020 23:08:56 +0100
Date:   Fri, 31 Jan 2020 23:08:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [Patch nf 1/3] xt_hashlimit: avoid OOM for user-controlled
 vmalloc
Message-ID: <20200131220856.GK795@breakpoint.cc>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131205216.22213-2-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> The hashtable size could be controlled by user, so use flags
> GFP_USER | __GFP_NOWARN to avoid OOM warning triggered by user-space.
> 
> Also add __GFP_NORETRY to avoid retrying, as this is just a
> best effort and the failure is already handled gracefully.
> 
> Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/netfilter/xt_hashlimit.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> index bccd47cd7190..885a266d8e57 100644
> --- a/net/netfilter/xt_hashlimit.c
> +++ b/net/netfilter/xt_hashlimit.c
> @@ -293,8 +293,9 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
>  		if (size < 16)
>  			size = 16;
>  	}
> -	/* FIXME: don't use vmalloc() here or anywhere else -HW */
> -	hinfo = vmalloc(struct_size(hinfo, hash, size));
> +	/* FIXME: don't use __vmalloc() here or anywhere else -HW */
> +	hinfo = __vmalloc(struct_size(hinfo, hash, size),
> +			  GFP_USER | __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);

Rationale looks sane, wonder if it makes sense to drop Haralds comment
though, I don't see what other solution other than vmalloc could be used
here.
