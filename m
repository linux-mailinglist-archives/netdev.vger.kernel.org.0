Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387CC4C0E2F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbiBWIZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiBWIZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:25:44 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774B35AED0;
        Wed, 23 Feb 2022 00:25:15 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0358B20527;
        Wed, 23 Feb 2022 09:25:12 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jC4y_vDuKg4B; Wed, 23 Feb 2022 09:25:11 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 86DF220519;
        Wed, 23 Feb 2022 09:25:11 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7E9BB80004A;
        Wed, 23 Feb 2022 09:25:11 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 23 Feb 2022 09:25:11 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 23 Feb
 2022 09:25:10 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8C8803180FB1; Wed, 23 Feb 2022 09:25:10 +0100 (CET)
Date:   Wed, 23 Feb 2022 09:25:10 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Lina Wang <lina.wang@mediatek.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] xfrm: fix tunnel model fragmentation behavior
Message-ID: <20220223082510.GL17351@gauss3.secunet.de>
References: <20220221110405.GJ1223722@gauss3.secunet.de>
 <20220222021803.27965-1-lina.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220222021803.27965-1-lina.wang@mediatek.com>
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

On Tue, Feb 22, 2022 at 10:18:04AM +0800, Lina Wang wrote:
> On Mon, 2022-02-21 at 12:04 +0100, Steffen Klassert wrote:
> > On Mon, Feb 21, 2022 at 01:16:48PM +0800, Lina Wang wrote:
> > > in tunnel mode, if outer interface(ipv4) is less, it is easily to
> We have two commits in the ipsec tree that address a very similar
> > issue. That is:
> > 
> > commit 6596a0229541270fb8d38d989f91b78838e5e9da
> > xfrm: fix MTU regression
> > 
> > and
> > 
> > commit a6d95c5a628a09be129f25d5663a7e9db8261f51
> > Revert "xfrm: xfrm_state_mtu should return at least 1280 for ipv6"
> > 
> > Can you please doublecheck that the issue you are fixing still
> > exist in the ipsec tree?
> 
> Yes, I know the two patches, which didnot help for my scenary. Whatever 
> commit a6d95c5a62 exist or not, there still is double fragment issue. From
> commit 6596a022's mail thread, owner has met double fragment issue, I am 
> not sure if it is the same with mine.

Thanks for the doublecking this!
