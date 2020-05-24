Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C981E0392
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 00:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbgEXWCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 18:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387850AbgEXWCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 18:02:42 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BBEC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 15:02:41 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a2so18659153ejb.10
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/SVrUnoqLrwUkNsVBGqldiAbW5qXKbZxDiyteAVyfHY=;
        b=B9rgsUKqNNSfZWHjW4Izq5kAcEXUOqhqE7yJz094pdQpEj+8FdYWieArg0zRt3ueEv
         iosEkIY9f5zIS5/M2xgQM2bllUpec347ZIdr2u3ml1Zq0Hb9qh32gwOWj6M+C4OP+6rm
         ZMYl9/tLjk5SQYh6CCTKEklwoCouExAXNaM0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/SVrUnoqLrwUkNsVBGqldiAbW5qXKbZxDiyteAVyfHY=;
        b=PIjsT3KL2Z1ysWlRkI89FMBz6VV3XHX7kPpqees8MxA4KgTZ70YrwgxDBCQJ6RQTx0
         WT7l06lsmQ/wLBwLQd+jTOce+k+vPBWQMMcCWUOyWhL5z/Ioqxim3zXxSt/YN7tggCyt
         lYd71R1R04EORFPmB82xj1cQXbviZrvYYkhQlPmd5/Nc8DOj6wyFZkQ9P+45+VQNzhj/
         69pItaWBIO7xveOeu3hNV++v8LDl2Ww+H+T84of+a+q/ALzHHnvN12ddNG2Xm5T0Geuy
         AAeT8JLm9RgUcs3r87tjsSlBUgTlgMPj6hw56xxUzxWnxaN1G8ueA9eKPlYieKTE7jhi
         BPuw==
X-Gm-Message-State: AOAM533eGr25l40V5J66PQs/NHwCOjzAojTSkox0Y+pwFt+E4nCGReFc
        YwRpGEuNkPcHSXAzEopa0134fDv76YpDFYI/ECnI8kcr
X-Google-Smtp-Source: ABdhPJySjqibmFb57yuaNTCF0EVaK539Vc6n3+qPALc/fAxcAZVC16OPkfn12dnEmtPyEAs8pQ8GknIRSERb52D2no4=
X-Received: by 2002:a17:906:2c03:: with SMTP id e3mr16205617ejh.206.1590357759935;
 Sun, 24 May 2020 15:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200524213856.1314103-1-idosch@idosch.org>
