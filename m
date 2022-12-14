Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E095864C6F5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbiLNKUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbiLNKUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:20:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E5813F0D;
        Wed, 14 Dec 2022 02:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F04CCCE18FF;
        Wed, 14 Dec 2022 10:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537CEC433D2;
        Wed, 14 Dec 2022 10:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671013227;
        bh=ctV7YHyh+mUHUVb+WNS0Td3VCfMraV0LfMLGZFLM5yM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mf5HqAOSX2E1VIvOg0Pap+A/XtjXWseXNTrUPqIJ4JaBd8FY00nBxoWly+cb9bRG/
         PXHlWxc53+QFFe7rj5jNmrChYTLno9PZcgCfy6PmxtYG55QV2Vb0HHFzkPZ/oniwu+
         ZWjHbiS8YkXpu5m/5PEolDl9hn0izxKOnDD9C38azQ2rHg204b69vAAeXxZKHuuxRu
         R/PaJK2nQUrCDrUM7xaiVKiKi+nSpNnnSlFtMwB0bPeFABnozsauLbqzv462ucxrt9
         WnWDynLnbxYBBdBRF8IpBSdm76v6nzVd1jd47MQUDrlOZnksfkLl3RSALYmA7zc4fr
         LrZj6QrHl5sAA==
Date:   Wed, 14 Dec 2022 10:20:21 +0000
From:   Lee Jones <lee@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jialiang Wang <wangjialiang0806@163.com>, stable@kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <Y5mjZWpTgc4oJxDg@google.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
 <Y5CFNqYNMkryiDcP@google.com>
 <Y5HwAWNtH5IfH9OA@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5HwAWNtH5IfH9OA@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Stable,

On Thu, 08 Dec 2022, Simon Horman wrote:
> On Wed, Dec 07, 2022 at 12:21:10PM +0000, Lee Jones wrote:
> > [Some people who received this message don't often get email from lee@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > On Wed, 10 Aug 2022, Jialiang Wang wrote:
> > 
> > > area_cache_get() is used to distribute cache->area and set cache->id,
> > >  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
> > >  release the cache->area by nfp_cpp_area_release(). area_cache_get()
> > >  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> > >
> > > But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
> > >  is already set but the refcount is not increased as expected. At this
> > >  time, calling the nfp_cpp_area_release() will cause use-after-free.
> > >
> > > To avoid the use-after-free, set cache->id after area_init() and
> > >  nfp_cpp_area_acquire() complete successfully.
> > >
> > > Note: This vulnerability is triggerable by providing emulated device
> > >  equipped with specified configuration.
> > >
> > >  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> > > /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> > >   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
> > >
> > >  Call Trace:
> > >   <TASK>
> > >  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> > >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
> > >
> > >  Allocated by task 1:
> > >  nfp_cpp_area_alloc_with_name (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
> > >  nfp_cpp_area_cache_add (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
> > >  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
> > >  nfp_cpp_from_operations (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
> > >  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > /netronome/nfp/nfp_main.c:744)
> > >
> > >  Freed by task 1:
> > >  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
> > >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
> > >  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > /netronome/nfp/nfpcore/nfp_cppcore.c:924 /home/user/Kernel/v5.19/x86_64
> > > /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
> > >  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > /netronome/nfp/nfpcore/nfp_cpplib.c:48)
> > >
> > > Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
> > 
> > Any reason why this doesn't have a Fixes: tag applied and/or didn't
> > get sent to Stable?
> > 
> > Looks as if this needs to go back as far as v4.19.
> > 
> > Fixes: 4cb584e0ee7df ("nfp: add CPP access core")
> > 
> > commit 02e1a114fdb71e59ee6770294166c30d437bf86a upstream.
> 
> Hi Lee,
> 
> From my side this looks like an oversight.

Understood, thank you Simon.

Stable Team, are you prepared to take this patch with the above info?

-- 
Lee Jones [李琼斯]
