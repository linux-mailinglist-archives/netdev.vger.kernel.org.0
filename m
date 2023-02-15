Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CE16982FC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjBOSOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOSN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:13:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618A93B66B
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:13:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3DFC61D0F
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 18:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FE3C433D2;
        Wed, 15 Feb 2023 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676484837;
        bh=2Fsvd7hPXprRIjZDEgKqvD3m8DKKUtXHwqXZAijXjSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=svpBqOiTN0CXxQalER9PNmOOn6zkeifIzHgXASBnm/pzjpbtRoQwgRAjXNVyzuC3l
         aKFHtELQquDKyJzeTf7OLfUsjztyXhJTVjFIbdaglhF9z3RXaisN4tB0UuLHcG5WDY
         Ryq9LX1PX4vKRb+L5trJVlLabkggqD44ETg/FG7o7Drze3CSeKbNqd3FUuYSAfG1F8
         wg+DPNjFROCiRALFxTjWJSaJkqkwJ3TeKrslX5+h592NzyqGdbseuiCZGRNixVbdlQ
         R6Qt5qGeyNtwHoVl2loeBMTnxLKgwVpaZ6QorE7wpbZM2rvt73rGdsYR3H/VxrQW+M
         TRb5yYxc+Rwjg==
Date:   Wed, 15 Feb 2023 10:13:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
Message-ID: <20230215101356.3b86c451@kernel.org>
In-Reply-To: <20230215094332.GB9908@breakpoint.cc>
References: <20230215034444.482178-1-kuba@kernel.org>
        <20230215094332.GB9908@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023 10:43:32 +0100 Florian Westphal wrote:
> I think the cleaner solution would be to move the new extension ids
> into sk_buff itself (at the end, uninitialized data unless used).
> 
> Those extensions would always reside there and not in the slab object.

Do you mean the entire extension? 8B of metadata + (possibly) 32B 
of the key?

> Obviously that only makes sense for extensions where we assume
> that typical workload will require them, which might be a hard call to
> make.

I'm guessing that's the reason why Google is okay with putting the key
in the skb - they know they will use it most of the time. But an
average RHEL user may appreciate the skb growth for an esoteric protocol
to a much smaller extent :(
