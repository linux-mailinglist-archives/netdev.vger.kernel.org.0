Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A541525C9D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 09:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377900AbiEMHuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 03:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377899AbiEMHt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 03:49:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05A1B154F81;
        Fri, 13 May 2022 00:49:55 -0700 (PDT)
Date:   Fri, 13 May 2022 09:49:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
Message-ID: <Yn4NnwAkoVryQtCK@salvia>
References: <20220510202739.67068-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220510202739.67068-1-nbd@nbd.name>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 10, 2022 at 10:27:39PM +0200, Felix Fietkau wrote:
> In many cases, it's not easily possible for user space to know, which
> devices properly support hardware offload.

Then, it is a matter of extending the netlink interface to expose this
feature? Probably add a FLOW_BLOCK_PROBE or similar which allow to
consult if this feature is available?

> Even if a device supports hardware flow offload, it is not
> guaranteed that it will actually be able to handle the flows for
> which hardware offload is requested.

When might this happen?

> Ignoring errors on the FLOW_BLOCK_BIND makes it a lot easier to set up
> configurations that use hardware offload where possible and gracefully
> fall back to software offload for everything else.

I understand this might be useful from userspace perspective, because
forcing the user to re-try is silly.

However, on the other hand, the user should have some way to know from
the control plane that the feature (hardware offload) that they
request is not available for their setup.

> Cc: Jo-Philipp Wich <jo@mein.io>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/netfilter/nf_tables_api.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 16c3a39689f4..9d4528f0aa12 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7323,11 +7323,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
>  			}
>  		}
>  
> -		err = flowtable->data.type->setup(&flowtable->data,
> -						  hook->ops.dev,
> -						  FLOW_BLOCK_BIND);
> -		if (err < 0)
> -			goto err_unregister_net_hooks;
> +		flowtable->data.type->setup(&flowtable->data,
> +					    hook->ops.dev,
> +					    FLOW_BLOCK_BIND);
>  
>  		err = nf_register_net_hook(net, &hook->ops);
>  		if (err < 0) {
> -- 
> 2.36.1
> 
