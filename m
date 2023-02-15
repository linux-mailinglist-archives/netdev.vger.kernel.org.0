Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E2E698325
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjBOSU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjBOSU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D876E3CE3D
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6478DB82361
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 18:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9924C433EF;
        Wed, 15 Feb 2023 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676485217;
        bh=RW09eCAtOZ+LpodDO60s8ubWxVnrlocJRzGOPAepJQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MJnTRyV4GkVFALIeBe+6nzVxts91PNl2Q/5+t8GF7sfXGXMhh6zNq1KnWD5zzX79y
         dGcfz8DcdojE2xHABKpDKz9o3aGSTmnPerRb46PuVQ4LJ4nYCbITVk2RqX++A5x0gf
         kjIzRn+eso60NCP2iIspOWuVPdulx/uedey5f8PtOaUA1v9vbbwZ6NFkkumvCO/huP
         yOjFD7tI2d1wSIXfeLqqYYrzzcsBVIPNjGM8fsU/+ieUJCazW5EXtztZeAQIArkEf0
         lhNeocAdP8z/u+6pPj2ZuGowdVvKMMtzkTfrBmwXA3vyZGr94dQxV7Iq2FSa+vhRLu
         BvBU6LWY0eX2A==
Date:   Wed, 15 Feb 2023 10:20:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <willemb@google.com>, <fw@strlen.de>
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
Message-ID: <20230215102015.70d81a20@kernel.org>
In-Reply-To: <4aa71029-8a4a-0c6d-438d-71cebb11ccea@intel.com>
References: <20230215034355.481925-1-kuba@kernel.org>
        <20230215034355.481925-3-kuba@kernel.org>
        <21e4b97a-430f-832d-cf49-5f938d1a8b77@gmail.com>
        <f2a30934-a0fe-ae1e-0897-2bb7dc572270@intel.com>
        <20230215095200.0d2e3b7e@kernel.org>
        <4aa71029-8a4a-0c6d-438d-71cebb11ccea@intel.com>
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

On Wed, 15 Feb 2023 19:01:19 +0100 Alexander Lobakin wrote:
> > I was hoping to leave sizing of the cache until we have some data from
> > a production network (or at least representative packet traces).
> > 
> > NAPI_SKB_CACHE_SIZE kinda assumes we're not doing much GRO, right?  
> 
> It assumes we GRO a lot :D
> 
> Imagine that you have 64 frames during one poll and the GRO layer
> decides to coalesce them by batches of 16. Then only 4 skbs will be
> used, the rest will go as frags (with "stolen heads") -> 60 of 64 skbs
> will return to that skb cache and will then be reused by napi_build_skb().

Let's say 5 - for 4 resulting skbs GRO will need the 4 resulting and
one extra to shuttle between the driver and GRO (worst case).
With a cache of 1 I'm guaranteed to save 59 alloc calls, 92%, right?

That's why I'm saying - the larger cache would help workloads which
don't GRO as much. Am I missing the point or how GRO works?
