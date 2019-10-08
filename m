Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2505ACF257
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfJHGBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:01:18 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37038 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729847AbfJHGBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:01:18 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iHiYX-0000GB-Et; Tue, 08 Oct 2019 08:01:09 +0200
Date:   Tue, 8 Oct 2019 08:01:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: fix a memory leak in nf_conntrack_in
Message-ID: <20191008060109.GA25052@breakpoint.cc>
References: <20191008053507.252202-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191008053507.252202-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Żenczykowski <zenczykowski@gmail.com> wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  net/netfilter/nf_conntrack_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0c63120b2db2..35459d04a050 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1679,7 +1679,8 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
>  		if ((tmpl && !nf_ct_is_template(tmpl)) ||
>  		     ctinfo == IP_CT_UNTRACKED) {
>  			NF_CT_STAT_INC_ATOMIC(state->net, ignore);
> -			return NF_ACCEPT;
> +			ret = NF_ACCEPT;

This looks wrong.

> +			goto out;

This puts tmpl, causing underflow of skb->nfct.
When we enter nf_conntrack_in and this branch, then 'tmpl'
is already assigned to skb->nfct, it will be put when skb
is free'd.

nf_ct_get() doesn't increment the refcnt.

tmpl only needs to be put in case of ...


>  		}
>  		skb->_nfct = 0;

...this.
