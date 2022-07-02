Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CD4564239
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiGBS7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiGBS7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2335D62EF
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 11:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B49A460FD4
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 18:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28FCC341CA;
        Sat,  2 Jul 2022 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788390;
        bh=lWse9WIHVMysF6eHjD8tXr7RJlMfXVChVWRWh1nUWac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tzjJ1k/AQab3StGhiV87UFFFkesJRji7dgdP+CT/qSOdCRe72+SIGVWwr2Wfg+I9+
         drvqi50S9fuil1K9ZGgIdAFcJXdbJnkfII0YmIJrsbur70YT5o67nTMqEL/UFYns4v
         UecMh6kqHBm303emZhHBRy6mWMFu51jQaNYmR7+QlYeCrLajcF//ABz+ip/f9Q4b25
         6oL5Fi8jSgiRcLQOijuj6uuaVy7UDbusQwO0AQ1hSy8cGTAPBzQLl2S27vpw1mvZUx
         SFwpGID+qlG5CDPF4OAD8k0j42nEjjZFP0zWXqH+Lj3uGyc64dCk3YI6goRopqyamy
         j8RGdzQlcm0TQ==
Date:   Sat, 2 Jul 2022 11:59:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Cc:     netdev@vger.kernel.org, security@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davy <davy@randorisec.fr>,
        amongodin@randorisec.fr, torvalds@linuxfoundation.org
Subject: Re: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap
 buffer overflow
Message-ID: <20220702115948.5de8b1e0@kernel.org>
In-Reply-To: <271d4a36-2212-5bce-5efb-f5bad53fa49e@randorisec.fr>
References: <271d4a36-2212-5bce-5efb-f5bad53fa49e@randorisec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Jul 2022 19:59:11 +0200 Hugues ANGUELKOV wrote:
> From d91007a18140e02a1f12c9627058a019fe55b8e6 Mon Sep 17 00:00:00 2001
> From: Arthur Mongodin <amongodin@randorisec.fr>
> Date: Sat, 2 Jul 2022 17:11:48 +0200
> Subject: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap buffer
>  overflow

You have the headers twice, you may want to trim them or use git
send-email if v2 is needed.

> The length used for the memcpy in nft_set_elem_init may exceed the bound
> of the allocated object due to a weak check in nft_setelem_parse_data.
> As a user can add an element with a data type NFT_DATA_VERDICT to a set
> with a data type different of NFT_DATA_VERDICT, then the comparison on the
> data type of the element allows to avoid the comparaison on the data length
> This fix forces the length comparison in nft_setelem_parse_data by removing
> the check for NFT_DATA_VERDICT type.

> Fixes: fdb9c405e35b ("netfilter: nf_tables: allow up to 64 bytes in the set element data area")
> Signed-off-by: Arthur Mongodin <amongodin@randorisec.fr>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 51144fc66889..07845f211f3e 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5219,7 +5219,7 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
>  	if (err < 0)
>  		return err;
>  
> -	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
> +	if (desc->len != set->dlen) {

Looking at the commit under fixes it seems like it changes the check
from desc->type != ... to set->type != ...

Seems like either the bug is even older or the fix should be to go back
to checking set->type. Prolly the former?
