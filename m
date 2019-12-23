Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB647129981
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 18:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfLWRkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 12:40:24 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:46958 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfLWRkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 12:40:24 -0500
Received: by mail-ua1-f67.google.com with SMTP id l6so5893022uap.13
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNFLSoQe0lR2iyKnAuV1NRMQR96oeCjWqMmsqcgP9RM=;
        b=A6UZvDMZ6PHfMyRnfDW7eocx2YHhfaaGFDnHpYc5aIuoxJebfqe33MkLZGMMFzCLYM
         ez/SoCKJ9NkLWwppNKcKGJDwR4SIVI//JKriCLqben34vI7aTZurMV5CZBTYlThU+RBi
         Q0JfMrnt2fRB985Fp4l/iNrZgu6FygN8LSwiel7gKnFpeh6ZB2NvKeUgIa7AVz3ipXxF
         6Xb9ZEw15NVPDsVR3sQJFPyYGziFG2zrXpimZmQst9z9MQ8jem8GaUdNZKCIxV5dsOYB
         BMhQHF5+WkTtVFyA+WzeSpfEFj9VAi/Wr+QYB2MFGqvrei9MemphVg4bfl62O5np62Jm
         8LQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eNFLSoQe0lR2iyKnAuV1NRMQR96oeCjWqMmsqcgP9RM=;
        b=tMy784EVATy6XhIIfjug5jzvfHctjiUuxAVrDfwMEX6EgJ/MSTMDgt5NThFYqNe7Lm
         PV+Ve/GI+ZpBwmd/VWRsHxzj5iXhQopGUQPv6bg+4S0HND7POBAyWrtcxRB9x7pPHfMK
         HHEwrw+35KaCgmu8UEKhCp6b3Bih+HsUI5fDswGUx3rq0OtcKzsRYpdxy8Lvn19EzCc5
         +ZBADWYjVaM2YSDAzzom8okisWwRJzmnrnY14rg2vrbSXG5k3O2x/5RxV9HRemAVzFXz
         7h0VesfewFqmOtU0AcHEGesfgLkddC01Aasudi/hxAzHpeYT2xdRMad4GJtwiWjktPYD
         Z9jQ==
X-Gm-Message-State: APjAAAXTSP2Grjytcd1r2nByqYcC1sfbmYMG4vW9KE1n7McUvAG7r/yK
        DP3qqE/ZefyGNEd92tvPeL+obcPsp1s5tzA637/dpw==
X-Google-Smtp-Source: APXvYqwxEUH2cKhilppKOCZIO1DWi/dnAPFMoG4mOkjIhWmwfct1/UmOrS1+43btm9Xr+ttnzRHWjiOvTVsC9lefHcM=
X-Received: by 2002:a9f:36ca:: with SMTP id p68mr17497306uap.112.1577122822284;
 Mon, 23 Dec 2019 09:40:22 -0800 (PST)
