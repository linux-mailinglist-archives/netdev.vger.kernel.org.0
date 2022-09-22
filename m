Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5D75E6300
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiIVM66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiIVM65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCAA27A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 05:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E285D62E3F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF48AC433D6;
        Thu, 22 Sep 2022 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663851535;
        bh=2rPFKpyOGTCas1lfdbTU1h7Ka09ZjRNGsIJWHTb3Tjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rrOubrCR4DAhKWKsdRU/xNNyR/Z7Qtjfi3/S+lE5LsgqceyR3LyXN8Ypc0JaGUGGD
         6XBieF9B2J10+FnzRHcLliHdthqwtkmh0OZMpoI2QBCQZOnpk+LrfSlca9UWd0jaUL
         jQ9wXQyqgvnNSyyEO1FDalRo5QbCgRvX9eLQ7rFWfQR348l+X2mIp39sncP2etb9/6
         azIjqmnvkyyx1CmxDiauFPKhycD6Xzq9p1+tCNYDvSju4mFCIP1niQ/izMyFjwXsV+
         kwg3zgO3EuuEV9DybYOHX0s+hK3xjR8N+7F+lESdC0dgtfMiETM8E0ioCKX2D5Va74
         H0xXZBz6j7lXg==
Date:   Thu, 22 Sep 2022 05:58:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set}link
Message-ID: <20220922055853.529873ad@kernel.org>
In-Reply-To: <Yyw1TRSMRUbmOOtK@Laptop-X1>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
        <20220921060123.1236276d@kernel.org>
        <20220921161409.GA11793@debian.home>
        <20220921155640.1f3dce59@kernel.org>
        <Yyw1TRSMRUbmOOtK@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 18:13:33 +0800 Hangbin Liu wrote:
> > In general I still don't think NLM_F_ECHO makes for a reasonable API.
> > It may seem okay to those who are willing to write manual netlink
> > parsers but for a normal programmer the ability to receive directly
> > notifications resulting from a API call they made is going to mean..
> > nothing they can have prior experience with. NEWLINK should have
> > reported the allocated handle / ifindex from the start :(
> > 
> > The "give me back the notifications" semantics match well your use
> > case to log what the command has done, in that case there is no need 
> > to "return" all the notifications from the API call.  
> 
> I didn't get what you mean about "no need to return all the notifications from
> the API call"? Do you ask for some update of the patch, or just talking about
> your propose of NEWLINK?

I'm talking about building "normal programmer" facing libraries on top
of netlink. The concept of ECHO fits very poorly into the normal
request-response semantics.
