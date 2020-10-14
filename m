Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D263828D9C1
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 08:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJNGAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 02:00:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53678 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgJNGAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 02:00:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0D83B205F0;
        Wed, 14 Oct 2020 08:00:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sO4fBeIkcs9y; Wed, 14 Oct 2020 08:00:07 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AA3EF2058E;
        Wed, 14 Oct 2020 08:00:03 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 08:00:03 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 14 Oct
 2020 08:00:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E272B31845E2; Wed, 14 Oct 2020 08:00:02 +0200 (CEST)
Date:   Wed, 14 Oct 2020 08:00:02 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     Xin Long <lucien.xin@gmail.com>, <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: interface: fix the priorities for ipip and
 ipv6 tunnels
Message-ID: <20201014060002.GV20687@gauss3.secunet.de>
References: <99c1ec6ed0212992474d19f4e15ef5d077fe99b3.1602144804.git.lucien.xin@gmail.com>
 <20201013092856.GU20687@gauss3.secunet.de>
 <df21f95b-f3eb-d853-49a6-e68b3830f566@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df21f95b-f3eb-d853-49a6-e68b3830f566@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 02:41:18PM +0200, Nicolas Dichtel wrote:
> Le 13/10/2020 à 11:28, Steffen Klassert a écrit :
> > On Thu, Oct 08, 2020 at 04:13:24PM +0800, Xin Long wrote:
> >> As Nicolas noticed in his case, when xfrm_interface module is installed
> >> the standard IP tunnels will break in receiving packets.
> >>
> >> This is caused by the IP tunnel handlers with a higher priority in xfrm
> >> interface processing incoming packets by xfrm_input(), which would drop
> >> the packets and return 0 instead when anything wrong happens.
> >>
> >> Rather than changing xfrm_input(), this patch is to adjust the priority
> >> for the IP tunnel handlers in xfrm interface, so that the packets would
> >> go to xfrmi's later than the others', as the others' would not drop the
> >> packets when the handlers couldn't process them.
> >>
> >> Note that IPCOMP also defines its own IPIP tunnel handler and it calls
> >> xfrm_input() as well, so we must make its priority lower than xfrmi's,
> >> which means having xfrmi loaded would still break IPCOMP. We may seek
> >> another way to fix it in xfrm_input() in the future.
> >>
> >> Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >> Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> >> Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
> >> FIxes: d7b360c2869f ("xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler")
> >> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > 
> > Applied, thanks a lot Xin!
> > 
> Is it possible to queue this for stable branches?

Yes, it will go to stable after it is intergated into the mainline.
