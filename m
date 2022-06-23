Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD770557823
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiFWKtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiFWKtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:49:52 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD764B1E2;
        Thu, 23 Jun 2022 03:49:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3D6DE20624;
        Thu, 23 Jun 2022 12:49:50 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c7xdIbu5WkPm; Thu, 23 Jun 2022 12:49:49 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8989920606;
        Thu, 23 Jun 2022 12:49:49 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 77A4B80004A;
        Thu, 23 Jun 2022 12:49:49 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 23 Jun 2022 12:49:49 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 23 Jun
 2022 12:49:49 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C2CA53182CD5; Thu, 23 Jun 2022 12:49:48 +0200 (CEST)
Date:   Thu, 23 Jun 2022 12:49:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] xfrm: convert alg_key to flexible array member
Message-ID: <20220623104948.GD566407@gauss3.secunet.de>
References: <20220524204741.980721-1-stephen@networkplumber.org>
 <20220602104515.GI91220@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220602104515.GI91220@gauss3.secunet.de>
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

On Thu, Jun 02, 2022 at 12:45:15PM +0200, Steffen Klassert wrote:
> On Tue, May 24, 2022 at 01:47:40PM -0700, Stephen Hemminger wrote:
> > Iproute2 build generates a warning when built with gcc-12.
> > This is because the alg_key in xfrm.h API has zero size
> > array element instead of flexible array.
> > 
> >     CC       xfrm_state.o
> > In function ‘xfrm_algo_parse’,
> >     inlined from ‘xfrm_state_modify.constprop’ at xfrm_state.c:573:5:
> > xfrm_state.c:162:32: warning: writing 1 byte into a region of size 0 [-Wstringop-overflow=]
> >   162 |                         buf[j] = val;
> >       |                         ~~~~~~~^~~~~
> > 
> > This patch convert the alg_key into flexible array member.
> > There are other zero size arrays here that should be converted as
> > well.
> > 
> > This patch is RFC only since it is only compile tested and
> > passes trivial iproute2 tests.
> > 
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> 
> I've put this today to our test systems and it showed no problems,
> so we can integrate it after the merge window.

This is now applied to ipsec-next, thanks!