MIME-Version: 1.0
References: <20191223140322.20013-1-mst@redhat.com>
In-Reply-To: <20191223140322.20013-1-mst@redhat.com>
From:   Alistair Delva <adelva@google.com>
Date:   Mon, 23 Dec 2019 09:40:11 -0800
Message-ID: <CANDihLHPk5khpv-f-M+qhkzgTkygAts38GGb-HChg-VL2bo+Uw@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Mon, Dec 23, 2019 at 6:09 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> The only way for guest to control offloads (as enabled by
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) is by sending commands
> through CTRL_VQ. So it does not make sense to
> acknowledge VIRTIO_NET_F_CTRL_GUEST_OFFLOADS without
> VIRTIO_NET_F_CTRL_VQ.
>
> The spec does not outlaw devices with such a configuration,
> but Linux assumed that with VIRTIO_NET_F_CTRL_GUEST_OFFLOADS
> control vq is always there, resulting in the following crash
> when configuring LRO:
>
> kernel BUG at drivers/net/virtio_net.c:1591!
> invalid opcode: 0000 [#1] PREEMPT SMP PTI
> CPU: 1 PID: 483 Comm: Binder:330_1 Not tainted 5.4.5-01326-g19463e9acaac #1
> Hardware name: ChromiumOS crosvm, BIOS 0
> RIP: 0010:virtnet_send_command+0x15d/0x170 [virtio_net]
> Code: d8 00 00 00 80 78 02 00 0f 94 c0 65 48 8b 0c 25 28 00 00 00 48 3b 4c 24 70 75 11 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d
> +c3 <0f> 0b e8 ec a4 12 c8 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
> RSP: 0018:ffffb97940e7bb50 EFLAGS: 00010246
> RAX: ffffffffc0596020 RBX: ffffa0e1fc8ea840 RCX: 0000000000000017
> RDX: ffffffffc0596110 RSI: 0000000000000011 RDI: 000000000000000d
> RBP: ffffb97940e7bbf8 R08: ffffa0e1fc8ea0b0 R09: ffffa0e1fc8ea0b0
> R10: ffffffffffffffff R11: ffffffffc0590940 R12: 0000000000000005
> R13: ffffa0e1ffad2c00 R14: ffffb97940e7bc08 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffa0e1fd100000(006b) knlGS:00000000e5ef7494
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 00000000e5eeb82c CR3: 0000000079b06001 CR4: 0000000000360ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ? preempt_count_add+0x58/0xb0
>  ? _raw_spin_lock_irqsave+0x36/0x70
>  ? _raw_spin_unlock_irqrestore+0x1a/0x40
>  ? __wake_up+0x70/0x190
>  virtnet_set_features+0x90/0xf0 [virtio_net]
>  __netdev_update_features+0x271/0x980
>  ? nlmsg_notify+0x5b/0xa0
>  dev_disable_lro+0x2b/0x190
>  ? inet_netconf_notify_devconf+0xe2/0x120
>  devinet_sysctl_forward+0x176/0x1e0
>  proc_sys_call_handler+0x1f0/0x250
>  proc_sys_write+0xf/0x20
>  __vfs_write+0x3e/0x190
>  ? __sb_start_write+0x6d/0xd0
>  vfs_write+0xd3/0x190
>  ksys_write+0x68/0xd0
>  __ia32_sys_write+0x14/0x20
>  do_fast_syscall_32+0x86/0xe0
>  entry_SYSENTER_compat+0x7c/0x8e
>
> A similar crash will likely trigger when enabling XDP.
>
> Reported-by: Alistair Delva <adelva@google.com>
> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Lightly tested.
>
> Alistair, could you please test and confirm that this resolves the
> crash for you?

This patch doesn't work. The reason is that NETIF_F_LRO is also turned
on by TSO4/TSO6, which your patch didn't check for. So it ends up
going through the same path and crashing in the same way.

        if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
            virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
                dev->features |= NETIF_F_LRO;

It sounds like this patch is fixing something slightly differently to
my patch fixed. virtnet_set_features() doesn't care about
GUEST_OFFLOADS, it only tests against NETIF_F_LRO. Even if "offloads"
is zero, it will call virtnet_set_guest_offloads(), which triggers the
crash.

So either we need to ensure NETIF_F_LRO is never set, or
virtnet_set_features needs to be updated to check for GUEST_OFFLOADS,
right?

> Dave, after testing confirms the fix, pls queue up for stable.
>
>
>  drivers/net/virtio_net.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..7b8805b47f0d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2971,6 +2971,15 @@ static int virtnet_validate(struct virtio_device *vdev)
>         if (!virtnet_validate_features(vdev))
>                 return -EINVAL;
>
> +       /* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
> +        * VIRTIO_NET_F_CTRL_VQ. However the virtio spec does not
> +        * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
> +        * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
> +        * not the former.
> +        */
> +       if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> +                       __virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
> +
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
>                 int mtu = virtio_cread16(vdev,
>                                          offsetof(struct virtio_net_config,
> --
> MST
>
