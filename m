Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556ED688ED8
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjBCFLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjBCFLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:11:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98916A4A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 21:11:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC3C61D77
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF40C4339C;
        Fri,  3 Feb 2023 05:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675401066;
        bh=hmHDOdpZ2SNCS7GgfTigeurac/UdY5ugWwJmGfD18WI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OSPMtgy9QlPPYoUfCyfG3gsC18vwg0HxGNHUkhobdvlgDT9B3cgVH0g9tpV54ZiU1
         l7EKVi7Ko8gfbFTcXVlTeBvXDxx8Sy5D20Dl0WOK751ixhDPjeSUPTH8PuOEgKdanZ
         tyGeeJruLJEAwf/HyYQmfYDm86VZPHqeOSZ3Sh54SvLHqE8mHUsn6i3ZgSDC/WhH6C
         Xys/UayhOaZQB0esRNrzeVrXyhXKJQSQllHPs9yWunKXw3tfLddj4r+DMRPkRiW2zS
         PS4sed//Fb1+1eTGCuDdRxgxds5JBH6DREXtfliWM/M9Lm6QyZC3x7Uw08cttHfOB1
         LYUiCzRJr7sHw==
Date:   Thu, 2 Feb 2023 21:11:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
Message-ID: <20230202211105.1ce7f83f@kernel.org>
In-Reply-To: <20230202185801.4179599-5-edumazet@google.com>
References: <20230202185801.4179599-1-edumazet@google.com>
        <20230202185801.4179599-5-edumazet@google.com>
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

On Thu,  2 Feb 2023 18:58:01 +0000 Eric Dumazet wrote:
> +/* We want SKB_SMALL_HEAD_CACHE_SIZE to not be a power of two. */

Why is that?  Is it to prevent potential mixing up of objects from 
the cache with objects from general slabs (since we only do a
end_offset == SKB_SMALL_HEAD_HEADROOM check)?