In-Reply-To: <20200524213856.1314103-1-idosch@idosch.org>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sun, 24 May 2020 15:02:35 -0700
Message-ID: <CAJieiUgVcNg18xb=figjHFckh_Gj3rY2AW8GtReFML=mUmD=Ng@mail.gmail.com>
Subject: Re: [PATCH net-next] vxlan: Do not assume RTNL is held in vxlan_fdb_info()
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 2:39 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> From: Ido Schimmel <idosch@mellanox.com>
>
> vxlan_fdb_info() is not always called with RTNL held or from an RCU
> read-side critical section. For example, in the following call path:
>
> vxlan_cleanup()
>   vxlan_fdb_destroy()
>     vxlan_fdb_notify()
>       __vxlan_fdb_notify()
>         vxlan_fdb_info()
>
> The use of rtnl_dereference() can therefore result in the following
> splat [1].
>
> Fix this by dereferencing the nexthop under RCU read-side critical
> section.
>
> [1]
> [May24 22:56] =============================
> [  +0.004676] WARNING: suspicious RCU usage
> [  +0.004614] 5.7.0-rc5-custom-16219-g201392003491 #2772 Not tainted
> [  +0.007116] -----------------------------
> [  +0.004657] drivers/net/vxlan.c:276 suspicious rcu_dereference_check() usage!
> [  +0.008164]
>               other info that might help us debug this:
>
> [  +0.009126]
>               rcu_scheduler_active = 2, debug_locks = 1
> [  +0.007504] 5 locks held by bash/6892:
> [  +0.004392]  #0: ffff8881d47e3410 (&sig->cred_guard_mutex){+.+.}-{3:3}, at: __do_execve_file.isra.27+0x392/0x23c0
> [  +0.011795]  #1: ffff8881d47e34b0 (&sig->exec_update_mutex){+.+.}-{3:3}, at: flush_old_exec+0x510/0x2030
> [  +0.010947]  #2: ffff8881a141b0b0 (ptlock_ptr(page)#2){+.+.}-{2:2}, at: unmap_page_range+0x9c0/0x2590
> [  +0.010585]  #3: ffff888230009d50 ((&vxlan->age_timer)){+.-.}-{0:0}, at: call_timer_fn+0xe8/0x800
> [  +0.010192]  #4: ffff888183729bc8 (&vxlan->hash_lock[h]){+.-.}-{2:2}, at: vxlan_cleanup+0x133/0x4a0
> [  +0.010382]
>               stack backtrace:
> [  +0.005103] CPU: 1 PID: 6892 Comm: bash Not tainted 5.7.0-rc5-custom-16219-g201392003491 #2772
> [  +0.009675] Hardware name: Mellanox Technologies Ltd. MSN2100-CB2FO/SA001017, BIOS 5.6.5 06/07/2016
> [  +0.010155] Call Trace:
> [  +0.002775]  <IRQ>
> [  +0.002313]  dump_stack+0xfd/0x178
> [  +0.003895]  lockdep_rcu_suspicious+0x14a/0x153
> [  +0.005157]  vxlan_fdb_info+0xe39/0x12a0
> [  +0.004775]  __vxlan_fdb_notify+0xb8/0x160
> [  +0.004672]  vxlan_fdb_notify+0x8e/0xe0
> [  +0.004370]  vxlan_fdb_destroy+0x117/0x330
> [  +0.004662]  vxlan_cleanup+0x1aa/0x4a0
> [  +0.004329]  call_timer_fn+0x1c4/0x800
> [  +0.004357]  run_timer_softirq+0x129d/0x17e0
> [  +0.004762]  __do_softirq+0x24c/0xaef
> [  +0.004232]  irq_exit+0x167/0x190
> [  +0.003767]  smp_apic_timer_interrupt+0x1dd/0x6a0
> [  +0.005340]  apic_timer_interrupt+0xf/0x20
> [  +0.004620]  </IRQ>
>
> Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Amit Cohen <amitc@mellanox.com>
> ---

Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Thanks Ido.



>  drivers/net/vxlan.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 3e88fbef2d4a..a0015cdedfaf 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -263,6 +263,8 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
>         struct nlmsghdr *nlh;
>         struct nexthop *nh;
>         struct ndmsg *ndm;
> +       int nh_family;
> +       u32 nh_id;
>
>         nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>         if (nlh == NULL)
> @@ -273,13 +275,20 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
>
>         send_eth = send_ip = true;
>
> -       nh = rcu_dereference_rtnl(fdb->nh);
> +       rcu_read_lock();
> +       nh = rcu_dereference(fdb->nh);
> +       if (nh) {
> +               nh_family = nexthop_get_family(nh);
> +               nh_id = nh->id;
> +       }
> +       rcu_read_unlock();
> +
>         if (type == RTM_GETNEIGH) {
>                 if (rdst) {
>                         send_ip = !vxlan_addr_any(&rdst->remote_ip);
>                         ndm->ndm_family = send_ip ? rdst->remote_ip.sa.sa_family : AF_INET;
>                 } else if (nh) {
> -                       ndm->ndm_family = nexthop_get_family(nh);
> +                       ndm->ndm_family = nh_family;
>                 }
>                 send_eth = !is_zero_ether_addr(fdb->eth_addr);
>         } else
> @@ -299,7 +308,7 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
>         if (send_eth && nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->eth_addr))
>                 goto nla_put_failure;
>         if (nh) {
> -               if (nla_put_u32(skb, NDA_NH_ID, nh->id))
> +               if (nla_put_u32(skb, NDA_NH_ID, nh_id))
>                         goto nla_put_failure;
>         } else if (rdst) {
>                 if (send_ip && vxlan_nla_put_addr(skb, NDA_DST,
> --
> 2.26.2
>
