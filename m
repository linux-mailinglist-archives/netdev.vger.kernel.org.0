Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D23264D90C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiLOJwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiLOJva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28398183B8;
        Thu, 15 Dec 2022 01:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6AF061D48;
        Thu, 15 Dec 2022 09:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446CDC433EF;
        Thu, 15 Dec 2022 09:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671097888;
        bh=FLxhdTY1VQyzwuVG4/oOhod3ZbSIZVOgwKf6XLYV1MA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MMmP9YTQ4+7Uq3C6aqSAyLsc1NPi2HjOnLfNzaxBSFW/sWd0+E1NYJYQcdggTomMj
         FDWrfRfN2JXKlS6aSyjb5e97cADfhK9tQe4Z3ZFELt6FNDjYjhZAY+sGR/77f0bSs8
         /Ptf2SFeLw22wtrTx7mX26zSYL6vHgwhAA9rYpTZKIJT67I/Zf459NbFnuN2g68VLe
         cp7SD1Lb3LE8Iv8QyQ64K4i9yeDyljNSsTjF9aAJD2PJ21wu3gzdEQsa3Ewp8y3J01
         w0Rc4uKNRnRgUfweSffTDejQKm/P0tHLSntgoyj1XPuV5hPW+dtk7w3Cnro0zeg9rP
         boMctuMA6N+eQ==
Date:   Thu, 15 Dec 2022 09:51:21 +0000
From:   Lee Jones <lee@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jialiang Wang <wangjialiang0806@163.com>,
        stable@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <Y5ruGRFfLAeI9jhy@google.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
 <Y5CFNqYNMkryiDcP@google.com>
 <Y5HwAWNtH5IfH9OA@corigine.com>
 <Y5roA4gOpvKBQySv@google.com>
 <Y5rsyiDNWp1QLhka@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5rsyiDNWp1QLhka@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022, Greg KH wrote:

> On Thu, Dec 15, 2022 at 09:25:23AM +0000, Lee Jones wrote:
> > Dear Stable,
> > 
> > [NB: Re-poking Stable with the correct contact address this time! :)]
> > 
> > > > > area_cache_get() is used to distribute cache->area and set cache->id,
> > > > >  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
> > > > >  release the cache->area by nfp_cpp_area_release(). area_cache_get()
> > > > >  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> > > > >
> > > > > But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
> > > > >  is already set but the refcount is not increased as expected. At this
> > > > >  time, calling the nfp_cpp_area_release() will cause use-after-free.
> > > > >
> > > > > To avoid the use-after-free, set cache->id after area_init() and
> > > > >  nfp_cpp_area_acquire() complete successfully.
> > > > >
> > > > > Note: This vulnerability is triggerable by providing emulated device
> > > > >  equipped with specified configuration.
> > > > >
> > > > >  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> > > > > /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> > > > >   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
> > > > >
> > > > >  Call Trace:
> > > > >   <TASK>
> > > > >  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > > > /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
> > > > >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
> > > > >
> > > > >  Allocated by task 1:
> > > > >  nfp_cpp_area_alloc_with_name (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
> > > > >  nfp_cpp_area_cache_add (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > > > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
> > > > >  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > > /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
> > > > >  nfp_cpp_from_operations (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> > > > > /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
> > > > >  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > > /netronome/nfp/nfp_main.c:744)
> > > > >
> > > > >  Freed by task 1:
> > > > >  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
> > > > >  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> > > > > /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
> > > > >  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > > /netronome/nfp/nfpcore/nfp_cppcore.c:924 /home/user/Kernel/v5.19/x86_64
> > > > > /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
> > > > >  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> > > > > /netronome/nfp/nfpcore/nfp_cpplib.c:48)
> > > > >
> > > > > Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>
> > > > 
> > > > Any reason why this doesn't have a Fixes: tag applied and/or didn't
> > > > get sent to Stable?
> > > > 
> > > > Looks as if this needs to go back as far as v4.19.
> > > > 
> > > > Fixes: 4cb584e0ee7df ("nfp: add CPP access core")
> > > > 
> > > > commit 02e1a114fdb71e59ee6770294166c30d437bf86a upstream.
> > 
> > Would you be able to take this with the information provided please?
> 
> You really want this back to 4.14.y, as 4cb584e0ee7df ("nfp: add CPP
> access core") showed up in the 4.11 release, right?

Yes please.  Brain said one thing, fingers typed another!

> if so, now queued up.

Thank you.

-- 
Lee Jones [李琼斯]
