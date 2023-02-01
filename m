Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6084B68617F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjBAIVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjBAIVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:21:10 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD185DC3C
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:21:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0626B2053B;
        Wed,  1 Feb 2023 09:21:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kySkMQ06Eg1H; Wed,  1 Feb 2023 09:21:01 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 85CDB20536;
        Wed,  1 Feb 2023 09:21:01 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 7729580004A;
        Wed,  1 Feb 2023 09:21:01 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 1 Feb 2023 09:21:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 09:21:00 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 773763180247; Wed,  1 Feb 2023 09:21:00 +0100 (CET)
Date:   Wed, 1 Feb 2023 09:21:00 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Christian Hopps <chopps@chopps.org>,
        "David S. Miller" <davem@davemloft.net>, <devel@linux-ipsec.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <chopps@labn.net>
Subject: Re: [PATCH ipsec-next v2] xfrm: fix bug with DSCP copy to v6 from v4
 tunnel
Message-ID: <Y9og7DV58e0KNPUB@gauss3.secunet.de>
References: <20230126102933.1245451-1-chopps@labn.net>
 <20230126163350.1520752-1-chopps@chopps.org>
 <Y9R9goAfEJ6ck+Z9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y9R9goAfEJ6ck+Z9@gondor.apana.org.au>
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

On Sat, Jan 28, 2023 at 09:42:26AM +0800, Herbert Xu wrote:
> On Thu, Jan 26, 2023 at 11:33:50AM -0500, Christian Hopps wrote:
> > When copying the DSCP bits for decap-dscp into IPv6 don't assume the
> > outer encap is always IPv6. Instead, as with the inner IPv4 case, copy
> > the DSCP bits from the correctly saved "tos" value in the control block.
> > 
> > Fixes: 227620e29509 ("[IPSEC]: Separate inner/outer mode processing on input")
> > 
> > Signed-off-by: Christian Hopps <chopps@chopps.org>
> > ---
> >  net/xfrm/xfrm_input.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

I've applied the version with the 'Fixes' tag to the
ipsec tree, thanks everyone!
