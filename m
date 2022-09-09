Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DA65B3A85
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIIOSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiIIOSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:18:33 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8CCE620A;
        Fri,  9 Sep 2022 07:18:32 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 130so2874846ybw.8;
        Fri, 09 Sep 2022 07:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VbytLmMRnnM6D+hx4cbzIRzxIpXC9xuXG9bxMN4wW6Y=;
        b=ZU4l0BlvKHWF3H8qVZbeQkfoU8LRjo5IoljInQmPouLehXVif2PcgtjwUeEAxWWIxF
         1cfeyu+fTOtpURRqYRuCLvU9hMot3QWVcqQJhqQ7y/7smYkD0EQasKUEbiUVAYJB8XnM
         JpBocLy/gaRE3t8h1pqxVRRYg1VwqTW++rQDLuY0ZAzD041tACgGifblGnhjLYSbhtuj
         53BvX24ZciIp0TOSJ4r7YFskeFOZGuiCr4Txp9EcLc13MVAvMWNj2Xu2wBQvoZpZMqTN
         DMK42UYwz4QlmiNll3vK2XZrt4SQGgzJDw29goCz40bWjsjI8ipGMZ4Xx9eEsCkbe04S
         dlAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VbytLmMRnnM6D+hx4cbzIRzxIpXC9xuXG9bxMN4wW6Y=;
        b=NBCpT+3IY+niPmNIbzw9FAiAnQ8Z/3emwJdf9RD1fJ25h9kB7Sk4KsvL0LJARdSYwR
         Ug7KXVq8W366mu0/9ilhicVnMqt6JPhOAb2dEv+LvOTth169H6XtQVuPFNx2dUWj7NvG
         7QiZrsPf9UctYd1lMiP1L9vPsevMpJu0yU/opCYiatf6t+u+VkGPSC7f+ORdJGPblsOM
         NH8KIz63kPtQxPKEokeNrcNce0UJIbc/UPTHhg4NF+Tkb7lUvcqapLa9SUvR1/1rdJnI
         oAs/fAQ52646nUHL+RoRJGuqRKImqbVkAQFuGM+xnvw0G3Lo7Ouj0jpnUhu315butTGr
         R16g==
X-Gm-Message-State: ACgBeo3IFMm8X1V3Ks9whfLutDeWX72Tm5I04na4CihGuvRDs1n+2XiQ
        9BRZWDtJ8NbL6wg3rrf0DgVQIfZCqc2FRRDjKBc=
X-Google-Smtp-Source: AA6agR7vSOcYzsCIA9hXX+1/LDHIZ6o0So3GrKTSljCmGEaKuF25g33/mY0Dr22JOvp68/hKbN/+C+KOQT1wP+iBrNA=
X-Received: by 2002:a25:2785:0:b0:69b:b1d2:fd05 with SMTP id
 n127-20020a252785000000b0069bb1d2fd05mr11798559ybn.81.1662733111590; Fri, 09
 Sep 2022 07:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
From:   Petar Penkov <peterpenkov96@gmail.com>
Date:   Fri, 9 Sep 2022 07:18:21 -0700
Message-ID: <CA+DcSEhNjuKybHMEtjkUkPJB8wEUxkuYzmtM_Kmi02BtD-xojg@mail.gmail.com>
Subject: Re: [PATCH net] net: tun: limit first seg size to avoid oversized linearization
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, maheshb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, this looks good to me!

On Tue, Sep 6, 2022 at 6:56 PM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Recently, we found a syzkaller problem as following:
>
> ========================================================
> WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
> ...
> Call trace:
>  __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
>  __alloc_pages_node include/linux/gfp.h:550 [inline]
>  alloc_pages_node include/linux/gfp.h:564 [inline]
>  kmalloc_large_node+0x94/0x350 mm/slub.c:4038
>  __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
>  __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
>  pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
>  __skb_grow include/linux/skbuff.h:2779 [inline]
>  tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
>  tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
>  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
>
> It is because the first seg size of the iov_iter from user space is
> very big, it is 2147479538 which is bigger than the threshold value
> for bail out early in __alloc_pages(). And skb->pfmemalloc is true,
> __kmalloc_reserve() would use pfmemalloc reserves without __GFP_NOWARN
> flag. Thus we got a warning.
>
> I noticed that non-first segs size are required less than PAGE_SIZE in
> tun_napi_alloc_frags(). The first seg should not be a special case, and
> oversized linearization is also unreasonable. Limit the first seg size to
> PAGE_SIZE to avoid oversized linearization.
>
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
Acked-by: Petar Penkov <ppenkov@aviatrix.com>
