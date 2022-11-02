Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628A0616B6D
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiKBSDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiKBSDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:03:16 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F9A2E68C
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:03:15 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-368edbc2c18so173359177b3.13
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TZ+dLjoYm09HSwY2V625UBoDfQUrFrbVVtB8huuIfFI=;
        b=AGksGsxycKU0pz7YGhRbwj2Iojk6QuhT7MKrH3A54CQzhF11pu+owlFVD+BOsAMKWi
         2uKu0k2uauNRvZuCpakhRq0ZWFyLW+ty0mlMEH8nz0+oRY2Vvz4izXaXUld6Wrd+tY1n
         JKnFsLrXniOFttFffAIWvS1enZyTEZrRjlne1CM14wmMOCHXUWhlP3WlQ+I/3sruJXlz
         ssmaENl4smV9KLqONOmdzvMtk9lFuvWdy22gLYHch7q8vJjFLb2W0ykcjm64xfLPi0lJ
         4eUiK2fVWwl9v4Z3IeygH+DKoRppTTk/yXdv/ylHAJ3HEqwyYj0/90vM+aGjQICmommR
         wgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZ+dLjoYm09HSwY2V625UBoDfQUrFrbVVtB8huuIfFI=;
        b=YuTkKR/S6MbfTGGWtx8AIuLFLFrxndnSaa+D1lZ8Noyc4/vPwC3F07RIMMlypdch7d
         H8razIf2/v/RtprbVv293rL7MkOxW1zHNqHCVW6whWBX+x3ZECbY6ugGoOsAj60cnEcN
         vipVmIUnsOiFgvGrwd4quoL0xZsB+3F57PYrKVxbFjIW9jy0q+at8gpoFAoaobpA3CCI
         xfMap4njeBUawaMvoKrIe29yINNrSLQ1t8zWYSjJoXvQxGrGJIE9BzkM99pj8IpyRPuc
         b/frqaRmwvufyV8j90r/cIX4UL+FejPuwKs2mbq72A8D+PQWKDrC1aMZCQJp9/Qd/k70
         1Z7Q==
X-Gm-Message-State: ACrzQf1So4gFRYBDPxOfHth8CcfVUxn/5//7w2x3/vLmiXxU0YCShcp2
        wlUdHsFZNl4aXtJNJ/nPzneVGzVyZhTaL/FNFYhhdg==
X-Google-Smtp-Source: AMsMyM5Gqb6kUi17AH+BhzL0TfWF5uPqYKuMPUkJ++nMUJUlhOgg1fieoLPpuovS0RDTOJskgH/sqYJGZby0NqYzkv4=
X-Received: by 2002:a81:c11:0:b0:36a:bcf0:6340 with SMTP id
 17-20020a810c11000000b0036abcf06340mr24062798ywm.467.1667412194201; Wed, 02
 Nov 2022 11:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <1667382079-6499-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1667382079-6499-1-git-send-email-wangyufen@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 11:03:03 -0700
Message-ID: <CANn89iJdWq-RvictmCtxE0C6EBifOxEDfoc5xLU0cKyTPcSy7w@mail.gmail.com>
Subject: Re: [PATCH net v2] net: tun: Fix memory leaks of napi_get_frags
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, peterpenkov96@gmail.com
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

On Wed, Nov 2, 2022 at 2:20 AM Wang Yufen <wangyufen@huawei.com> wrote:
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
>   <-- not ask to complete the gro work, will cause memory leaks in
>   <-- following tun_napi_del()
> ...
> tun_napi_del()
>   netif_napi_del()
>     __netif_napi_del()
>     <-- &napi->rx_list is not empty, which caused memory leaks
>
> To fix, add napi_complete() after napi_gro_frags().
>
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  drivers/net/tun.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 27c6d23..07a0a61 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1976,6 +1976,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>
>                 local_bh_disable();
>                 napi_gro_frags(&tfile->napi);
> +               napi_complete(&tfile->napi);
>                 local_bh_enable();
>                 mutex_unlock(&tfile->napi_mutex);
>         } else if (tfile->napi_enabled) {
> --
> 1.8.3.1
>

I think the intent of this code was to allow user space to send
multiple packets to GRO layer for test purposes.
(Check that GRO can aggregate multiple MSS, with respect of standard GRO rules)
This fix might break some tests, but they can be updated if needed
(using /sys/class/net/xxx/gro_flush_timeout)

Reviewed-by: Eric Dumazet <edumazet@google.com>
