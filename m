Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C20F628E91
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiKOAnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237456AbiKOAmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4581D0CD
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:42:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55DCA614E9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572ECC433C1;
        Tue, 15 Nov 2022 00:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668472959;
        bh=szLpJI0wqqBZ1TV/40tyVq092C6auC2LD7ocKmr4HD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ajFUfS+x1bYxxb63T7bgmfsz7ikfzXqhsH05SwsApPAiZDKys/QKifRSHX1bwdbdB
         DHRq8Mvo8TmyPky99qYMk3ckKo8AvvlJQe+LiYb0IX4xVqGpaM8kxU/wQuO/B3x0Ye
         CCZoE/W4Kht3kMjwiLbExOVwha+zMkgXIZObu9HpBeQjmXeaBzInMjeP7RS6NR6KFm
         BIXFJSCCH4PqGAZJoxKpnQukzlqS4vq/q42MpBh0CGur5Ao0EttFQMF3/bA6GixXkg
         A2zQekZv7XC+Thcm4cGyswb9xDwlyK4DvJIIb1l3z7fJgtFkLzaKluff6/x8kLXGdf
         0VDrNBZQ+fGFw==
Date:   Mon, 14 Nov 2022 16:42:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>, Gal Pressman <gal@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
Message-ID: <20221114164238.209f3a9d@kernel.org>
In-Reply-To: <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-2-dnlplm@gmail.com>
        <20221111090720.278326d1@kernel.org>
        <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
        <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
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

On Mon, 14 Nov 2022 11:06:19 +0100 Daniele Palmas wrote:
> > Isn't this the same as TX copybreak? TX
> > copybreak for multiple packets?  
> 
> I tried looking at how tx copybreak works to understand your comment,
> but I could not find any useful document. Probably my fault, but can
> you please point me to something I can read?

FWIW it's not exactly copy break, as it applies to all packets.
But there is indeed an extra copy.

Daniele's explanation is pretty solid, USB devices very often try 
to pack multiple packets into a single URB for better perf. IIUC Linux
drivers implement the feature on the Rx side, but fall short of doing
the same on the Tx side, because there's no API to control it.

I've seen the same thing in the WiFi USB devices I worked on in my
youth :)
