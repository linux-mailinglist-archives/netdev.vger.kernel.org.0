Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB6B6D9CD5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbjDFP4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239495AbjDFP4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EE593F4
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22B8E648D1
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 15:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1EBC433EF;
        Thu,  6 Apr 2023 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680796590;
        bh=pyQpBCAVXNF7pyykfzOrXAqrtLDcvaDUm3b+/7WOUzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jV/nj2xy6JPwueQXy5r6meOXCuhATdaeXSDA+wl++EZd7xU/B89L89Ho0jQ5AyT5L
         6cAEadPubG+r7O5sL0G2j7k+UmdsImnEAsPcx6cJ+NTRGgdN46MAqt/KN3YQmo4tCp
         iYBAaorQ2/Sw03NZQLixcwdOjXj+PKGEuZ8zbv6HNqlnIFoeiXWKuIwRZ1lL2SFTpe
         rjaqgzzaVI2PuRPKtvQEy5CyYHq+LP5y1o0GpxxFdoK7jMjz7b2MBwuRZmdPoY/Y/X
         Obe6jAR+bup9AVoBS1jdmzlXjKXnnrm+q0XhMr4nOGg2tpg22bcFRu2h3G54BH+Vb7
         ywlAAVplNA35w==
Date:   Thu, 6 Apr 2023 08:56:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230406085629.3e0c9514@kernel.org>
In-Reply-To: <c3b05efb-e691-4947-84f9-cf524e7d2cd9@paulmck-laptop>
References: <20230401115854.371a5b4c@kernel.org>
        <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
        <20230403085601.44f04cd2@kernel.org>
        <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
        <20230403120345.0c02232c@kernel.org>
        <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
        <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
        <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
        <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
        <20230406074648.4c26a795@kernel.org>
        <c3b05efb-e691-4947-84f9-cf524e7d2cd9@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 08:45:10 -0700 Paul E. McKenney wrote:
> > Starting the queue only happens from softirq (I hope) and stopping 
> > can happen from any context. So we're risking false-starts again.
> > I think this puts to bed any hope of making this code safe against
> > false-starts with just barriers :(  
> 
> Is it possible to jam all the relevant state into a single variable?
> (I believe that that answer is "no", but just in case asking this question
> inspires someone to come up with a good idea.)

Not in any obvious way, half of the state is driver-specific the other
half is flags maintained by the core :S
