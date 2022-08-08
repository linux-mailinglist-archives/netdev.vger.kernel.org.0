Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A55A58CE74
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244351AbiHHTQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244400AbiHHTQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5000219C11;
        Mon,  8 Aug 2022 12:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2F52612B7;
        Mon,  8 Aug 2022 19:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00901C433D6;
        Mon,  8 Aug 2022 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659986138;
        bh=ixU74nyB6lXnufS/Mxla5bKUb4noApy93h18rcJcCRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UBurGjx9NurCEAl795DGLNzZQIlE+xM/euccxXXfMp22iMdqCmFoM5WNELFOisml+
         Mzq7k37AuK0sERsvWDCB6RlPGaTSXu7wqVMQ9R1rGfTucTWEkJsOybtbS8W7OE6HEO
         OyYC20uqQDDS5CV7xjjs8HESkvudJ7h1BeW03g6kjBT4UcMXpZLArgQAs+XpPfDs+H
         ZQPTGBDAeHmlmEGQkZAAgKiqHnKTWIqL1YLMttGPVw/KN69uXk39CLwrIIz68JN6vm
         LzKGcoq8GBLUoMJ4ioQTUskEYpItlmMHb5TvDFXDQGK3+CjekFIBosJN0QKcWNNHjL
         yQXjBJnYkdTSg==
Date:   Mon, 8 Aug 2022 12:15:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jialiang Wang <wangjialiang0806@163.com>
Cc:     simon.horman@corigine.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, niejianglei2021@163.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: fix use-after-free in area_cache_get()
Message-ID: <20220808121536.412c042d@kernel.org>
In-Reply-To: <20220806143043.106787-1-wangjialiang0806@163.com>
References: <20220806143043.106787-1-wangjialiang0806@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  6 Aug 2022 22:30:43 +0800 Jialiang Wang wrote:
> area_cache_get() calls cpp->op->area_init() and uses cache->area by
>  nfp_cpp_area_priv(area), but in
>  nfp_cpp_area_release()->nfp_cpp_area_put()->__release_cpp_area() we
>  already freed the cache->area.
> 
> To avoid the use-after-free, reallocate a piece of memory for the
>  cache->area by nfp_cpp_area_alloc().
> 
> Note: This vulnerability is triggerable by providing emulated device
>  equipped with specified configuration.
> 
> BUG: KASAN: use-after-free in nfp6000_area_init+0x74/0x1d0 [nfp]
> Write of size 4 at addr ffff888005b490a0 by task insmod/226
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x33/0x46
>   print_report.cold.12+0xb2/0x6b7
>   ? nfp6000_area_init+0x74/0x1d0 [nfp]
>   kasan_report+0xa5/0x120
>   ? nfp6000_area_init+0x74/0x1d0 [nfp]
>   nfp6000_area_init+0x74/0x1d0 [nfp]
>   area_cache_get.constprop.8+0x2da/0x360 [nfp]

Please provide more of the report, including the allocated at and freed
at sections and run the thing thru stack decode so we get the line
numbers.
