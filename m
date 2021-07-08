Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47753C1B1A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhGHVlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhGHVlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 17:41:21 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8235C061574;
        Thu,  8 Jul 2021 14:38:38 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id x192so11321564ybe.6;
        Thu, 08 Jul 2021 14:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x43n+LTJaTzuRg6vjxk7HVx1IzEgyzJYcKdqMBWkryM=;
        b=f1W9NHTe36naPmUgZykh2tpD8/AV2expJqlFHrYVxi2CXjNqTZr3VoeHgDTOk0ZtTM
         y9e2Kn8j6eKTqGLqcElU5tMaFKVRCuKecXdwRyWeOQu1ANQ97E8BBVknUYAmx2oWMntQ
         tvZh6HbV0TuV/LumHPDu4OXv9KSbjGKzROLGltzzWWLmuNUZblpfs7ULNN+00L80wx44
         r3RKvepNE45tKD2keoLO9pzgPCWvoikCic/YJDG7P7R2Vc2V7iGSKDM+0DmAFBmald+f
         4SEwXDp+VmBq4MuNQ+L0kDK7s9RDrZ8Jb35Dd/N6ATM97IoBddtqbbHi3rOLk6oA4KqV
         Dmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x43n+LTJaTzuRg6vjxk7HVx1IzEgyzJYcKdqMBWkryM=;
        b=G9p0hk42Z4/sTW2CdzUvKtf5FuSl13hQzjcApf1au6/VI/gg3f063uF2twLWnWTCIe
         4KjCraUbcYjUo1fLWviiKl8VAQUh5D75WtV8XZvkPkX41Ma3nOthZZH0u7VPU2mhn0Zq
         12W+BTcRolXCjsxQYqOMqedCw+C6pRytsEYKKO0QFtbGd0TZYOhT1RGY8aJHLjy1v5MP
         13EyoGUJd548qiR8aPqtIoiNC5Ne1JZR1Oiw7JL3ZwdcDzLnGDyC7AblzlXyng1qy6XF
         O8y9HkKZYZNTQZLhOkxSahyMIFWPmW8Nx9RF/RhYrvCWL7AtLzylbYwyVX/+/ro4WyqO
         CtUA==
X-Gm-Message-State: AOAM530a22SjywH/cYAZbsHRq0zS2JIjsFjRVHqSql4GRVvyke0LxqsI
        OYX7Ou0FJHRYrGDIJu1804/cy8vDIS37/4Kktf7QtxjuuGIg5g==
X-Google-Smtp-Source: ABdhPJwMYkLHsmwA2ZnL9euU+6VEkigkMH3ir/kCtnAXyqwym4UO3aBD7qcj1Oh4wBuwEIZUFI/Q89Mg0RIcW0j/puw=
X-Received: by 2002:a25:9942:: with SMTP id n2mr42443384ybo.230.1625780317993;
 Thu, 08 Jul 2021 14:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210708080532.74526-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210708080532.74526-1-xuanzhuo@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Jul 2021 14:38:26 -0700
Message-ID: <CAEf4BzYEX_i26tZ1pO1+60+C-3=X218Qkp8N+Wjpk_yU8KfEwA@mail.gmail.com>
Subject: Re: [PATCH net] xdp, net: fix use-after-free in bpf_xdp_link_release
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        bpf <bpf@vger.kernel.org>, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 1:05 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> The problem occurs between dev_get_by_index() and dev_xdp_attach_link().
> At this point in time, the xdp link will not be released automatically
> when dev is deleted. In this way, when xdp link is released, dev will
> still be accessed, but dev has been released.

Do I understand correctly that the problem is that between when get
dev with dev_get_by_index() and by the time we call
dev_xdp_attach_link() to record bpf_link inside dev we might get a
call to dev_xdp_uninstall(dev). At that point we missed the
notification that dev is going away but we still succeed to attach
bpf_link. Do I understand the situation correctly?

If yes, I wonder whether the proper fix would be to make sure that if
the device was removed bpf_xdp_link_attach() will return an error.
That seems like a sane behavior, instead of pretending that attachment
succeeded. At that point we should NULL out link->dev and cleanup
bpf_xdp_link.

