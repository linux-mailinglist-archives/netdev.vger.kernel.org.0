Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4283512071
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243643AbiD0Q5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243537AbiD0Q5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:57:19 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A945583B1
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:54:08 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ec42eae76bso25615847b3.10
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 09:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfiHkBYhkuuwagiza//CJWlmobKsPGjvIgfj2Zl77i0=;
        b=AX0PVJkenkMDyDZfWx53hn0/wD0EZ3SA5eNMPnuVyG0rTAZ59N8AHf66J+mEF3o1d6
         ymwrEPrOPEqkHgBwo2lSXDkpikJu6HDEzA6PRnkIhuzpEo+j+hw3tDekOejN+DUEIAwz
         6NUCyHm4LHKpm+dIGtLjnZVPp2EP913smV3pmeOETnB09AojJC+WsIQa/HLnXQRsW8ba
         W0NiGvT+tY8xhsiJmMjlO9qxObMLNm0D8NCPMfZ69xghN0vCeWtJHUnNk88pe7uQ/elm
         RrVU23hW0WGzJt22dv6/yzcnggu7h8TQ15uyBd0LeLYks1DRVXCkphy7ZMsgbZ6GW/L/
         PaeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfiHkBYhkuuwagiza//CJWlmobKsPGjvIgfj2Zl77i0=;
        b=SepskqW4a2EHe5XyHAiz/ccv2D2VYuMCwCKENgmDM5QUNXN4PH/Nio1ddZmsjE+g6R
         ymhqWEwnpGJia7Kqk9juJoM4L+J8MaZMhs9KYRbtwtWf9kluuQF0c5RU7+x4lpRFnXvJ
         ytS3fzXE3fmF5zpbLWL15VCLmQftUhFABa6AtO1CE9ciY0XR97Zd0de900u3fEXjciuo
         fr77x3Yq1XNdzN0vS1VFYSz29IW4eSuu6j6MWv6rWOwVk2BZ9O/pIbZWOz98+KItHQjZ
         1Sx9vm7Cj4GdeX3ElSEEoGZj+ZTQhuFYQcxZT7l55Fef427u8JuI0R+NsCEzdEA4RiNl
         tgTQ==
X-Gm-Message-State: AOAM531Q4J+Y9nW9s0MiKgeiRF85mkpEDUbfCWTKfd3KBnpgWSAzHtAD
        QX87nglffGCA6nSo8SDOlpIjpl1jniI6ZBJ8HsWLEA==
X-Google-Smtp-Source: ABdhPJwv7IMex+4x/KuBwlwWVvzt7ZGLpS6u+P36j3lENQFeUqIcaCH3/qQxHaizbB4uHEz+yPW4f3CnmZfirjdKj9c=
X-Received: by 2002:a0d:e8c7:0:b0:2f4:cd95:76d8 with SMTP id
 r190-20020a0de8c7000000b002f4cd9576d8mr27520111ywe.55.1651078447080; Wed, 27
 Apr 2022 09:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com> <YmlilMi5MmApVqTX@shredder>
In-Reply-To: <YmlilMi5MmApVqTX@shredder>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Apr 2022 09:53:55 -0700
Message-ID: <CANn89i+x44iM97YmGa6phMMUx6L5a3Cn86aNwq3OsbQf3iVgWA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
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

On Wed, Apr 27, 2022 at 8:34 AM Ido Schimmel <idosch@idosch.org> wrote:
>

>
> Eric, with this patch I'm seeing memory leaks such as these [1][2] after
> boot. The system is using the igb driver for its management interface
> [3]. The leaks disappear after reverting the patch.
>
> Any ideas?
>

No idea, skbs allocated to send an ACK can not be stored in receive
queue, I guess this is a kmemleak false positive.

Stress your host for hours, and check if there are real kmemleaks, as
in memory being depleted.

