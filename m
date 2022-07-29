Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5951358507B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiG2NIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiG2NId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:08:33 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B5310F7;
        Fri, 29 Jul 2022 06:08:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5B75D2057B;
        Fri, 29 Jul 2022 15:08:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7NYllXnDYExq; Fri, 29 Jul 2022 15:08:23 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7A3CE204E5;
        Fri, 29 Jul 2022 15:08:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 704D380004A;
        Fri, 29 Jul 2022 15:08:23 +0200 (CEST)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 15:08:23 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 29 Jul
 2022 15:08:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D284B318103E; Fri, 29 Jul 2022 15:08:22 +0200 (CEST)
Date:   Fri, 29 Jul 2022 15:08:22 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Xiong <xiongx18@fudan.edu.cn>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "=?utf-8?B?4oCcRGF2aWQgUyAu?= Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        James Morris <jmorris@namei.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yuanxzhang@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] xfrm: fix refcount leak in __xfrm_policy_check()
Message-ID: <20220729130822.GC2602992@gauss3.secunet.de>
References: <20220724095557.4350-1-xiongx18@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220724095557.4350-1-xiongx18@fudan.edu.cn>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 05:55:58PM +0800, Xin Xiong wrote:
> The issue happens on an error path in __xfrm_policy_check(). When the
> fetching process of the object `pols[1]` fails, the function simply
> returns 0, forgetting to decrement the reference count of `pols[0]`,
> which is incremented earlier by either xfrm_sk_policy_lookup() or
> xfrm_policy_lookup(). This may result in memory leaks.
> 
> Fix it by decreasing the reference count of `pols[0]` in that path.
> 
> Fixes: 134b0fc544ba ("IPsec: propagate security module errors up from flow_cache_lookup")
> Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied, thanks a lot Xin!
