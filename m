Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A5556C5C3
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 03:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGIBp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 21:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGIBp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 21:45:58 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A5257E38
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 18:45:56 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-10be0d7476aso779810fac.2
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 18:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W4zo9OAu7NrtCFU9y68Y9BNU4mH728a664NiUEIp42U=;
        b=QyfavS56PvNCaeXLSoWV969K9x54VYP+la8v54RKGCsYBQ6vLVi+vCS3LsUStlbbKl
         Pm4WY4HkDcMZbwkDtatAhLjM6EqyaPKJgVNDQ3L1gKS4+P7yAJO8EulS29tzVQJ3ASVR
         ICtjBfQiZ8gBv4OYWVYHz+y2Crg3rh69QA4x46REgKyH3VaLm944Z26kN6f8Z83zSOaZ
         VhnF8a38LFV/y+B3iOi+46yQ9kRUZZwiONJ98F4qr2NcZ9PBDhd2F1HOxHvEeU6YoM/d
         7ahWIyMFbyo6ongTZdJ+fa9d3IjKog/GrbZKMv+mJxS5cnunPfG8yjo/dt4imN+JbC9Q
         LPDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W4zo9OAu7NrtCFU9y68Y9BNU4mH728a664NiUEIp42U=;
        b=i2Qx3Cb+zxGTeE/jt7hzIJP+Qq7LcBgpUF4upXSHaN0QpnGpNNaBZhw8ywszBsycsA
         RqY4snvCiiZAK5Ybswjqa5MPbq8m5pCGvnrg2+CWlShWpaFQMaJ0L1GDWwfzWNVyMh4O
         7y5tU3aGP2/BlLBV7UT8SGPq7PCYPEc+CqtF78mOnbfQJWgkRowXJQUbZmXWiW2/e4xY
         hdN1MXXmwIC1kPDJnt7q3jFTQz0ei80oklEe/y5zUATSvSDhm2ZbvKSYHcHEcTQ5S5P0
         CQ06OnHTI/QeEN/VW617+D+KPYR+4NXTmIh1+mpPu9zitHHj4c2jyPK/CLRxuk+ezCPF
         uDyg==
X-Gm-Message-State: AJIora/SBDp2ewDXsQgbdSSB6l09/7jno/SHdZalklgOFozDQrFz5rJD
        4uOhKPA+5Xeacr/1m3A2FCH9G2aug4Wfoi5IdJHw2OIp7GE=
X-Google-Smtp-Source: AGRyM1sDXEKgH+XqiR1oGY9xMWLNvwRCBQB14Hcqu9E8cFj6cwZDQgcFI7Z6J+kjJ2+QhqgZ/2I0HTlVy5mSmHmlOFk=
X-Received: by 2002:a05:6870:c101:b0:10c:66d2:b069 with SMTP id
 f1-20020a056870c10100b0010c66d2b069mr1636479oad.190.1657331155173; Fri, 08
 Jul 2022 18:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220708151153.1813012-1-edumazet@google.com>
In-Reply-To: <20220708151153.1813012-1-edumazet@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 8 Jul 2022 21:45:17 -0400
Message-ID: <CADvbK_d9yd=pNUQ7NQ9xzeCuo6say2BBpYBPzt2GD2Yd2FYMCg@mail.gmail.com>
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
BTW, it seems that:

# ip link change link dummy0 dummy0.100 type vlan id 100
egress-qos-map 8:9 2003:2004

instead of changing qos-map to {8:1 2003:2004}, this cmd can only be
able to append the new qos-map "2003:2004".

Is this expected?

Thanks.

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
