Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95B06BBF11
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjCOV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCOV2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:28:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54798CDDE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 018D1B81F19
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B76C4339B;
        Wed, 15 Mar 2023 21:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678915722;
        bh=gQ+MOvi6Y2xh80HSO5KO4j8mTrT6CllfpjfjkqMbiAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J8YOOY4KZBrWVkrweD7vRQvbKRjgRF8YDvs0aoFbhxe74IgbhV2+d0JC+okeCf0lh
         gKgHyUzFqJjN8IN+UFUSBbX2K0jj+x1WdHx0vsHcfnt97Sf2mOkGQ/M8qFlnHBatQT
         YhFXzIKQQV5jjFg08nW6YGBHSh3nCeD0hAe14Tgr7iUkJqNyLccPF5ssNOLSE8jmST
         eOXOTd9G8jNcOSeLH0cntkuSqAeYkHRNjfqnRzeBNAx+vUJHVyXgPBBp4uPuzF2G9C
         SbR9G18arIP8Cql/vj7kqzj8MVreR3SmL0XjdZQASNEsqGE3B6+gFR87aN5yqNoXW5
         AyowTjY8WAyig==
Date:   Wed, 15 Mar 2023 14:28:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in
 inet_sk()
Message-ID: <20230315142841.3a2ac99a@kernel.org>
In-Reply-To: <20230315154245.3405750-2-edumazet@google.com>
References: <20230315154245.3405750-1-edumazet@google.com>
        <20230315154245.3405750-2-edumazet@google.com>
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

On Wed, 15 Mar 2023 15:42:38 +0000 Eric Dumazet wrote:
> -static inline struct inet_sock *inet_sk(const struct sock *sk)
> -{
> -	return (struct inet_sock *)sk;
> -}
> +#define inet_sk(sk) \
> +       _Generic(sk,                                          		\
> +                const struct sock * : ((const struct inet_sock *)(sk)),	\
> +                struct sock * : ((struct inet_sock *)(sk))		\
> +       )

Could we possibly use container_of_const() or define a new common
macro for this downcast? I'm worried it will spread and it's a bit
verbose.

(I think Greg is constifying things too so let me add him and Linus.)
