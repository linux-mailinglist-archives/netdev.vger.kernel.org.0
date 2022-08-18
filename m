Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE95598155
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244051AbiHRKKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244008AbiHRKKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:10:36 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498655727A
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:10:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0AF7120613;
        Thu, 18 Aug 2022 12:10:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IoM09R_YrHb1; Thu, 18 Aug 2022 12:10:32 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 06D54201A0;
        Thu, 18 Aug 2022 12:10:32 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id E852780004A;
        Thu, 18 Aug 2022 12:10:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 12:10:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 18 Aug
 2022 12:10:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5005F3182AA7; Thu, 18 Aug 2022 12:10:31 +0200 (CEST)
Date:   Thu, 18 Aug 2022 12:10:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220818101031.GC566407@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220816195408.56eec0ed@kernel.org>
 <Yvx6+qLPWWfCmDVG@unreal>
 <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yv3M/T5K/f35R5UM@unreal>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 08:24:13AM +0300, Leon Romanovsky wrote:
> On Wed, Aug 17, 2022 at 11:10:52AM -0700, Jakub Kicinski wrote:
> > On Wed, 17 Aug 2022 08:22:02 +0300 Leon Romanovsky wrote:
> > > On Tue, Aug 16, 2022 at 07:54:08PM -0700, Jakub Kicinski wrote:
> > > > This is making a precedent for full tunnel offload in netdev, right?  
> > > 
> > > Not really. SW IPsec supports two modes: tunnel and transport.
> > > 
> > > However HW and SW stack supports only offload of transport mode.
> > > This is the case for already merged IPsec crypto offload mode and
> > > the case for this full offload.
> > 
> > My point is on what you called "full offload" vs "crypto offload".
> > The policy so far has always been that Linux networking stack should
> > populate all the headers and instruct the device to do crypto, no
> > header insertion. Obviously we do header insertion in switch/router
> > offloads but that's different and stateless.
> > 
> > I believe the reasoning was to provide as much flexibility and control
> > to the software as possible while retaining most of the performance
> > gains.
> 
> I honestly don't know the reasoning, but "performance gains" are very
> limited as long as IPsec stack involved with various policy/state
> lookups. These lookups are expensive in terms of CPU and they can't
> hold 400 Gb/s line rate.

Can you provide some performance results that show the difference
between crypto and full offload? In particular because on the TX
path, the full policy and state offload is done twice (in software
to find the offloading device and then in hardware to match policy
to state).

> 
> https://docs.nvidia.com/networking/display/connectx7en/Introduction#Introduction-ConnectX-7400GbEAdapterCards
> 
> > 
> > You must provide a clear analysis (as in examination in data) and
> > discussion (as in examination in writing) if you're intending to 
> > change the "let's keep packet formation in the SW" policy. What you 
> > got below is a good start but not sufficient.

I'm still a bit unease about this approach. I fear that doing parts
of statefull IPsec procesing in software and parts in hardware will
lead to all sort of problems. E.g. with this implementation
the software has no stats, liftetime, lifebyte and packet count
information but is responsible to do the IKE communication.

We might be able to sort out all problems during the upstraming
process, but I still have no clear picture how this should work
in the end with all corener cases this creates.

Also the name full offload is a bit missleading, because the
software still has to hold all offloaded states and policies.
In a full offload, the stack would IMO just act as a stub
layer between IKE and hardware.

> > > Some of them:
> > > 1. Request to have reqid for policy and state. I use reqid for HW
> > > matching between policy and state.
> > 
> > reqid?
> 
> Policy and state are matched based on their selectors (src/deet IP, direction ...),
> but they independent. The reqid is XFRM identification that this specific policy
> is connected to this specific state.
> https://www.man7.org/linux/man-pages/man8/ip-xfrm.8.html
> https://docs.kernel.org/networking/xfrm_device.html
> ip x s add ....
>    reqid 0x07 ...
>    offload dev eth4 dir in

Can you elaborate this a bit more? Does that matching happen in
hardware? The reqid is not a unique identifyer to match between
policy and state. You MUST match the selectors as defined in 
https://www.rfc-editor.org/rfc/rfc4301

