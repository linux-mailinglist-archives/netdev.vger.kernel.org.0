Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D145910E9
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbiHLMrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiHLMrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:47:16 -0400
X-Greylist: delayed 901 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 Aug 2022 05:47:15 PDT
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 227F3A599F;
        Fri, 12 Aug 2022 05:47:15 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 54CD211F32;
        Fri, 12 Aug 2022 15:22:16 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id BDEDB11FBD;
        Fri, 12 Aug 2022 15:17:12 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id B0AD83C043D;
        Fri, 12 Aug 2022 15:17:08 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 27CCH4PL063928;
        Fri, 12 Aug 2022 15:17:05 +0300
Date:   Fri, 12 Aug 2022 15:17:04 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     sunsuwan <sunsuwan3@huawei.com>
cc:     Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        chenzhen126@huawei.com, yanan@huawei.com, liaichun@huawei.com,
        caowangbao@huawei.com
Subject: Re: [PATCH] net:ipvs: add rcu read lock in some parts
In-Reply-To: <20220812093412.808351-1-sunsuwan3@huawei.com>
Message-ID: <a9f9ec97-61bb-b246-728-8d6677b863e9@ssi.bg>
References: <20220812093412.808351-1-sunsuwan3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 12 Aug 2022, sunsuwan wrote:

> We founf a possible UAF if rmmod pe_sid or schedule,
> when packages in hook and get pe or sched.
> 
> Signed-off-by: sunsuwan <sunsuwan3@huawei.com>
> Signed-off-by: chenzhen <chenzhen126@huawei.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 6 ++++++
>  net/netfilter/ipvs/ip_vs_ctl.c  | 3 +++
>  net/netfilter/ipvs/ip_vs_dh.c   | 2 ++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 51ad557a525b..d289f184d5c1 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -235,7 +235,9 @@ ip_vs_conn_fill_param_persist(const struct ip_vs_service *svc,
>  {
>  	ip_vs_conn_fill_param(svc->ipvs, svc->af, protocol, caddr, cport, vaddr,
>  			      vport, p);
> +	rcu_read_lock();
>  	p->pe = rcu_dereference(svc->pe);
> +	rcu_read_unlock();

	Hm, in theory, here we are under rcu_read_lock, see
nf_hook() in include/linux/netfilter.h. IPVS processes packets
by using netfilter hooks. So, IPVS scheduling is under this lock
too and ip_vs_conn_fill_param_persist() is part of the scheduling
call flow.

>  	if (p->pe && p->pe->fill_param)
>  		return p->pe->fill_param(p, skb);
>  
> @@ -346,7 +348,9 @@ ip_vs_sched_persist(struct ip_vs_service *svc,
>  		 * template is not available.
>  		 * return *ignored=0 i.e. ICMP and NF_DROP
>  		 */
> +		rcu_read_lock();
>  		sched = rcu_dereference(svc->scheduler);
> +		rcu_read_unlock();

	Scheduling from hook...

>  		if (sched) {
>  			/* read svc->sched_data after svc->scheduler */
>  			smp_rmb();
> @@ -521,7 +525,9 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
>  		return NULL;
>  	}
>  
> +	rcu_read_lock();
>  	sched = rcu_dereference(svc->scheduler);
> +	rcu_read_unlock();

	Scheduling from hook...

>  	if (sched) {
>  		/* read svc->sched_data after svc->scheduler */
>  		smp_rmb();
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index efab2b06d373..91e568028001 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -580,6 +580,7 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
>  	/* Check for "full" addressed entries */
>  	hash = ip_vs_rs_hashkey(af, daddr, dport);
>  
> +	rcu_read_lock();

	ip_vs_has_real_service() is called by ip_vs_out_hook()

>  	hlist_for_each_entry_rcu(dest, &ipvs->rs_table[hash], d_list) {
>  		if (dest->port == dport &&
>  		    dest->af == af &&
> @@ -587,9 +588,11 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
>  		    (dest->protocol == protocol || dest->vfwmark) &&
>  		    IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_MASQ) {
>  			/* HIT */
> +			rcu_read_unlock();
>  			return true;
>  		}
>  	}
> +	rcu_read_unlock();
>  
>  	return false;
>  }
> diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
> index 5e6ec32aff2b..3e4b9607172b 100644
> --- a/net/netfilter/ipvs/ip_vs_dh.c
> +++ b/net/netfilter/ipvs/ip_vs_dh.c
> @@ -219,7 +219,9 @@ ip_vs_dh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
>  	IP_VS_DBG(6, "%s(): Scheduling...\n", __func__);
>  
>  	s = (struct ip_vs_dh_state *) svc->sched_data;
> +	rcu_read_lock();
>  	dest = ip_vs_dh_get(svc->af, s, &iph->daddr);
> +	rcu_read_unlock();

	Scheduling from hook...

>  	if (!dest
>  	    || !(dest->flags & IP_VS_DEST_F_AVAILABLE)
>  	    || atomic_read(&dest->weight) <= 0
> -- 
> 2.30.0

	So, all above places are already under rcu_read_lock.

	If you see some real problem, we should track it somehow.
As for the PEs, they are protected as follows:

- svc holds 1 pe_sip module refcnt (svc->pe), from ip_vs_pe_getbyname()

- every conn can get 1 pe_sip module refcnt (cp->pe): ip_vs_pe_get()

- when last conn releases pe_sip with ip_vs_pe_put() there
can be flying packets, so we have synchronize_rcu() in
ip_vs_sip_cleanup()

Regards

--
Julian Anastasov <ja@ssi.bg>

