Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC8F5C0563
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiIURhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiIURhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:37:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93746A285F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 10:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F8B621CD
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150EAC433C1;
        Wed, 21 Sep 2022 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663781830;
        bh=B9KwqJmVgervp1jcZYlKe8GEmpCoHW2id+GO5B/Q8Y8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VoHrhv8SAJQWR1yMsQWlSs9z4BtD+5Hzu94hYD7uAKcMZldrycLW4iP/+v7DmzRYo
         v3MutSYMyp+Lo4uoASSXvJZaKymoWre0g6epgHUSje7uf7rOBoHmfOVkmVZagy9YJu
         EnCyblOIsXyreGDZaC2xIZ2Ar2gxQzau3YTm8HumgZsWHCQ5mK9tE0Ww+95nLMrwIe
         gX0QVXhQCITlygnQt0HdLOa5DapQXDwJNVxrtetExD2W+V0+jgwdupgfNyAcgKWwUN
         v6K1RgBkWvT6UyVB2d4dHhdi0MPB4ocnT/bXpIiF8IpBdI3MYL3vvanpos/pNlnRji
         ceTz1AUsj5qEg==
Date:   Wed, 21 Sep 2022 20:37:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <YytLwlvza1ulmyTd@unreal>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yxm8QFvtMcpHWzIy@unreal>
 <20220921075927.3ace0307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921075927.3ace0307@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 07:59:27AM -0700, Jakub Kicinski wrote:
> On Thu, 8 Sep 2022 12:56:16 +0300 Leon Romanovsky wrote:
> > I have TX traces too and can add if RX are not sufficient. 
> 
> The perf trace is good, but for those of us not intimately familiar
> with xfrm, could you provide some analysis here?

The perf trace presented is for RX path of IPsec crypto offload mode. In that
mode, decrypted packet enters the netdev stack to perform various XFRM specific
checks.

The trace presents "the cost" of these checks, which is 25% according to the
line "--25.80%--xfrm_input".

The xfrm_input has number of "slow" places (other places are not fast either),
which are handled by HW in parallel without any locks in IPsec full offload
mode.

The avoided checks include:
 * XFRM state lookup. It is linked list iteration.
 * Lock of whole xfrm_state. It means that parallel traffic will be
   congested on this lock.
 * Double calculation of replay window protection.
 * Update of replay window.

https://elixir.bootlin.com/linux/v6.0-rc6/source/net/xfrm/xfrm_input.c#L459
int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
{
...
		x = xfrm_state_lookup(net, mark, daddr, spi, nexthdr, family);
...
		spin_lock(&x->lock);
...
		if (xfrm_replay_check(x, skb, seq)) {
...
		spin_unlock(&x->lock);
...
		spin_lock(&x->lock);
...
		if (xfrm_replay_recheck(x, skb, seq)) {
...
		xfrm_replay_advance(x, seq);
.....


