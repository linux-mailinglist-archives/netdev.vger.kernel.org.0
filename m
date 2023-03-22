Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AFD6C4230
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjCVFbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjCVFa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC1C1ADD6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAF33B81B30
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132B6C433EF;
        Wed, 22 Mar 2023 05:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679463056;
        bh=pyQLA2VOtvj8xtiH8gE1V9YWitR7MNUs8b15YK4c9H4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R78gLxO8cNTezvS/9txtROGPptp5kl4pklFFcXaymcl8sQJdjAALEgkPhsnfyR/+B
         UMw6JJcddKir4mvFxbthglsvO9ELI89LSi64GKrdEffZyArDOjMTkhJW/b/pRfxnHm
         aVdpinFpwNFTUh2G/Ae0YGhoyqVp5L7ySYowz5b+4TMRiXVf9O5e/5r9c2mnG2MiuR
         FlD8VVKdtg23+MxUS5VtFa8dpdgSIXqH6HJMxnFlhJS5earCj9n8KRtQIiVlSi5pbG
         z5kdc/zUE+VTka8bPSK9CQ/e4TnaODaX2wndBuHAuZsz6qqvBWe2r2nmVsMhz9FsIX
         +mu+w5WRdF1sg==
Date:   Tue, 21 Mar 2023 22:30:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 4/6] tools: ynl: Add struct attr decoding to
 ynl
Message-ID: <20230321223055.21def08d@kernel.org>
In-Reply-To: <20230319193803.97453-5-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-5-donald.hunter@gmail.com>
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

On Sun, 19 Mar 2023 19:38:01 +0000 Donald Hunter wrote:
>                  enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
> -                        string, nest, array-nest, nest-type-value ]
> +                        string, nest, array-nest, nest-type-value, struct ]

I wonder if we should also only allow struct as a subtype of binary?

Structs can technically grow with newer kernels (i.e. new members can
be added at the end). So I think for languages like C we will still
need to expose to the user the original length of the attribute.
And binary comes with a length so codgen reuse fits nicely.

Either way - docs need to be updated.
