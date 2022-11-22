Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35999633D00
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiKVNAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKVNAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:00:06 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F6D61BAD
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:00:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 15D442050A;
        Tue, 22 Nov 2022 14:00:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ynCHNK0nfLyI; Tue, 22 Nov 2022 14:00:03 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 897B620299;
        Tue, 22 Nov 2022 14:00:03 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8134580004A;
        Tue, 22 Nov 2022 14:00:03 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 14:00:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 22 Nov
 2022 14:00:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A820331829DB; Tue, 22 Nov 2022 14:00:02 +0100 (CET)
Date:   Tue, 22 Nov 2022 14:00:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221122130002.GM704954@gauss3.secunet.de>
References: <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <20221121121040.GY704954@gauss3.secunet.de>
 <Y3t7aSUBPXPoR8VD@unreal>
 <Y3xQGEZ7izv/JAAX@gondor.apana.org.au>
 <Y3xr5DkA+EZXEfkZ@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3xr5DkA+EZXEfkZ@unreal>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 08:27:48AM +0200, Leon Romanovsky wrote:
> On Tue, Nov 22, 2022 at 12:29:12PM +0800, Herbert Xu wrote:
> > On Mon, Nov 21, 2022 at 03:21:45PM +0200, Leon Romanovsky wrote:
> > >
> > > The thing is that this SW acquire flow is a fraction case, as it applies
> > > to locally generated traffic.
> > 
> > A router can trigger an acquire on forwarded packets too.  Without
> > larvals this could quickly overwhelm the router.
> 
> This series doesn't support tunnel mode yet.

It does not matter if tunnel or transport mode, acquires must
work as expected. This is a fundamental concept of IPsec, there
is no way to tell userspace that we don't support this.

> Maybe I was not clear, but I wanted to say what in eswitch case and
> tunnel mode, the packets will be handled purely by HW without raising
> into SW core.

Can you please explain why we need host interaction for
transport, but not for tunnel mode?

Staying away with HW policies and states from SW databases is what
I wanted to have from the beginning. If that is possible for tunnel
mode, it should be possible for transport mode too.

And as said already, I want to see the full picture (transport
+ tunnel mode) before we merge it.
