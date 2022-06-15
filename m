Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9B054D55E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 01:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244828AbiFOXdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241672AbiFOXdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 19:33:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F014519028
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 16:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C023619FE
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8006DC3411A;
        Wed, 15 Jun 2022 23:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655335984;
        bh=dBBPcMjta8eLVg4C7tcokqqlbkjwbWO3mVjyG75QNKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eC4wKqpn/WcLuWE2S+vQDkJDn7HfdWkrWUZ7qxnx1PAorsOLmUxUCK2aMoSHnsoe2
         ZHQDO0yC0WqbPQm5C55JJAJJxOqgFiVclnSNaXNeViDyChlvaM9a/ToAXj02ryyc7J
         onNBhnorr5WIc8X4ENTsgpfGBwHsLItKsY6NwIJZ+Wkn9tiKtMQKKRNTqDoz1yps7O
         SPCT2kbOg1BvMZqJIb5AHJdkQ2x36OIejVQAnopFVXibFHZyaA3TIc4kq0pORY1onY
         eT69HLpttOy952uUGTvLhAr67KegtFqn3ZiiImy9vl8FGNoVP7Ka3qUeqVXcfZt5Z0
         4HkBbz7eZOU4A==
Date:   Wed, 15 Jun 2022 16:33:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Yuwei Wang <wangyuweihx@gmail.com>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce
 interval_probe_time for periodic probe
Message-ID: <20220615163303.11c4e7ef@kernel.org>
In-Reply-To: <57228F24-81CD-49E9-BE4D-73FC6697872B@blackwall.org>
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
        <20220609105725.2367426-3-wangyuweihx@gmail.com>
        <101855d8-878b-2334-fd5a-85684fd78e12@blackwall.org>
        <CANmJ_FNXSxPtBbESV4Y4Zme6vabgTJFSw0hjZNndfstSvxAeLw@mail.gmail.com>
        <57228F24-81CD-49E9-BE4D-73FC6697872B@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 18:39:53 +0300 Nikolay Aleksandrov wrote:
> >> Do we need the proc entry to be in jiffies when the netlink option is in ms?
> >> Why not make it directly in ms (with _ms similar to other neigh _ms time options) ?
> >>
> >> IMO, it would be better to be consistent with the netlink option which sets it in ms.
> >>
> >> It seems the _ms options were added later and usually people want a more understandable
> >> value, I haven't seen anyone wanting a jiffies version of a ms interval variable. :)
> >>  
> >
> >It was in jiffies because this entry was separated from `DELAY_PROBE_TIME`,
> >it keeps nearly all the things the same as `DELAY_PROBE_TIME`,
> >they are both configured by seconds and read to jiffies, was `ms` in
> >netlink attribute,
> >I think it's ok to keep this consistency, and is there a demand
> >required to configure it by ms?
> >If there is that demand, we can make it configured as ms.
> 
> no, no demand, just out of user-friendliness :) but 
> I get it keeping it as jiffies is also fine 

+1 to using ms