>
> [   45.966867] BUG: KASAN: use-after-free in bpf_xdp_link_release+0x3b8/0x3d0
> [   45.967619] Read of size 8 at addr ffff00000f9980c8 by task a.out/732
> [   45.968297]
> [   45.968502] CPU: 1 PID: 732 Comm: a.out Not tainted 5.13.0+ #22
> [   45.969222] Hardware name: linux,dummy-virt (DT)
> [   45.969795] Call trace:
> [   45.970106]  dump_backtrace+0x0/0x4c8
> [   45.970564]  show_stack+0x30/0x40
> [   45.970981]  dump_stack_lvl+0x120/0x18c
> [   45.971470]  print_address_description.constprop.0+0x74/0x30c
> [   45.972182]  kasan_report+0x1e8/0x200
> [   45.972659]  __asan_report_load8_noabort+0x2c/0x50
> [   45.973273]  bpf_xdp_link_release+0x3b8/0x3d0
> [   45.973834]  bpf_link_free+0xd0/0x188
> [   45.974315]  bpf_link_put+0x1d0/0x218
> [   45.974790]  bpf_link_release+0x3c/0x58
> [   45.975291]  __fput+0x20c/0x7e8
> [   45.975706]  ____fput+0x24/0x30
> [   45.976117]  task_work_run+0x104/0x258
> [   45.976609]  do_notify_resume+0x894/0xaf8
> [   45.977121]  work_pending+0xc/0x328
> [   45.977575]
> [   45.977775] The buggy address belongs to the page:
> [   45.978369] page:fffffc00003e6600 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4f998
> [   45.979522] flags: 0x7fffe0000000000(node=0|zone=0|lastcpupid=0x3ffff)
> [   45.980349] raw: 07fffe0000000000 fffffc00003e6708 ffff0000dac3c010 0000000000000000
> [   45.981309] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> [   45.982259] page dumped because: kasan: bad access detected
> [   45.982948]
> [   45.983153] Memory state around the buggy address:
> [   45.983753]  ffff00000f997f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   45.984645]  ffff00000f998000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   45.985533] >ffff00000f998080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   45.986419]                                               ^
> [   45.987112]  ffff00000f998100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   45.988006]  ffff00000f998180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   45.988895] ==================================================================
> [   45.989773] Disabling lock debugging due to kernel taint
> [   45.990552] Kernel panic - not syncing: panic_on_warn set ...
> [   45.991166] CPU: 1 PID: 732 Comm: a.out Tainted: G    B             5.13.0+ #22
> [   45.991929] Hardware name: linux,dummy-virt (DT)
> [   45.992448] Call trace:
> [   45.992753]  dump_backtrace+0x0/0x4c8
> [   45.993208]  show_stack+0x30/0x40
> [   45.993627]  dump_stack_lvl+0x120/0x18c
> [   45.994113]  dump_stack+0x1c/0x34
> [   45.994530]  panic+0x3a4/0x7d8
> [   45.994930]  end_report+0x194/0x198
> [   45.995380]  kasan_report+0x134/0x200
> [   45.995850]  __asan_report_load8_noabort+0x2c/0x50
> [   45.996453]  bpf_xdp_link_release+0x3b8/0x3d0
> [   45.997007]  bpf_link_free+0xd0/0x188
> [   45.997474]  bpf_link_put+0x1d0/0x218
> [   45.997942]  bpf_link_release+0x3c/0x58
> [   45.998429]  __fput+0x20c/0x7e8
> [   45.998833]  ____fput+0x24/0x30
> [   45.999247]  task_work_run+0x104/0x258
> [   45.999731]  do_notify_resume+0x894/0xaf8
> [   46.000236]  work_pending+0xc/0x328
> [   46.000697] SMP: stopping secondary CPUs
> [   46.001226] Dumping ftrace buffer:
> [   46.001663]    (ftrace buffer empty)
> [   46.002110] Kernel Offset: disabled
> [   46.002545] CPU features: 0x00000001,23202c00
> [   46.003080] Memory Limit: none
>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/core/dev.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..f7aba3108016 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9684,14 +9684,17 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>         struct net_device *dev;
>         int err, fd;
>
> +       rtnl_lock();
>         dev = dev_get_by_index(net, attr->link_create.target_ifindex);
> -       if (!dev)
> +       if (!dev) {
> +               rtnl_unlock();
>                 return -EINVAL;
> +       }
>
>         link = kzalloc(sizeof(*link), GFP_USER);
>         if (!link) {
>                 err = -ENOMEM;
> -               goto out_put_dev;
> +               goto unlock_put_dev;
>         }
>
>         bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog);
> @@ -9701,10 +9704,9 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>         err = bpf_link_prime(&link->link, &link_primer);
>         if (err) {
>                 kfree(link);
> -               goto out_put_dev;
> +               goto unlock_put_dev;
>         }
>
> -       rtnl_lock();
>         err = dev_xdp_attach_link(dev, NULL, link);
>         rtnl_unlock();
>
> @@ -9718,6 +9720,9 @@ int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>         dev_put(dev);
>         return fd;
>
> +unlock_put_dev:
> +       rtnl_unlock();
> +
>  out_put_dev:
>         dev_put(dev);
>         return err;
> --
> 2.31.0
>
