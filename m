Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6739F56C599
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 03:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiGIBHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 21:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIBHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 21:07:24 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ECE774BE
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 18:07:22 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id by10-20020a056830608a00b0061c1ac80e1dso318969otb.13
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 18:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O1BqeX73LXl2qcs/plGOVBkD98choxHdeTatPZ7oLLc=;
        b=m+qttkhczSS4mvYApB3Sez+bxiq5BSOu+35cDUnBE0/3XBFehnzoOo4x28OSQQltxM
         RSDh5xLkB1gVhFm567DDjisfe2efiUeNcManSBn/HT7t1MiZwmVkCLYllsvvhnF7kVdm
         OYBeoI9ubdAqoxq288LgSduOxc2bdHuyh7u36ZKwn2cV5xzEWggOaVLKxs5H3optTUa9
         S7NOkoQe04pN/DIrx4Hh7VI9bBgyyS4a9LDnxxkKaFwbSCtYYW67ZdjDvVWTdWMmedXW
         pNitiETReTAm2KxYGC6t/U6s3uWhMNc4oaR6b7iDn8EKDxd5shnksOrJ8QLI1VQr9TRh
         //lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O1BqeX73LXl2qcs/plGOVBkD98choxHdeTatPZ7oLLc=;
        b=IOZ6pvBemNj18BuR3imETXQmG7glMjXnL+3B/eeKBSymsjwQsr/5V44eWMWMyGNsn7
         hVFZ6HYvu1ouW3VtgJHU5pGc7cpDzAezg/Qi94mWcjGM1LZK1DCf2l2besrn7e5xiJcM
         SDNxa29KDjpwqEMmxg1xRTZTHYMoj6fNxNMYGcoUdXcZ7asL9IRAsXb1w32drVfy7HU4
         8QNLkZqmSChV+F6lhdq8IF2w1aBkCpFxP8+1sQAmekUnlvvKQdfsE5IG2Bpm1L6qYWkP
         kBNTv/VE6Qux0FmuRcCEsfRQwMo1fJIkZezKPI6fD9UbYv13ExUtMbYTtqKalvU0mxgp
         psoA==
X-Gm-Message-State: AJIora/oiil/7VYNe62a2fXk6IplIy+4ti9xjQj/dZsdT/br83psl7hR
        gqnPsyyNUCBODFS0JFww8rnW586krEU1+83bYpvh/hfsFgU=
X-Google-Smtp-Source: AGRyM1uD10+B9+kGASBVshf5bjz6qY6fhRbcZnJB1LANQb6OtjyongqaH2j15p7eWhz0mOYntTI8XsZxEyyblxPDexU=
X-Received: by 2002:a05:6830:2787:b0:60c:33b4:f374 with SMTP id
 x7-20020a056830278700b0060c33b4f374mr2603392otu.295.1657328842277; Fri, 08
 Jul 2022 18:07:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220708151153.1813012-1-edumazet@google.com>
In-Reply-To: <20220708151153.1813012-1-edumazet@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 8 Jul 2022 21:06:45 -0400
Message-ID: <CADvbK_e3Z6=d9gZb7Psxh16dHbAKGX-CZYEG=g7CnNCJuscRnQ@mail.gmail.com>
Subject: Re: [PATCH net] vlan: fix memory leak in vlan_newlink()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        network dev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 11:11 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Blamed commit added back a bug I fixed in commit 9bbd917e0bec
> ("vlan: fix memory leak in vlan_dev_set_egress_priority")
>
> If a memory allocation fails in vlan_changelink() after other allocations
> succeeded, we need to call vlan_dev_free_egress_priority()
> to free all allocated memory because after a failed ->newlink()
> we do not call any methods like ndo_uninit() or dev->priv_destructor().
>
> In following example, if the allocation for last element 2000:2001 fails,
> we need to free eight prior allocations:
>
> ip link add link dummy0 dummy0.100 type vlan id 100 \
>         egress-qos-map 1:2 2:3 3:4 4:5 5:6 6:7 7:8 8:9 2000:2001
>
> syzbot report was:
>
> BUG: memory leak
> unreferenced object 0xffff888117bd1060 (size 32):
> comm "syz-executor408", pid 3759, jiffies 4294956555 (age 34.090s)
> hex dump (first 32 bytes):
> 09 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> backtrace:
> [<ffffffff83fc60ad>] kmalloc include/linux/slab.h:600 [inline]
> [<ffffffff83fc60ad>] vlan_dev_set_egress_priority+0xed/0x170 net/8021q/vlan_dev.c:193
> [<ffffffff83fc6628>] vlan_changelink+0x178/0x1d0 net/8021q/vlan_netlink.c:128
> [<ffffffff83fc67c8>] vlan_newlink+0x148/0x260 net/8021q/vlan_netlink.c:185
> [<ffffffff838b1278>] rtnl_newlink_create net/core/rtnetlink.c:3363 [inline]
> [<ffffffff838b1278>] __rtnl_newlink+0xa58/0xdc0 net/core/rtnetlink.c:3580
> [<ffffffff838b1629>] rtnl_newlink+0x49/0x70 net/core/rtnetlink.c:3593
> [<ffffffff838ac66c>] rtnetlink_rcv_msg+0x21c/0x5c0 net/core/rtnetlink.c:6089
> [<ffffffff839f9c37>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2501
> [<ffffffff839f8da7>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> [<ffffffff839f8da7>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
> [<ffffffff839f9266>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
> [<ffffffff8384dbf6>] sock_sendmsg_nosec net/socket.c:714 [inline]
> [<ffffffff8384dbf6>] sock_sendmsg+0x56/0x80 net/socket.c:734
> [<ffffffff8384e15c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2488
> [<ffffffff838523cb>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2542
> [<ffffffff838525b8>] __sys_sendmsg net/socket.c:2571 [inline]
> [<ffffffff838525b8>] __do_sys_sendmsg net/socket.c:2580 [inline]
> [<ffffffff838525b8>] __se_sys_sendmsg net/socket.c:2578 [inline]
> [<ffffffff838525b8>] __x64_sys_sendmsg+0x78/0xf0 net/socket.c:2578
> [<ffffffff845ad8d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> [<ffffffff845ad8d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> [<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Fixes: 37aa50c539bc ("vlan: introduce vlan_dev_free_egress_priority")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Xin Long <lucien.xin@gmail.com>
> ---
>  net/8021q/vlan_netlink.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
> index 53b1955b027f89245eb8dd46ede9d7bfd6e553a3..214532173536b790cf032615f73fb3d868d2aae1 100644
> --- a/net/8021q/vlan_netlink.c
> +++ b/net/8021q/vlan_netlink.c
> @@ -182,10 +182,14 @@ static int vlan_newlink(struct net *src_net, struct net_device *dev,
>         else if (dev->mtu > max_mtu)
>                 return -EINVAL;
>
> +       /* Note: If this initial vlan_changelink() fails, we need
> +        * to call vlan_dev_free_egress_priority() to free memory.
> +        */
>         err = vlan_changelink(dev, tb, data, extack);
> -       if (err)
> -               return err;
> -       err = register_vlan_dev(dev, extack);
> +
> +       if (!err)
> +               err = register_vlan_dev(dev, extack);
> +
>         if (err)
>                 vlan_dev_free_egress_priority(dev);
>         return err;
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
