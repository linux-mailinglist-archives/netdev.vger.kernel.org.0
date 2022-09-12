Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F9A5B5A5D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiILMpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiILMpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:45:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D536112A9E;
        Mon, 12 Sep 2022 05:45:02 -0700 (PDT)
Date:   Mon, 12 Sep 2022 14:44:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix nft_counters_enabled underflow
 at nf_tables_addchain()
Message-ID: <Yx8pyq97n8gIN0ui@salvia>
References: <000000000000a9172705e7ffef2e@google.com>
 <8c86a1bb-9c43-b02e-cf93-e098b158ee8c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c86a1bb-9c43-b02e-cf93-e098b158ee8c@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 09:41:00PM +0900, Tetsuo Handa wrote:
> syzbot is reporting underflow of nft_counters_enabled counter at
> nf_tables_addchain() [1], for commit 43eb8949cfdffa76 ("netfilter:
> nf_tables: do not leave chain stats enabled on error") missed that
> nf_tables_chain_destroy() after nft_basechain_init() in the error path of
> nf_tables_addchain() decrements the counter because nft_basechain_init()
> makes nft_is_base_chain() return true by setting NFT_CHAIN_BASE flag.
> 
> Increment the counter immediately after returning from
> nft_basechain_init().

Patch LGTM, thanks

> Link:  https://syzkaller.appspot.com/bug?extid=b5d82a651b71cd8a75ab [1]
> Reported-by: syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+b5d82a651b71cd8a75ab@syzkaller.appspotmail.com>
> Fixes: 43eb8949cfdffa76 ("netfilter: nf_tables: do not leave chain stats enabled on error")
> ---
>  net/netfilter/nf_tables_api.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 816052089b33..e062754dc6cc 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2197,7 +2197,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>  			      struct netlink_ext_ack *extack)
>  {
>  	const struct nlattr * const *nla = ctx->nla;
> -	struct nft_stats __percpu *stats = NULL;
>  	struct nft_table *table = ctx->table;
>  	struct nft_base_chain *basechain;
>  	struct net *net = ctx->net;
> @@ -2212,6 +2211,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>  		return -EOVERFLOW;
>  
>  	if (nla[NFTA_CHAIN_HOOK]) {
> +		struct nft_stats __percpu *stats = NULL;
>  		struct nft_chain_hook hook;
>  
>  		if (flags & NFT_CHAIN_BINDING)
> @@ -2245,6 +2245,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>  			kfree(basechain);
>  			return err;
>  		}
> +		if (stats)
> +			static_branch_inc(&nft_counters_enabled);
>  	} else {
>  		if (flags & NFT_CHAIN_BASE)
>  			return -EINVAL;
> @@ -2319,9 +2321,6 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>  		goto err_unregister_hook;
>  	}
>  
> -	if (stats)
> -		static_branch_inc(&nft_counters_enabled);
> -
>  	table->use++;
>  
>  	return 0;
> -- 
> 2.18.4
> 
