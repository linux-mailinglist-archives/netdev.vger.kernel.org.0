Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A7D5ECC07
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiI0SSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiI0SSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:18:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8981FFA63;
        Tue, 27 Sep 2022 11:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7498761B22;
        Tue, 27 Sep 2022 18:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F31C433D7;
        Tue, 27 Sep 2022 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664302679;
        bh=PhqML3o0FkjVwOp6KVZGd/fjTJC+ahaQOUgedohAt9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O9BF0NWxQG/GX5/1PpsNZRWeA6L4xHy1XnkRwbbUmXr9xkmWhhUT+W+fhniPtI+7Z
         f7ppcUG0P3Peb4NUShHh6ocbxAJfsN/tdg02OivDUN3f0x7yMgJEqpcluLwJO3xH6D
         cMoQ2uPO1wTUneae0NqU0AJexW8BeRnDP4+xPWg9dtk1TDKKY+GMndrgemzhPfOHfQ
         yxT/1GBinvxFhI0OMYcYM2ft4KzqXn95O2ei/qc3bAfEtdzokteRRgFcsh3AqAcsz2
         346nQTcHsKTs2nMqTQdcOh2szJbXzv5zk0NzlQcJeGGElSh/7DmMat/ZA9WvqUZK+n
         hc8WEe9ZFcBGg==
Date:   Tue, 27 Sep 2022 11:17:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        kvalo@kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: drop the weight argument from
 netif_napi_add
Message-ID: <20220927111758.1d25ea0f@kernel.org>
In-Reply-To: <CANn89iL4m=aMjZ1XWFNWDyyyDBF1uhNocN0OFqhm2VMm_JQOog@mail.gmail.com>
References: <20220927132753.750069-1-kuba@kernel.org>
        <CANn89iL4m=aMjZ1XWFNWDyyyDBF1uhNocN0OFqhm2VMm_JQOog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 10:54:49 -0700 Eric Dumazet wrote:
> On Tue, Sep 27, 2022 at 6:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > We tell driver developers to always pass NAPI_POLL_WEIGHT
> > as the weight to netif_napi_add(). This may be confusing
> > to newcomers, drop the weight argument, those who really
> > need to tweak the weight can use netif_napi_add_weight().
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Sure, but this kind of patch makes backports harder.
> Not sure how confused are newcomers about this NAPI_POLL_WEIGHT....

I maintained this patch in my tree for a couple of releases (because 
I was waiting for the _weight() version to propagate to non-netdev
trees) and the conflicts were minor. Three or so cases of new features
added to drivers which touched the NAPI calls (WiFi and embedded) and
the strlcpy -> strscpy patch, and, well, why did we take that in if we
worry about backports...

NAPI weight was already dead when I started hacking on the kernel
10 years ago. I don't think it's reasonable to keep dead stuff 
in our APIs for backport's sake. Adding Jiri to CC in case I need
someone to back me up :)

The idea for this patch came because I was reviewing a driver which 
was trying to do something clever with the weight.

