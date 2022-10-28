Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA99610FA0
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJ1L03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJ1L01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:26:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C541C2093;
        Fri, 28 Oct 2022 04:26:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 20E1720573;
        Fri, 28 Oct 2022 13:26:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kGeEpoinJo8B; Fri, 28 Oct 2022 13:26:23 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A04DF20569;
        Fri, 28 Oct 2022 13:26:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9A62280004A;
        Fri, 28 Oct 2022 13:26:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 13:26:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 28 Oct
 2022 13:26:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 078CA3182D7B; Fri, 28 Oct 2022 13:26:23 +0200 (CEST)
Date:   Fri, 28 Oct 2022 13:26:22 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>,
        syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
Subject: Re: [v3 PATCH] af_key: Fix send_acquire race with pfkey_register
Message-ID: <20221028112622.GK2602992@gauss3.secunet.de>
References: <000000000000fd9a4005ebbeac67@google.com>
 <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
 <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
 <Y1YrVGP+5TP7V1/R@gondor.apana.org.au>
 <Y1Y8oN5xcIoMu+SH@hog>
 <Y1d8+FdfgtVCaTDS@gondor.apana.org.au>
 <Y1k4T/rgRz4rkvcl@hog>
 <Y1n+LM57U3HUHMJa@gondor.apana.org.au>
 <CANn89iLVRq28iMzjKBovyDvytH1ssW_Tp0AjoUbv74dFg2wXWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANn89iLVRq28iMzjKBovyDvytH1ssW_Tp0AjoUbv74dFg2wXWQ@mail.gmail.com>
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

On Wed, Oct 26, 2022 at 08:45:57PM -0700, Eric Dumazet wrote:
> On Wed, Oct 26, 2022 at 8:42 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Oct 26, 2022 at 03:38:23PM +0200, Sabrina Dubroca wrote:
> > >
> > > LGTM, thanks.
> > >
> > > Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
> >
> > Thanks for the review and comments!
> 
> SGTM, thanks for the fix.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Applied, thanks everyone!
