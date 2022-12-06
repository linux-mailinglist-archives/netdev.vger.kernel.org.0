Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18187644D98
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLFU6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLFU6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:58:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7612F023
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE580618B4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08C2C433D6;
        Tue,  6 Dec 2022 20:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670360282;
        bh=l6XDhgx+Me74n5G1CQMw/BRUUc3uDTRJyAYmuR3J8GM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EFFV4OExLLkitjAhiPF3DWSlhrGrMR5rhV4cq/KfV08DdVLhDrpvUVIUj6tM+YP/t
         ktCfdFYKNbQQEImVHddtughFI8gQWjfGtXBBp6+eIGhCwZDdh7dW2VFga7bue6rjU6
         QW2hC2QcYOqux6lk898WSfGjqLh8e6+lUOg9ls/i19JF064xZoorcZDRmXAbmuVDSp
         Qjyvuxkq24ANP0jgtNg3/RWvB8aax6OvFZh667r5d+FuQLkJksPnjWwe8Gwjmmp5qT
         oXgpE6IzFmvPxvzRD2nGVw+YXMfN/wAkTo/pHq8PC90X+M2/J/itYWrFF/k72ZFbVN
         QjrZwLtXDpCmA==
Date:   Tue, 6 Dec 2022 12:58:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, soheil@google.com
Subject: Re: [PATCH net-next] net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP
Message-ID: <20221206125801.21203419@kernel.org>
In-Reply-To: <CA+FuTScpBNEDy6D+dBaj3avMzXCQBRMUQib_gkono4V5k+Ke9w@mail.gmail.com>
References: <20221205230925.3002558-1-willemdebruijn.kernel@gmail.com>
        <20221206122239.58e16ae4@kernel.org>
        <CA+FuTScpBNEDy6D+dBaj3avMzXCQBRMUQib_gkono4V5k+Ke9w@mail.gmail.com>
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

On Tue, 6 Dec 2022 15:46:25 -0500 Willem de Bruijn wrote:
> > We can't just copy back the value of
> >
> >         tcp_sk(sk)->snd_una - tcp_sk(sk)->write_seq
> >
> > to the user if the input of setsockopt is large enough (ie. extend the
> > struct, if len >= sizeof(new struct) -> user is asking to get this?
> > Or even add a bit somewhere that requests a copy back?  
> 
> We could, but indeed then we first need a way to signal that the
> kernel is new enough to actually write something meaningful back that
> is safe to read.

It should be sufficient to init the memory to -1. 
(I guess I'm not helping my own "this is less hacky" argument? :)

> And if we change the kernel API and applications, I find this a
> somewhat hacky approach: why program the slightly wrong thing and
> return the offset to patch it up in userspace, if we can just program
> the right thing to begin with?

Ah, so you'd also switch all your apps to use this new bit?

What wasn't clear to me whether this is a
 1 - we clearly did the wrong thing
or
 2 - there is a legit use case for un-packetized(?) data not being
     counted

In case of (1) we should make it clearer that the new bit is in fact
a "fixed" version of the functionality.
For (2) we can view this as an extension of the existing functionality
so combining in the same bit with write back seems natural (and TBH 
I like the single syscall probing path more than try-one-then-the-other,
but that's 100% subjective).

Anyway, don't wanna waste too much of your time. If you prefer to keep
as is the doc change is good enough for me.
