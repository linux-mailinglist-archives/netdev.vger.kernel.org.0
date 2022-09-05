Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9005AD7E1
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiIEQvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIEQvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC3C4F66A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662396704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vKSL9pKNMCBS4xJu1kk0Jq/KDoKI3NjDZ72FzQ0w4P0=;
        b=Qjql+WejS80D8Hf6srXqt8lzpDF0DbjQaSbU8ulL7inEcimPpg+S12rOS32FlUWwc+D0P7
        vwr+Rm4Ndr5uOW/HEZi0VRiEDCMofbkfXXt652G25hLpUCuVsv8wpoyROGF+xk4Vg/CkjB
        fYvx8OJrcW/oKafutBKrdxiay8o2JgY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-15-0hkk58jJOQS68HgUvFe_Nw-1; Mon, 05 Sep 2022 12:51:43 -0400
X-MC-Unique: 0hkk58jJOQS68HgUvFe_Nw-1
Received: by mail-wm1-f71.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso7660089wmq.4
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 09:51:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=vKSL9pKNMCBS4xJu1kk0Jq/KDoKI3NjDZ72FzQ0w4P0=;
        b=sCVfmAzac+XHwqgmpcuLheZIWmk6CTNVtfp3EpPKRutlCAW3dT7ZpqbYDLvy3Z99mU
         h8ydLDWU0awCVP64MPlOxQCfzTWpMNhKguYfwZJ6cRblyZy2djgg2d7UlFJkeRPW+FJH
         jFHoYUc04NlJCQBRun2aLSwVMNeHSlxteoDQslbXldE7+UN7NsDQgUnR6ZydWbfOug6q
         moGTbq1BbQDePc535Hqzm/9QvYDMfTm0kHOxYU+kEeLgGaMHVBeaqK8hpObRDvmhGa/c
         hwvmvycjJBEgrWTF9/ac+1/+//Pb/I7QIFSzK550fIGaygRFssoVPS9F0eofDB2pLUsa
         VX+w==
X-Gm-Message-State: ACgBeo0m62Kr2ScEyGtKogPAn++qPs7jWvgTv5r2gZfPDiSvogEIzcR5
        2Pegy6gr7m0X2QzX6+0G+gDRJkDhPPlwrhD48cwlRrznS52LlZXnpvjGh3Tvb0nkKpyN7ZHi2r+
        OPMtW7gFvuXVwO9YX
X-Received: by 2002:adf:db8a:0:b0:228:6462:f87c with SMTP id u10-20020adfdb8a000000b002286462f87cmr4700581wri.514.1662396702533;
        Mon, 05 Sep 2022 09:51:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6fmLOZBNjlkLm5/5DJTxobZ5+R2mPCex6of1uWKWqJmllUg3nKUCDOjXQ+Vq77lJTpU7bONA==
X-Received: by 2002:adf:db8a:0:b0:228:6462:f87c with SMTP id u10-20020adfdb8a000000b002286462f87cmr4700572wri.514.1662396702312;
        Mon, 05 Sep 2022 09:51:42 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id j4-20020adfe504000000b00226cf855861sm9236368wrm.84.2022.09.05.09.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 09:51:41 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yicong Yang <yangyicong@huawei.com>
Cc:     yangyicong@hisilicon.com, Saeed Mahameed <saeedm@nvidia.com>,
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
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "shenjian (K)" <shenjian15@huawei.com>, wangjie125@huawei.com,
        linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 7/9] sched/topology: Introduce sched_numa_hop_mask()
In-Reply-To: <9c1d79e4-cdfb-8fe9-60a2-9eea259d6960@huawei.com>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-8-vschneid@redhat.com>
 <9c1d79e4-cdfb-8fe9-60a2-9eea259d6960@huawei.com>
Date:   Mon, 05 Sep 2022 17:51:40 +0100
Message-ID: <xhsmh1qspdasj.mognet@vschneid.remote.csb>
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

On 26/08/22 16:14, Yicong Yang wrote:
> On 2022/8/26 2:12, Valentin Schneider wrote:
>> Tariq has pointed out that drivers allocating IRQ vectors would benefit
>> from having smarter NUMA-awareness - cpumask_local_spread() only knows
>> about the local node and everything outside is in the same bucket.
>>
>> sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
>> of CPUs reachable within a given distance budget), introduce
>> sched_numa_hop_mask() to export those cpumasks.
>>
>> Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>> ---
>>  include/linux/topology.h |  9 +++++++++
>>  kernel/sched/topology.c  | 28 ++++++++++++++++++++++++++++
>>  2 files changed, 37 insertions(+)
>>
>> diff --git a/include/linux/topology.h b/include/linux/topology.h
>> index 4564faafd0e1..13b82b83e547 100644
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -245,5 +245,14 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>>      return cpumask_of_node(cpu_to_node(cpu));
>>  }
>>
>> +#ifdef CONFIG_NUMA
>> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
>> +#else
>> +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
>> +{
>> +	return ERR_PTR(-EOPNOTSUPP);
>> +}
>> +#endif	/* CONFIG_NUMA */
>> +
>>
>
> I think it should be better to return cpu_online_mask() if CONFIG_NUMA=n and hop is 0. Then we
> can keep the behaviour consistent with cpumask_local_spread() which for_each_numa_hop_cpu is
> going to replace.
>

That's a good point, thanks.

> The macro checking maybe unnecessary, check whether node is NUMA_NO_NODE will handle the case
> where NUMA is not configured.
>
> Thanks.

