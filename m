Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3815E91E5
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 11:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiIYJfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 05:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiIYJe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 05:34:59 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9771A80E
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 02:34:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DE4742052E;
        Sun, 25 Sep 2022 11:34:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KpPQbahBCuiE; Sun, 25 Sep 2022 11:34:55 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5BDE020504;
        Sun, 25 Sep 2022 11:34:55 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 43B1380004A;
        Sun, 25 Sep 2022 11:34:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 25 Sep 2022 11:34:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 25 Sep
 2022 11:34:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 872893182DAE; Sun, 25 Sep 2022 11:34:54 +0200 (CEST)
Date:   Sun, 25 Sep 2022 11:34:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 6/8] xfrm: enforce separation between
 priorities of HW/SW policies
Message-ID: <20220925093454.GU2602992@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <1b9d865971972a63eaa2c076afd71743952bd3c8.1662295929.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1b9d865971972a63eaa2c076afd71743952bd3c8.1662295929.git.leonro@nvidia.com>
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

On Sun, Sep 04, 2022 at 04:15:40PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Devices that implement IPsec full offload mode offload policies too.
> In RX path, it causes to the situation that HW can't effectively handle
> mixed SW and HW priorities unless users make sure that HW offloaded
> policies have higher priorities.
> 
> In order to make sure that users have coherent picture, let's require
> that HW offloaded policies have always (both RX and TX) higher priorities
> than SW ones.
> 
> To do not over engineer the code, HW policies are treated as SW ones and
> don't take into account netdev to allow reuse of same priorities for
> different devices.

I think we should split HW and SW SPD (and maybe even SAD) and priorize
over the SPDs instead of doing that in one single SPD. Each NIC should
maintain its own databases and we should do the lookups from SW with
a callback. With the current approach, we still do the costly full
policy and state lookup on the TX side in software. On a 'full offload'
that should happen in HW too. Also, that will make things easier with
tunnel mode whre we can have overlapping traffic selectors.

We can keep a HW SPD in software as a fallback for devices that don't
support the offloaded lookup, but on the long run lookups for the  RX
anf TX path should happen in HW.

