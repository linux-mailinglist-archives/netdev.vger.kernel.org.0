Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5685EF3BA
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiI2Kxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiI2Kxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:53:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36D2109629;
        Thu, 29 Sep 2022 03:53:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 604F0B82428;
        Thu, 29 Sep 2022 10:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748E2C433D6;
        Thu, 29 Sep 2022 10:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664448812;
        bh=sZuIjfSp6Vx+HwrCQ+D8Xsx9v7jNEhaZgxEAhP0d0Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIGYnWCORoxVctFfgurybpC7Qcu+d8brtglYNBF4Kor8mm0CuuF3IVyXdhuYWpYBR
         Pahdn4Yq2lFl38tW0TxZYqu+athqnnuqL2oy5SjHYDpA8yvFpc2fL+zteX5Ky9h2S2
         3W656moZ/R66QyK+2ao3kziqvXHy3aKALshwMi167k/by/UHIgGCNZwKWCx063JlGJ
         u2EIf1QREk6MTKS0Mk/8sfnhW3DEDPs6S0QmRNDuJeUFo7oGzI+5xEvN+nXquDsjze
         8t6DVOh8VwiTWSuLHY2rgtFnJnnmmnUPo/6Z6TdIChRH5SfkAMz+wMYvoEvvNfcSqy
         yyf+YJ2p1pkKA==
Date:   Thu, 29 Sep 2022 13:53:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux_oss@crudebyte.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org,
        syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] 9p: destroy client in symmetric order
Message-ID: <YzV5J9NmL7hijFTR@unreal>
References: <cover.1664442592.git.leonro@nvidia.com>
 <743fc62b2e8d15c84e234744e3f3f136c467752d.1664442592.git.leonro@nvidia.com>
 <YzVzjR4Yz3Oo3JS+@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzVzjR4Yz3Oo3JS+@codewreck.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:29:33PM +0900, Dominique Martinet wrote:
> Leon Romanovsky wrote on Thu, Sep 29, 2022 at 12:37:56PM +0300:
> > Make sure that all variables are initialized and released in correct
> > order.
> 
> Haven't tried running or compiling, comments out of my head that might
> be wrong below
> 
> > 
> > Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
> 
> You're adding this report tag but I don't see how you fix that failure.
> What you need is p9_tag_cleanup(clnt) from p9_client_destroy -- I assume
> this isn't possible for any fid to be allocated at this point so the fid
> destroying loop is -probably- optional.
> 
> I would assume it is needed from p9_client_version failures.
> 
> 
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > ---
> >  net/9p/client.c | 37 ++++++++++++-------------------------
> >  1 file changed, 12 insertions(+), 25 deletions(-)
> > 
> > diff --git a/net/9p/client.c b/net/9p/client.c
> > index aaa37b07e30a..8277e33506e7 100644
> > --- a/net/9p/client.c
> > +++ b/net/9p/client.c
> > @@ -179,7 +179,6 @@ static int parse_opts(char *opts, struct p9_client *clnt)
> >  				goto free_and_return;
> >  			}
> >  
> > -			v9fs_put_trans(clnt->trans_mod);
> 
> Pretty sure you'll be "leaking transports" if someone tries to pass
> trans=foo multiple times; this can't be removed...(continues below)...

It is pity, you are right.

Thanks
