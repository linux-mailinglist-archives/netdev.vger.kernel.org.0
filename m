Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EC14A7F66
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 07:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243518AbiBCGto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 01:49:44 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37896 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbiBCGtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 01:49:43 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5320F20504;
        Thu,  3 Feb 2022 07:49:42 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YGJeGPFUfIZl; Thu,  3 Feb 2022 07:49:41 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CDE8A20491;
        Thu,  3 Feb 2022 07:49:41 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id BDE0F80004A;
        Thu,  3 Feb 2022 07:49:41 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 3 Feb 2022 07:49:41 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 3 Feb
 2022 07:49:41 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E10593181E69; Thu,  3 Feb 2022 07:49:40 +0100 (CET)
Date:   Thu, 3 Feb 2022 07:49:40 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: delete not-used XFRM_OFFLOAD_IPV6 define
Message-ID: <20220203064940.GW1223722@gauss3.secunet.de>
References: <31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com>
 <20220201065836.GT1223722@gauss3.secunet.de>
 <YfjfqWRVr4KpkQC8@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YfjfqWRVr4KpkQC8@unreal>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 09:22:17AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 01, 2022 at 07:58:36AM +0100, Steffen Klassert wrote:
> > On Thu, Jan 27, 2022 at 08:24:58PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > XFRM_OFFLOAD_IPV6 define was exposed in the commit mentioned in the
> > > fixes line, but it is never been used both in the kernel and in the
> > > user space. So delete it.
> > 
> > How can you be sure that is is not used in userspace? At least some
> > versions of strongswan set that flag. So even if it is meaningless
> > in the kernel, we can't remove it.
> 
> I looked over all net/* and include/uapi/* code with "git log -p" and didn't
> see any use of this flag ever. 
> 
> Looking in strongsswan, I see that they bring kernel header files [1] for the build
> and removal won't break build of old strongsswan versions.
> 
> We just can't use this bit anymore, because of this commit [2]. I have
> no clue why it was used there.
> 
> So yes, we can remove, but worth to add a comment about old strongsswan.

It is always problematic to remove something that was exposed
to userspace by the uapi, that should not happen. We can't
know that nobody uses that, even if unlikely. So please keep
it and maybe mark it as unused with a comment.

> 
> And if we are talking about xfrm_user_offload flags, there is a
> well-known API mistake in xfrm_dev_state_add() of not checking validity
> of flags. So *theoretically* we can find some software in the wild that
> uses other bits too.
> 
> I would like to see it is fixed.

Yes, catching usage of undefined flags should be indeed implemented.

Thanks!

