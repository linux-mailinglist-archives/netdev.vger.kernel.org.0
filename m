Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC86459BC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiLGMVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiLGMVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:21:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FC74876A;
        Wed,  7 Dec 2022 04:21:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCF56151B;
        Wed,  7 Dec 2022 12:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70056C433C1;
        Wed,  7 Dec 2022 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670415676;
        bh=bJTOYGRKbBLBl4IJzYfsfgHZILlH+TXYGlIDqiob+aA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QQ7OVP0j9g8UjR2IdP7zKi2/TmTvDKxoLkKJ4hNt69mrYOdTdmf7W/4ZBtXDfrBt3
         +avNeA0dI+Q9zQQDguOb2T5VFQyURoR0Q0xt0v+sdL33Q77DwK2ujq1BSoq9l0HggZ
         nKLivTBiKxVnnym2e2fx8BDfxpTm4ILF362fpUaeVKF3aabLSPQ4MgkaB7rPhcqv7o
         ymsUcR8xHY+/LGj0KwNRrqd5X8ep46rAAbXf+StEEe8YyaQKMmzGO52DyiC49mP9vm
         Ikmm7CIj0+LoJhnY3djalDUkdSOabCIWiBxyJbf9Xo/jwQCBV8m4ml/0R8ViIkou53
         ANgcXQtIfkI4g==
Date:   Wed, 7 Dec 2022 12:21:10 +0000
From:   Lee Jones <lee@kernel.org>
To:     Jialiang Wang <wangjialiang0806@163.com>, stable@kernel.org
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nfp: fix use-after-free in area_cache_get()
Message-ID: <Y5CFNqYNMkryiDcP@google.com>
References: <20220810073057.4032-1-wangjialiang0806@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220810073057.4032-1-wangjialiang0806@163.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022, Jialiang Wang wrote:

> area_cache_get() is used to distribute cache->area and set cache->id,
>  and if cache->id is not 0 and cache->area->kref refcount is 0, it will
>  release the cache->area by nfp_cpp_area_release(). area_cache_get()
>  set cache->id before cpp->op->area_init() and nfp_cpp_area_acquire().
> 
> But if area_init() or nfp_cpp_area_acquire() fails, the cache->id is
>  is already set but the refcount is not increased as expected. At this
>  time, calling the nfp_cpp_area_release() will cause use-after-free.
> 
> To avoid the use-after-free, set cache->id after area_init() and
>  nfp_cpp_area_acquire() complete successfully.
> 
> Note: This vulnerability is triggerable by providing emulated device
>  equipped with specified configuration.
> 
>  BUG: KASAN: use-after-free in nfp6000_area_init (/home/user/Kernel/v5.19
> /x86_64/src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
>   Write of size 4 at addr ffff888005b7f4a0 by task swapper/0/1
> 
>  Call Trace:
>   <TASK>
>  nfp6000_area_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> /ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c:760)
>  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:884)
> 
>  Allocated by task 1:
>  nfp_cpp_area_alloc_with_name (/home/user/Kernel/v5.19/x86_64/src/drivers
> /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:303)
>  nfp_cpp_area_cache_add (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:802)
>  nfp6000_init (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfpcore/nfp6000_pcie.c:1230)
>  nfp_cpp_from_operations (/home/user/Kernel/v5.19/x86_64/src/drivers/net
> /ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:1215)
>  nfp_pci_probe (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfp_main.c:744)
> 
>  Freed by task 1:
>  kfree (/home/user/Kernel/v5.19/x86_64/src/mm/slub.c:4562)
>  area_cache_get.constprop.8 (/home/user/Kernel/v5.19/x86_64/src/drivers
> /net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:873)
>  nfp_cpp_read (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfpcore/nfp_cppcore.c:924 /home/user/Kernel/v5.19/x86_64
> /src/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c:973)
>  nfp_cpp_readl (/home/user/Kernel/v5.19/x86_64/src/drivers/net/ethernet
> /netronome/nfp/nfpcore/nfp_cpplib.c:48)
> 
> Signed-off-by: Jialiang Wang <wangjialiang0806@163.com>

Any reason why this doesn't have a Fixes: tag applied and/or didn't
get sent to Stable?

Looks as if this needs to go back as far as v4.19.

Fixes: 4cb584e0ee7df ("nfp: add CPP access core")

commit 02e1a114fdb71e59ee6770294166c30d437bf86a upstream.

> ---
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> index 34c0d2ddf9ef..a8286d0032d1 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
> @@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
>  	}
>  
>  	/* Adjust the start address to be cache size aligned */
> -	cache->id = id;
>  	cache->addr = addr & ~(u64)(cache->size - 1);
>  
>  	/* Re-init to the new ID and address */
> @@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
>  		return NULL;
>  	}
>  
> +	cache->id = id;
> +
>  exit:
>  	/* Adjust offset */
>  	*offset = addr - cache->addr;

-- 
Lee Jones [李琼斯]
