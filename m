Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7D664D880
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLOJZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOJZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:25:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B86662EB;
        Thu, 15 Dec 2022 01:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDBDAB81B1F;
        Thu, 15 Dec 2022 09:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A98BC433EF;
        Thu, 15 Dec 2022 09:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671096330;
        bh=Ghx7bQQmB4dNko5TEqFTpcrI/7XoAzb8oef6uZQtmfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUp637i7/fbnFMM8pD7qQLn51ZBBtgxlLxRbeB+owEkPVDdiwl47ZmRQSsvqBjoh0
         6aFpa85Uof3gsNKbNntSPR2jtYoE54fc+d2oXKQyyyYMzjBsobT+6nUXXVXTGt4VlT
         utbfcpUNBLpoMHkAqyIzYrsWUT/Tu2nj/lL6KmKmmQ37RX9CF5UwDWZA5dHrAZlp33
         xGvHX+EY+Sz63DxZxuyhvrrG+XvGMd5a/w3mhhfbxeD9JElxM47/zv/RzW7Q9lU153
         E28OXLLPDWgRBqZ95l46kdJklCNSpOlq4t3nR5UPKnvR2jtZyH+ThnwEugnLd1QzhJ
         Os3wZcDvNhaFQ==
Date:   Thu, 15 Dec 2022 09:25:23 +0000
From:   Lee Jones <lee@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jialiang Wang <wangjialiang0806@163.com>, stable@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <Y5roA4gOpvKBQySv@google.com>
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

[NB: Re-poking Stable with the correct contact address this time! :)]

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

Would you be able to take this with the information provided please?

-- 
Lee Jones [李琼斯]
