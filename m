Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72F710425B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfKTRpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:45:25 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40815 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfKTRpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:45:24 -0500
Received: by mail-pf1-f194.google.com with SMTP id r4so79137pfl.7;
        Wed, 20 Nov 2019 09:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u/FO9/uGb6ia4yqT1gk4T7dyswG4Tz445b/PHVRv1+Y=;
        b=SchYdeKSr4hG52kZgoNfF98lZ7LPPvSwFTqKInaF/udMlHgclekQCV5kL0N2W+M7Ol
         GkXosCn1QIZuNfg5DRsWRQIHohglKXTDSCLp79akhCcIeQFmYbeNpXf50fPVp0cWnXrD
         1YkOg/8PtsZH+Nn7Fg8nT92HKrp1oirXxSwcMFXJtnjy66AJFe9QUYjkZ8lU5ygQo4XN
         n6O9jjtFPGVrUR9HSgm4Ks1pNAOuqoBBS6M0Z0/I1Q1aWGAEv8H4G4v9io5hdq8Pseo8
         kq+XhqjBjLq7N3hGJU1NIy5ih0FLMHtiH2rVT58vNfvZUBIv9T2I2FDnKitjrv/DKXk9
         +OSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u/FO9/uGb6ia4yqT1gk4T7dyswG4Tz445b/PHVRv1+Y=;
        b=rxa1rWEuRndxtHbDqIKBpVkT1fGvVSf3otzHQ8elGcXywWoZEHT+mLsc6pPKsDv9Kv
         3cBv57H654K0cUOVkIXKlVOJjXmXxrhHxNWBrt37LDFG0zL861/6mBqLnyTYeXAOB5Pc
         T4Og984EonQlz87QUf9xCu97YyAdJve0d7W85fURz4BOGlUhInpgwC+FpOvuE0MDT198
         5SnjeF3Oe+OWfo+xbHKlF0CJphiwdx9OP8MJYmQ2a4sGoj0ga2jPVS86gS0TtLNVsxAt
         zvzqZZ8p0/LvkxHE0ZFIMKeT7Lh7bm+ZUAsJ2P5Z9ewJieGbuLAo1gpwrMr0vlYsDcn8
         BryA==
X-Gm-Message-State: APjAAAVfwuTsSzKWGjG6fuME2wABb74tIf73Kv1bOpnBlEhNQYPU2WKU
        xCCWV6me7X2Wu6ZtIR22bEGJaMta
X-Google-Smtp-Source: APXvYqyN+KLdwmcTLKNV0wY7HMdHmncMDitX55Wq+BGGluNTz1x6zs/7HaHpE4+PdoRcY0opqJtmMQ==
X-Received: by 2002:a63:3f4f:: with SMTP id m76mr2661684pga.353.1574271921442;
        Wed, 20 Nov 2019 09:45:21 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id u65sm30218421pfb.35.2019.11.20.09.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 09:45:19 -0800 (PST)
