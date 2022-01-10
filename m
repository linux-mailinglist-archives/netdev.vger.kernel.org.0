Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910E348A015
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbiAJTZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:25:46 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44466 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241847AbiAJTZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:25:45 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C3DB63F5A;
        Mon, 10 Jan 2022 20:22:54 +0100 (CET)
Date:   Mon, 10 Jan 2022 20:25:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Wiedmann <jwiedmann.dev@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next 19/32] netfilter: nft_connlimit: move stateful
 fields out of expression data
Message-ID: <YdyINIariflWgbCc@salvia>
References: <20220109231640.104123-1-pablo@netfilter.org>
 <20220109231640.104123-20-pablo@netfilter.org>
 <077d6843-bf14-f528-d9cd-9c5245687be5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <077d6843-bf14-f528-d9cd-9c5245687be5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jan 10, 2022 at 08:20:47PM +0200, Julian Wiedmann wrote:
> On 10.01.22 01:16, Pablo Neira Ayuso wrote:
> > In preparation for the rule blob representation.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nft_connlimit.c | 26 ++++++++++++++++++--------
> >  1 file changed, 18 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
> > index 7d0761fad37e..58dcafe8bf79 100644
> > --- a/net/netfilter/nft_connlimit.c
> > +++ b/net/netfilter/nft_connlimit.c
> 
> [...]
> 
> >  
> >  static int nft_connlimit_do_dump(struct sk_buff *skb,
> > @@ -200,7 +205,11 @@ static int nft_connlimit_clone(struct nft_expr *dst, const struct nft_expr *src)
> >  	struct nft_connlimit *priv_dst = nft_expr_priv(dst);
> >  	struct nft_connlimit *priv_src = nft_expr_priv(src);
> >  
> > -	nf_conncount_list_init(&priv_dst->list);
> > +	priv_dst->list = kmalloc(sizeof(*priv_dst->list), GFP_ATOMIC);
> > +	if (priv_dst->list)
> > +		return -ENOMEM;
> > +
> > +	nf_conncount_list_init(priv_dst->list);
> >  	priv_dst->limit	 = priv_src->limit;
> >  	priv_dst->invert = priv_src->invert;
> >  
> 
> Hi Pablo,
> 
> Coverity (CID 1510697) spotted a typo in this NULL check, it should be
> 
> 	if (!priv_dst->list)
> 		return -ENOMEM;
> 
> 
> Looks like the following patches also have this bug.

Thanks, I'll post a patchset to fix this.
