Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DF36F0377
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 11:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbjD0JgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 05:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243372AbjD0JgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 05:36:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970FE2D69
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682588119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nLTOa2gvY/yQPlkBPm/UDjW99+fDZr0dsfJVgkOBXe8=;
        b=C69Ar5miGCrWMuFHYyktAfb+hYK1MrS83ors27O/0XiFabb/XOGC2lViBd3AaWHivIO5EP
        T6mY748Qc9odiN+FvHBm68h7w2L0zLvT9u63/cCj4COASR9dwKMoojMTqp65MeeB8f/jRh
        hs0cQ5WE5l5Xk3pF3c0uAXDmPS82Xck=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-v-9hiYg0MvWvH1cJK1BdzQ-1; Thu, 27 Apr 2023 05:35:17 -0400
X-MC-Unique: v-9hiYg0MvWvH1cJK1BdzQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f21e35dc08so20730165e9.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682588116; x=1685180116;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLTOa2gvY/yQPlkBPm/UDjW99+fDZr0dsfJVgkOBXe8=;
        b=UU9is6TNrmyX3FYOwl2wCkAJwqCIFCxvM6obrXIBH1/WIYkKrpLzswNG8hrZOwWcoq
         LMPkM2eKeJ1LOqVedjOkzqVYTU/kpSD85D/JfCPCytwubH8hIy9EfuGaibeBZhlYgBxE
         3f+XrBxFh2zI5QNqjyHzcKZ0P7I+pa/cf/M9C4AB8C4Ei5kp//gv4FPcdbaQqmc6pt8M
         Cv2wTfU4undPhlJu6YwfBw4dafxQTaFLG94GVt40sCxmqf1p1VoZhvGCe8Z9HgjuMFgI
         HycTm422pBCcIXflzetsT9QlvV5Dd2DH3f5NgfIGDRVKJ9Toc/cyGs6Yw4v/ovpE+mRs
         cMMg==
X-Gm-Message-State: AC+VfDwqTwSJE47RszkGUxDrTcWus01l1kIcGJ/4LixBIxEgNwA5eMh8
        pb4bp7uo+F3hn8JTb6ijnPl9tAxPIhL58M93utlmviC83N9BhkVgKxoUuczo7r0g8REWNcgPLsd
        d5k5UIrqYG8wrotiN
X-Received: by 2002:a7b:c4c2:0:b0:3eb:29fe:f922 with SMTP id g2-20020a7bc4c2000000b003eb29fef922mr905181wmk.29.1682588116476;
        Thu, 27 Apr 2023 02:35:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ70GfP+ZZHQ6xluKgBksQTzeWz0mxAUsXLWSbOrJGn1bNSVtyNdb3QOaLXsLQkF4nyomIuayg==
X-Received: by 2002:a7b:c4c2:0:b0:3eb:29fe:f922 with SMTP id g2-20020a7bc4c2000000b003eb29fef922mr905155wmk.29.1682588116119;
        Thu, 27 Apr 2023 02:35:16 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id k36-20020a05600c1ca400b003f1733feb3dsm24321037wms.0.2023.04.27.02.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 02:35:15 -0700 (PDT)
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
Subject: Re: [PATCH v2 7/8] lib: add test for for_each_numa_{cpu,hop_mask}()
In-Reply-To: <ZEmOxpgZqyoHcMqu@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-8-yury.norov@gmail.com>
 <xhsmh8rehkxzz.mognet@vschneid.remote.csb>
 <ZEi7n4ZJgF2o8Ps9@yury-ThinkPad>
 <xhsmhttx3j93u.mognet@vschneid.remote.csb>
 <ZEmOxpgZqyoHcMqu@yury-ThinkPad>
Date:   Thu, 27 Apr 2023 10:35:14 +0100
Message-ID: <xhsmho7n9k6r1.mognet@vschneid.remote.csb>
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

On 26/04/23 13:51, Yury Norov wrote:
>> I realized I only wrote half the relevant code - comparing node IDs is
>> meaningless, I meant to compare distances as we walk through the
>> CPUs... I tested the below against a few NUMA topologies and it seems to be
>> sane:
>> 
>> @@ -756,12 +773,23 @@ static void __init test_for_each_numa(void)
>>  {
>>  	unsigned int cpu, node;
>>  
>> -	for (node = 0; node < sched_domains_numa_levels; node++) {
>> -		unsigned int hop, c = 0;
>> +	for_each_node(node) {
>> +		unsigned int start_cpu, prev_dist, hop = 0;
>> +
>> +		cpu = cpumask_first(cpumask_of_node(node));
>> +		prev_dist = node_distance(node, node);
>> +		start_cpu = cpu;
>>  
>>  		rcu_read_lock();
>> -		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
>> -			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
>> +
>> +		/* Assert distance is monotonically increasing */
>> +		for_each_numa_cpu(cpu, hop, node, cpu_online_mask) {
>> +			unsigned int dist = node_distance(cpu_to_node(cpu), cpu_to_node(start_cpu));
>
> Interestingly, node_distance() is an arch-specific function. Generic
> implementation is quite useless:
>
>  #define node_distance(from,to)  ((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
>
> Particularly, arm64 takes the above. With node_distance() implemented
> like that, we can barely test something...
>

riscv and arm64 rely on drivers/base/arch_numa.c to provide
__node_distance() (cf. CONFIG_GENERIC_ARCH_NUMA).

x86, sparc, powerpc and ia64 define __node_distance()
loongarch and mips define their own node_distance().

So all of those archs will have a usable node_distance(), the others won't
and that means the scheduler can't do anything about it - the scheduler
relies on node_distance() to understand the topolgoy!