Subject: Re: [PATCH v2] net: ipmr: fix suspicious RCU warning
To:     Anders Roxell <anders.roxell@linaro.org>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     paulmck@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191120152255.18928-1-anders.roxell@linaro.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e07311c7-24b8-8c48-d6f2-a7c93976613c@gmail.com>
Date:   Wed, 20 Nov 2019 09:45:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120152255.18928-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/19 7:22 AM, Anders Roxell wrote:
> When booting an arm64 allmodconfig kernel on linux-next next-20191115
> The following "suspicious RCU usage" warning shows up.  This bug seems
> to have been introduced by commit f0ad0860d01e ("ipv4: ipmr: support
> multiple tables") in 2010, but the warning was added only in this past
> year by commit 28875945ba98 ("rcu: Add support for consolidated-RCU
> reader checking").
> 
> [   32.496021][    T1] =============================
> [   32.497616][    T1] WARNING: suspicious RCU usage
> [   32.499614][    T1] 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2 Not tainted
> [   32.502018][    T1] -----------------------------
> [   32.503976][    T1] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> [   32.506746][    T1]
> [   32.506746][    T1] other info that might help us debug this:
> [   32.506746][    T1]
> [   32.509794][    T1]
> [   32.509794][    T1] rcu_scheduler_active = 2, debug_locks = 1
> [   32.512661][    T1] 1 lock held by swapper/0/1:
> [   32.514169][    T1]  #0: ffffa000150dd678 (pernet_ops_rwsem){+.+.}, at: register_pernet_subsys+0x24/0x50
> [   32.517621][    T1]
> [   32.517621][    T1] stack backtrace:
> [   32.519930][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc6-next-20191108-00003-gf74bac957b5c-dirty #2
> [   32.523063][    T1] Hardware name: linux,dummy-virt (DT)
> [   32.524787][    T1] Call trace:
> [   32.525946][    T1]  dump_backtrace+0x0/0x2d0
> [   32.527433][    T1]  show_stack+0x20/0x30
> [   32.528811][    T1]  dump_stack+0x204/0x2ac
> [   32.530258][    T1]  lockdep_rcu_suspicious+0xf4/0x108
> [   32.531993][    T1]  ipmr_get_table+0xc8/0x170
> [   32.533496][    T1]  ipmr_new_table+0x48/0xa0
> [   32.535002][    T1]  ipmr_net_init+0xe8/0x258
> [   32.536465][    T1]  ops_init+0x280/0x2d8
> [   32.537876][    T1]  register_pernet_operations+0x210/0x420
> [   32.539707][    T1]  register_pernet_subsys+0x30/0x50
> [   32.541372][    T1]  ip_mr_init+0x54/0x180
> [   32.542785][    T1]  inet_init+0x25c/0x3e8
> [   32.544186][    T1]  do_one_initcall+0x4c0/0xad8
> [   32.545757][    T1]  kernel_init_freeable+0x3e0/0x500
> [   32.547443][    T1]  kernel_init+0x14/0x1f0
> [   32.548875][    T1]  ret_from_fork+0x10/0x18
> 
> This commit therefore holds RTNL mutex around the problematic code path,
> which is function ipmr_rules_init() in ipmr_net_init().  This commit
> also adds a lockdep_rtnl_is_held() check to the ipmr_for_each_table()
> macro.
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  net/ipv4/ipmr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 6e68def66822..53dff9a0e60a 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -110,7 +110,8 @@ static void ipmr_expire_process(struct timer_list *t);
>  
>  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
>  #define ipmr_for_each_table(mrt, net) \
> -	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
> +	list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> +				lockdep_rtnl_is_held())
>  
>  static struct mr_table *ipmr_mr_table_iter(struct net *net,
>  					   struct mr_table *mrt)
> @@ -3086,7 +3087,9 @@ static int __net_init ipmr_net_init(struct net *net)
>  	if (err)
>  		goto ipmr_notifier_fail;
>  
> +	rtnl_lock();
>  	err = ipmr_rules_init(net);
> +	rtnl_unlock();
>  	if (err < 0)
>  		goto ipmr_rules_fail;

Hmmm... this might have performance impact for creation of a new netns

Since the 'struct net' is not yet fully initialized (thus published/visible),
should we really have to grab RTNL (again) only to silence a warning ?

What about the following alternative ?

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6e68def66822f47fc08d94eddd32a4bd4f9fdfb0..b6dcdce08f1d82c83756a319623e24ae0174092c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -94,7 +94,7 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
 
 static struct kmem_cache *mrt_cachep __ro_after_init;
 
-static struct mr_table *ipmr_new_table(struct net *net, u32 id);
+static struct mr_table *ipmr_new_table(struct net *net, u32 id, bool init);
 static void ipmr_free_table(struct mr_table *mrt);
 
 static void ip_mr_forward(struct net *net, struct mr_table *mrt,
@@ -245,7 +245,7 @@ static int __net_init ipmr_rules_init(struct net *net)
 
        INIT_LIST_HEAD(&net->ipv4.mr_tables);
 
-       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT);
+       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT, true);
        if (IS_ERR(mrt)) {
                err = PTR_ERR(mrt);
                goto err1;
@@ -322,7 +322,7 @@ static int __net_init ipmr_rules_init(struct net *net)
 {
        struct mr_table *mrt;
 
-       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT);
+       mrt = ipmr_new_table(net, RT_TABLE_DEFAULT, true);
        if (IS_ERR(mrt))
                return PTR_ERR(mrt);
        net->ipv4.mrt = mrt;
@@ -392,7 +392,7 @@ static struct mr_table_ops ipmr_mr_table_ops = {
        .cmparg_any = &ipmr_mr_table_ops_cmparg_any,
 };
 
-static struct mr_table *ipmr_new_table(struct net *net, u32 id)
+static struct mr_table *ipmr_new_table(struct net *net, u32 id, bool init)
 {
        struct mr_table *mrt;
 
@@ -400,9 +400,11 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
        if (id != RT_TABLE_DEFAULT && id >= 1000000000)
                return ERR_PTR(-EINVAL);
 
-       mrt = ipmr_get_table(net, id);
-       if (mrt)
-               return mrt;
+       if (!init) {
+               mrt = ipmr_get_table(net, id);
+               if (mrt)
+                       return mrt;
+       }
 
        return mr_table_alloc(net, id, &ipmr_mr_table_ops,
                              ipmr_expire_process, ipmr_new_table_set);
@@ -1547,7 +1549,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, char __user *optval,
                if (sk == rtnl_dereference(mrt->mroute_sk)) {
                        ret = -EBUSY;
                } else {
-                       mrt = ipmr_new_table(net, uval);
+                       mrt = ipmr_new_table(net, uval, false);
                        if (IS_ERR(mrt))
                                ret = PTR_ERR(mrt);
                        else


