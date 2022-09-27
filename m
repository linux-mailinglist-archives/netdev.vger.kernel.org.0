Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA85EC9E4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiI0QqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiI0Qph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:45:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A26D1C115
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664297129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3aYh91Y5WzQL9iD8Qk6Vf/HhWFbftIWDiE0GIw3ZzEc=;
        b=cdzCuSWH6HAXXxLIxdYHZinTxsty8tgqEPhj7b/si/ZzYHyfktFWF2mrn6RrpYzCpQj+d3
        3o4eWS+oqX4vlPBssrQQHBslyMyucma080OmbQg9LVRcNWg9dxGGCoLxkOXfnkceMBYkSG
        SPz8Cf2jvC73+ZDiAbhJ97a3TECyOeY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-282-Erjm7Ju-PsiPweuK1wRGXQ-1; Tue, 27 Sep 2022 12:45:25 -0400
X-MC-Unique: Erjm7Ju-PsiPweuK1wRGXQ-1
Received: by mail-wm1-f70.google.com with SMTP id h187-20020a1c21c4000000b003b51369ff1bso6865149wmh.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:45:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=3aYh91Y5WzQL9iD8Qk6Vf/HhWFbftIWDiE0GIw3ZzEc=;
        b=RCdKUFBjUTtJxZ0BUaRNTwIfdESNwEIMBvYWlZZ84fb3sC7QmjHL8cOmTs3qDTPTPF
         VixULEqduerFIzMAd0xGkX04ih5mJKKppat8SCqcX1nxUGnO4O5EH5JsXmR2oqXfHdXJ
         lgAvZeWQAM13utYlPHwfvf8hnlaHNgQO8NXn+XEwIbji+PveagE9VIf7VjtHkE1i/1E4
         xY4njZDG8aP/Ok9tS+njt2ynKSQMXPqFJyfEy1imdnF3+ixuAjuXt85tGIjtmpy8d1PL
         fJgTeQ9E3YCU3nmhBjE7178xW58K6bHfPQZVn2DVBol+AqwXqLz3GT7nFAVp3unoHxaA
         AUxg==
X-Gm-Message-State: ACrzQf1Rt6Zerx08mygVThkgJsdw1WUoacGZDfxHeQ+MAhp5BLoYq/co
        J9yrlr4eaV4Uw0ba0nEgaSDg5Y8AE3DTUf2NsCC/JC26Rq8n4JF15TLhn1IQyrNXkno801AxKB0
        KXLs+PsPlVEHY1E9K
X-Received: by 2002:a05:6000:1081:b0:22a:2ecf:9cf8 with SMTP id y1-20020a056000108100b0022a2ecf9cf8mr16895827wrw.205.1664297123837;
        Tue, 27 Sep 2022 09:45:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4xfXd99KDnmORegLCH4Mobu+mrKA/QfOT4UCXrEVf80cwvr7snphoIuQO9+NR1l/RPhKpcDQ==
X-Received: by 2002:a05:6000:1081:b0:22a:2ecf:9cf8 with SMTP id y1-20020a056000108100b0022a2ecf9cf8mr16895793wrw.205.1664297123592;
        Tue, 27 Sep 2022 09:45:23 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id t18-20020adfe452000000b00228cd9f6349sm2287334wrm.106.2022.09.27.09.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:45:22 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v4 6/7] sched/topology: Introduce for_each_numa_hop_cpu()
In-Reply-To: <YzBsonBFi9OJ29UT@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-5-vschneid@redhat.com>
 <YzBsonBFi9OJ29UT@yury-laptop>
Date:   Tue, 27 Sep 2022 17:45:21 +0100
Message-ID: <xhsmhedvw4vha.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/09/22 07:58, Yury Norov wrote:
> On Fri, Sep 23, 2022 at 04:55:41PM +0100, Valentin Schneider wrote:
>> +/**
>> + * for_each_numa_hop_cpu - iterate over CPUs by increasing NUMA distance,
>> + *                         starting from a given node.
>> + * @cpu: the iteration variable.
>> + * @node: the NUMA node to start the search from.
>> + *
>> + * Requires rcu_lock to be held.
>> + * Careful: this is a double loop, 'break' won't work as expected.
>
> This warning concerns me not only because new iteration loop hides
> complexity and breaks 'break' (sic!), but also because it looks too
> specific. Why don't you split it, so instead:
>
>        for_each_numa_hop_cpu(cpu, dev->priv.numa_node) {
>                cpus[i] = cpu;
>                if (++i == ncomp_eqs)
>                        goto spread_done;
>        }
>
> in the following patch you would have something like this:
>
>        for_each_node_hop(hop, node) {
>                struct cpumask hop_cpus = sched_numa_hop_mask(node, hop);
>
>                for_each_cpu_andnot(cpu, hop_cpus, ...) {
>                        cpus[i] = cpu;
>                        if (++i == ncomp_eqs)
>                                goto spread_done;
>                }
>        }
>
> It looks more bulky, but I believe there will be more users for
> for_each_node_hop() alone.
>
> On top of that, if you really like it, you can implement
> for_each_numa_hop_cpu() if you want.
>

IIUC you're suggesting to introduce an iterator for the cpumasks first, and
then maybe add one on top for the individual cpus.

I'm happy to do that, though I have to say I'm keen to keep the CPU
iterator - IMO the complexity is justified if it is centralized in one
location and saves us from boring old boilerplate code.

>> + * Implementation notes:
>> + *
>> + * Providing it is valid, the mask returned by
>> + *  sched_numa_hop_mask(node, hops+1)
>> + * is a superset of the one returned by
>> + *   sched_numa_hop_mask(node, hops)
>> + * which may not be that useful for drivers that try to spread things out and
>> + * want to visit a CPU not more than once.
>> + *
>> + * To accommodate for that, we use for_each_cpu_andnot() to iterate over the cpus
>> + * of sched_numa_hop_mask(node, hops+1) with the CPUs of
>> + * sched_numa_hop_mask(node, hops) removed, IOW we only iterate over CPUs
>> + * a given distance away (rather than *up to* a given distance).
>> + *
>> + * hops=0 forces us to play silly games: we pass cpu_none_mask to
>> + * for_each_cpu_andnot(), which turns it into for_each_cpu().
>> + */
>> +#define for_each_numa_hop_cpu(cpu, node)				       \
>> +	for (struct { const struct cpumask *curr, *prev; int hops; } __v =     \
>> +		     { sched_numa_hop_mask(node, 0), NULL, 0 };		       \
>
> This anonymous structure is never used as structure. What for you
> define it? Why not just declare hops, prev and curr without packing
> them?
>

I haven't found a way to do this that doesn't involve a struct - apparently
you can't mix types in a for loop declaration clause.

> Thanks,
> Yury
>

