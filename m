Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4EC5FD495
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 08:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJMGQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 02:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiJMGQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 02:16:37 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6252257575;
        Wed, 12 Oct 2022 23:16:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 896392052E;
        Thu, 13 Oct 2022 08:16:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tbJE7XzYVTHr; Thu, 13 Oct 2022 08:16:34 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0FDB02050A;
        Thu, 13 Oct 2022 08:16:34 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 016E680004A;
        Thu, 13 Oct 2022 08:16:34 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 08:16:33 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 13 Oct
 2022 08:16:33 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 244673180C45; Thu, 13 Oct 2022 08:16:33 +0200 (CEST)
Date:   Thu, 13 Oct 2022 08:16:33 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Christian Langrock <christian.langrock@secunet.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ipsec v6] xfrm: replay: Fix ESN wrap around for GSO
Message-ID: <20221013061633.GS2950045@gauss3.secunet.de>
References: <6810817b-e6b7-feac-64f8-c83c517ae9a5@secunet.com>
 <Y0aI2bGb24M5vA7B@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y0aI2bGb24M5vA7B@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 05:28:57PM +0800, Herbert Xu wrote:
> On Fri, Oct 07, 2022 at 04:50:15PM +0200, Christian Langrock wrote:
> > When using GSO it can happen that the wrong seq_hi is used for the last
> > packets before the wrap around. This can lead to double usage of a
> > sequence number. To avoid this, we should serialize this last GSO
> > packet.
> > 
> > Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
> > Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
> > Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> > ---
> > Changes in v6:
> >  - move overflow check to offloading path to avoid locking issues
> > 
> > Changes in v5:
> >  - Fix build
> > 
> > Changes in v4:
> >  - move changelog within comment
> >  - add reviewer
> > 
> > Changes in v3:
> > - fix build
> > - remove wrapper function
> > 
> > Changes in v2:
> > - switch to bool as return value
> > - remove switch case in wrapper function
> > ---
> >  net/ipv4/esp4_offload.c |  3 +++
> >  net/ipv6/esp6_offload.c |  3 +++
> >  net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
> >  net/xfrm/xfrm_replay.c  |  2 +-
> >  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> Could you please explain how this code restructure makes it safe
> with respect to multiple users of the same xfrm_state?

That is because with this patch, the sequence number from the xfrm_state
is assigned to the skb and advanced by the number of segments while
holding the state lock, as it was before. The sequence numbers this
patch operates on are exclusive and private to that skb (and its
segments). The next skb will checkout the correct number from the
xfrm_state regardless on which cpu it comes.
