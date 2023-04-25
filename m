Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10D66EDBDA
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 08:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjDYGrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 02:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjDYGrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 02:47:21 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26725FF0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 23:47:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BF5BE20826;
        Tue, 25 Apr 2023 08:47:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oQ_w2QYaMTCZ; Tue, 25 Apr 2023 08:47:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E956B20547;
        Tue, 25 Apr 2023 08:47:16 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id DB14280004A;
        Tue, 25 Apr 2023 08:47:16 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 08:47:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 25 Apr
 2023 08:47:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D11083182BD0; Tue, 25 Apr 2023 08:47:15 +0200 (CEST)
Date:   Tue, 25 Apr 2023 08:47:15 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Tobias Brunner <tobias@strongswan.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: Ensure consistent address families when
 resolving templates
Message-ID: <ZEd3c8j+ceBvObeM@gauss3.secunet.de>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 01:34:44PM +0800, Herbert Xu wrote:
> On Mon, Apr 24, 2023 at 03:23:02PM +0200, Tobias Brunner wrote:
> > xfrm_state_find() uses `encap_family` of the current template with
> > the passed local and remote addresses to find a matching state.
> > This check makes sure that there is no mismatch and out-of-bounds
> > read in mixed-family scenarios where optional tunnel or BEET mode
> > templates were skipped that would have changed the addresses to
> > match the current template's family.
> > 
> > This basically enforces the same check as validate_tmpl(), just at
> > runtime when one or more optional templates might have been skipped.
> > 
> > Signed-off-by: Tobias Brunner <tobias@strongswan.org>
> > ---
> >  net/xfrm/xfrm_policy.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> 
> I'm confused.  By skipping, you're presumably referring to IPcomp.
> 
> For IPcomp, skipping should only occur on inbound, but your patch
> is changing a code path that's only invoked for outbound.  What's
> going on?

The problem is, that you can configure it for outbound too.
Even though, it does not make much sense. syzbot reported
a stack-out-of-bounds issue with intermediate optional
templates that change the address family:

https://www.spinics.net/lists/netdev/msg890567.html

I tried to fix this by rejecting such a configuration:

https://lore.kernel.org/netdev/ZCZ79IlUW53XxaVr@gauss3.secunet.de/T/

This broke some strongswan configurations.

Tobias patch is the next attempt to fix that.
