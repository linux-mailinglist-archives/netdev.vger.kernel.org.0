Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ECA6E72D8
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDSGGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDSGGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:06:43 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A722F59F5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:06:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CD3CF20847;
        Wed, 19 Apr 2023 08:06:40 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HwxyE5Ibq8Kw; Wed, 19 Apr 2023 08:06:40 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 649B1207BB;
        Wed, 19 Apr 2023 08:06:40 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 5F14480004A;
        Wed, 19 Apr 2023 08:06:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 08:06:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Apr
 2023 08:06:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 851773182BFB; Wed, 19 Apr 2023 08:06:39 +0200 (CEST)
Date:   Wed, 19 Apr 2023 08:06:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     Martin Willi <martin@strongswan.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec v2] xfrm: Preserve xfrm interface secpath for
 packets forwarded
Message-ID: <ZD+E78dbXrUWR5mq@gauss3.secunet.de>
References: <20230412085615.124791-1-martin@strongswan.org>
 <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
 <CANrj0bYFzrLsVx=VPY1FR8VpmQ7CYeJWDKv6iE3fPxBFh26qVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANrj0bYFzrLsVx=VPY1FR8VpmQ7CYeJWDKv6iE3fPxBFh26qVQ@mail.gmail.com>
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

On Mon, Apr 17, 2023 at 03:01:26PM -0700, Benedict Wong wrote:
> I believe I have a potential solution that caches the policy matches,
> rather than clearing the secpath, which should allow for repeated
> matches against a secpath entry, while allowing other already-matched
> secpath entries to not need to match nested policies. That should
> solve for the general case where the secpath gets checked against
> policies multiple times (both in the forwarding case, as well as in
> the nested transport mode in tunnel mode case.
> 
> Forgive my not knowing of convention; should I send that as a separate
> patch, or append it as a reply to this thread?

Send it as a separate patch.

Thanks!
