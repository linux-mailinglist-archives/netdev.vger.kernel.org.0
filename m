Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D555374E5
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiE3HOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiE3HO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:14:29 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1BF286D0
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:14:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 17D6C205CD;
        Mon, 30 May 2022 09:14:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cJVKQSj2jZds; Mon, 30 May 2022 09:14:25 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3DD502052E;
        Mon, 30 May 2022 09:14:25 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 388FF80004A;
        Mon, 30 May 2022 09:14:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 09:14:25 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 30 May
 2022 09:14:24 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9039E3182D2D; Mon, 30 May 2022 09:14:24 +0200 (CEST)
Date:   Mon, 30 May 2022 09:14:24 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
CC:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "Lorenzo Colitti" <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lina Wang <lina.wang@mediatek.com>
Subject: Re: [PATCH] xfrm: do not set IPv4 DF flag when encapsulating IPv6
 frames <= 1280 bytes.
Message-ID: <20220530071424.GB2517843@gauss3.secunet.de>
References: <20220518210548.2296546-1-zenczykowski@gmail.com>
 <20220526065115.GA680067@gauss3.secunet.de>
 <CANP3RGdt2aOOK80PLcB-Q2ecz-sjyWuN+Wc8h0Kuo7RdUNGSTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGdt2aOOK80PLcB-Q2ecz-sjyWuN+Wc8h0Kuo7RdUNGSTA@mail.gmail.com>
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

On Sat, May 28, 2022 at 02:25:59AM -0700, Maciej Żenczykowski wrote:
> On Wed, May 25, 2022 at 11:51 PM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Wed, May 18, 2022 at 02:05:48PM -0700, Maciej Żenczykowski wrote:
> > > From: Maciej Żenczykowski <maze@google.com>
> > >
> > > One may want to have DF set on large packets to support discovering
> > > path mtu and limiting the size of generated packets (hence not
> > > setting the XFRM_STATE_NOPMTUDISC tunnel flag), while still
> > > supporting networks that are incapable of carrying even minimal
> > > sized IPv6 frames (post encapsulation).
> > >
> > > Having IPv4 Don't Frag bit set on encapsulated IPv6 frames that
> > > are not larger than the minimum IPv6 mtu of 1280 isn't useful,
> > > because the resulting ICMP Fragmentation Required error isn't
> > > actionable (even assuming you receive it) because IPv6 will not
> > > drop it's path mtu below 1280 anyway.  While the IPv4 stack
> > > could prefrag the packets post encap, this requires the ICMP
> > > error to be successfully delivered and causes a loss of the
> > > original IPv6 frame (thus requiring a retransmit and latency
> > > hit).  Luckily with IPv4 if we simply don't set the DF flag,
> > > we'll just make further fragmenting the packets some other
> > > router's problems.
> > >
> > > We'll still learn the correct IPv4 path mtu through encapsulation
> > > of larger IPv6 frames.
> > >
> > > I'm still not convinced this patch is entirely sufficient to make
> > > everything happy... but I don't see how it could possibly
> > > make things worse.
> > >
> > > See also recent:
> > >   4ff2980b6bd2 'xfrm: fix tunnel model fragmentation behavior'
> > > and friends
> > >
> > > Bug: 203183943
> > > Cc: Lorenzo Colitti <lorenzo@google.com>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Lina Wang <lina.wang@mediatek.com>
> > > Cc: Steffen Klassert <steffen.klassert@secunet.com>
> > > Signed-off-by: Maciej Zenczykowski <maze@google.com>
> >
> > Applied, thanks a lot!
> 
> Thanks.
> 
> Is this published somewhere, since I'd lack to backport it to Android
> Common Kernel 5.10+, but can't find a sha1 (yet?)

Actually I applied it, but forgot to push it out.
It is now in the ipsec tree:

git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git
