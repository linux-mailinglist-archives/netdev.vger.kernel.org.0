Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC2B635265
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 09:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiKWIYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 03:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbiKWIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 03:24:03 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB09765B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 00:24:01 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AF57720538;
        Wed, 23 Nov 2022 09:23:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cROTDfGhZL20; Wed, 23 Nov 2022 09:23:59 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 29C3420299;
        Wed, 23 Nov 2022 09:23:59 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2414680004A;
        Wed, 23 Nov 2022 09:23:59 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:23:59 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 09:23:58 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5F7F63182F8F; Wed, 23 Nov 2022 09:23:58 +0100 (CET)
Date:   Wed, 23 Nov 2022 09:23:58 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221123082358.GL424616@gauss3.secunet.de>
References: <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <20221121121040.GY704954@gauss3.secunet.de>
 <Y3t7aSUBPXPoR8VD@unreal>
 <Y3xQGEZ7izv/JAAX@gondor.apana.org.au>
 <Y3xr5DkA+EZXEfkZ@unreal>
 <20221122130002.GM704954@gauss3.secunet.de>
 <Y3zUosZQhPyoE53C@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3zUosZQhPyoE53C@unreal>
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

On Tue, Nov 22, 2022 at 03:54:42PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 22, 2022 at 02:00:02PM +0100, Steffen Klassert wrote:
> > On Tue, Nov 22, 2022 at 08:27:48AM +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 22, 2022 at 12:29:12PM +0800, Herbert Xu wrote:
> > > > On Mon, Nov 21, 2022 at 03:21:45PM +0200, Leon Romanovsky wrote:
> > 
> > Can you please explain why we need host interaction for
> > transport, but not for tunnel mode?
> 
> The main difference is that in transport mode, you must bring packet
> to the kernel in which you configured SA/policy. It means that we must
> ensure that such packets won't be checked again in SW because all packets
> (encrypted and not) pass XFRM logic.
> 
>  - wire -> RX NIC -> kernel -> XFRM stack (we need HW DB here to skip this stage) -> ....
>  ... -> kernel -> XFRM stack (skip for HW SA/policies) -> TX NIC -> wire.
> 
> In tunnel mode, we arrive to XFRM when nothing IPsec related is configured.
> 
>  - wire -> RX PF NIC -> eswitch NIC logic -> TX uplink NIC -> RX
>    representors -> XFRM stack in VM (nothing configured here) -> kernel

Forget about eswitch, VM, etc. for a moment. I'm interested how the
simplest possible tunnel mode cases will work.

Forwarding:

wire -> random NIC RX -> kernel -> IPsec tunnel offload NIC TX -> wire
wire -> IPsec tunnel offload NIC RX -> kernel -> random NIC TX -> wire

Local endpoints:

Application -> kernel -> IPsec tunnel offload NIC TX -> wire
wire -> IPsec tunnel offload NIC RX -> kernel -> Application

These two must work, so how are these cases handled?

If you can do more fancy things with tunnel mode and special NICs
at TX and RX, that's fine but not absolutely required.
