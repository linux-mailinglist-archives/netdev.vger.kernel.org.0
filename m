Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D75104B98
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfKUHPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:15:35 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33538 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfKUHPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:15:32 -0500
Received: by mail-lj1-f193.google.com with SMTP id t5so2034535ljk.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 23:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LvNqh176+zTPkEmAJQRV3mdnP6nbhg4hTBDop+8hPYA=;
        b=vPxf+OygpR7DfiE6peFYKxo98DSa6b8AW9efxo16EidBlFVsMFVPJk+EWWAPGWjryY
         7y/TX++vWiLACep4/2DeucDbQFDHvNYkT1ZdXuujcZEs0lCM1K4gevvDVgD3BryZvAcE
         bB3WaM918Ek5YDCoTUmB4FPv2JE8TQ6Rz5AufpfmYIhCuIMsaoNkxTx+grfDcdqGVs3v
         WsLoyBQp0WjvpGNgl4jqxHPGZUPvRjV0gBxQchkkCpYqFXfpEp60sFMBSGjZx9hu4KY5
         IWjAfnC9V6MhTTENt0Un0P3sfu4z3SzUMlao9TtFjZWHV5Ed0drv4LhgWdPcg+cfnv2l
         RJuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LvNqh176+zTPkEmAJQRV3mdnP6nbhg4hTBDop+8hPYA=;
        b=C3MWKji23wfDn3+6w/d1vA+em1ZtCtlV1V/vN+O80u8+ZEj4zeknxnmIAWWUqWlL8q
         DUbK0kJtWZ8z60Szr8ca118UyNWvKZQDg+1P0PZxcCHyFnfDlef77ZPIyvrE05QQzpf/
         mn5HevLHyCfaTev0Ngn4V++BTBDiAUjQN90aTDOTjFNC/eJ87Ejt+vj8AbrUyo3Fcs7Q
         Jc3x824X0gdeCWEhnkq4deUqw0jed7wSEbKS4zt5j+mtlEdOXWl8LeOU/t6PCxFlq9QB
         oN9GYQjC4RRLbl6D8pIWqoWbGfhbKngVuSXpkgKEY/H6II0XnPIAk5pWXsfmzdsyDGDb
         6qBw==
X-Gm-Message-State: APjAAAV5n3BaFhqPXKiyJ5rVU6F0nbuS+4i/sc3VDajla7EjL3M8BYsI
        mN1sIc64UQny26kO0PhVF1Zf3W6Pn51F3Cr/QvQSbQ==
X-Google-Smtp-Source: APXvYqyGAKEeWeRP7BqCjrUxerAcHNAccAFfalJFom/KvdUfzuAtXZit1ER159PqgPvYFOySvI5hV+unEi7fdRYjUKU=
X-Received: by 2002:a2e:95c5:: with SMTP id y5mr6074005ljh.184.1574320529091;
 Wed, 20 Nov 2019 23:15:29 -0800 (PST)
