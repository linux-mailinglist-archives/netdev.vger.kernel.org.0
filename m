Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BA12DAF22
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 15:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgLOOjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:39:37 -0500
Received: from correo.us.es ([193.147.175.20]:46490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbgLOOjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 09:39:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3C851E2C7D
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:38:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B55DADA72F
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:38:17 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AAFDFDA78E; Tue, 15 Dec 2020 15:38:17 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5232ADA78A;
        Tue, 15 Dec 2020 15:38:15 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Dec 2020 15:38:15 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2A5954265A5A;
        Tue, 15 Dec 2020 15:38:15 +0100 (CET)
Date:   Tue, 15 Dec 2020 15:38:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nftables: fix incorrect increment of
 loop counter
Message-ID: <20201215143830.GA10086@salvia>
References: <20201214234015.85072-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201214234015.85072-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Dec 14, 2020 at 11:40:15PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The intention of the err_expr cleanup path is to iterate over the
> allocated expr_array objects and free them, starting from i - 1 and
> working down to the start of the array. Currently the loop counter
> is being incremented instead of decremented and also the index i is
> being used instead of k, repeatedly destroying the same expr_array
> element.  Fix this by decrementing k and using k as the index into
> expr_array.
> 
> Addresses-Coverity: ("Infinite loop")
> Fixes: 8cfd9b0f8515 ("netfilter: nftables: generalize set expressions support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

@Jakub: Would you please take this one into net-next? Thanks!

> ---
>  net/netfilter/nf_tables_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8d5aa0ac45f4..4186b1e52d58 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5254,8 +5254,8 @@ static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
>  	return 0;
>  
>  err_expr:
> -	for (k = i - 1; k >= 0; k++)
> -		nft_expr_destroy(ctx, expr_array[i]);
> +	for (k = i - 1; k >= 0; k--)
> +		nft_expr_destroy(ctx, expr_array[k]);
>  
>  	return -ENOMEM;
>  }
> -- 
> 2.29.2
> 
