Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78516CA136
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbjC0KWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbjC0KWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:22:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38C165FE8;
        Mon, 27 Mar 2023 03:22:38 -0700 (PDT)
Date:   Mon, 27 Mar 2023 12:22:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [lvc-project] [PATCH] netfilter: nfnetlink: NULL-check skb->dev
 in __build_packet_message()
Message-ID: <ZCFuaDrSdsyzRdgJ@salvia>
References: <20230327094116.1763201-1-Igor.A.Artemiev@mcst.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230327094116.1763201-1-Igor.A.Artemiev@mcst.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 12:41:16PM +0300, Igor Artemiev wrote:
> After having been compared to NULL value at nfnetlink_log.c:560,
> pointer 'skb->dev' is dereferenced at nfnetlink_log.c:576.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
> ---
>  net/netfilter/nfnetlink_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index d97eb280cb2e..2711509eb9a5 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -572,7 +572,7 @@ __build_packet_message(struct nfnl_log_net *log,
>  		}
>  	}
>  
> -	if (indev && skb_mac_header_was_set(skb)) {
> +	if (indev && skb->dev && skb_mac_header_was_set(skb)) {

This cannot ever happen, we assume skb->dev is always set on.

>  		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
>  		    nla_put_be16(inst->skb, NFULA_HWLEN,
>  				 htons(skb->dev->hard_header_len)))
> -- 
> 2.30.2
> 
