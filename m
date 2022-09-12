Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF295B5C0D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiILORq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 10:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiILORm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 10:17:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78A8D32AA8;
        Mon, 12 Sep 2022 07:17:38 -0700 (PDT)
Date:   Mon, 12 Sep 2022 16:17:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix percpu memory leak at
 nf_tables_addchain()
Message-ID: <Yx8/frbK9hxF8290@salvia>
References: <41e415f2-3ca4-8e8a-a4b5-5044e7043131@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <41e415f2-3ca4-8e8a-a4b5-5044e7043131@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 10:58:51PM +0900, Tetsuo Handa wrote:
> It seems to me that percpu memory for chain stats started leaking since
> commit 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to
> hardware priority") when nft_chain_offload_priority() returned an error.

Patch also LGTM. Thanks.

> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to hardware priority")
> ---
> The "netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()" made
> me wonder where free_percpu() is called when nft_basechain_init() returned an error. But I
> don't know whether this patch is correct. Please check carefully.
>
>  net/netfilter/nf_tables_api.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index e062754dc6cc..63c70141b3e5 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2243,6 +2243,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
>  		if (err < 0) {
>  			nft_chain_release_hook(&hook);
>  			kfree(basechain);
> +			free_percpu(stats);
>  			return err;
>  		}
>  		if (stats)
> -- 
> 2.18.4
