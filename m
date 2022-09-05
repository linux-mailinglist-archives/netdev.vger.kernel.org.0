Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C55AD7C6
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbiIEQo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiIEQoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF16313
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662396259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pvPW0cjV7c+Ybyz5Fia/K22ovnKJbGa0LNbZZE3i9A4=;
        b=iZGfukypy6jv6hlEJTYxa45ndVDnMz3vOT42GshaZQOlgLeWUx6SCFnpIf+OhX9yUWON2C
        +/okNueZ+NZYclOcmMlXQ6NS6Z1Aqixhz6Oe2pG+xwGnX04XVhRPEnvuwVc443eGpnTux1
        vPTNzBWvDzMg2amxhmdvGIPXrWC5hTw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-179-0FDlJ5TYOZCi1_-HeuxJLw-1; Mon, 05 Sep 2022 12:44:18 -0400
X-MC-Unique: 0FDlJ5TYOZCi1_-HeuxJLw-1
Received: by mail-wr1-f70.google.com with SMTP id v15-20020adf8b4f000000b002285ec61b3aso935332wra.6
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 09:44:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=pvPW0cjV7c+Ybyz5Fia/K22ovnKJbGa0LNbZZE3i9A4=;
        b=RwEr+xeF45r09tX7gj8S9jkk0UJ/vkZZj9ycQSl6VNC3tJvmdbYQ/DeyhIwt4P2Mms
         vznO1c1WUT2OdWB1RIuFNb8H0FMols8GzzZUMbZlDtr2071Ns6bxg6iZeZbmQc9UFJNd
         pZm/tqRe55TJ5dJGupkYmTGGFMR4Q83LpdeBEOiqa/FFMSjJm1fXaXMNrycOkjVQqcg6
         8us1fleVHOEkwxMyWly8jMtGHP5E6Ck67bFt4pjxCsg/Q9AKz+ImBT5BF3tzjILBxjU0
         vzZkL8K2afVGHygwnftXoGWnPHaqXa/2uEqNOAw4FNKwxdKMewX0OEU2goAnDwN+qNLF
         Nljw==
X-Gm-Message-State: ACgBeo3DnzEWA0ZbUn4vqn9VG2+GVhLje+UFt2zpwgtnfUtY2uVvHdCk
        5zN4NhdXkdqBCjbqmpfFA92Z3MFgSb6C1derOdBcjZMDZ1WsuuMMnPlRQBIS0sEElIPhL9zJSQJ
        eZLYZA+fWaR1etdNI
X-Received: by 2002:a05:600c:22ca:b0:3a5:c30d:ca9f with SMTP id 10-20020a05600c22ca00b003a5c30dca9fmr11310676wmg.25.1662396257256;
        Mon, 05 Sep 2022 09:44:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5GVm2sHyWOUzv41P6dtXvf+05U0eLlp8z685a0xZn4x+RRILZOtS4VXaIfJOKF5CIa2Fow0A==
X-Received: by 2002:a05:600c:22ca:b0:3a5:c30d:ca9f with SMTP id 10-20020a05600c22ca00b003a5c30dca9fmr11310648wmg.25.1662396257014;
        Mon, 05 Sep 2022 09:44:17 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id l10-20020a1ced0a000000b003a8436e2a94sm11092786wmh.16.2022.09.05.09.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 09:44:16 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
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
Subject: Re: [PATCH v3 8/9] sched/topology: Introduce for_each_numa_hop_cpu()
In-Reply-To: <b5ce51e6-976b-1729-3023-c4c4deb36f14@gmail.com>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-9-vschneid@redhat.com>
 <b5ce51e6-976b-1729-3023-c4c4deb36f14@gmail.com>
Date:   Mon, 05 Sep 2022 17:44:15 +0100
Message-ID: <xhsmh4jxldb4w.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/09/22 12:46, Tariq Toukan wrote:
> On 8/25/2022 9:12 PM, Valentin Schneider wrote:
>> The recently introduced sched_numa_hop_mask() exposes cpumasks of CPUs
>> reachable within a given distance budget, but this means each successive
>> cpumask is a superset of the previous one.
>>
>> Code wanting to allocate one item per CPU (e.g. IRQs) at increasing
>> distances would thus need to allocate a temporary cpumask to note which
>> CPUs have already been visited. This can be prevented by leveraging
>> for_each_cpu_andnot() - package all that logic into one ugl^D fancy macro.
>>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>> ---
>>   include/linux/topology.h | 37 +++++++++++++++++++++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>
>> diff --git a/include/linux/topology.h b/include/linux/topology.h
>> index 13b82b83e547..6c671dc3252c 100644
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -254,5 +254,42 @@ static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
>>   }
>>   #endif	/* CONFIG_NUMA */
>>
>> +/**
>> + * for_each_numa_hop_cpu - iterate over CPUs by increasing NUMA distance,
>> + *                         starting from a given node.
>> + * @cpu: the iteration variable.
>> + * @node: the NUMA node to start the search from.
>> + *
>> + * Requires rcu_lock to be held.
>> + * Careful: this is a double loop, 'break' won't work as expected.
>> + *
>> + *
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
>> +	     !IS_ERR_OR_NULL(__v.curr);					       \
>> +	     __v.hops++,                                                       \
>> +	     __v.prev = __v.curr,					       \
>> +	     __v.curr = sched_numa_hop_mask(node, __v.hops))                   \
>> +		for_each_cpu_andnot(cpu,				       \
>> +				    __v.curr,				       \
>> +				    __v.hops ? __v.prev : cpu_none_mask)
>>
>
> Hiding two nested loops together in one for_each_* macro leads to
> unexpected behavior for the standard usage of 'break/continue'.
>
> for_each_numa_hop_cpu(cpu, node) {
>      if (condition)
>          break; <== will terminate the inner loop only, but it's
> invisible to the human developer/reviewer.
> }
>
> These bugs will not be easy to spot in code review.
>

Yeah, it's not ideal, but I *did* attach a comment warning about
it. Spreading this pattern for sure isn't great, but there *is* a precedent
with for_each_process_thread().

>>   #endif /* _LINUX_TOPOLOGY_H */

