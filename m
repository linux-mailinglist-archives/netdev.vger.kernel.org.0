Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC15FF23F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiJNQ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiJNQ1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:27:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80441D1AB3
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665764857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gWQFQj7gvmQlpOAvJJGpEIR/W6rMI9tCdbEcuViyKiM=;
        b=QgZQpXlKyRXsL4Wtfr5efNZt9gALRyVOPBl+2bru/9Lx5OKiXHjtKaJ0U5WOVoLRAunMnK
        ZyGH3tTHKXZtPZRECm2KpqeyWJtMdEtt1ME7mkozIaknrWdyw3wpKg7TvY32Qd+a2QwYGp
        c1HaEWDpTV3GrifRaPQp008Xp+tNY5s=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-630-vcore1GBOCaPcbth7Il3HA-1; Fri, 14 Oct 2022 12:27:35 -0400
X-MC-Unique: vcore1GBOCaPcbth7Il3HA-1
Received: by mail-ot1-f72.google.com with SMTP id w4-20020a9d5384000000b00661b6b49c75so1623411otg.11
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWQFQj7gvmQlpOAvJJGpEIR/W6rMI9tCdbEcuViyKiM=;
        b=k7aUx5IoywjVUb9bpHny05JPhBUIKr0MYazYJ+seS7JMzzjAHYPEac/joJm8LcGbfr
         os1avecHKhvV/WybmXOb+BHQ4Fad+Ue3Rsn4c3PLrXJ0u5o2o097/kPl+9uE113fC8gh
         jbmjd0C6RJD5r1zXtZbtRv8hwThHRromaSSz5loRSTSH7Ak6NIWVPb3e3/0vxqwlmZE1
         ZCCJ+nTI3+dK57UhmqCPphBjgBmfb/r3qgsfKKVfWAyvu5yqB0JNfQu0uko/pz0z1D7F
         3VMjeghZdNbQ7QGKZ28Btat+bQeLGhsq5lp7CfD3f/RdetTUlotBjxKvpFzqR4aCRLT6
         eLIw==
X-Gm-Message-State: ACrzQf2mHRlEHva1CVwe8/vQlO/Rejzay5WR64QOV7RcTni9CSMSwCS8
        d83fV2SQV82EaYjql1mdprL/i9BDRnYAzBZOPie1eSMivoH2F1d20NfXsFwI4iOnweSkA7a5UyF
        a86YGDA5cwyuj7VYR
X-Received: by 2002:a05:6870:2054:b0:132:d1fb:ddf0 with SMTP id l20-20020a056870205400b00132d1fbddf0mr9025888oad.283.1665764855077;
        Fri, 14 Oct 2022 09:27:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5rG/MQ7wNzObW4bY3Eu9bywv7qJQUN8nIWFMTkDev7VaPb9LOJXDmUMNlynrjXphiKqEHA5Q==
X-Received: by 2002:a05:6870:2054:b0:132:d1fb:ddf0 with SMTP id l20-20020a056870205400b00132d1fbddf0mr9025853oad.283.1665764854746;
        Fri, 14 Oct 2022 09:27:34 -0700 (PDT)
Received: from ?IPv6:2804:1b3:a801:baa9:f002:974b:318a:f9b? ([2804:1b3:a801:baa9:f002:974b:318a:f9b])
        by smtp.gmail.com with ESMTPSA id f23-20020a9d7b57000000b00661b5e95173sm1404752oto.35.2022.10.14.09.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 09:27:34 -0700 (PDT)
Message-ID: <7249d33e5b3e7d63b1b2a0df2b43e7a6f2082cf9.camel@redhat.com>
Subject: Re: [PATCH v2 3/4] sched/isolation: Add HK_TYPE_WQ to
 isolcpus=domain
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        fweisbec@gmail.com
Date:   Fri, 14 Oct 2022 13:27:25 -0300
In-Reply-To: <20221014132410.GA1108603@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
         <20221013184028.129486-4-leobras@redhat.com>
         <Y0kfgypRPdJYrvM3@hirez.programming.kicks-ass.net>
         <20221014132410.GA1108603@lothringen>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-10-14 at 15:24 +0200, Frederic Weisbecker wrote:
> On Fri, Oct 14, 2022 at 10:36:19AM +0200, Peter Zijlstra wrote:
> >=20
> > + Frederic; who actually does most of this code
> >=20
> > On Thu, Oct 13, 2022 at 03:40:28PM -0300, Leonardo Bras wrote:
> > > Housekeeping code keeps multiple cpumasks in order to keep track of w=
hich
> > > cpus can perform given housekeeping category.
> > >=20
> > > Every time the HK_TYPE_WQ cpumask is checked before queueing work at =
a cpu
> > > WQ it also happens to check for HK_TYPE_DOMAIN. So It can be assumed =
that
> > > the Domain isolation also ends up isolating work queues.
> > >=20
> > > Delegating current HK_TYPE_DOMAIN's work queue isolation to HK_TYPE_W=
Q
> > > makes it simpler to check if a cpu can run a task into an work queue,=
 since
