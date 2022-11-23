Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D191563574F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbiKWJjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiKWJij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:38:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F1A112C4C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D52E61B6B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD10BC433B5;
        Wed, 23 Nov 2022 09:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669196185;
        bh=o3d3CDSxbvPLiKMAWmFXm0jXssJVWBegK4rnicq4WWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0AlX28wZwr6X9j6BUbMuXgmVfGEfpo/9bolshJFdpP4aqANKXHA8fCNBPLYPVrNu
         P8mUp0rshL3TdmYJ4DiftLq0x99u9VPUjgi+wG7yiQ3k2mKZmmlnsQhJQlBK2MFTCC
         JlhBUV6F/F6XgK6cosXyNPQIHLDOMQtqzp+f6BMi6FypHCKtS6EKdvtWkgbDiTkFGC
         x+WxmLv89dsjVfZk1V29G3DxduCuPnFEf/spxmuug+jvlV+lMQqTMMulOVgxhU/5g/
         9lBC66TiI5j2M6Kv7F3fsYNz+tU7qlBfVTco2Z4KvbRloYKysQzxQOpwBlfYJJimxn
         L+IR4I8PwQFwg==
Date:   Wed, 23 Nov 2022 11:36:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y33pk/3rUxFqbH2h@unreal>
References: <20221121110926.GV704954@gauss3.secunet.de>
 <Y3td2OjeIL0GN7uO@unreal>
 <20221121112521.GX704954@gauss3.secunet.de>
 <Y3tiRnbfBcaH7bP0@unreal>
 <Y3to7FYBwfkBSZYA@unreal>
 <20221121124349.GZ704954@gauss3.secunet.de>
 <Y3t2tsHDpxjnBAb/@unreal>
 <20221122131002.GN704954@gauss3.secunet.de>
 <Y3zVVzfrR1YKL4Xd@unreal>
 <20221123083720.GM424616@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123083720.GM424616@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 09:37:20AM +0100, Steffen Klassert wrote:
> On Tue, Nov 22, 2022 at 03:57:43PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 22, 2022 at 02:10:02PM +0100, Steffen Klassert wrote:
> > > On Mon, Nov 21, 2022 at 03:01:42PM +0200, Leon Romanovsky wrote:
> > > > On Mon, Nov 21, 2022 at 01:43:49PM +0100, Steffen Klassert wrote:
> > > > > On Mon, Nov 21, 2022 at 02:02:52PM +0200, Leon Romanovsky wrote:
> > > > > 
> > > > > If policy and state do not match here, this means the lookup
> > > > > returned the wrong state. The correct state might still sit
> > > > > in the database. At this point, you should either have found
> > > > > a matching state, or no state at all.
> > > > 
> > > > I check for "x" because of "x = NULL" above.
> > > 
> > > This does not change the fact that the lookup returned the wrong state.
> > 
> > Steffen, but this is exactly why we added this check - to catch wrong
> > states and configurations. 
> 
> No, you have to adjust the lookup so that this can't happen.
> This is not a missconfiguration, The lookup found the wrong
> SA, this is a difference.
> 
> Use the offload type and dev as a lookup key and don't consider
> SAs that don't match this in the lookup.
> 
> This is really not too hard to do. The thing that could be a bit
> more difficult is that the lookup should be only adjusted when
> we really have HW policies installed. Otherwise this affects
> even systems that don't use this kind of offload.

Thanks for an explanation, trying it now.
