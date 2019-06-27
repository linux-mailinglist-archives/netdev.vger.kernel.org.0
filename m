Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24A258A0D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfF0Sdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:33:50 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40251 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0Sdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:33:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so8028810eds.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNIsUYE3uBRW+MpsW1gPLK6sPUvjRHvE1xQT/TOyw5I=;
        b=Ld0KbfDZ3koIn/e2CbOpq4PRWt60JaEPqM7+hnFSidh1ZTf09kxZq3iED7GuW7YxiW
         jDZeHUUsifoSIecGJmrT8dzAJKoslQLj7dW/pFBJkV2r3zY7shPVgbxd6LzDb3Q5KDTw
         ad4sekXeS3+waA4LURYoxIkep5U7JRlTVOc8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNIsUYE3uBRW+MpsW1gPLK6sPUvjRHvE1xQT/TOyw5I=;
        b=dh6PdiyLta7pgBgtImehqlHfS4+ohUvNjOA0GFefEx53dDN/2juVko1W+diP+ZOB4Y
         +rzTCPKYVjln6JnI86iwqAGIzLUzrqegsvIllzyOsdRLC2c4c7e5usr5SibRZ7N7sB1s
         +uOTa3HNbYBQR5a0ReUfVMWKFOzC72Cw2SYWd4ohRCuVVPWLS6nw5bJtLf3EFJos49QX
         mx/PdITt3QhrphPz8Pvpo2l+JewHYiPgJVZayX6fsxLsoq4KXB849jioaFvbqk3jRVbW
         nmrk3qBphyel41J+CTHGq+kILUTf78NecFWMELJoUFjubwHi2oeX5GB592Q7dNP7xzg0
         yRfw==
X-Gm-Message-State: APjAAAX6Xi+ll84utfwdUEadLlhyHpOTbvz2s6snCrM2/ENMoDlk1p5E
        GLyM0okaZAKfQJK0MrvhLg0c+Vo8macivT4dLQP9t8v9T8A=
X-Google-Smtp-Source: APXvYqyiBs1p9VzkfSCtsp08Qvy1hT7lZhmzESk8HBZMGswud2gFnMV/IZPt24snkBkFI2OcgRqwlngQZZwCrwPFXiw=
X-Received: by 2002:a50:b34a:: with SMTP id r10mr6132583edd.84.1561660427923;
 Thu, 27 Jun 2019 11:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190627145010.21073-1-ap420073@gmail.com>
