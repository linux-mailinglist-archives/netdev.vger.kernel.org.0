Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17106255CA
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiKKIyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiKKIym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:54:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB13DFD4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668156817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WEJmJ5jV5I9vgXhkorz4r1a4bEM4gVOcUDK2msQn6xY=;
        b=Hh7CIanvmuxMjuUV8aVzjXTTGojw3BUYhOFH4tCrshQDqTxj/oOZAqzL3AFoliVi/4TsLT
        dr0t5kIbjCGpD019+AFjPgCLTlrpLDq7gWfqB8RPU8ibtg+msOciaGJcWVUR/MtKs8dATk
        dGUNXZq4VkPv45Mw17RLXbf/Vde/RIQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-65-uiS1Sk-APiadzapmWANtLg-1; Fri, 11 Nov 2022 03:53:35 -0500
X-MC-Unique: uiS1Sk-APiadzapmWANtLg-1
Received: by mail-qt1-f199.google.com with SMTP id cd6-20020a05622a418600b003a54cb17ad9so3262658qtb.0
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:53:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WEJmJ5jV5I9vgXhkorz4r1a4bEM4gVOcUDK2msQn6xY=;
        b=myLHclFUGXfVQJNQiHBFngPWPE3Ka4pDbjXkdwDFO6tkQ3oi+QpbCzIB0BBhmWJylw
         PQqzD9O+MZTSfwYAtqC/ZXZLRnMgRQTiA/tXLh1UhWuUhTHYZ0QJoKU3ta6ONc5A5x8b
         NKCVO7c9cZpQZO83RYHDPHY3ja8fSzzoD4CUWXnV1c3mNfDPIBf5WPFCDKWX7J+uJcLn
         OaqOe8SNHWcYbJzOkoC0ePuD/Hp22BbaNaiLaugPkxRt7S2iH1B0OVuLoWTKAA+xD0bq
         kMKAYR+7xXtaEH5QAcA7uKjQQIDwc9HTLksjcchLPivN/ZVwPYn4Hk9Qx32qYCJAKv1X
         CCGA==
X-Gm-Message-State: ANoB5pnWYkuCsi0jMZufJifoHqgvrRreLQhB1swnJjXq3OvBdiBnelT5
        df0YH2pUk3LQf5b03dOBfmA1GCxCdBaCAjp3rmp9fz7YZpvmT7VdMEd7Qbo9ZZMkOR0Uc91bFSD
        V3jR4/RCfgzKjsYqE
X-Received: by 2002:a05:622a:4a0d:b0:3a5:c5c1:43ff with SMTP id fv13-20020a05622a4a0d00b003a5c5c143ffmr462844qtb.312.1668156815401;
        Fri, 11 Nov 2022 00:53:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5f2UqZDTkqPq7M3jh43XNKU3r3/XMjQ+v5FPIIrovaPBfoAgwutxjncyzR51hftftrcG9Bfg==
X-Received: by 2002:a05:622a:4a0d:b0:3a5:c5c1:43ff with SMTP id fv13-20020a05622a4a0d00b003a5c5c143ffmr462832qtb.312.1668156815098;
        Fri, 11 Nov 2022 00:53:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id p70-20020a374249000000b006eef13ef4c8sm1057054qka.94.2022.11.11.00.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 00:53:34 -0800 (PST)
Message-ID: <33ccbd2770b069da8144aa1b94134f7d6464f4eb.camel@redhat.com>
Subject: Re: [PATCH v2 net-next 6/6] udp: Introduce optional per-netns hash
 table.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 11 Nov 2022 09:53:31 +0100
In-Reply-To: <20221111040034.29736-7-kuniyu@amazon.com>
References: <20221111040034.29736-1-kuniyu@amazon.com>
         <20221111040034.29736-7-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-11-10 at 20:00 -0800, Kuniyuki Iwashima wrote:
> @@ -408,6 +409,28 @@ static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
>  	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
>  }
>  
> +static int proc_udp_hash_entries(struct ctl_table *table, int write,
> +				 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct net *net = container_of(table->data, struct net,
> +				       ipv4.sysctl_udp_child_hash_entries);
> +	int udp_hash_entries;
> +	struct ctl_table tbl;
> +
> +	udp_hash_entries = net->ipv4.udp_table->mask + 1;
> +
> +	/* A negative number indicates that the child netns
> +	 * shares the global udp_table.
> +	 */
> +	if (!net_eq(net, &init_net) && net->ipv4.udp_table == &udp_table)
> +		udp_hash_entries *= -1;
> +
> +	tbl.data = &udp_hash_entries;
> +	tbl.maxlen = sizeof(int);

I see the procfs code below will only use tbl.data and tbl.maxlen, but
perhaps is cleaner intially explicitly memset tbl to 0 

> 
> +
> +	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
> +}
> +
>  #ifdef CONFIG_IP_ROUTE_MULTIPATH
>  static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
>  					  void *buffer, size_t *lenp,

[...]

> @@ -3308,22 +3308,112 @@ u32 udp_flow_hashrnd(void)
>  }
>  EXPORT_SYMBOL(udp_flow_hashrnd);
>  
> -static int __net_init udp_sysctl_init(struct net *net)
> +static void __net_init udp_sysctl_init(struct net *net)
>  {
> -	net->ipv4.udp_table = &udp_table;
> -
>  	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
>  	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
>  
>  #ifdef CONFIG_NET_L3_MASTER_DEV
>  	net->ipv4.sysctl_udp_l3mdev_accept = 0;
>  #endif
> +}
> +
> +static struct udp_table __net_init *udp_pernet_table_alloc(unsigned int hash_entries)
> +{
> +	unsigned long hash_size, bitmap_size;
> +	struct udp_table *udptable;
> +	int i;
> +
> +	udptable = kmalloc(sizeof(*udptable), GFP_KERNEL);
> +	if (!udptable)
> +		goto out;
> +
> +	udptable->log = ilog2(hash_entries);
> +	udptable->mask = hash_entries - 1;
> +
> +	hash_size = L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot));
> +	bitmap_size = hash_entries *
> +		BITS_TO_LONGS(udp_bitmap_size(udptable)) * sizeof(unsigned long);

Ouch, I'm very sorry. I did not realize we need a bitmap per hash
bucket. This leads to a constant 8k additional memory overhead per
netns, undependently from arch long bitsize.

I guess it's still acceptable, but perhaps worth mentioning in the
commit message?

Again sorry for the back && forth, I'm reconsidering all the above
given my dumb misunderstanding.

I see that a minumum size of 256 hash buckets does not match your use
case, still... if lower values of the per netns hash size are inflated
to e.g. 128 and we keep the bitmap on stack (should be 64 bytes wide, I
guess still an acceptable value), the per netns memory overhead will be
128*2*<hash bucket size> = 8K, less that what we get the above schema
and any smaller hash - a single hash bucket leads to a 32 + 8K memory
overhead.

TL;DR: what about accepting any per netns hash table size, but always
allocate at least 128 buckets and keep the bitmap on the stack?

Thanks,

Paolo

