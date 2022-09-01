Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227A85A8C52
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 06:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiIAETH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 00:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiIAESN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 00:18:13 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B009E162160;
        Wed, 31 Aug 2022 21:18:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oTbeR-00HQMa-Dn; Thu, 01 Sep 2022 14:18:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Sep 2022 12:17:59 +0800
Date:   Thu, 1 Sep 2022 12:17:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] xfrm: Update ipcomp_scratches with NULL if not
 allocated
Message-ID: <YxAyd6++6oWPu9L1@gondor.apana.org.au>
References: <00000000000092839d0581fd74ad@google.com>
 <20220901040307.4674-1-khalid.masum.92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901040307.4674-1-khalid.masum.92@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 10:03:07AM +0600, Khalid Masum wrote:
> 
> diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> index cb40ff0ff28d..3774d07c5819 100644
> --- a/net/xfrm/xfrm_ipcomp.c
> +++ b/net/xfrm/xfrm_ipcomp.c
> @@ -203,6 +203,7 @@ static void ipcomp_free_scratches(void)
>  		vfree(*per_cpu_ptr(scratches, i));
>  
>  	free_percpu(scratches);
> +	ipcomp_scratches = NULL;
>  }

Good catch! This is probably the root cause of all the crashes.

>  static void * __percpu *ipcomp_alloc_scratches(void)
> @@ -215,7 +216,7 @@ static void * __percpu *ipcomp_alloc_scratches(void)
>  
>  	scratches = alloc_percpu(void *);
>  	if (!scratches)
> -		return NULL;
> +		return ipcomp_scratches = NULL;

This is unnecessary as with your first hunk, ipcomp_scratches
is guaranteed to be NULL.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
