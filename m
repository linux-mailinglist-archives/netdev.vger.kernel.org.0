Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8898C666495
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbjAKUIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjAKUH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:07:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740A91010
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEF4C61E2D
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCA7C433D2;
        Wed, 11 Jan 2023 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673467568;
        bh=E8QuhtzXnJFbiPdUAIfD3Ux+xLcDVNSL2NpqqK0UeUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYJP8IhH1irN6N6Mpts3hv3YCQnH4N72Z+5oj8xjUKi4ps8LnSdtS89aH9XVuPXSx
         AcTlS7UHqvje6Gy5Q7J6qrdVbDdpvLnl/pFeNd+VL8WStkRqDikKqqR9hdYBQDz5pg
         AKASSxDYH9QyrdePaw4tCZXLqFf7UscNTJWn0Im4yhDY3v6+uwH5h0F+YrQMXLk4lo
         7Wbkesa0xljpRDmAhyuqbEl1MEgy+2yoeOPLBbfT+8AqlKZcAGwh/nGJ5f4H46jbsQ
         1lWd0XlE8bge66dH6Q/amNoHMmH/wjw5UHLZ1Sj2HYf6qd0NHnulZIX3CqJynjeqe3
         b16EC0Z4kjbYg==
Date:   Wed, 11 Jan 2023 12:06:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
Message-ID: <20230111120606.6a209472@kernel.org>
In-Reply-To: <8e6fae4d-83f4-e31c-2274-208e27e7b156@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
        <20230109191523.12070-11-gerhard@engleder-embedded.com>
        <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
        <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
        <20230110161237.2a40ccc8@kernel.org>
        <8e6fae4d-83f4-e31c-2274-208e27e7b156@engleder-embedded.com>
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

On Wed, 11 Jan 2023 20:11:44 +0100 Gerhard Engleder wrote:
> I agree with you that this pattern is bad. Most XDP BPF program setup do
> it like that, but this is of course no valid argument.
> 
> In the last review round I made the following suggestion (but got no
> reply so far):
> 
> What about always using 'XDP_PACKET_HEADROOM' as offset in the RX
> buffer? The offset 'NET_SKB_PAD + NET_IP_ALIGN' would not even be used
> if XDP is not enabled. Changing this offset is the only task to be done
> at the first XDP BFP prog setup call. By always using this offset
> no
> 
> 	close()
> 	change config
> 	open()
> 
> pattern is needed. As a result no handling for failed open() is needed
> and __TSNEP_DOWN is not needed. Simpler code with less problems in my
> opinion.
> 
> The only problem could be that NET_IP_ALIGN is not used, but
> NET_IP_ALIGN is 0 anyway on the two platforms (x86, arm64) where this
> driver is used.

You can add NET_IP_ALIGN as well, AFAIU XDP_PACKET_HEADROOM is more 
of a minimum headroom than an exact one.

The other thing off the top of my head is that you'll always need to
DMA map the Rx buffers BIDIR.

If those are acceptable for your platform / applications then indeed
seems like an easy way out of the problem!