> Let me know if you need more info. I can easily test a patch.
>
> Thanks
>
> [1]
> # cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff888170143740 (size 216):
>   comm "softirq", pid 0, jiffies 4294825261 (age 95.244s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 17 0f 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff82571fc0>] napi_skb_cache_get+0xf0/0x180
>     [<ffffffff8257206a>] __napi_build_skb+0x1a/0x60
>     [<ffffffff8257b0f3>] napi_build_skb+0x23/0x350
>     [<ffffffffa0469592>] igb_poll+0x2b72/0x5880 [igb]
>     [<ffffffff825f9584>] __napi_poll.constprop.0+0xb4/0x480
>     [<ffffffff825f9d5a>] net_rx_action+0x40a/0xc60
>     [<ffffffff82e00295>] __do_softirq+0x295/0x9fe
>     [<ffffffff81185bcc>] __irq_exit_rcu+0x11c/0x180
>     [<ffffffff8118622a>] irq_exit_rcu+0xa/0x20
>     [<ffffffff82bbed39>] common_interrupt+0xa9/0xc0
>     [<ffffffff82c00b5e>] asm_common_interrupt+0x1e/0x40
>     [<ffffffff824a186e>] cpuidle_enter_state+0x27e/0xcb0
>     [<ffffffff824a236f>] cpuidle_enter+0x4f/0xa0
>     [<ffffffff8126a290>] do_idle+0x3b0/0x4b0
>     [<ffffffff8126a869>] cpu_startup_entry+0x19/0x20
>     [<ffffffff810f4725>] start_secondary+0x265/0x340
>
> [2]
> # cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff88810ce3aac0 (size 216):
>   comm "softirq", pid 0, jiffies 4294861408 (age 64.607s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 c0 7b 07 81 88 ff ff 00 00 00 00 00 00 00 00  ..{.............
>   backtrace:
>     [<ffffffff82575539>] __alloc_skb+0x229/0x360
>     [<ffffffff8290bd3c>] __tcp_send_ack.part.0+0x6c/0x760
>     [<ffffffff8291a062>] tcp_send_ack+0x82/0xa0
>     [<ffffffff828cb6db>] __tcp_ack_snd_check+0x15b/0xa00
>     [<ffffffff828f17fe>] tcp_rcv_established+0x198e/0x2120
>     [<ffffffff829363b5>] tcp_v4_do_rcv+0x665/0x9a0
>     [<ffffffff8293d8ae>] tcp_v4_rcv+0x2c1e/0x32f0
>     [<ffffffff828610b3>] ip_protocol_deliver_rcu+0x53/0x2c0
>     [<ffffffff828616eb>] ip_local_deliver+0x3cb/0x620
>     [<ffffffff8285e66f>] ip_sublist_rcv_finish+0x9f/0x2c0
>     [<ffffffff82860895>] ip_list_rcv_finish.constprop.0+0x525/0x6f0
>     [<ffffffff82861f88>] ip_list_rcv+0x318/0x460
>     [<ffffffff825f5e61>] __netif_receive_skb_list_core+0x541/0x8f0
>     [<ffffffff825f8043>] netif_receive_skb_list_internal+0x763/0xdc0
>     [<ffffffff826c3025>] napi_gro_complete.constprop.0+0x5a5/0x700
>     [<ffffffff826c44ed>] dev_gro_receive+0xf2d/0x23f0
> unreferenced object 0xffff888175e1afc0 (size 216):
>   comm "sshd", pid 1024, jiffies 4294861424 (age 64.591s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 c0 7b 07 81 88 ff ff 00 00 00 00 00 00 00 00  ..{.............
>   backtrace:
>     [<ffffffff82575539>] __alloc_skb+0x229/0x360
>     [<ffffffff8258201c>] alloc_skb_with_frags+0x9c/0x720
>     [<ffffffff8255f333>] sock_alloc_send_pskb+0x7b3/0x940
>     [<ffffffff82876af4>] __ip_append_data+0x1874/0x36d0
>     [<ffffffff8287f283>] ip_make_skb+0x263/0x2e0
>     [<ffffffff82978afa>] udp_sendmsg+0x1c8a/0x29d0
>     [<ffffffff829af94e>] inet_sendmsg+0x9e/0xe0
>     [<ffffffff8255082d>] __sys_sendto+0x23d/0x360
>     [<ffffffff82550a31>] __x64_sys_sendto+0xe1/0x1b0
>     [<ffffffff82bbde05>] do_syscall_64+0x35/0x80
>     [<ffffffff82c00068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> [3]
> # ethtool -i enp8s0
> driver: igb
> version: 5.18.0-rc3-custom-91743-g481c1b
> firmware-version: 3.25, 0x80000708, 1.1824.0
> expansion-rom-version:
> bus-info: 0000:08:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: yes
