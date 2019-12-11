Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD211BF6C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLKVxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:53:17 -0500
Received: from correo.us.es ([193.147.175.20]:59180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfLKVxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 16:53:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0636820A540
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:53:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED61CDA710
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:53:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E2F48DA70D; Wed, 11 Dec 2019 22:53:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E38B8DA702;
        Wed, 11 Dec 2019 22:53:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 22:53:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BE21F42EE38F;
        Wed, 11 Dec 2019 22:53:11 +0100 (CET)
Date:   Wed, 11 Dec 2019 22:53:12 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH nf-next 3/7] netfilter: nft_tunnel: no need to call
 htons() when dumping ports
Message-ID: <20191211215312.ratn33c52e5c4esz@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c9abbd7ac3b89af9addb550bccb9169f47e39a2.1575779993.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 08, 2019 at 12:41:33PM +0800, Xin Long wrote:
> info->key.tp_src and tp_dst are __be16, when using nla_put_be16()
> to dump them, htons() is not needed, so remove it in this patch.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/netfilter/nft_tunnel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index d9d6c0d..e1184fa 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -502,8 +502,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
>  static int nft_tunnel_ports_dump(struct sk_buff *skb,
>  				 struct ip_tunnel_info *info)
>  {
> -	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
> -	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
> +	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
> +	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)

info->key.tp_src is already in __be16 as you describe. So I would take
this as a consistency fix. I would take this as a fix.
