Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EC743B05C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhJZKo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:44:59 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56860 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbhJZKow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:44:52 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AC368217BA;
        Tue, 26 Oct 2021 10:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635244946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i4TvOKge/0edIOzgTdShvqpHMR6x4jD6tX4ND9uVM/E=;
        b=yAtaRwZoCJFySesrefjF9cn7sQNiX3TacNYbIcBQj+cVDQ6gdNLj1NGiZ//KUocPaVKkMj
        GZc4MzuTvlV8ykpx46McvQ2orkkinMHpZk6hE7t9kXggY9lDpkJP4QGKrc1vAg1Fha9M4U
        RYXs154QLoFFYBhs2oLyoRPVUd9hHts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635244946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i4TvOKge/0edIOzgTdShvqpHMR6x4jD6tX4ND9uVM/E=;
        b=VXDFHDRUbhy1Bk6b3n8tUQPAJwTMNvufxBKt46OH/oYuSwTnjxhnF//MAd3mzpdg0Iu03V
        6OQJPrO98P4q5LDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BA6213D66;
        Tue, 26 Oct 2021 10:42:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GtNdGZHbd2HuGwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 26 Oct 2021 10:42:25 +0000
Subject: Re: [PATCH net-next v3] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <3bf1e148-14fc-98f6-5319-78046a7b9565@suse.de>
Date:   Tue, 26 Oct 2021 13:42:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/26/21 1:07 PM, Sebastian Andrzej Siewior пишет:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The tc_gred_qopt_offload structure has grown too big to be on the
> stack for 32-bit architectures after recent changes.
> 
> net/sched/sch_gred.c:903:13: error: stack frame size (1180) exceeds limit (1024) in 'gred_destroy' [-Werror,-Wframe-larger-than]
> net/sched/sch_gred.c:310:13: error: stack frame size (1212) exceeds limit (1024) in 'gred_offload' [-Werror,-Wframe-larger-than]
> 
> Use dynamic allocation per qdisc to avoid this.
> 
> Fixes: 50dc9a8572aa ("net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats data types")
> Fixes: 67c9e6270f30 ("net: sched: Protect Qdisc::bstats with u64_stats")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v2…v3:
>   - drop not needed return statement in gred_offload() (Jakub)
>   - use kzalloc(sizeof(*table->opt) in gred_init() (Eric)
>   - Make the allocation conditional on ->ndo_setup_tc (Jakub).
> 
>   net/sched/sch_gred.c | 50 ++++++++++++++++++++++++++------------------
>   1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
> index 72de08ef8335e..1073c76d05c45 100644
> --- a/net/sched/sch_gred.c
> +++ b/net/sched/sch_gred.c
> @@ -56,6 +56,7 @@ struct gred_sched {
>   	u32 		DPs;
>   	u32 		def;
>   	struct red_vars wred_set;
> +	struct tc_gred_qopt_offload *opt;
>   };
>   
>   static inline int gred_wred_mode(struct gred_sched *table)
> @@ -311,42 +312,43 @@ static void gred_offload(struct Qdisc *sch, enum tc_gred_command command)
>   {
>   	struct gred_sched *table = qdisc_priv(sch);
>   	struct net_device *dev = qdisc_dev(sch);
> -	struct tc_gred_qopt_offload opt = {
> -		.command	= command,
> -		.handle		= sch->handle,
> -		.parent		= sch->parent,
> -	};
> +	struct tc_gred_qopt_offload *opt = table->opt;
>   
>   	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
>   		return;
>   
> +	memset(opt, 0, sizeof(*opt));

It's zeroed in kzalloc()

> +	opt->command = command;
> +	opt->handle = sch->handle;
> +	opt->parent = sch->parent;
> +
>   	if (command == TC_GRED_REPLACE) {
>   		unsigned int i;
>   
> -		opt.set.grio_on = gred_rio_mode(table);
> -		opt.set.wred_on = gred_wred_mode(table);
> -		opt.set.dp_cnt = table->DPs;
> -		opt.set.dp_def = table->def;
> +		opt->set.grio_on = gred_rio_mode(table);
> +		opt->set.wred_on = gred_wred_mode(table);
> +		opt->set.dp_cnt = table->DPs;
> +		opt->set.dp_def = table->def;
>   
>   		for (i = 0; i < table->DPs; i++) {
>   			struct gred_sched_data *q = table->tab[i];
>   
>   			if (!q)
>   				continue;
> -			opt.set.tab[i].present = true;
> -			opt.set.tab[i].limit = q->limit;
> -			opt.set.tab[i].prio = q->prio;
> -			opt.set.tab[i].min = q->parms.qth_min >> q->parms.Wlog;
> -			opt.set.tab[i].max = q->parms.qth_max >> q->parms.Wlog;
> -			opt.set.tab[i].is_ecn = gred_use_ecn(q);
> -			opt.set.tab[i].is_harddrop = gred_use_harddrop(q);
> -			opt.set.tab[i].probability = q->parms.max_P;
> -			opt.set.tab[i].backlog = &q->backlog;
> +			opt->set.tab[i].present = true;
> +			opt->set.tab[i].limit = q->limit;
> +			opt->set.tab[i].prio = q->prio;
> +			opt->set.tab[i].min = q->parms.qth_min >> q->parms.Wlog;
> +			opt->set.tab[i].max = q->parms.qth_max >> q->parms.Wlog;
> +			opt->set.tab[i].is_ecn = gred_use_ecn(q);
> +			opt->set.tab[i].is_harddrop = gred_use_harddrop(q);
> +			opt->set.tab[i].probability = q->parms.max_P;
> +			opt->set.tab[i].backlog = &q->backlog;
>   		}
> -		opt.set.qstats = &sch->qstats;
> +		opt->set.qstats = &sch->qstats;
>   	}
>   
> -	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, &opt);
> +	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, opt);
>   }
>   
>   static int gred_offload_dump_stats(struct Qdisc *sch)
> @@ -731,6 +733,7 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
>   static int gred_init(struct Qdisc *sch, struct nlattr *opt,
>   		     struct netlink_ext_ack *extack)
>   {
> +	struct gred_sched *table = qdisc_priv(sch);
>   	struct nlattr *tb[TCA_GRED_MAX + 1];
>   	int err;
>   
> @@ -754,6 +757,12 @@ static int gred_init(struct Qdisc *sch, struct nlattr *opt,
>   		sch->limit = qdisc_dev(sch)->tx_queue_len
>   		             * psched_mtu(qdisc_dev(sch));
>   
> +	if (qdisc_dev(sch)->netdev_ops->ndo_setup_tc) {
> +		table->opt = kzalloc(sizeof(*table->opt), GFP_KERNEL);
> +		if (!table->opt)
> +			return -ENOMEM;
> +	}
> +
>   	return gred_change_table_def(sch, tb[TCA_GRED_DPS], extack);
>   }
>   
> @@ -910,6 +919,7 @@ static void gred_destroy(struct Qdisc *sch)
>   			gred_destroy_vq(table->tab[i]);
>   	}
>   	gred_offload(sch, TC_GRED_DESTROY);
> +	kfree(table->opt);
>   }
>   
>   static struct Qdisc_ops gred_qdisc_ops __read_mostly = {
> 
