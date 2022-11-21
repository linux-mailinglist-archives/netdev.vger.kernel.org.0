Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDC16320A3
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiKULb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiKULaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:30:55 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EF8BEAF1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:25:24 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CB80B200BB;
        Mon, 21 Nov 2022 12:25:22 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id amqzpH2kfdCn; Mon, 21 Nov 2022 12:25:22 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 483F42006F;
        Mon, 21 Nov 2022 12:25:22 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 431F280004A;
        Mon, 21 Nov 2022 12:25:22 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 12:25:22 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 12:25:21 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 780A331829DB; Mon, 21 Nov 2022 12:25:21 +0100 (CET)
Date:   Mon, 21 Nov 2022 12:25:21 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221121112521.GX704954@gauss3.secunet.de>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
 <Y3YuVcj5uNRHS7Ek@unreal>
 <20221118104907.GR704954@gauss3.secunet.de>
 <Y3p9LvAEQMAGeaCR@unreal>
 <20221121094404.GU704954@gauss3.secunet.de>
 <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3td2OjeIL0GN7uO@unreal>
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

On Mon, Nov 21, 2022 at 01:15:36PM +0200, Leon Romanovsky wrote:
> On Mon, Nov 21, 2022 at 12:09:26PM +0100, Steffen Klassert wrote:
> > On Mon, Nov 21, 2022 at 12:27:01PM +0200, Leon Romanovsky wrote:
> > > On Mon, Nov 21, 2022 at 10:44:04AM +0100, Steffen Klassert wrote:
> > > > On Sun, Nov 20, 2022 at 09:17:02PM +0200, Leon Romanovsky wrote:
> > > > > On Fri, Nov 18, 2022 at 11:49:07AM +0100, Steffen Klassert wrote:
> > > > > > On Thu, Nov 17, 2022 at 02:51:33PM +0200, Leon Romanovsky wrote:
> > > > > > > On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> > > > > > > > On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > 
> > > > > > > > So this raises the question how to handle acquires with this packet
> > > > > > > > offload. 
> > > > > > > 
> > > > > > > We handle acquires as SW policies and don't offload them.
> > > > > > 
> > > > > > We trigger acquires with states, not policies. The thing is,
> > > > > > we might match a HW policy but create a SW acquire state.
> > > > > > This will not match anymore as soon as the lookup is
> > > > > > implemented correctly.
> > > > > 
> > > > > For now, all such packets will be dropped as we have offlaoded
> > > > > policy but not SA.
> > > > 
> > > > I think you missed my point. If the HW policy does not match
> > > > the SW acquire state, then each packet will geneate a new
> > > > acquire. So you need to make sure that policy and acquire
> > > > state will match to send the acquire just once to userspace.
> > > 
> > > I think that I'm still missing the point.
> > > 
> > > We require both policy and SA to be offloaded. It means that once
> > > we hit HW policy, we must hit SA too (at least this is how mlx5 part
> > > is implemented).
> > 
> > Let's assume a packet hits a HW policy. Then this HW policy must match
> > a HW state. In case there is no matching HW state, we generate an acquire
> > and insert a larval state. Currently, larval states are never marked as HW.
> 
> And this is there our views are different. If HW (in RX) sees policy but
> doesn't have state, this packet will be dropped in HW. It won't get to
> stack and no acquire request will be issues.

This makes no sense. Acquires are always generated at TX, never at RX.

On RX, the state lookup happens first, the policy must match to the
decapsulated packet.

