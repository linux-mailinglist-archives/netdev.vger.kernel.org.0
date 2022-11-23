Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61A6352D3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 09:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiKWIhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 03:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKWIhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 03:37:24 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77531EA117
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 00:37:23 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 239F120299;
        Wed, 23 Nov 2022 09:37:22 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wvUohj_INyBY; Wed, 23 Nov 2022 09:37:21 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A021320184;
        Wed, 23 Nov 2022 09:37:21 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 9A59A80004A;
        Wed, 23 Nov 2022 09:37:21 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:37:21 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 09:37:21 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E0BC03182F8F; Wed, 23 Nov 2022 09:37:20 +0100 (CET)
Date:   Wed, 23 Nov 2022 09:37:20 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <20221123083720.GM424616@gauss3.secunet.de>
References: <Y3tSdcA9GgpOJjgP@unreal>
 <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
 <20221122131002.GN704954@gauss3.secunet.de>
 <Y3zVVzfrR1YKL4Xd@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3zVVzfrR1YKL4Xd@unreal>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 03:57:43PM +0200, Leon Romanovsky wrote:
> On Tue, Nov 22, 2022 at 02:10:02PM +0100, Steffen Klassert wrote:
> > On Mon, Nov 21, 2022 at 03:01:42PM +0200, Leon Romanovsky wrote:
> > > On Mon, Nov 21, 2022 at 01:43:49PM +0100, Steffen Klassert wrote:
> > > > On Mon, Nov 21, 2022 at 02:02:52PM +0200, Leon Romanovsky wrote:
> > > > 
> > > > If policy and state do not match here, this means the lookup
> > > > returned the wrong state. The correct state might still sit
> > > > in the database. At this point, you should either have found
> > > > a matching state, or no state at all.
> > > 
> > > I check for "x" because of "x = NULL" above.
> > 
> > This does not change the fact that the lookup returned the wrong state.
> 
> Steffen, but this is exactly why we added this check - to catch wrong
> states and configurations. 

No, you have to adjust the lookup so that this can't happen.
This is not a missconfiguration, The lookup found the wrong
SA, this is a difference.

Use the offload type and dev as a lookup key and don't consider
SAs that don't match this in the lookup.

This is really not too hard to do. The thing that could be a bit
more difficult is that the lookup should be only adjusted when
we really have HW policies installed. Otherwise this affects
even systems that don't use this kind of offload.
