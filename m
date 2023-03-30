Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0166D0FB7
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjC3UId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC3UIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47898172A
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 13:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A912620BE
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1DCC433D2;
        Thu, 30 Mar 2023 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680206909;
        bh=VQZrAGdpuaHk1P4kZl2nCiBAifwWOGL8wiW4I6FgnJU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wea9vbcDTV6hu6BbE7kHrEvwfWvLOjBCb4/a7tBe6Y8Icx/CkH25vU22TR0Q1Bd2e
         oyU05jO1dBJMmiF7wi9286zJPXeXI/6bdzzkHfAhqzLCSiNsYSuV5B4zysFj5G49dw
         +z2gwozq+tTYksMqpptelkKuFkWneBABtG8+0wWP8JKVmq1X+WQ5sASMkYH1mBo+oB
         P/DQylwQhYGCJKArC4ZqqnggY1ixlh++EBvhYQDFip5F09tRxJtYWjAs3WcGmJsst7
         ydD7zBxSrxyJ8YuMrrVlX06kGfOLdEOXVC6iewvHBrfcnGlzglIJboJTQXrmutoNwD
         BdbFiJZDmXMPg==
Date:   Thu, 30 Mar 2023 13:08:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: tsq: avoid using a tasklet if possible
Message-ID: <20230330130828.4aa7f911@kernel.org>
In-Reply-To: <20230330192534.2307410-1-edumazet@google.com>
References: <20230330192534.2307410-1-edumazet@google.com>
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

On Thu, 30 Mar 2023 19:25:34 +0000 Eric Dumazet wrote:
> Instead of always defer TCP Small Queue handling to a tasklet
> we can try to lock the socket and immediately call tcp_tsq_handler()
> 
> In my experiments on a 100Gbit NIC with FQ qdisc, number of times
> tcp_tasklet_func() is fired per second goes from ~70,000 to ~1,000.
> 
> This reduces number of ksoftirqd wakeups and thus extra cpu
> costs and latencies.

Oh, you posted already. LMK what you think about other locks,
I reckon we should apply this patch... just maybe around -rc1
to give ourselves plenty of time to find the broken drivers?
