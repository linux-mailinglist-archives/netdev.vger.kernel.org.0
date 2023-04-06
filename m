Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2623E6D9B0E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDFOsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbjDFOsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEA3C64F
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 07:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C28E643AB
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 14:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19104C433EF;
        Thu,  6 Apr 2023 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680792409;
        bh=Y+M/2iT5SPsRPE9MoD9NUjFceQO5HduZrin/yxWIKMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Be3ySrlPZ08BRi3aeAnpFKLNTWyZPgEBe5AWgmDOcRSKC9olcSBwcn5FSQ5nrimoP
         92RgI08N8ff4NHpfcOrZgjZs6xQT1su54Ua55dpFd5RXyFKRjMEoGOVs/j7a6khiIJ
         epx2nBZB3HXrcieui8KKUaNPscQNlJRroKRQQiFnmfQk3u0/z7t4D9rDaYv0MlOf84
         NHc3zgf8hLYm7Op9uSV5BJgQ0dc8Lc6jIVIA3YJxrAZPrJojY50imNclPjK+6k4Spi
         fuXXOdpsVt418NEK7lyrHY61ivwPuynYfDnRneX27D0QHCns/HTEX+dWjVgY2T+ys9
         eUBLVB414Xvmg==
Date:   Thu, 6 Apr 2023 07:46:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230406074648.4c26a795@kernel.org>
In-Reply-To: <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
References: <20230401051221.3160913-2-kuba@kernel.org>
        <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
        <20230401115854.371a5b4c@kernel.org>
        <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
        <20230403085601.44f04cd2@kernel.org>
        <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
        <20230403120345.0c02232c@kernel.org>
        <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
        <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
        <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
        <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
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

On Thu, 6 Apr 2023 07:17:09 -0700 Paul E. McKenney wrote:
> > > Mightn't preemption or interrupts cause further issues?  Or are preemption
> > > and/or interrupts disabled across the relevant sections of code?  
> > 
> > The code in question is supposed to run in softirq context.  So
> > both interrupts and preemption should be disabled.  
> 
> Agreed, preemption will be enabled in softirq, but interrupts can still
> happen, correct?

Starting the queue only happens from softirq (I hope) and stopping 
can happen from any context. So we're risking false-starts again.
I think this puts to bed any hope of making this code safe against
false-starts with just barriers :(
