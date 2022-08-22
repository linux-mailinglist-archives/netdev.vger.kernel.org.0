Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A4559BBBB
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiHVIeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiHVIes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:34:48 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648FA2BB30
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:34:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AF8622052E;
        Mon, 22 Aug 2022 10:34:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WOq-wzV2f-df; Mon, 22 Aug 2022 10:34:44 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D799920504;
        Mon, 22 Aug 2022 10:34:44 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id C48FC80004A;
        Mon, 22 Aug 2022 10:34:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 22 Aug 2022 10:34:44 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 22 Aug
 2022 10:34:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F173A3182A10; Mon, 22 Aug 2022 10:34:43 +0200 (CEST)
Date:   Mon, 22 Aug 2022 10:34:43 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220822083443.GH2602992@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220818100930.GA622211@gauss3.secunet.de>
 <Yv4+D+2d3HPQKymx@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yv4+D+2d3HPQKymx@unreal>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Thu, Aug 18, 2022 at 04:26:39PM +0300, Leon Romanovsky wrote:
> On Thu, Aug 18, 2022 at 12:09:30PM +0200, Steffen Klassert wrote:
> > Hi Leon,
> > 
> > On Tue, Aug 16, 2022 at 11:59:21AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Changelog:
> > > v2:
> > >  * Rebased to latest 6.0-rc1
> > >  * Add an extra check in TX datapath patch to validate packets before
> > >    forwarding to HW.
> > >  * Added policy cleanup logic in case of netdev down event 
> > > v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com 
> > >  * Moved comment to be before if (...) in third patch.
> > > v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> > > -----------------------------------------------------------------------
> > > 
> > > The following series extends XFRM core code to handle new type of IPsec
> > > offload - full offload.
> > > 
> > > In this mode, the HW is going to be responsible for whole data path, so
> > > both policy and state should be offloaded.
> > 
> > some general comments about the pachset:
> > 
> > As implemented, the software does not hold any state.
> > I.e. there is no sync between hardware and software
> > regarding stats, liftetime, lifebyte, packet counts
> > and replay window. IKE rekeying and auditing is based
> > on these, how should this be done?
> 
> This is only rough idea as we only started to implement needed
> support in libreswan, but our plan is to configure IKE with
> highest possible priority 

If it is only a rough idea, then mark it as RFC. I want to see
the whole picture before we merge it. And btw. tunnel mode
belongs to the whoule picture too.

> 
> > 
> > I have not seen anything that catches configurations
> > that stack multiple tunnels with the outer offloaded.
> > 
> > Where do we make sure that policy offloading device
> > is the same as the state offloading device?
> 
> It is configuration error and we don't check it. Should we?

We should at least make sure to not send out packets untransformed
in this case.
