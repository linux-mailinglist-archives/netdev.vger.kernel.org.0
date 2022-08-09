Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5B558D703
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbiHIKCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240376AbiHIKCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15DAE22BCC
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 03:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660039334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JQ4rx3p2EcFXQ1V5iVeBvBViEa90MF16sMNOOJrJ4ZY=;
        b=cYaR3DzWFfGBOkt1fVnhfFXYFIqjzW54QBZOcYrBR4pEIVcd0t03FLF0Zwhm2F8jizGDIU
        QTAGZNC97CYxOAcEgsTaqscU4WvM7V7T1uA1auq8vXf/Nqqq+v/gardtUogP4N1n4MZEmO
        HrK41bcJvxtbD2wEjguAVIhl/xjFDsY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-YRdziBihOnel0KvZcvXFKg-1; Tue, 09 Aug 2022 06:02:10 -0400
X-MC-Unique: YRdziBihOnel0KvZcvXFKg-1
Received: by mail-wr1-f70.google.com with SMTP id c7-20020adfc6c7000000b0021db3d6961bso1774256wrh.23
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 03:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=JQ4rx3p2EcFXQ1V5iVeBvBViEa90MF16sMNOOJrJ4ZY=;
        b=J7YL4JZSefj7fbrOwYzwKDeKhX8wifFBTkuCTCKZMMfWuV8M3PBjs3ncrnGK8HDcHW
         RYk5OL08p974+3+JlwZokDy9ND8lZ0VQGsqOgK9Kmg4qEDlSws/FmLv1jCV0KsQcYety
         sBv6OZnIA0OfKxYodIphYPCdpc2IB5lK7C+VaEmv1xSLorjT6kNqHlJjBG1VYvTOvGha
         YLeFmsvepZ4fLfyOt+sm/Vhw7+ttjQAsH8LUrGxtF4VkTlfH8z0YtvKKkdCGU+PK//h6
         /NiZXDcrNMwiJyXjGXefWvaTy0umKpm77vE+KBldJxQ2pmYEisMvgbcxKbe19TGHZ6+4
         AzVA==
X-Gm-Message-State: ACgBeo1lwDsA5rEW0jG6Le1NqSYf1j5lxqYpKbWNCjjy5giH5DoyWTbK
        pS6UEK5P0JtBjIudmOVHQ0oyRdJfezd4yVX4UKmgqi4V4MWBaxih37modVoIyiPDQ/AXuW/igIY
        SLzW1Rjb0GIhhn3ph
X-Received: by 2002:a05:600c:4e41:b0:3a5:1a0c:c52 with SMTP id e1-20020a05600c4e4100b003a51a0c0c52mr12748575wmq.51.1660039329785;
        Tue, 09 Aug 2022 03:02:09 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6tm2HzECoaWBmuka51DwVtiBM0cqXZcsf+uzA99fhRZwJPX20Dz1mrLQVRih/G0pCKAWwPSQ==
X-Received: by 2002:a05:600c:4e41:b0:3a5:1a0c:c52 with SMTP id e1-20020a05600c4e4100b003a51a0c0c52mr12748545wmq.51.1660039329572;
        Tue, 09 Aug 2022 03:02:09 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c359300b003a32297598csm21171607wmq.43.2022.08.09.03.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 03:02:08 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
In-Reply-To: <df8b684d-ede6-7412-423d-51d57365e065@gmail.com>
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
 <xhsmhedxvdikz.mognet@vschneid.remote.csb>
 <df8b684d-ede6-7412-423d-51d57365e065@gmail.com>
Date:   Tue, 09 Aug 2022 11:02:07 +0100
Message-ID: <xhsmh35e5d9b4.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/22 17:39, Tariq Toukan wrote:
> On 8/4/2022 8:28 PM, Valentin Schneider wrote:
>> On 28/07/22 22:12, Tariq Toukan wrote:
>>> +static bool sched_cpus_spread_by_distance(int node, u16 *cpus, int ncpus)
>>                                                         ^^^^^^^^^
>> That should be a struct *cpumask.
>
> With cpumask, we'll lose the order.
>

Right, I didn't get that from the changelog.

>>
>>> +{
>>> +	cpumask_var_t cpumask;
>>> +	int first, i;
>>> +
>>> +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
>>> +		return false;
>>> +
>>> +	cpumask_copy(cpumask, cpu_online_mask);
>>> +
>>> +	first = cpumask_first(cpumask_of_node(node));
>>> +
>>> +	for (i = 0; i < ncpus; i++) {
>>> +		int cpu;
>>> +
>>> +		cpu = sched_numa_find_closest(cpumask, first);
>>> +		if (cpu >= nr_cpu_ids) {
>>> +			free_cpumask_var(cpumask);
>>> +			return false;
>>> +		}
>>> +		cpus[i] = cpu;
>>> +		__cpumask_clear_cpu(cpu, cpumask);
>>> +	}
>>> +
>>> +	free_cpumask_var(cpumask);
>>> +	return true;
>>> +}
>>
>> This will fail if ncpus > nr_cpu_ids, which shouldn't be a problem. It
>> would make more sense to set *up to* ncpus, the calling code can then
>> decide if getting fewer than requested is OK or not.
>>
>> I also don't get the fallback to cpumask_local_spread(), is that if the
>> NUMA topology hasn't been initialized yet? It feels like most users of this
>> would invoke it late enough (i.e. anything after early initcalls) to have
>> the backing data available.
>
> I don't expect this to fail, as we invoke it late enough. Fallback is
> there just in case, to preserve the old behavior instead of getting
> totally broken.
>

Then there shouldn't be a fallback method - the main method is expected to
work.

>>
>> Finally, I think iterating only once per NUMA level would make more sense.
>
> Agree, although it's just a setup stage.
> I'll check if it can work for me, based on the reference code below.
>
>>
>> I've scribbled something together from those thoughts, see below. This has
>> just the mlx5 bits touched to show what I mean, but that's just compile
>> tested.
>
> My function returns a *sorted* list of the N closest cpus.
> That is important. In many cases, drivers do not need all N irqs, but
> only a portion of it, so it wants to use the closest subset of cpus.
>

Are there cases where we can't figure this out in advance? From what I grok
out of the two callsites you patched, all vectors will be used unless some
error happens, so compressing the CPUs in a single cpumask seemed
sufficient.

