Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A1A53D5F7
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 09:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiFDHkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 03:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiFDHkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 03:40:06 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DE9275E6;
        Sat,  4 Jun 2022 00:40:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1989B2055E;
        Sat,  4 Jun 2022 09:40:03 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jHU0zutdV4mI; Sat,  4 Jun 2022 09:40:02 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9E1D120322;
        Sat,  4 Jun 2022 09:40:02 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8DF3D80004A;
        Sat,  4 Jun 2022 09:40:02 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 4 Jun 2022 09:40:02 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 4 Jun
 2022 09:40:02 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D343B3182D6B; Sat,  4 Jun 2022 09:40:01 +0200 (CEST)
Date:   Sat, 4 Jun 2022 09:40:01 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Hangyu Hua <hbh25y@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <timo.teras@iki.fi>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: xfrm_policy: fix a possible double
 xfrm_pols_put() in xfrm_bundle_lookup()
Message-ID: <20220604074001.GL680067@gauss3.secunet.de>
References: <20220601064625.26414-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220601064625.26414-1-hbh25y@gmail.com>
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

On Wed, Jun 01, 2022 at 02:46:25PM +0800, Hangyu Hua wrote:
> xfrm_policy_lookup() will call xfrm_pol_hold_rcu() to get a refcount of
> pols[0]. This refcount can be dropped in xfrm_expand_policies() when
> xfrm_expand_policies() return error. pols[0]'s refcount is balanced in
> here. But xfrm_bundle_lookup() will also call xfrm_pols_put() with
> num_pols == 1 to drop this refcount when xfrm_expand_policies() return
> error.
> 
> This patch also fix an illegal address access. pols[0] will save a error
> point when xfrm_policy_lookup fails. This lead to xfrm_pols_put to resolve
> an illegal address in xfrm_bundle_lookup's error path.
> 
> Fix these by setting num_pols = 0 in xfrm_expand_policies()'s error path.
> 
> Fixes: 80c802f3073e ("xfrm: cache bundles instead of policies for outgoing flows")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Applied, thanks!
