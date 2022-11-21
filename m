Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195AC631D17
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiKUJoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiKUJoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:44:10 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DE5C775
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:44:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C59352049B;
        Mon, 21 Nov 2022 10:44:05 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aK65mOmtWRYx; Mon, 21 Nov 2022 10:44:05 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3FFF220185;
        Mon, 21 Nov 2022 10:44:05 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 3A31C80004A;
        Mon, 21 Nov 2022 10:44:05 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 10:44:05 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 10:44:04 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6DFD331829DB; Mon, 21 Nov 2022 10:44:04 +0100 (CET)
Date:   Mon, 21 Nov 2022 10:44:04 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221121094404.GU704954@gauss3.secunet.de>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3p9LvAEQMAGeaCR@unreal>
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

On Sun, Nov 20, 2022 at 09:17:02PM +0200, Leon Romanovsky wrote:
> On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> > On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > > So this raises the question how to handle acquires with this packet
> > > > offload. 
> > > 
> > > We handle acquires as SW policies and don't offload them.
> > 
> > We trigger acquires with states, not policies. The thing is,
> > we might match a HW policy but create a SW acquire state.
> > This will not match anymore as soon as the lookup is
> > implemented correctly.
> 
> For now, all such packets will be dropped as we have offlaoded
> policy but not SA.

I think you missed my point. If the HW policy does not match
the SW acquire state, then each packet will geneate a new
acquire. So you need to make sure that policy and acquire
state will match to send the acquire just once to userspace.

> > > It is not different from any other kernel code, bugs will be fixed.
> > 
> > The thing that is different here is, that the concept is already
> > broken. We can't split the datapath to be partially handled in
> > SW and HW in any sane way, this becomes clearer and clearer.
> > 
> > The full protocol offload simply does not fit well into HW,
> > but we try to make it fit with a hammer. This is the problem
> > why I do not really like this, and is also the reason why this
> > is still not merged. We might be much better of by doing a
> > HW frindly redesign of the protocol and offload this then.
> > But, yes that takes time and will have issues too.
> 
> When you say "protocol", what do you mean? Many users, who have
> deployed IPsec solutions, just want to have same look and feel
> but much faster.
> 
> I truly believe that this packet offload fits SW model and the
> (small) amount of changes supports it. There are almost no changes
> to the stack to natively support this offload.
> 
> As long as HW involved, you will never have solution without issues,
> and like you said even redesign "will have issues".

Things would be much easier, if we don't need to add HW policies
and states to SW databases. But yes, a redesign might have issues
too. That's why we are still working on the current soluion :)

