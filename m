Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8241162D383
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 07:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiKQGcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 01:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKQGcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 01:32:36 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AEF264A2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 22:32:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4C4102052E;
        Thu, 17 Nov 2022 07:32:32 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yvQxfJA9EZON; Thu, 17 Nov 2022 07:32:31 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C409820501;
        Thu, 17 Nov 2022 07:32:31 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id BE6A180004A;
        Thu, 17 Nov 2022 07:32:31 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 07:32:31 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 07:32:31 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 04ED7318194B; Thu, 17 Nov 2022 07:32:30 +0100 (CET)
Date:   Thu, 17 Nov 2022 07:32:30 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Antony Antony <antony.antony@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "Leon Romanovsky" <leon@kernel.org>, Roth Mark <rothm@mail.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Tobias Brunner <tobias@strongswan.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: Fix oops in __xfrm_state_delete()
Message-ID: <20221117063230.GC704954@gauss3.secunet.de>
References: <20221031152612.o3h44x3whath4iyp@intra2net.com>
 <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
 <Y2FvHZiWejxRiIS8@moon.secunet.de>
 <Y2IXTc1M6K7KaQwW@gondor.apana.org.au>
 <20221102083159.2rqu6j27weg2cxtq@intra2net.com>
 <20221102101848.ibvumaxg2jdvk52y@intra2net.com>
 <Y2SYiVHXyKR48MZ8@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2SYiVHXyKR48MZ8@gondor.apana.org.au>
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

On Fri, Nov 04, 2022 at 12:43:53PM +0800, Herbert Xu wrote:
> On Wed, Nov 02, 2022 at 11:18:48AM +0100, Thomas Jarosch wrote:
...
> > 
> > Fixes: fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")
> > Reported-by: Roth Mark <rothm@mail.com>
> > Reported-by: Zhihao Chen <chenzhihao@meizu.com>
> > Tested-by: Roth Mark <rothm@mail.com>
> > Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> > ---
> >  net/key/af_key.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks everyone!
