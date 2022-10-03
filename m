Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B127A5F39D0
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJCX0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJCXZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:25:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B9C2A972
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 877D961070
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 23:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9263C433C1;
        Mon,  3 Oct 2022 23:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664839557;
        bh=sa6x2Y4X6FDtYWE8yoh+ksR16giNzpHhvQbHrMQesk0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MKfIS3GoYOvkfkaqvc+r1p8Pw+wURwoyotK9SroARKWfBpu/+q9ZQOwOlpgpukFoX
         ttsT+NmvDqAKE3XgmzXPiyMMQvpAuaNM2Pztfll4w8KM8xGxk462taC9ZJn0DL2pG6
         SeQzlvfA17I0Zicth+3ADGG9GmI4IkNIFXHFlt0psnIqItZ6vpoTbH8T2ps1z1nQnI
         zPOf3PeBb+bRplvZrp5bd7e2EjjXolJktJOiEF6jlRKeWCMF97bbd3ugsEYcnC+VhC
         4R/aM1vgL/PNqRIuFGdP29org0MWgah29EDAqPIKpQQf87a+0VfjgXUZVOYcE7PTAT
         OKadKIPbVxmvw==
Date:   Mon, 3 Oct 2022 16:25:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH 0/4] net: drop netif_attrmask_next*()
Message-ID: <20221003162556.10a80858@kernel.org>
In-Reply-To: <YzsluT4ET0zyjCtp@yury-laptop>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
        <20221003095048.1a683ba7@kernel.org>
        <YzsluT4ET0zyjCtp@yury-laptop>
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

On Mon, 3 Oct 2022 11:11:05 -0700 Yury Norov wrote:
> On Mon, Oct 03, 2022 at 09:50:48AM -0700, Jakub Kicinski wrote:
> > On Sun,  2 Oct 2022 08:16:58 -0700 Yury Norov wrote:  
> > > netif_attrmask_next_and() generates warnings if CONFIG_DEBUG_PER_CPU_MAPS
> > > is enabled.  
> > 
> > Could you describe the nature of the warning? Is it a false positive 
> > or a legit warning?
> > 
> > If the former perhaps we should defer until after the next merge window.  
> 
> The problem is that netif_attrmask_next_and() is called with
> n == nr_cpu_ids-1, which triggers cpu_max_bits_warn() after this:
> 
> https://lore.kernel.org/netdev/20220926103437.322f3c6c@kernel.org/

I see. Is that patch merged and on it's way? Perhaps we can just revert
it and try again after the merge window?

> Underlying bitmap layer handles this correctly, so this wouldn't make
> problems for people. But this is not a false-positive.
