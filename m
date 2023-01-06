Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DAD66098C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 23:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjAFWdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 17:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbjAFWds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 17:33:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B9384631
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 14:33:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5617B81DD6
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 22:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3288FC433D2;
        Fri,  6 Jan 2023 22:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673044423;
        bh=nPw3NLAj1NmorqS2E4c0UKiDQdGMdeLc4mCzzu0lFvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HCfUy7AQcGp2+dTf9S+cNpMOzEPjBTPNuRWENn2ZYeA5SrhGExEjEG2JBVFzLSCa0
         UD0y4/Mby5k1NC3vVKnt/6DZ68uV3qraqOgxjNltWHe8NZtSEcd4sSqQXKrfeAezxT
         Rld0n/cldl/7WTyZV3ZJbKZYA81az0nrX1866pYjRq0nBZYgXZ2HLVlmihWHqRtQUV
         r4ui95uTOj3xl/AvvTq01nDGGM2gbCrR9f5a5cLy+5e80ZV5WS82THXRaZMgX3D8uA
         KZFPer+FmrkU/eGY+HDsqky6+q7SOoWB0mLl4PmybFUy6RDXOO8Qi0QaX5wZ031J1K
         CeRQn/eys+vmg==
Date:   Fri, 6 Jan 2023 14:33:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Message-ID: <20230106143310.699197bd@kernel.org>
In-Reply-To: <167293336786.249536.14237439594457105125.stgit@firesoul>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
        <167293336786.249536.14237439594457105125.stgit@firesoul>
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

Hi!

Would it not be better to try to actually defer them (queue to 
the deferred free list and try to ship back to the NAPI cache of 
the allocating core)? Is the spin lock on the defer list problematic
for fowarding cases (which I'm assuming your target)?

Also the lack of perf numbers is a bit of a red flag.

On Thu, 05 Jan 2023 16:42:47 +0100 Jesper Dangaard Brouer wrote:
> +static void kfree_skb_defer_local(struct sk_buff *skb,
> +				  struct skb_free_array *sa,
> +				  enum skb_drop_reason reason)

If we wanna keep the implementation as is - I think we should rename
the thing to say "bulk" rather than "defer" to avoid confusion with 
the TCP's "defer to allocating core" scheme..

kfree_skb_list_bulk() ?
