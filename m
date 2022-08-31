Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150985A80C8
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiHaO7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiHaO7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:59:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FE9D51D6;
        Wed, 31 Aug 2022 07:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6E4F61BDF;
        Wed, 31 Aug 2022 14:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F72FC433D6;
        Wed, 31 Aug 2022 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661957930;
        bh=dHdAtSNFczMa5SahuO8kpen8QKzLYM4RqqTL7DvJxtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yshzeEpq9LzzS954o22uUQP3Ql6tTP99Kl3IubCbhjf/yYuI8BcfpMkK7eIiKfV/M
         tJOjv4GkUq7+L/7yDRuIzWrvLHqCu+Yz3qbAamEAN44r/VAa/79rxcYddYk5+POzPB
         47rMj9/4QxjBVrBgBhTY4mpIreSrMCqAL1P+YfOA=
Date:   Wed, 31 Aug 2022 16:58:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] xfrm: ipcomp: Update ipcomp_scratches with NULL if
 alloc fails
Message-ID: <Yw93JsVUG0u1cmfe@kroah.com>
References: <00000000000092839d0581fd74ad@google.com>
 <20220831142938.5882-1-khalid.masum.92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831142938.5882-1-khalid.masum.92@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 08:29:38PM +0600, Khalid Masum wrote:
> Currently if ipcomp_alloc_scratches() fails to allocate memory
> ipcomp_scratches holds obsolete address. So when we try to free the
> percpu scratches using ipcomp_free_scratches() it tries to vfree non
> existent vm area. Described below:
> 
> static void * __percpu *ipcomp_alloc_scratches(void)
> {
> 	...
> 	scratches = alloc_percpu(void *);
>         if (!scratches)
>                 return NULL;
> ipcomp_scratches does not know about this allocation failure.
> Therefore holding the old obsolete address.
>         ...
> }
> 
> So when we free,
> 
> static void ipcomp_free_scratches(void)
> {
> 	...
> 
>         scratches = ipcomp_scratches;
> Receiving obsolete addresses from ipcomp_scratches
>         
> 	if (!scratches)
>                 return;
> 
>         for_each_possible_cpu(i)
>                vfree(*per_cpu_ptr(scratches, i));
> Trying to free non existent page, causing warning.
> 
>         ...
> }
> 
> Fix this breakage by updating ipcomp_scratches with NULL if
> the above mentioned allocation fails.
> 
> Reported-and-tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
> Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
> 
> ---
> diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> index cb40ff0ff28d..17815cde8a7f 100644
> --- a/net/xfrm/xfrm_ipcomp.c
> +++ b/net/xfrm/xfrm_ipcomp.c
> @@ -215,7 +215,7 @@ static void * __percpu *ipcomp_alloc_scratches(void)
>  
>  	scratches = alloc_percpu(void *);
>  	if (!scratches)
> -		return NULL;
> +		return ipcomp_scratches = NULL;
>  
>  	ipcomp_scratches = scratches;
>  

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