MIME-Version: 1.0
References: <20191120152255.18928-1-anders.roxell@linaro.org> <e07311c7-24b8-8c48-d6f2-a7c93976613c@gmail.com>
In-Reply-To: <e07311c7-24b8-8c48-d6f2-a7c93976613c@gmail.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 21 Nov 2019 08:15:17 +0100
Message-ID: <CADYN=9Jzxgun9k8v9oQT47ZUFGPhCnsDoYaohG-DXmA1De1zXg@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipmr: fix suspicious RCU warning
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, paulmck@kernel.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 at 18:45, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/20/19 7:22 AM, Anders Roxell wrote:
> > When booting an arm64 allmodconfig kernel on linux-next next-20191115
> > The following "suspicious RCU usage" warning shows up.  This bug seems
> > to have been introduced by commit f0ad0860d01e ("ipv4: ipmr: support
> > multiple tables") in 2010, but the warning was added only in this past
> > year by commit 28875945ba98 ("rcu: Add support for consolidated-RCU
> > reader checking").
> >
> > [   32.496021][    T1] =============================
> > [   32.497616][    T1] WARNING: suspicious RCU usage
> > [   32.499614][    T1] 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2 Not tainted
> > [   32.502018][    T1] -----------------------------
> > [   32.503976][    T1] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> > [   32.506746][    T1]
> > [   32.506746][    T1] other info that might help us debug this:
> > [   32.506746][    T1]
> > [   32.509794][    T1]
> > [   32.509794][    T1] rcu_scheduler_active = 2, debug_locks = 1
> > [   32.512661][    T1] 1 lock held by swapper/0/1:
> > [   32.514169][    T1]  #0: ffffa000150dd678 (pernet_ops_rwsem){+.+.}, at: register_pernet_subsys+0x24/0x50
> > [   32.517621][    T1]
> > [   32.517621][    T1] stack backtrace:
> > [   32.519930][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2
> > [   32.523063][    T1] Hardware name: linux,dummy-virt (DT)
> > [   32.524787][    T1] Call trace:
> > [   32.525946][    T1]  dump_backtrace+0x0/0x2d0
> > [   32.527433][    T1]  show_stack+0x20/0x30
> > [   32.528811][    T1]  dump_stack+0x204/0x2ac
> > [   32.530258][    T1]  lockdep_rcu_suspicious+0xf4/0x108
> > [   32.531993][    T1]  ipmr_get_table+0xc8/0x170
> > [   32.533496][    T1]  ipmr_new_table+0x48/0xa0
> > [   32.535002][    T1]  ipmr_net_init+0xe8/0x258
> > [   32.536465][    T1]  ops_init+0x280/0x2d8
> > [   32.537876][    T1]  register_pernet_operations+0x210/0x420
> > [   32.539707][    T1]  register_pernet_subsys+0x30/0x50
> > [   32.541372][    T1]  ip_mr_init+0x54/0x180
> > [   32.542785][    T1]  inet_init+0x25c/0x3e8
> > [   32.544186][    T1]  do_one_initcall+0x4c0/0xad8
> > [   32.545757][    T1]  kernel_init_freeable+0x3e0/0x500
> > [   32.547443][    T1]  kernel_init+0x14/0x1f0
> > [   32.548875][    T1]  ret_from_fork+0x10/0x18
> >
> > This commit therefore holds RTNL mutex around the problematic code path,
> > which is function ipmr_rules_init() in ipmr_net_init().  This commit
> > also adds a lockdep_rtnl_is_held() check to the ipmr_for_each_table()
> > macro.
> >
> > Suggested-by: David Miller <davem@davemloft.net>
> > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  net/ipv4/ipmr.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> > index 6e68def66822..53dff9a0e60a 100644
> > --- a/net/ipv4/ipmr.c
> > +++ b/net/ipv4/ipmr.c
> > @@ -110,7 +110,8 @@ static void ipmr_expire_process(struct timer_list *t);
> >
> >  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
> >  #define ipmr_for_each_table(mrt, net) \
> > -     list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
> > +     list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> > +                             lockdep_rtnl_is_held())
> >
> >  static struct mr_table *ipmr_mr_table_iter(struct net *net,
> >                                          struct mr_table *mrt)
> > @@ -3086,7 +3087,9 @@ static int __net_init ipmr_net_init(struct net *net)
> >       if (err)
> >               goto ipmr_notifier_fail;
> >
> > +     rtnl_lock();
> >       err = ipmr_rules_init(net);
> > +     rtnl_unlock();
> >       if (err < 0)
> >               goto ipmr_rules_fail;
>
> Hmmm... this might have performance impact for creation of a new netns
>
> Since the 'struct net' is not yet fully initialized (thus published/visible),
> should we really have to grab RTNL (again) only to silence a warning ?
>
> What about the following alternative ?

I tried what you suggested, unfortunately, I still got the warning.


[   43.253850][    T1] =============================
[   43.255473][    T1] WARNING: suspicious RCU usage
[   43.259068][    T1]
5.4.0-rc8-next-20191120-00003-g3aa7c2a8649e-dirty #6 Not tainted
[   43.263078][    T1] -----------------------------
[   43.265134][    T1] net/ipv4/ipmr.c:1759 RCU-list traversed in
non-reader section!!
[   43.267587][    T1]
[   43.267587][    T1] other info that might help us debug this:
[   43.267587][    T1]
[   43.271129][    T1]
[   43.271129][    T1] rcu_scheduler_active = 2, debug_locks = 1
[   43.274021][    T1] 2 locks held by swapper/0/1:
[   43.275532][    T1]  #0: ffff000065abeaa0 (&dev->mutex){....}, at:
__device_driver_lock+0xa0/0xb0
[   43.278930][    T1]  #1: ffffa000153017f0 (rtnl_mutex){+.+.}, at:
rtnl_lock+0x1c/0x28
[   43.282023][    T1]
[   43.282023][    T1] stack backtrace:
[   43.283921][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
5.4.0-rc8-next-20191120-00003-g3aa7c2a8649e-dirty #6
[   43.287152][    T1] Hardware name: linux,dummy-virt (DT)
[   43.288920][    T1] Call trace:
[   43.290057][    T1]  dump_backtrace+0x0/0x2d0
[   43.291535][    T1]  show_stack+0x20/0x30
[   43.292967][    T1]  dump_stack+0x204/0x2ac
[   43.294423][    T1]  lockdep_rcu_suspicious+0xf4/0x108
[   43.296163][    T1]  ipmr_device_event+0x100/0x1e8
[   43.297812][    T1]  notifier_call_chain+0x100/0x1a8
[   43.299486][    T1]  raw_notifier_call_chain+0x38/0x48
[   43.301248][    T1]  call_netdevice_notifiers_info+0x128/0x148
[   43.303158][    T1]  rollback_registered_many+0x684/0xb48
[   43.304963][    T1]  rollback_registered+0xd8/0x150
[   43.306595][    T1]  unregister_netdevice_queue+0x194/0x1b8
[   43.308406][    T1]  unregister_netdev+0x24/0x38
[   43.310012][    T1]  virtnet_remove+0x44/0x78
[   43.311519][    T1]  virtio_dev_remove+0x5c/0xc0
[   43.313114][    T1]  really_probe+0x508/0x920
[   43.314635][    T1]  driver_probe_device+0x164/0x230
[   43.316337][    T1]  device_driver_attach+0x8c/0xc0
[   43.318024][    T1]  __driver_attach+0x1e0/0x1f8
[   43.319584][    T1]  bus_for_each_dev+0xf0/0x188
[   43.321169][    T1]  driver_attach+0x34/0x40
[   43.322645][    T1]  bus_add_driver+0x204/0x3c8
[   43.324202][    T1]  driver_register+0x160/0x1f8
[   43.325788][    T1]  register_virtio_driver+0x7c/0x88
[   43.327480][    T1]  virtio_net_driver_init+0xa8/0xf4
[   43.329196][    T1]  do_one_initcall+0x4c0/0xad8
[   43.330767][    T1]  kernel_init_freeable+0x3e0/0x500
[   43.332444][    T1]  kernel_init+0x14/0x1f0
[   43.333901][    T1]  ret_from_fork+0x10/0x18


Cheers,
Anders

>
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 6e68def66822f47fc08d94eddd32a4bd4f9fdfb0..b6dcdce08f1d82c83756a319623e24ae0174092c 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -94,7 +94,7 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
>
>  static struct kmem_cache *mrt_cachep __ro_after_init;
>
> -static struct mr_table *ipmr_new_table(struct net *net, u32 id);
> +static struct mr_table *ipmr_new_table(struct net *net, u32 id, bool init);
>  static void ipmr_free_table(struct mr_table *mrt);
>
>  static void ip_mr_forward(struct net *net, struct mr_table *mrt,
> @@ -245,7 +245,7 @@ static int __net_init ipmr_rules_init(struct net *net)
>
>         INIT_LIST_HEAD(&net->ipv4.mr_tables);
>
> -       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT);
> +       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT, true);
>         if (IS_ERR(mrt)) {
>                 err = PTR_ERR(mrt);
>                 goto err1;
> @@ -322,7 +322,7 @@ static int __net_init ipmr_rules_init(struct net *net)
>  {
>         struct mr_table *mrt;
>
> -       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT);
> +       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT, true);
>         if (IS_ERR(mrt))
>                 return PTR_ERR(mrt);
>         net->ipv4.mrt = mrt;
> @@ -392,7 +392,7 @@ static struct mr_table_ops ipmr_mr_table_ops = {
>         .cmparg_any = &ipmr_mr_table_ops_cmparg_any,
>  };
>
> -static struct mr_table *ipmr_new_table(struct net *net, u32 id)
> +static struct mr_table *ipmr_new_table(struct net *net, u32 id, bool init)
>  {
>         struct mr_table *mrt;
>
> @@ -400,9 +400,11 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
>         if (id != RT_TABLE_DEFAULT && id >= 1000000000)
>                 return ERR_PTR(-EINVAL);
>
> -       mrt = ipmr_get_table(net, id);
> -       if (mrt)
> -               return mrt;
> +       if (!init) {
> +               mrt = ipmr_get_table(net, id);
> +               if (mrt)
> +                       return mrt;
> +       }
>
>         return mr_table_alloc(net, id, &ipmr_mr_table_ops,
>                               ipmr_expire_process, ipmr_new_table_set);
> @@ -1547,7 +1549,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, char __user *optval,
>                 if (sk == rtnl_dereference(mrt->mroute_sk)) {
>                         ret = -EBUSY;
>                 } else {
> -                       mrt = ipmr_new_table(net, uval);
> +                       mrt = ipmr_new_table(net, uval, false);
>                         if (IS_ERR(mrt))
>                                 ret = PTR_ERR(mrt);
>                         else
>
>
