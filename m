Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F756EDD18
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjDYHrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbjDYHrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:47:23 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76AA2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:47:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CFD0A2083F;
        Tue, 25 Apr 2023 09:47:04 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xNMyWJjYH4cA; Tue, 25 Apr 2023 09:47:04 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6449520847;
        Tue, 25 Apr 2023 09:47:04 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 5EA6280004A;
        Tue, 25 Apr 2023 09:47:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 09:47:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 25 Apr
 2023 09:47:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A75A63182BD0; Tue, 25 Apr 2023 09:47:03 +0200 (CEST)
Date:   Tue, 25 Apr 2023 09:47:03 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Martin Willi <martin@strongswan.org>
CC:     Benedict Wong <benedictwong@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec v2] xfrm: Preserve xfrm interface secpath for
 packets forwarded
Message-ID: <ZEeFd0vZawjVpluc@gauss3.secunet.de>
References: <20230412085615.124791-1-martin@strongswan.org>
 <CANrj0bb6nGzsQMH3eOHHD_fukynFb0NVS6=+xqGrWmAZ+gco1g@mail.gmail.com>
 <b5972f7bab88300e924853f4d9cca62f36a735cb.camel@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b5972f7bab88300e924853f4d9cca62f36a735cb.camel@strongswan.org>
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

On Tue, Apr 25, 2023 at 09:45:40AM +0200, Martin Willi wrote:
> 
> 
> > [...] my original change also happens to break Transport-in-Tunnel
> > mode (which attempts to match the outer tunnel mode policy twice.). I
> > wonder if it's worth just reverting first
> 
> Given that the offending commit has been picked up by -stable and now
> by distros, I guess this regression will start affecting more IPsec
> users.
> 
> May I suggest to go with a revert of the offending commit as an
> immediate fix, and then bring in a fixed nested policy check from
> Benedict in a separate effort?
> 
> I'll post a patch with the revert.

I'm fine with that.