> > > code just need to go through a single HK_TYPE_* cpumask.
> > >=20
> > > Make isolcpus=3Ddomain aggregate both HK_TYPE_DOMAIN and HK_TYPE_WQ, =
and
> > > remove a lot of cpumask_and calls.
> > >=20
> > > Also, remove a unnecessary '|=3D' at housekeeping_isolcpus_setup() si=
nce we
> > > are sure that 'flags =3D=3D 0' here.
> > >=20
> > > Signed-off-by: Leonardo Bras <leobras@redhat.com>
> >=20
> > I've long maintained that having all these separate masks is daft;
> > Frederic do we really need that?
>=20
> Indeed. In my queue for the cpuset interface to nohz_full, I have the fol=
lowing
> patch (but note DOMAIN and WQ have to stay seperate flags because workque=
ue
> affinity can be modified seperately from isolcpus)
>=20
> ---
> From: Frederic Weisbecker <frederic@kernel.org>
> Date: Tue, 26 Jul 2022 17:03:30 +0200
> Subject: [PATCH] sched/isolation: Gather nohz_full related isolation feat=
ures
>  into common flag
>=20
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  arch/x86/kvm/x86.c              |  2 +-
>  drivers/pci/pci-driver.c        |  2 +-
>  include/linux/sched/isolation.h |  7 +------
>  kernel/cpu.c                    |  4 ++--
>  kernel/kthread.c                |  4 ++--
>  kernel/rcu/tasks.h              |  2 +-
>  kernel/rcu/tree_plugin.h        |  6 +++---
>  kernel/sched/core.c             | 10 +++++-----
>  kernel/sched/fair.c             |  6 +++---
>  kernel/sched/isolation.c        | 25 +++++++------------------
>  kernel/watchdog.c               |  2 +-
>  kernel/workqueue.c              |  2 +-
>  net/core/net-sysfs.c            |  2 +-
>  13 files changed, 29 insertions(+), 45 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1910e1e78b15..d0b73fcf4a1c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9009,7 +9009,7 @@ int kvm_arch_init(void *opaque)
>  	}
> =20
>  	if (pi_inject_timer =3D=3D -1)
> -		pi_inject_timer =3D housekeeping_enabled(HK_TYPE_TIMER);
> +		pi_inject_timer =3D housekeeping_enabled(HK_TYPE_NOHZ_FULL);
>  #ifdef CONFIG_X86_64
>  	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
> =20
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 49238ddd39ee..af3494a39921 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -378,7 +378,7 @@ static int pci_call_probe(struct pci_driver *drv, str=
uct pci_dev *dev,
>  			goto out;
>  		}
>  		cpumask_and(wq_domain_mask,
> -			    housekeeping_cpumask(HK_TYPE_WQ),
> +			    housekeeping_cpumask(HK_TYPE_NOHZ_FULL),
>  			    housekeeping_cpumask(HK_TYPE_DOMAIN));
> =20
>  		cpu =3D cpumask_any_and(cpumask_of_node(node),
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolat=
ion.h
> index 8c15abd67aed..7ca34e04abe7 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -6,15 +6,10 @@
>  #include <linux/tick.h>
> =20
>  enum hk_type {
> -	HK_TYPE_TIMER,
> -	HK_TYPE_RCU,
> -	HK_TYPE_MISC,
> +	HK_TYPE_NOHZ_FULL,
>  	HK_TYPE_SCHED,
> -	HK_TYPE_TICK,
>  	HK_TYPE_DOMAIN,
> -	HK_TYPE_WQ,
>  	HK_TYPE_MANAGED_IRQ,
> -	HK_TYPE_KTHREAD,
>  	HK_TYPE_MAX
>  };
> =20
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index bbad5e375d3b..573f14d75a2e 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -1500,8 +1500,8 @@ int freeze_secondary_cpus(int primary)
>  	cpu_maps_update_begin();
>  	if (primary =3D=3D -1) {
>  		primary =3D cpumask_first(cpu_online_mask);
> -		if (!housekeeping_cpu(primary, HK_TYPE_TIMER))
> -			primary =3D housekeeping_any_cpu(HK_TYPE_TIMER);
> +		if (!housekeeping_cpu(primary, HK_TYPE_NOHZ_FULL))
> +			primary =3D housekeeping_any_cpu(HK_TYPE_NOHZ_FULL);
>  	} else {
>  		if (!cpu_online(primary))
>  			primary =3D cpumask_first(cpu_online_mask);
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 544fd4097406..0719035feba0 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -355,7 +355,7 @@ static int kthread(void *_create)
>  	 * back to default in case they have been changed.
>  	 */
>  	sched_setscheduler_nocheck(current, SCHED_NORMAL, &param);
> -	set_cpus_allowed_ptr(current, housekeeping_cpumask(HK_TYPE_KTHREAD));
> +	set_cpus_allowed_ptr(current, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
> =20
>  	/* OK, tell user we're spawned, wait for stop or wakeup */
>  	__set_current_state(TASK_UNINTERRUPTIBLE);
> @@ -721,7 +721,7 @@ int kthreadd(void *unused)
>  	/* Setup a clean context for our children to inherit. */
>  	set_task_comm(tsk, "kthreadd");
>  	ignore_signals(tsk);
> -	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_KTHREAD));
> +	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
>  	set_mems_allowed(node_states[N_MEMORY]);
> =20
>  	current->flags |=3D PF_NOFREEZE;
> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> index f5bf6fb430da..b99f79625b26 100644
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -537,7 +537,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
>  	struct rcu_tasks *rtp =3D arg;
> =20
>  	/* Run on housekeeping CPUs by default.  Sysadm can move if desired. */
> -	housekeeping_affine(current, HK_TYPE_RCU);
> +	housekeeping_affine(current, HK_TYPE_NOHZ_FULL);
>  	WRITE_ONCE(rtp->kthread_ptr, current); // Let GPs start!
> =20
>  	/*
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index b2219577fbe2..4935b06c3caf 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1237,9 +1237,9 @@ static void rcu_boost_kthread_setaffinity(struct rc=
u_node *rnp, int outgoingcpu)
>  		if ((mask & leaf_node_cpu_bit(rnp, cpu)) &&
>  		    cpu !=3D outgoingcpu)
>  			cpumask_set_cpu(cpu, cm);
> -	cpumask_and(cm, cm, housekeeping_cpumask(HK_TYPE_RCU));
> +	cpumask_and(cm, cm, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
>  	if (cpumask_empty(cm))
> -		cpumask_copy(cm, housekeeping_cpumask(HK_TYPE_RCU));
> +		cpumask_copy(cm, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
>  	set_cpus_allowed_ptr(t, cm);
>  	mutex_unlock(&rnp->boost_kthread_mutex);
>  	free_cpumask_var(cm);
> @@ -1294,5 +1294,5 @@ static void rcu_bind_gp_kthread(void)
>  {
>  	if (!tick_nohz_full_enabled())
>  		return;
> -	housekeeping_affine(current, HK_TYPE_RCU);
> +	housekeeping_affine(current, HK_TYPE_NOHZ_FULL);
>  }
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f53c0096860b..5ff205f39197 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1079,13 +1079,13 @@ int get_nohz_timer_target(void)
>  	struct sched_domain *sd;
>  	const struct cpumask *hk_mask;
> =20
> -	if (housekeeping_cpu(cpu, HK_TYPE_TIMER)) {
> +	if (housekeeping_cpu(cpu, HK_TYPE_NOHZ_FULL)) {
>  		if (!idle_cpu(cpu))
>  			return cpu;
>  		default_cpu =3D cpu;
>  	}
> =20
> -	hk_mask =3D housekeeping_cpumask(HK_TYPE_TIMER);
> +	hk_mask =3D housekeeping_cpumask(HK_TYPE_NOHZ_FULL);
> =20
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
> @@ -1101,7 +1101,7 @@ int get_nohz_timer_target(void)
>  	}
> =20
>  	if (default_cpu =3D=3D -1)
> -		default_cpu =3D housekeeping_any_cpu(HK_TYPE_TIMER);
> +		default_cpu =3D housekeeping_any_cpu(HK_TYPE_NOHZ_FULL);
>  	cpu =3D default_cpu;
>  unlock:
>  	rcu_read_unlock();
> @@ -5562,7 +5562,7 @@ static void sched_tick_start(int cpu)
>  	int os;
>  	struct tick_work *twork;
> =20
> -	if (housekeeping_cpu(cpu, HK_TYPE_TICK))
> +	if (housekeeping_cpu(cpu, HK_TYPE_NOHZ_FULL))
>  		return;
> =20
>  	WARN_ON_ONCE(!tick_work_cpu);
> @@ -5583,7 +5583,7 @@ static void sched_tick_stop(int cpu)
>  	struct tick_work *twork;
>  	int os;
> =20
> -	if (housekeeping_cpu(cpu, HK_TYPE_TICK))
> +	if (housekeeping_cpu(cpu, HK_TYPE_NOHZ_FULL))
>  		return;
> =20
>  	WARN_ON_ONCE(!tick_work_cpu);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 77b2048a9326..ac3b33e00451 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -10375,7 +10375,7 @@ static inline int on_null_domain(struct rq *rq)
>   * - When one of the busy CPUs notice that there may be an idle rebalanc=
ing
>   *   needed, they will kick the idle load balancer, which then does idle
>   *   load balancing for all the idle CPUs.
> - * - HK_TYPE_MISC CPUs are used for this task, because HK_TYPE_SCHED not=
 set
> + * - HK_TYPE_NOHZ_FULL CPUs are used for this task, because HK_TYPE_SCHE=
D not set
>   *   anywhere yet.
>   */
> =20
> @@ -10384,7 +10384,7 @@ static inline int find_new_ilb(void)
>  	int ilb;
>  	const struct cpumask *hk_mask;
> =20
> -	hk_mask =3D housekeeping_cpumask(HK_TYPE_MISC);
> +	hk_mask =3D housekeeping_cpumask(HK_TYPE_NOHZ_FULL);
> =20
>  	for_each_cpu_and(ilb, nohz.idle_cpus_mask, hk_mask) {
> =20
> @@ -10400,7 +10400,7 @@ static inline int find_new_ilb(void)
> =20
>  /*
>   * Kick a CPU to do the nohz balancing, if it is time for it. We pick an=
y
> - * idle CPU in the HK_TYPE_MISC housekeeping set (if there is one).
> + * idle CPU in the HK_TYPE_NOHZ_FULL housekeeping set (if there is one).
>   */
>  static void kick_ilb(unsigned int flags)
>  {
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 4087718ee5b4..443f1ce83e32 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -4,20 +4,15 @@
>   *  any CPU: unbound workqueues, timers, kthreads and any offloadable wo=
rk.
>   *
>   * Copyright (C) 2017 Red Hat, Inc., Frederic Weisbecker
> - * Copyright (C) 2017-2018 SUSE, Frederic Weisbecker
> + * Copyright (C) 2017-2022 SUSE, Frederic Weisbecker
>   *
>   */
> =20
>  enum hk_flags {
> -	HK_FLAG_TIMER		=3D BIT(HK_TYPE_TIMER),
> -	HK_FLAG_RCU		=3D BIT(HK_TYPE_RCU),
> -	HK_FLAG_MISC		=3D BIT(HK_TYPE_MISC),
> +	HK_FLAG_NOHZ_FULL	=3D BIT(HK_TYPE_NOHZ_FULL),
>  	HK_FLAG_SCHED		=3D BIT(HK_TYPE_SCHED),
> -	HK_FLAG_TICK		=3D BIT(HK_TYPE_TICK),
>  	HK_FLAG_DOMAIN		=3D BIT(HK_TYPE_DOMAIN),
> -	HK_FLAG_WQ		=3D BIT(HK_TYPE_WQ),
>  	HK_FLAG_MANAGED_IRQ	=3D BIT(HK_TYPE_MANAGED_IRQ),
> -	HK_FLAG_KTHREAD		=3D BIT(HK_TYPE_KTHREAD),
>  };
> =20
>  DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
> @@ -88,7 +83,7 @@ void __init housekeeping_init(void)
> =20
>  	static_branch_enable(&housekeeping_overridden);
> =20
> -	if (housekeeping.flags & HK_FLAG_TICK)
> +	if (housekeeping.flags & HK_FLAG_NOHZ_FULL)
>  		sched_tick_offload_init();
> =20
>  	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
> @@ -111,7 +106,7 @@ static int __init housekeeping_setup(char *str, unsig=
ned long flags)
>  	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
>  	int err =3D 0;
> =20
> -	if ((flags & HK_FLAG_TICK) && !(housekeeping.flags & HK_FLAG_TICK)) {
> +	if ((flags & HK_FLAG_NOHZ_FULL) && !(housekeeping.flags & HK_FLAG_NOHZ_=
FULL)) {
>  		if (!IS_ENABLED(CONFIG_NO_HZ_FULL)) {
>  			pr_warn("Housekeeping: nohz unsupported."
>  				" Build with CONFIG_NO_HZ_FULL\n");
> @@ -163,7 +158,7 @@ static int __init housekeeping_setup(char *str, unsig=
ned long flags)
>  			housekeeping_setup_type(type, housekeeping_staging);
>  	}
> =20
> -	if ((flags & HK_FLAG_TICK) && !(housekeeping.flags & HK_FLAG_TICK))
> +	if ((flags & HK_FLAG_NOHZ_FULL) && !(housekeeping.flags & HK_FLAG_NOHZ_=
FULL))
>  		tick_nohz_full_setup(non_housekeeping_mask);
> =20
>  	housekeeping.flags |=3D flags;
> @@ -179,12 +174,7 @@ static int __init housekeeping_setup(char *str, unsi=
gned long flags)
> =20
>  static int __init housekeeping_nohz_full_setup(char *str)
>  {
> -	unsigned long flags;
> -
> -	flags =3D HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU |
> -		HK_FLAG_MISC | HK_FLAG_KTHREAD;
> -
> -	return housekeeping_setup(str, flags);
> +	return housekeeping_setup(str, HK_FLAG_NOHZ_FULL);
>  }
>  __setup("nohz_full=3D", housekeeping_nohz_full_setup);
> =20
> @@ -198,8 +188,7 @@ static int __init housekeeping_isolcpus_setup(char *s=
tr)
>  	while (isalpha(*str)) {
>  		if (!strncmp(str, "nohz,", 5)) {
>  			str +=3D 5;
> -			flags |=3D HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER |
> -				HK_FLAG_RCU | HK_FLAG_MISC | HK_FLAG_KTHREAD;
> +			flags |=3D HK_FLAG_NOHZ_FULL;
>  			continue;
>  		}
> =20
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 20a7a55e62b6..3e9636f4bac6 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -852,7 +852,7 @@ void __init lockup_detector_init(void)
>  		pr_info("Disabling watchdog on nohz_full cores by default\n");
> =20
>  	cpumask_copy(&watchdog_cpumask,
> -		     housekeeping_cpumask(HK_TYPE_TIMER));
> +		     housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
> =20
>  	if (!watchdog_nmi_probe())
>  		nmi_watchdog_available =3D true;
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 1ea50f6be843..3eb283d76d81 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -5993,7 +5993,7 @@ void __init workqueue_init_early(void)
>  	BUILD_BUG_ON(__alignof__(struct pool_workqueue) < __alignof__(long long=
));
> =20
>  	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
> -	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_WQ));
> +	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_NOHZ_FULL=
));
>  	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, housekeeping_cpumas=
k(HK_TYPE_DOMAIN));
> =20
>  	pwq_cache =3D KMEM_CACHE(pool_workqueue, SLAB_PANIC);
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index e319e242dddf..6dddf359b754 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -852,7 +852,7 @@ static ssize_t store_rps_map(struct netdev_rx_queue *=
queue,
> =20
>  	if (!cpumask_empty(mask)) {
>  		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
> -		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
> +		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_NOHZ_FULL));
>  		if (cpumask_empty(mask)) {
>  			free_cpumask_var(mask);
>  			return -EINVAL;

Hello Frederic,

So, IIUC you are removing all flags composing nohz_full=3D parameter in fav=
or of a
unified NOHZ_FULL flag.=20

I am very new to the code, and I am probably missing the whole picture, but=
 I
actually think it's a good approach to keep them split for a couple reasons=
:
1 - They are easier to understand in code (IMHO):=C2=A0
"This cpu should not do this, because it's not able to do WQ housekeeping" =
looks
better than "because it's not in DOMAIN or NOHZ_FULL housekeeping"

2 - They are simpler for using:=C2=A0
Suppose we have this function that should run at a WQ, but we want to keep =
them
out of the isolated cpus. If we have the unified flags, we need to combine =
both
DOMAIN and NOHZ_FULL bitmasks, and then combine it again with something lik=
e
cpu_online_mask. It usually means allocating a new cpumask_t, and also free=
ing
it afterwards.
If we have a single WQ flag, we can avoid the allocation altogether by usin=
g
for_each_cpu_and(), making the code much simpler.

3 - It makes easier to compose new isolation modes:
In case the future requires a new isolation mode that also uses the types o=
f
isolation we currently have implemented, it would be much easier to just co=
mpose
it with the current HK flags, instead of having to go through all usages an=
d do
a cpumask_and() there. Also, new isolation modes would make (2) worse.

What I am able see as a pro in "unified flag" side, is that getting all the
multiple flags doing their jobs should be a lot of trouble.=20

While I do understand you are much more experienced than me on that, and th=
at
your decision is more likely to be better,=C2=A0I am unable to see the argu=
ments that
helped you reach it.=C2=A0

Could you please point them, so I can better understand the decision?

Best regards,
Leo

