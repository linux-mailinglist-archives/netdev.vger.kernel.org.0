Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D806BC0A7
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjCOXIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjCOXId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:08:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B8A6C18F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9155B81F7B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66538C433EF;
        Wed, 15 Mar 2023 23:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921709;
        bh=VvX4uT+qHsm5p9ngMHbENlhYLUUqQzT1IrVx/7Zegmc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hEzc0ifnbSzicUDS4ae7bnRA8l0vD9l+qW940oxLTuCRpGvoNd2fMN/fwBlVruO+9
         oApIBf2ubzJYPMCPPEZpV1k/w1SRdvtZYwaDxmLo6zJxgYhehY3gFnKyw+aze4nTye
         niMd8tBxHidRsKKyvpu0OQ3bd3qh8VNA54ZHTnuRmTr2j0mmZBPJKFXY4JmIKsfv9t
         vr2T+mhIA8bqMysaDa3Cc2DMC0Lau0cnS1G7VktqxsWnDN5s+dyuBTcVOJmW5rc/9n
         VT4QLcigWGFhlL/grrnruP932w2SCahW5+glxFrLrBfjNt9Qdh8BrwIpq89nh9pOx2
         6pZHBbickIdRg==
Date:   Wed, 15 Mar 2023 16:08:28 -0700
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
Message-ID: <20230315160828.00c9cedb@kernel.org>
In-Reply-To: <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
References: <20230315154245.3405750-1-edumazet@google.com>
        <20230315154245.3405750-2-edumazet@google.com>
        <20230315142841.3a2ac99a@kernel.org>
        <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
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

On Wed, 15 Mar 2023 15:37:50 -0700 Eric Dumazet wrote:
> I did see container_of_const() but the default: case was not appealing to me.
> 
> Maybe something like this?
> 
> diff --git a/include/linux/container_of.h b/include/linux/container_of.h
> index 713890c867bea78804defe1a015e3c362f40f85d..9a24d8db1f4c46166c07589bb084eda9b9ede8ba
> 100644
> --- a/include/linux/container_of.h
> +++ b/include/linux/container_of.h
> @@ -35,4 +35,10 @@
>                 default: ((type *)container_of(ptr, type, member))      \
>         )
> 
> +#define promote_to_type(ptr, oldtype, newtype)                 \
> +       _Generic(ptr,                                           \
> +                const oldtype *: ((const newtype *)(ptr)),     \
> +                oldtype *: ((newtype *)(ptr))                  \
> +       )

Perfect, I'll defer to you on whether you want to patch it on top 
or repost the series.
