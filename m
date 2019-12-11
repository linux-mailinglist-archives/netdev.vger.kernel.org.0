Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908E011BF69
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfLKVwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:52:16 -0500
Received: from correo.us.es ([193.147.175.20]:58534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfLKVwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 16:52:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D1681F0CE6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:52:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ECD0DA702
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:52:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 343B2DA701; Wed, 11 Dec 2019 22:52:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F787DA702;
        Wed, 11 Dec 2019 22:52:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 22:52:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1A6A94265A5A;
        Wed, 11 Dec 2019 22:52:11 +0100 (CET)
Date:   Wed, 11 Dec 2019 22:52:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH nf-next 2/7] netfilter: nft_tunnel: parse VXLAN_GBP attr
 as u32 in nft_tunnel
Message-ID: <20191211215211.rthtvxy7psglpdf5@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533ced1ea1cc339c459d9446e610e782f165ae6b.1575779993.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 08, 2019 at 12:41:32PM +0800, Xin Long wrote:
> Both user and kernel sides want VXLAN_GBP opt as u32, so there's no
> need to convert it on each side.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/netfilter/nft_tunnel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index f76cd7d..d9d6c0d 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -239,7 +239,7 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
>  	if (!tb[NFTA_TUNNEL_KEY_VXLAN_GBP])
>  		return -EINVAL;
>  
> -	opts->u.vxlan.gbp = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]));
> +	opts->u.vxlan.gbp = nla_get_u32(tb[NFTA_TUNNEL_KEY_VXLAN_GBP]);

In netfilter, attributes go in network byte order to make it easier to
send them over the wire. The only remaining part that needs to be
converted to network byte order is the netlink header.

Please, leave this one as is.
