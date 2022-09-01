Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2ED5A912E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiIAHtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiIAHtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:49:15 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821651257E7;
        Thu,  1 Sep 2022 00:48:40 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oTewD-00HUk4-KZ; Thu, 01 Sep 2022 17:48:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Sep 2022 15:48:33 +0800
Date:   Thu, 1 Sep 2022 15:48:33 +0800
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
Subject: Re: [PATCH v4] xfrm: Update ipcomp_scratches with NULL when freed
Message-ID: <YxBj0QAdRaVZCr9i@gondor.apana.org.au>
References: <00000000000092839d0581fd74ad@google.com>
 <20220901071210.8402-1-khalid.masum.92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901071210.8402-1-khalid.masum.92@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 01:12:10PM +0600, Khalid Masum wrote:
> Currently if ipcomp_alloc_scratches() fails to allocate memory
> ipcomp_scratches holds obsolete address. So when we try to free the
> percpu scratches using ipcomp_free_scratches() it tries to vfree non
> existent vm area. Described below:
> 
> static void * __percpu *ipcomp_alloc_scratches(void)
> {
>         ...
>         scratches = alloc_percpu(void *);
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
>         ...
>         scratches = ipcomp_scratches;
> Assigning obsolete address from ipcomp_scratches
> 
>         if (!scratches)
>                 return;
> 
>         for_each_possible_cpu(i)
>                vfree(*per_cpu_ptr(scratches, i));
> Trying to free non existent page, causing warning: trying to vfree
> existent vm area.
>         ...
> }
> 
> Fix this breakage by updating ipcomp_scrtches with NULL when scratches
> is freed
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
> Tested-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com
> Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
