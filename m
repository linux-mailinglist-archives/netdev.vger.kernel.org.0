Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC81523B26
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345325AbiEKRKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiEKRKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:10:42 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B705414B668
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:10:38 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A81E522205;
        Wed, 11 May 2022 19:10:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1652289037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHdonhKGgeVyX5fKQ0pIziCHJ/pItisk1uGLdrmScnU=;
        b=UxN0VLPUvj827CDtPV7pa50AXZLyt3HlUKxLff7JKc8dnh4tMnjTw7vmaC7VbQMnzNq2YL
        bJTvPvzKxpqkNkoV4wSx5Um+5JpF06A4Qhh2SXmc3LjBGz8GOwWG+t5F5O0uVfxmA0Mls+
        wsNYo1l7UVH499Ky4rtCHo1vbdfyGdM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 May 2022 19:10:36 +0200
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     alexandru.ardelean@analog.com, alvaro.karsz@solid-run.com,
        davem@davemloft.net, edumazet@google.com, josua@solid-run.com,
        krzysztof.kozlowski+dt@linaro.org, michael.hennerich@analog.com,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
In-Reply-To: <20220511091136.34dade9b@kernel.org>
References: <20220510133928.6a0710dd@kernel.org>
 <20220511125855.3708961-1-michael@walle.cc>
 <20220511091136.34dade9b@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c457047dd2af8fc0db69d815db981d61@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-05-11 18:11, schrieb Jakub Kicinski:
> On Wed, 11 May 2022 14:58:55 +0200 Michael Walle wrote:
>> > I'm still not convinced that exposing the free running vs recovered
>> > distinction from the start is a good idea. Intuitively it'd seem that
>> > it's better to use the recovered clock to feed the wire side of the MAC,
>> > this patch set uses the free running. So I'd personally strip the last
>> > part off and add it later if needed.
>> 
>> FWIW, the recovered clock only works if there is a link. AFAIR on the
>> AR8031 you can have the free-running one enabled even if there is no
>> link, which might sometimes be useful.
> 
> Is that true for all PHYs? I've seen "larger" devices mention holdover
> or some other form of automatic fallback in the DPLL if input clock is
> lost.

I certainly can't speak of 'all' PHYs, who can ;) But how is the
switchover for example? hitless? will there be a brief period of
no clock at all?

The point I wanted to add is that the user should have the choice or
at least you should clearly mention that. If you drop the suffix and 
just
use "25mhz" is that now the recovered one or the free-running one. And
why is that one preferred over the other? Eg. if I were a designer for a
cheapo board and I'd need a 125MHz clock and want to save some bucks
for the 125MHz osc and the PHY could supply one, I'd use the
free-running mode. Just to avoid any surprises with a switchover
or whatever.

> I thought that's the case here, too:
> 
>> > > +      The phy can also automatically switch between the reference and the
>> > > +      respective 125MHz clocks based on its internal state.

I read "reference" as being the 25MHz (maybe when the PHY is in 10Mbit
mode? I didn't read the datasheet) because the first mode is called
25mhz-reference. So it might be switching between 25MHz and 125MHz?
I don't know.

-michael
