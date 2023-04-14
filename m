Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300C76E2B88
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDNVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjDNVJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:09:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6630D4EF2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 14:09:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pnQg2-0004K3-40; Fri, 14 Apr 2023 23:09:50 +0200
Date:   Fri, 14 Apr 2023 23:09:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Message-ID: <20230414210950.GC5927@breakpoint.cc>
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414160105.172125-6-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> Accesses to nf_trace and ipvs_property are already wrapped
> by ifdefs where necessary. Don't allocate the bits for those
> fields at all if possible.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: pablo@netfilter.org
> CC: fw@strlen.de
> ---
>  include/linux/skbuff.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 543f7ae9f09f..7b43d5a03613 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -966,8 +966,12 @@ struct sk_buff {
>  	__u8			ndisc_nodetype:2;
>  #endif
>  
> +#if IS_ENABLED(CONFIG_IP_VS)
>  	__u8			ipvs_property:1;
> +#endif
> +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
>  	__u8			nf_trace:1;

As already pointed out nftables can be a module, other than that

Acked-by: Florian Westphal <fw@strlen.de>
