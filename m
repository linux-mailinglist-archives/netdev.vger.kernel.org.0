Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409C162602B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbiKKRLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiKKRLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:11:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DDA63D6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB51CB8267A
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 17:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE4FC433C1;
        Fri, 11 Nov 2022 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668186702;
        bh=mL/diFZGeBol2cZjWZismDRnc1NQLFiVqECNxyk6HZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1VVphw4JY4IeUW87vbJFq4Z89eYr+hy0DurrrprNX5jdPA2PVinpykSw2bn4Vhlk
         tU4G0wP517VbhQwojQG7CINtJHlxpvTUZesQrIODAQ2QBkmH9RveeEAFk5HopkXhzc
         r7typOof4uskz7u+QOUHsmnOpnULtecDZ980zw96gQfzPFSdBgFM0xKqnTti/DIqFL
         y0DCwKyUNAas+vHGbtTDa17qNnJqGma9zzFW01dY8pJJKt69gVgvjPFPUfGj6hK7H4
         kac4Pc4SrOHnwKIXJI9iyl9fnbqbBwZmVPvreJG5hWMboJ6Zd+ODSoxKgnqpnYmiPd
         asAh8j4x4YM/w==
Date:   Fri, 11 Nov 2022 09:11:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Sean Tranchetti" <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
Message-ID: <20221111091141.784c88f3@kernel.org>
In-Reply-To: <b84e45e0-55e0-a1f5-e1cc-980983946019@quicinc.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-3-dnlplm@gmail.com>
        <20221110173222.3536589-1-alexandr.lobakin@intel.com>
        <b84e45e0-55e0-a1f5-e1cc-980983946019@quicinc.com>
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

On Thu, 10 Nov 2022 18:17:09 -0700 Subash Abhinov Kasiviswanathan (KS)
wrote:
> The difference here is that hardware would use a single descriptor for 
> aggregation vs multiple descriptors for scatter gather.
> 
> I wonder if this issue is related to pacing though.
> Daniele, perhaps you can try this hack without enabling EGRESS 
> AGGREGATION and check if you are able to reach the same level of 
> performance for your scenario.
> 
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -236,7 +236,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
>          struct rmnet_priv *priv;
>          u8 mux_id;
> 
> -       sk_pacing_shift_update(skb->sk, 8);
> +       skb_orphan(skb);
> 
>          orig_dev = skb->dev;
>          priv = netdev_priv(orig_dev);

The pacing shift update is much cleaner than orphaning packets, IMHO.
And the aggregation should hold onto the original skbs (a list?) and
free them once the aggregate was transmitted.
