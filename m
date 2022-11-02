Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EC4615B6D
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKBE2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiKBE1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:27:55 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226B22496C
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 21:27:54 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id y72so19751545yby.13
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 21:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fMRUmAr79mhf65R3r3CTqFdQA1gI3MmG4TA4Iq1Mxog=;
        b=cPFC1Q0Jchcu9Gb/9jpSZ2rILmIQvFj7BEqMbVp0umpAFjI/+0GXjGwL1icgjpaV/g
         buteaKvrbSHRt9NUEq2sW3Jg4o8hsXxyZdKLqUbdzJIrxAbFRdY4dAQ2QvEvmLiwGTD4
         N6DVTgthxYnPaD/5nV/TpwdKaHGBpHefpyJAhRz5LtCVQXAPMyuEyaxXW+af/LAquKuy
         O0AZVkfFAFCgG/FRGQNeBk43VDrOuf9IckJgIF1ywli1l6n2z+hJXBaqKw9vFLLmNjmi
         v9Js+Bu8IeKE9Si7exNxD+USuca0EILYkD1x6WCxDR6ubUa0HLOU2tGu5Qi4ljAeASK9
         MnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fMRUmAr79mhf65R3r3CTqFdQA1gI3MmG4TA4Iq1Mxog=;
        b=Xq9zRFPMfJOEOL9qqwyr7RohrQUwQagnSfyahYN9G2NLIfs9hg7KMYWdif94slv0mL
         h3k3xAziugV7Z8sDKALkf7wWqUQ0CC30NBffvbvt7rM8mYX1RCLHgVuGaidRZDsWuZRx
         GSfllz8xtiMkMyiCm/vg0e/21uBbYF/BivNjee9qdu+u5fb8LtVW9nvXzjtBIAhxQC7F
         2K6gcFtP58vZ/+JWciiPK1UGlUDVaflnQlqbS4gmfIvLEe4rusYQUpebyG5qStux+FHr
         hVvzNDb2ximX2CqbsDXI7/dbpEZcPuLnW0LdfM52Mst0LA7u+p/Sjxsn2H2jKhOqDeSi
         22KA==
X-Gm-Message-State: ACrzQf3/g88aztR+xphbK/cxetXYwkAX7YNebPWkuT6ilP6xIQLA4VYc
        vkVxExn3dYS3qkpprM+B4C4AneGsgB3RocYBdzFz4OeJVFc=
X-Google-Smtp-Source: AMsMyM44kU871oUxZPoc03xn+TmZq+NKDSwkW+arkCqFM/EoV1M/i3I6vzhuoE/MvnBYO3y9i/AfiEEG4PSqKvjA0Z8=
X-Received: by 2002:a25:6647:0:b0:6cb:8601:238a with SMTP id
 z7-20020a256647000000b006cb8601238amr20885797ybm.598.1667363273106; Tue, 01
 Nov 2022 21:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <1667361274-2621-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1667361274-2621-1-git-send-email-wangyufen@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Nov 2022 21:27:42 -0700
Message-ID: <CANn89i+cNjUH8pR0-QTdWM09G8ZfX_gzDqOY6ecyY4igDwrYaQ@mail.gmail.com>
Subject: Re: [PATCH net] net: Fix memory leaks of napi->rx_list
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ecree@solarflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 1, 2022 at 8:34 PM Wang Yufen <wangyufen@huawei.com> wrote:
>
> kmemleak reports after running test_progs:
>
> unreferenced object 0xffff8881b1672dc0 (size 232):
>   comm "test_progs", pid 394388, jiffies 4354712116 (age 841.975s)
>   hex dump (first 32 bytes):
>     e0 84 d7 a8 81 88 ff ff 80 2c 67 b1 81 88 ff ff  .........,g.....
>     00 40 c5 9b 81 88 ff ff 00 00 00 00 00 00 00 00  .@..............
>   backtrace:
>     [<00000000c8f01748>] napi_skb_cache_get+0xd4/0x150
>     [<0000000041c7fc09>] __napi_build_skb+0x15/0x50
>     [<00000000431c7079>] __napi_alloc_skb+0x26e/0x540
>     [<000000003ecfa30e>] napi_get_frags+0x59/0x140
>     [<0000000099b2199e>] tun_get_user+0x183d/0x3bb0 [tun]
>     [<000000008a5adef0>] tun_chr_write_iter+0xc0/0x1b1 [tun]
>     [<0000000049993ff4>] do_iter_readv_writev+0x19f/0x320
>     [<000000008f338ea2>] do_iter_write+0x135/0x630
>     [<000000008a3377a4>] vfs_writev+0x12e/0x440
>     [<00000000a6b5639a>] do_writev+0x104/0x280
>     [<00000000ccf065d8>] do_syscall_64+0x3b/0x90
>     [<00000000d776e329>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The issue occurs in the following scenarios:
> tun_get_user()
>   napi_gro_frags()
>     napi_frags_finish()
>       case GRO_NORMAL:
>         gro_normal_one()
>           list_add_tail(&skb->list, &napi->rx_list);
>           <-- While napi->rx_count < READ_ONCE(gro_normal_batch),
>           <-- gro_normal_list() is not called, napi->rx_list is not empty
> ...
> netif_napi_del()
>   __netif_napi_del()
>   <-- &napi->rx_list is not empty, which caused memory leaks
>
> To fix, add flush_rx_list() to free skbs in napi->rx_list.
>
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")

I do not think the bug is there.

Most likely tun driver is buggy.

It does not follow the correct napi protocol.

It feeds packets to GRO, but does not ever ask to complete the work.

More sanity work is needed in tun, not in GRO layer.


> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  net/core/dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3be2560..de3bc9c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6461,6 +6461,16 @@ static void flush_gro_hash(struct napi_struct *napi)
>         }
>  }
>
> +static void flush_rx_list(struct napi_struct *napi)
> +{
> +       struct sk_buff *skb, *next;
> +
> +       list_for_each_entry_safe(skb, next, &napi->rx_list, list) {
> +               skb_list_del_init(skb);
> +               kfree_skb(skb);
> +       }
> +}
> +
>  /* Must be called in process context */
>  void __netif_napi_del(struct napi_struct *napi)
>  {
> @@ -6471,6 +6481,7 @@ void __netif_napi_del(struct napi_struct *napi)
>         list_del_rcu(&napi->dev_list);
>         napi_free_frags(napi);
>
> +       flush_rx_list(napi);
>         flush_gro_hash(napi);
>         napi->gro_bitmask = 0;
>
> --
> 1.8.3.1
>
