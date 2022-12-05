Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C747642A62
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiLEO2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiLEO2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:28:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5910BC22;
        Mon,  5 Dec 2022 06:28:10 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:28:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] netfilter: nfnetlink: check 'skb->dev' pointer in
 nfulnl_log_packet()
Message-ID: <Y43/90Z3NukjG9Pr@salvia>
References: <20221202083304.9005-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221202083304.9005-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:33:04PM +0800, Li Qiong wrote:
> The 'skb->dev' may be NULL, it should be better to check it.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  net/netfilter/nfnetlink_log.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index d97eb280cb2e..74ac9fa40137 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -572,7 +572,7 @@ __build_packet_message(struct nfnl_log_net *log,
>  		}
>  	}
>  
> -	if (indev && skb_mac_header_was_set(skb)) {
> +	if (indev && skb->dev && skb_mac_header_was_set(skb)) {
>  		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
>  		    nla_put_be16(inst->skb, NFULA_HWLEN,
>  				 htons(skb->dev->hard_header_len)))
> @@ -724,7 +724,7 @@ nfulnl_log_packet(struct net *net,
>  		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
>  		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
>  
> -	if (in && skb_mac_header_was_set(skb)) {
> +	if (in && skb->dev && skb_mac_header_was_set(skb)) {
>  		size += nla_total_size(skb->dev->hard_header_len)
>  			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
>  			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */

skb->dev is always guaranteed to be set in this path.
