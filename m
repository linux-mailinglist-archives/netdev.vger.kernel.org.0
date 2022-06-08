Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72C5542819
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiFHHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348783AbiFHGNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:13:45 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3A2DA608;
        Tue,  7 Jun 2022 22:39:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 07DE42059C;
        Wed,  8 Jun 2022 07:39:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tChzzvgOgNwg; Wed,  8 Jun 2022 07:39:39 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DD1F420581;
        Wed,  8 Jun 2022 07:39:39 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D5B9580004A;
        Wed,  8 Jun 2022 07:39:39 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 8 Jun 2022 07:39:39 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 8 Jun
 2022 07:39:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3F3B83182CC9; Wed,  8 Jun 2022 07:39:39 +0200 (CEST)
Date:   Wed, 8 Jun 2022 07:39:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] net: xfrm: unexport __init-annotated
 xfrm4_protocol_init()
Message-ID: <20220608053939.GM680067@gauss3.secunet.de>
References: <20220606045355.4160711-1-masahiroy@kernel.org>
 <20220606045355.4160711-3-masahiroy@kernel.org>
 <52e02030f7b2c0052472f127dae91fb9f5312b85.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52e02030f7b2c0052472f127dae91fb9f5312b85.camel@redhat.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 01:18:32PM +0200, Paolo Abeni wrote:
> On Mon, 2022-06-06 at 13:53 +0900, Masahiro Yamada wrote:
> > EXPORT_SYMBOL and __init is a bad combination because the .init.text
> > section is freed up after the initialization. Hence, modules cannot
> > use symbols annotated __init. The access to a freed symbol may end up
> > with kernel panic.
> > 
> > modpost used to detect it, but it has been broken for a decade.
> > 
> > Recently, I fixed modpost so it started to warn it again, then this
> > showed up in linux-next builds.
> > 
> > There are two ways to fix it:
> > 
> >   - Remove __init
> >   - Remove EXPORT_SYMBOL
> > 
> > I chose the latter for this case because the only in-tree call-site,
> > net/ipv4/xfrm4_policy.c is never compiled as modular.
> > (CONFIG_XFRM is boolean)
> > 
> > Fixes: 2f32b51b609f ("xfrm: Introduce xfrm_input_afinfo to access the the callbacks properly")
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> @Steffen: are you ok if we take this one in the -net tree directly?
> Otherwise a repost would probably be the better option, with this patch
> stand-alone targeting the ipsec tree and the other 2 targeting -net.

Yes, just take it.

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
