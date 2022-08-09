Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735D058D357
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 07:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiHIFrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 01:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiHIFrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 01:47:35 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A351BEAD;
        Mon,  8 Aug 2022 22:47:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7D7D32050A;
        Tue,  9 Aug 2022 07:47:30 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pBNKI6Ghzl_T; Tue,  9 Aug 2022 07:47:29 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A26712008D;
        Tue,  9 Aug 2022 07:47:29 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 977FB80004A;
        Tue,  9 Aug 2022 07:47:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 9 Aug 2022 07:47:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 9 Aug
 2022 07:47:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BC732318053D; Tue,  9 Aug 2022 07:47:28 +0200 (CEST)
Date:   Tue, 9 Aug 2022 07:47:28 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Abhishek Shah <abhishek.shah@columbia.edu>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        Gabriel Ryan <gabe@cs.columbia.edu>,
        Fan Du <fan.du@windriver.com>,
        Steffen Klassert <klassert@kernel.org>
Subject: Re: [PATCH] af_key: Do not call xfrm_probe_algs in parallel
Message-ID: <20220809054728.GX2950045@gauss3.secunet.de>
References: <CAEHB24-9hXY+TgQKxJB4bE9a9dFD9C+Lan+ShBwpvwaHVAGMFg@mail.gmail.com>
 <YtoWqEkKzvimzWS5@gondor.apana.org.au>
 <CAEHB249ygptvp9wpynMF7zZ2Kcet0+bwLVuVg5UReZHOU1+8HA@mail.gmail.com>
 <YuNGR/5U5pSo6YM3@gondor.apana.org.au>
 <YuuZgsdmJK8roKLD@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YuuZgsdmJK8roKLD@gondor.apana.org.au>
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

On Thu, Aug 04, 2022 at 06:03:46PM +0800, Herbert Xu wrote:
> When namespace support was added to xfrm/afkey, it caused the
> previously single-threaded call to xfrm_probe_algs to become
> multi-threaded.  This is buggy and needs to be fixed with a mutex.
> 
> Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
> Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks a lot Herbert!
