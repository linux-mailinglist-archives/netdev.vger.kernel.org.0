Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109774BF247
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 07:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiBVG6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 01:58:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiBVG6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 01:58:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3804CFDFA8;
        Mon, 21 Feb 2022 22:57:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nMP7K-0006HB-1i; Tue, 22 Feb 2022 07:57:46 +0100
Date:   Tue, 22 Feb 2022 07:57:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 5/5] netfilter: nf_tables: fix memory leak during
 stateful obj update
Message-ID: <20220222065746.GA14401@breakpoint.cc>
References: <20220221161757.250801-1-pablo@netfilter.org>
 <20220221161757.250801-6-pablo@netfilter.org>
 <20220221205840.08110cab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221205840.08110cab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
> >  static void nft_commit_release(struct nft_trans *trans)
> > @@ -8976,7 +8981,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
> >  			break;
> >  		case NFT_MSG_NEWOBJ:
> >  			if (nft_trans_obj_update(trans)) {
> > -				kfree(nft_trans_obj_newobj(trans));
> > +				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
> >  				nft_trans_destroy(trans);
> >  			} else {
> >  				trans->ctx.table->use--;
> 
> net/netfilter/nf_tables_api.c:6561:6: warning: variable 'err' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>         if (!trans)
>             ^~~~~~
> net/netfilter/nf_tables_api.c:6581:9: note: uninitialized use occurs here
>         return err;
>                ^~~
> net/netfilter/nf_tables_api.c:6561:2: note: remove the 'if' if its condition is always false
>         if (!trans)
>         ^~~~~~~~~~~
> net/netfilter/nf_tables_api.c:6554:9: note: initialize the variable 'err' to silence this warning
>         int err;
>                ^

I've sent a followup patch to this, no idea why gcc doesn't warn here.
Looks like I should dump it in favor of clang.
