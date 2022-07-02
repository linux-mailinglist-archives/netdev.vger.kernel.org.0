Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74463564247
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiGBTCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiGBTCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:02:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B6AFAE4F
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:02:06 -0700 (PDT)
Date:   Sat, 2 Jul 2022 21:02:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hugues ANGUELKOV <hanguelkov@randorisec.fr>,
        netdev@vger.kernel.org, security@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, davy <davy@randorisec.fr>, amongodin@randorisec.fr,
        torvalds@linuxfoundation.org
Subject: Re: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap
 buffer overflow
Message-ID: <YsCWK4rn3mBQSjX+@salvia>
References: <271d4a36-2212-5bce-5efb-f5bad53fa49e@randorisec.fr>
 <20220702115948.5de8b1e0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220702115948.5de8b1e0@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 11:59:48AM -0700, Jakub Kicinski wrote:
> On Sat, 2 Jul 2022 19:59:11 +0200 Hugues ANGUELKOV wrote:
> > From d91007a18140e02a1f12c9627058a019fe55b8e6 Mon Sep 17 00:00:00 2001
> > From: Arthur Mongodin <amongodin@randorisec.fr>
> > Date: Sat, 2 Jul 2022 17:11:48 +0200
> > Subject: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap buffer
> >  overflow
> 
> You have the headers twice, you may want to trim them or use git
> send-email if v2 is needed.
> 
> > The length used for the memcpy in nft_set_elem_init may exceed the bound
> > of the allocated object due to a weak check in nft_setelem_parse_data.
> > As a user can add an element with a data type NFT_DATA_VERDICT to a set
> > with a data type different of NFT_DATA_VERDICT, then the comparison on the
> > data type of the element allows to avoid the comparaison on the data length
> > This fix forces the length comparison in nft_setelem_parse_data by removing
> > the check for NFT_DATA_VERDICT type.
> 
> > Fixes: fdb9c405e35b ("netfilter: nf_tables: allow up to 64 bytes in the set element data area")
> > Signed-off-by: Arthur Mongodin <amongodin@randorisec.fr>
> > ---
> >  net/netfilter/nf_tables_api.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 51144fc66889..07845f211f3e 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -5219,7 +5219,7 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
> >  	if (err < 0)
> >  		return err;
> >  
> > -	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
> > +	if (desc->len != set->dlen) {
> 
> Looking at the commit under fixes it seems like it changes the check
> from desc->type != ... to set->type != ...
> 
> Seems like either the bug is even older or the fix should be to go back
> to checking set->type. Prolly the former?

Hold on with this, please.

There is a patch coming in a pull request from nf.git

Thanks for reviewing.