In-Reply-To: <20190627145010.21073-1-ap420073@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Thu, 27 Jun 2019 11:33:36 -0700
Message-ID: <CAJieiUjuRFgxC+YCNUfQFQa-FXjAmfMnTwLw-SOithEQt5QQyw@mail.gmail.com>
Subject: Re: [PATCH net v2] vxlan: do not destroy fdb if register_netdevice()
 is failed
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 7:50 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> __vxlan_dev_create() destroys FDB using specific pointer which indicates
> a fdb when error occurs.
> But that pointer should not be used when register_netdevice() fails because
> register_netdevice() internally destroys fdb when error occurs.
>
> This patch makes vxlan_fdb_create() to do not link fdb entry to vxlan dev
> internally.
> Instead, a new function vxlan_fdb_link() is added to link fdb to vxlan dev.
>
> vxlan_fdb_link() is called after calling register_netdevice().
> This routine can avoid situation that ->ndo_uninit() destroys fdb entry
> in error path of register_netdevice().
> Hence, error path of __vxlan_dev_create() routine can have an opportunity
> to destroy default fdb entry by hand.
>
> Test command
>     ip link add bonding_masters type vxlan id 0 group 239.1.1.1 \
>             dev enp0s9 dstport 4789
>
> Splat looks like:
> [  213.392816] kasan: GPF could be caused by NULL-ptr deref or user memory access
> [  213.401257] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [  213.402178] CPU: 0 PID: 1414 Comm: ip Not tainted 5.2.0-rc5+ #256
> [  213.402178] RIP: 0010:vxlan_fdb_destroy+0x120/0x220 [vxlan]
> [  213.402178] Code: df 48 8b 2b 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 4c 8b 63 08 48 b8 00 00 00 00 00 fc d
> [  213.402178] RSP: 0018:ffff88810cb9f0a0 EFLAGS: 00010202
> [  213.402178] RAX: dffffc0000000000 RBX: ffff888101d4a8c8 RCX: 0000000000000000
> [  213.402178] RDX: 1bd5a00000000040 RSI: ffff888101d4a8c8 RDI: ffff888101d4a8d0
> [  213.402178] RBP: 0000000000000000 R08: fffffbfff22b72d9 R09: 0000000000000000
> [  213.402178] R10: 00000000ffffffef R11: 0000000000000000 R12: dead000000000200
> [  213.402178] R13: ffff88810cb9f1f8 R14: ffff88810efccda0 R15: ffff88810efccda0
> [  213.402178] FS:  00007f7f6621a0c0(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
> [  213.402178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  213.402178] CR2: 000055746f0807d0 CR3: 00000001123e0000 CR4: 00000000001006f0
> [  213.402178] Call Trace:
> [  213.402178]  __vxlan_dev_create+0x3a9/0x7d0 [vxlan]
> [  213.402178]  ? vxlan_changelink+0x740/0x740 [vxlan]
> [  213.402178]  ? rcu_read_unlock+0x60/0x60 [vxlan]
> [  213.402178]  ? __kasan_kmalloc.constprop.3+0xa0/0xd0
> [  213.402178]  vxlan_newlink+0x8d/0xc0 [vxlan]
> [  213.402178]  ? __vxlan_dev_create+0x7d0/0x7d0 [vxlan]
> [  213.554119]  ? __netlink_ns_capable+0xc3/0xf0
> [  213.554119]  __rtnl_newlink+0xb75/0x1180
> [  213.554119]  ? rtnl_link_unregister+0x230/0x230
> [ ... ]
>
> Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
> Suggested-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>
> v1 -> v2 :
>  - Add a new function vxlan_fdb_link().
>  - Fix fdb entry leak.
>  - Update description.
>

thanks for v2!. a few comments inline below ...

>  drivers/net/vxlan.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 083f3f0bf37f..4066346d6f41 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -804,6 +804,14 @@ static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan,
>         return f;
>  }
>
> +static void vxlan_fdb_link(struct vxlan_dev *vxlan, const u8 *mac,
> +                          __be32 src_vni, struct vxlan_fdb *f)

I would prefer vxlan_fdb_insert or something along those lines.

> +{
> +       ++vxlan->addrcnt;
> +       hlist_add_head_rcu(&f->hlist,
> +                          vxlan_fdb_head(vxlan, mac, src_vni));
> +}
> +
>  static int vxlan_fdb_create(struct vxlan_dev *vxlan,
>                             const u8 *mac, union vxlan_addr *ip,
>                             __u16 state, __be16 port, __be32 src_vni,
> @@ -829,10 +837,6 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
>                 return rc;
>         }
>
> -       ++vxlan->addrcnt;
> -       hlist_add_head_rcu(&f->hlist,
> -                          vxlan_fdb_head(vxlan, mac, src_vni));
> -
>         *fdb = f;
>
>         return 0;
> @@ -977,6 +981,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
>         if (rc < 0)
>                 return rc;
>
> +       vxlan_fdb_link(vxlan, mac, src_vni, f);
>         rc = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f), RTM_NEWNEIGH,
>                               swdev_notify, extack);
>         if (rc)
> @@ -3571,12 +3576,17 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
>         if (err)
>                 goto errout;
>
> -       /* notify default fdb entry */
>         if (f) {
> +               vxlan_fdb_link(vxlan, all_zeros_mac,
> +                              vxlan->default_dst.remote_vni, f);
> +
> +               /* notify default fdb entry */
>                 err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
>                                        RTM_NEWNEIGH, true, extack);
> -               if (err)
> -                       goto errout;
> +               if (err) {
> +                       vxlan_fdb_destroy(vxlan, f, false, false);
> +                       goto unregister;
> +               }
>         }
>
>         list_add(&vxlan->next, &vn->vxlan_list);
> @@ -3588,7 +3598,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
>          * destroy the entry by hand here.
>          */
>         if (f)
> -               vxlan_fdb_destroy(vxlan, f, false, false);
> +               call_rcu(&f->rcu, vxlan_fdb_free);

f is local to this function and not inserted at this point, so maybe
we dont need to call_rcu here ?

> +unregister:
>         if (unregister)
>                 unregister_netdevice(dev);
>         return err;
> --
> 2.17.1
>
