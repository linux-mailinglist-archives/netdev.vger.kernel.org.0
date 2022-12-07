Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4B646562
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLGXsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLGXsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:48:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC92FC3F;
        Wed,  7 Dec 2022 15:48:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAFD6B81CEC;
        Wed,  7 Dec 2022 23:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F6FC433D6;
        Wed,  7 Dec 2022 23:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670456907;
        bh=yayt23wn+GArDo93jmU42JfNMrSGxzH7B3q5Dt5xjDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YIEQIkN64G6nXouBGC+7JU9QUuFiz3lrFfVpTk+ohMLKv1xw1FyRA3of3z3bv6XfT
         SkT02OLQKvTQCMc9WI9xU2HgAncYVxrxBvzOhkKjVGU7vUqoDdB8YZthHizwZaCuTY
         rKin3G1hQcoNu/RF68kq67U+4YMXRI482LOXKd0axsYatLqtD9Ah0cul6PagFMkEEK
         amPlp8dmvZDHtVQ88QB6IEYUwy/l511ipdBYU3naT+Ng8nBa0H+zqk16QA0fcU3qMM
         9haF0Ry7JZ1CO5JQanEijimlVOw8wWlmK9iX3jVZCwOZFwOp8V9clJVsZLYvYl6Eud
         OkLhW5cw0rijA==
Date:   Wed, 7 Dec 2022 15:48:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64
 support for ksz8 series of switches
Message-ID: <20221207154826.5477008b@kernel.org>
In-Reply-To: <20221207061630.GC19179@pengutronix.de>
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
        <20221206114133.291881a4@kernel.org>
        <20221207061630.GC19179@pengutronix.de>
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

On Wed, 7 Dec 2022 07:16:30 +0100 Oleksij Rempel wrote:
> > FWIW for normal netdevs / NICs the rtnl_link_stat pkts do not include
> > pause frames, normally. Otherwise one can't maintain those stats in SW
> > (and per-ring stats, if any, don't add up to the full link stats).
> > But if you have a good reason to do this - I won't nack..  
> 
> Pause frames are accounted by rx/tx_bytes by HW. Since pause frames may
> have different size, it is not possible to correct byte counters, so I
> need to add them to the packet counters.

I have embarrassed myself with my lack of understanding of pause frames
before but nonetheless - are you sure?  I thought they are always 64B.
Quick look at the standard seems to agree:

 31C.3.1 Receive state diagram (INITIATE MAC CONTROL FUNCTION) for
         EXTENSION operation

shows a 64 octet frame.

Sending long pause frames seems self-defeating as we presumably want
the receiver to react ASAP.
