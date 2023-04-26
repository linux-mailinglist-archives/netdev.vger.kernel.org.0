Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686D66EF0FF
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 11:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbjDZJWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 05:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbjDZJWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 05:22:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7111A6
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682500861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jvxWHN4pleINQbtviEy41ebpqPZsaL76Dfbg3weAJmg=;
        b=DniKi7lSA2I2H/wru2cnqLx9Msc/1pul70a7O3/C9Nw32njn7I8vD/MJnX2JgeSDItazmH
        VrqXDdcayJhAyguNKlo7LYDMHVlzQ0bLW/ZqrVpJc/G6iccmTxs+7AEuE0qkMD2uzJAa4i
        Aq2dqBmztQK2csc1AwToxbBmyeRwao0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339--1nqqslhOmaHUxcuRHyhzA-1; Wed, 26 Apr 2023 05:17:23 -0400
X-MC-Unique: -1nqqslhOmaHUxcuRHyhzA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f21e35dc08so15095125e9.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682500642; x=1685092642;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvxWHN4pleINQbtviEy41ebpqPZsaL76Dfbg3weAJmg=;
        b=HqiTjWuFh95VC/psKMsu7gz5niUut069NbEidBbAPvsCuk8E7aoeiDsP4u/jXin0KX
         THjgPbUxuHbMN5qAaWYuTZycU6q+OGu9MNgjbjc1BrHBh310sfOFZSG2xXFKLQzl1LRI
         wa2ECE5c/lSg4zZDwmHFwGMPkQJfdLLIFbjXa6n+DeiqrZWLJuBur2GLJh6p6T5xGCJ0
         +oqHP9lnCg2kR+isCj/723/3T8xf+FnkbspT3rV4KGIlpSPFewOeBusXRX0okmZoZ8ZD
         m2zBiw/ZK6cxQO6i734pw6PbeVmNXmnvrke2a5znWyo5uUgTjDL5uD6KRLItCSXSx4T+
         N7uA==
X-Gm-Message-State: AAQBX9f5iyLjJqrc5FTlwNJyBvjuGMEal2YScrViak5rXB3ByLPVYNDo
        Ku0jdQVB4r7tcuy8/YBn5I3/E9Db1BUkOnICmV84lKiApMHVUecZ/+Cypj3U5QzcP6J0VKjoCvU
        jqbEVwznUsl7KlZfX
X-Received: by 2002:a05:600c:2194:b0:3f0:9ff5:79fb with SMTP id e20-20020a05600c219400b003f09ff579fbmr11935205wme.39.1682500642724;
        Wed, 26 Apr 2023 02:17:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350awKZ4trDCLRlRhqFdRT9vYeVZysXcN5ybDgFx6g7OwgLKTxEoxuH/fYZLPrZLtisim1Kn5MQ==
X-Received: by 2002:a05:600c:2194:b0:3f0:9ff5:79fb with SMTP id e20-20020a05600c219400b003f09ff579fbmr11935192wme.39.1682500642398;
        Wed, 26 Apr 2023 02:17:22 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c4f4600b003ee5fa61f45sm20899093wmq.3.2023.04.26.02.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 02:17:21 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 3/8] sched/topology: add for_each_numa_cpu() macro
In-Reply-To: <ZEi3dLvlg/35DUrM@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-4-yury.norov@gmail.com>
 <xhsmh4jp4l21j.mognet@vschneid.remote.csb>
 <ZEi3dLvlg/35DUrM@yury-ThinkPad>
Date:   Wed, 26 Apr 2023 10:17:20 +0100
Message-ID: <xhsmhv8hjj93z.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/23 22:32, Yury Norov wrote:
> On Tue, Apr 25, 2023 at 10:54:48AM +0100, Valentin Schneider wrote:
>> On 19/04/23 22:19, Yury Norov wrote:
>> > +/**
>> > + * for_each_numa_cpu - iterate over cpus in increasing order taking into account
>> > + *		       NUMA distances from a given node.
>> > + * @cpu: the (optionally unsigned) integer iterator
>> > + * @hop: the iterator variable, must be initialized to a desired minimal hop.
>> > + * @node: the NUMA node to start the search from.
>> > + * @mask: the cpumask pointer
>> > + *
>> > + * Requires rcu_lock to be held.
>> > + */
>> > +#define for_each_numa_cpu(cpu, hop, node, mask)					\
>> > +	for ((cpu) = 0, (hop) = 0;						\
>> > +		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
>> > +		(cpu) < nr_cpu_ids;						\
>> > +		(cpu)++)
>> > +
>> 
>> I think we can keep sched_numa_find_next_cpu() as-is, but could we make
>> that macro use cpu_possible_mask by default? We can always add a variant
>> if/when we need to feed in a different mask.
>
> As mentioned in discussion to the driver's patch, all that numa things
> imply only online CPUs, so cpu_possible_mask may mislead to some extent. 
>
> Anyways, can you elaborate what you exactly want? Like this?
>
>  #define for_each_numa_online_cpu(cpu, hop, node)       \
>         for_each_numa_cpu(cpu, hop, node, cpu_online_mask)

Yeah, something like that. Like you said, the NUMA cpumasks built by the
scheduler reflect the online topology, so s/possible/online/ shouldn't
change much here.

