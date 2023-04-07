Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E735C6DA6A9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 02:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbjDGAlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 20:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbjDGAlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 20:41:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09059EC5
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 17:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E6C464DDF
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 00:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AC7C433EF;
        Fri,  7 Apr 2023 00:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680828101;
        bh=xbAHtk8oAtBkBap2SdUKUpEVpFr3c1tMkS5fcSP+Vtk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E3VOadiE4aJ2C0Of75n2PzS2KXby6ryNSw9ZlxVZQNDK2T7PZqEOLxV3GuYJTQYcm
         yq88UbXrPe2WiYAS6Df6C6bQIqbOY+5BxLcCF5GEjzgsQMFaIIx+Ywc3OJ0AhKziC1
         GI7s0in4AR0Fxr57fTFZKIlkrzXMCBuZLj4uVeGYa2eyiWhNFiUWLJ4AA8+NZTo5ss
         eLnBMOoP6ZtBf8KGq55v4cyYwq5XfyPpk9QEAdJhVPMoS8y4Md3z0rseUD3dwIIRd9
         6XpWFt+V4Bvv4qyqeQWo+TyQwvUJgFaH71WEYqLN/nvz0AFhqJ9YcONPRVyfhZIxU9
         uQXefY3uZo6mA==
Date:   Thu, 6 Apr 2023 17:41:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alexander.duyck@gmail.com, hkallweit1@gmail.com,
        andrew@lunn.ch, willemb@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v3 7/7] net: piggy back on the memory barrier
 in bql when waking queues
Message-ID: <20230406174140.36930b15@kernel.org>
In-Reply-To: <ZC52VRfUOOObx2fw@gondor.apana.org.au>
References: <20230405223134.94665-1-kuba@kernel.org>
        <20230405223134.94665-8-kuba@kernel.org>
        <ZC52VRfUOOObx2fw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 15:35:49 +0800 Herbert Xu wrote:
> Minor nit, I would write this as
> 
> 	if (IS_ENABLED(CONFIG_BQL))
> 		netdev_tx_completed_queue(dev_queue, pkts, bytes);
> 	else if (bytes)
> 		smp_mb();

Will do!

> Actually, why is this checking bytes while the caller is checking
> pkts? Do we need to check them at all? If pkts/bytes is commonly
> non-zero, then we should just do a barrier unconditionally and make
> the uncommon path pay the penalty.

I wanted to keep the same semantics as netdev_tx_completed_queue()
which only barriers if (bytes). Not in the least to make it obvious
to someone looking at the code of netdev_txq_completed_mb() (and not
the comment above it) that it doesn't _always_ put a barrier in.
