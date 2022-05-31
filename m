Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9293D539134
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 14:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344432AbiEaM7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiEaM7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 08:59:41 -0400
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 05:59:39 PDT
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5B165A2;
        Tue, 31 May 2022 05:59:39 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C911F3EA15;
        Tue, 31 May 2022 14:54:13 +0200 (CEST)
Date:   Tue, 31 May 2022 14:54:12 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [RFC PATCH v3 1/1] mac80211: use AQL airtime for expected
 throughput.
Message-ID: <YpYP9NBD+Wmzup+s@sellars>
References: <20220531100922.491344-1-gasmibal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220531100922.491344-1-gasmibal@gmail.com>
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 12:09:22PM +0200, Baligh Gasmi wrote:
> Since the integration of AQL, packet TX airtime estimation is
> calculated and counted to be used for the dequeue limit.
> 
> Use this estimated airtime to compute expected throughput for
> each station.
> 
> It will be a generic mac80211 implementation. If the driver has
> get_expected_throughput implementation, it will be used instead.
> 
> Useful for L2 routing protocols, like B.A.T.M.A.N.
> 
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>

Hi Baligh,

Thanks for your work, this indeed sounds very relevant for
batman-adv. Do you have some test results on how this compares to
real throughput? And maybe how it compares to other methods we
already have in the kernel, like expected throughput via
minstrel_ht rate control or the estimates performed in 802.11s
HWMP [0]?

Is there a certain minimum amount of traffic you'd suggest to have
enough samples to get a meaningful result?

I'm also wondering if we are starting to accumulate too many
places to provide wifi expected throughput calculations. Do you
see a chance that this generic mac80211 implementation could be made
good enough to be used as the sole source for both batman-adv and
802.11s HWMP, for instance? Or do you see some pros and cons
between the different methods?

Regards, Linus


[0]: https://elixir.bootlin.com/linux/v5.18/source/net/mac80211/mesh_hwmp.c#L295
