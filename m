Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B474D28CE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiCIGPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiCIGPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:15:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B6D13D0F
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D00C261910
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFC5C340EE;
        Wed,  9 Mar 2022 06:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646806448;
        bh=Yw0OjAsWj2rUufahRiFBlL8z1E5oIx32FptBFXAyzDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d4er+efWY1vWpYk/q45m3u1Qxz7QE5FcQ2w/UEZEh5iynMh0dZReJwu7/CYq4FBZ3
         ahp3a/iW0++Ul+mVy6H6/fAgB5/8hf0NH7ssssBKNXTWH3J8XHRWxis1a8abA8ZLLo
         5zhqyTq+IY58HdEjJch+Gmmo7yPVIJ965fXo7/jmBuWRQnH0JsS0XOMa2dDXHhGfBH
         0/YGu69F/lBRRY7y6mxU/t1DdXLYhbXniFm499BCIcUHkc4opclDWXSF2l7fhw1r+Y
         E2SXAZ4c4SrT/kDKzE9oAmbpJFAy7Ed1xOfFtlXJwvTU+fveSA/ydgfwyaqWp1U2oj
         9EydtNaWse1Uw==
Date:   Tue, 8 Mar 2022 22:14:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH net-next] net/fungible: Fix local_memory_node error
Message-ID: <20220308221407.5f26332b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308045321.2843-1-dmichail@fungible.com>
References: <20220308045321.2843-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Mar 2022 20:53:21 -0800 Dimitris Michailidis wrote:
> Stephen Rothwell reported the following failure on powerpc:
> 
> ERROR: modpost: ".local_memory_node"
> [drivers/net/ethernet/fungible/funeth/funeth.ko] undefined!
> 
> AFAICS this is because local_memory_node() is a non-inline non-exported
> function when CONFIG_HAVE_MEMORYLESS_NODES=y. It is also the wrong API
> to get a CPU's memory node. Use cpu_to_mem() in the two spots it's used.

Can the ids actually not match? I'm asking because nobody else is doing
the cpu -> mem node conversions.

> Fixes: ee6373ddf3a9 ("net/funeth: probing and netdev ops")
> Fixes: db37bc177dae ("net/funeth: add the data path")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> ---
>  drivers/net/ethernet/fungible/funeth/funeth_main.c | 2 +-
>  drivers/net/ethernet/fungible/funeth/funeth_txrx.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
> index c58b10c216ef..67dd02ed1fa3 100644
> --- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
> +++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
> @@ -253,7 +253,7 @@ static struct fun_irq *fun_alloc_qirq(struct funeth_priv *fp, unsigned int idx,
>  	int cpu, res;
>  
>  	cpu = cpumask_local_spread(idx, node);
> -	node = local_memory_node(cpu_to_node(cpu));
> +	node = cpu_to_mem(cpu);
>  
>  	irq = kzalloc_node(sizeof(*irq), GFP_KERNEL, node);
>  	if (!irq)
> diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
> index 7aed0561aeac..04c9f91b7489 100644
> --- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
> +++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
> @@ -239,7 +239,7 @@ static inline void fun_txq_wr_db(const struct funeth_txq *q)
>  
>  static inline int fun_irq_node(const struct fun_irq *p)
>  {
> -	return local_memory_node(cpu_to_node(cpumask_first(&p->affinity_mask)));
> +	return cpu_to_mem(cpumask_first(&p->affinity_mask));
>  }
>  
>  int fun_rxq_napi_poll(struct napi_struct *napi, int budget);

