Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A905A79DC
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiHaJOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiHaJOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:14:00 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CC7C0E4D;
        Wed, 31 Aug 2022 02:13:59 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oTJnF-00H6FV-EG; Wed, 31 Aug 2022 19:13:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 31 Aug 2022 17:13:53 +0800
Date:   Wed, 31 Aug 2022 17:13:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH] xfrm: Don't increase scratch users if allocation fails
Message-ID: <Yw8mUVCdov6l3Cun@gondor.apana.org.au>
References: <00000000000092839d0581fd74ad@google.com>
 <20220831014126.6708-1-khalid.masum.92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831014126.6708-1-khalid.masum.92@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 07:41:26AM +0600, Khalid Masum wrote:
> ipcomp_alloc_scratches() routine increases ipcomp_scratch_users count
> even if it fails to allocate memory. Therefore, ipcomp_free_scratches()
> routine, when triggered, tries to vfree() non existent percpu 
> ipcomp_scratches.
> 
> To fix this breakage, do not increase scratch users count if
> ipcomp_alloc_scratches() fails to allocate scratches.
> 
> Reported-and-tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
> Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
> ---
>  net/xfrm/xfrm_ipcomp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> index cb40ff0ff28d..af9097983139 100644
> --- a/net/xfrm/xfrm_ipcomp.c
> +++ b/net/xfrm/xfrm_ipcomp.c
> @@ -210,13 +210,15 @@ static void * __percpu *ipcomp_alloc_scratches(void)
>  	void * __percpu *scratches;
>  	int i;
>  
> -	if (ipcomp_scratch_users++)
> +	if (ipcomp_scratch_users) {
> +		ipcomp_scratch_users++;
>  		return ipcomp_scratches;
> -
> +	}
>  	scratches = alloc_percpu(void *);
>  	if (!scratches)
>  		return NULL;
>  
> +	ipcomp_scratch_users++;
>  	ipcomp_scratches = scratches;

This patch is broken because on error we will always call
ipcomp_free_scratches which frees any partially allocated memory
and restores ipcomp_scratch_users to zero.

With this patch ipcomp_scratch_users will turn negative on error.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
