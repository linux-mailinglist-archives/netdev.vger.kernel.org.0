Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16A364D8E6
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiLOJqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiLOJpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4D63A2;
        Thu, 15 Dec 2022 01:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E5AB8169B;
        Thu, 15 Dec 2022 09:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E66AC433EF;
        Thu, 15 Dec 2022 09:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671097550;
        bh=URF8kvnXmm4BcP1TbxIMhysn2xcdIgsFycLZvZfysCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KAn6hWt1c9cQ9omJOJ5sU9iSW7M5u95iBbI5Ae9fdKowwdQWjPyLIkPmIWClzvuXE
         2+Hnhq0tqGBgN0KsHaH6qhovzlzleL54J6VDxsVlfS0IeV0BiDf4r/1K2/KlMZqRs0
         He7/849MoO43kDNz3HeFdp+8Z8i8jml6EUfviIaE=
Date:   Thu, 15 Dec 2022 10:45:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jialiang Wang <wangjialiang0806@163.com>,
        stable@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <Y5rsyiDNWp1QLhka@kroah.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
 <Y5CFNqYNMkryiDcP@google.com>
 <Y5HwAWNtH5IfH9OA@corigine.com>
 <Y5roA4gOpvKBQySv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5roA4gOpvKBQySv@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 09:25:23AM +0000, Lee Jones wrote:
> Dear Stable,
> 
> [NB: Re-poking Stable with the correct contact address this time! :)]
> 
> > > > area_cache_get() is used to distribute cache->area and set cache->id,
> > > >  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
> > > >  release the cache->area by nfp_cpp_area_release(). area_cache_get()
> > > >  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> > > >
> > > > But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
> > > >  is already set but the refcount is not increased as expected. At this
> > > >  time, calling the nfp_cpp_area_release() will cause use-after-free.
> > > >
> > > > To avoid the use-after-free, set cache->id after area_init() and
> > > >  nfp_cpp_area_acquire() complete successfully.
> > > >
> > > > Note: This vulnerability is triggerable by providing emulated device
> > > >  equipped with specified configuration.
> > > >
> > > >  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> > > > /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> > > >   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
> > > >
> > > >  Call Trace:
> > > >   <TASK>
> > > >  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > > /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> > > >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
> > > >
> > > >  Allocated by task 1:
> > > >  nfp_cpp_area_alloc_with_name (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
> > > >  nfp_cpp_area_cache_add (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
> > > >  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
> > > >  nfp_cpp_from_operations (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
> > > >  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > /netronome/nfp/nfp_main.c:744)
> > > >
> > > >  Freed by task 1:
> > > >  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
> > > >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
> > > >  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > /netronome/nfp/nfpcore/nfp_cppcore.c:924 /home/user/Kernel/v5.19/x86_64
> > > > /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
> > > >  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > /netronome/nfp/nfpcore/nfp_cpplib.c:48)
> > > >
> > > > Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
> > > 
> > > Any reason why this doesn't have a Fixes: tag applied and/or didn't
> > > get sent to Stable?
> > > 
> > > Looks as if this needs to go back as far as v4.19.
> > > 
> > > Fixes: 4cb584e0ee7df ("nfp: add CPP access core")
> > > 
> > > commit 02e1a114fdb71e59ee6770294166c30d437bf86a upstream.
> 
> Would you be able to take this with the information provided please?

You really want this back to 4.14.y, as 4cb584e0ee7df ("nfp: add CPP
access core") showed up in the 4.11 release, right?

if so, now queued up.

greg k-h
