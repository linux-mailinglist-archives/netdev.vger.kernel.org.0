Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA6A5999BF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348350AbiHSKYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiHSKYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:24:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836347DF66
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660904674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N/mHVSrbqdjC1aGVDhd/e9K2D4ML01uWyXVxjKqxQ38=;
        b=G6b1Uu1BBzHV9DjgrsVeIV7pIUfBP8p9qUe3dJTS6iU0Aubq7ghgGuLgwfOmjOvvyhJSp8
        c78JHJPGVq2Oj6+fRQtfrWRYnxOIibRRLv+fO9MfERW2nrg04Ovs3nnnVqSwFAmeLruwb1
        /ezCjwQhEQtC7+tPxYIs7Oc/kfPVJBM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-550-DUi-M3YXNgikEZ7gdlmWrg-1; Fri, 19 Aug 2022 06:24:33 -0400
X-MC-Unique: DUi-M3YXNgikEZ7gdlmWrg-1
Received: by mail-wr1-f70.google.com with SMTP id o13-20020adfba0d000000b0022524f3f4faso637093wrg.6
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=N/mHVSrbqdjC1aGVDhd/e9K2D4ML01uWyXVxjKqxQ38=;
        b=n7j4Vbt2Brwtl7AxQmzwQ6JD2hAM3OBW9oWMMtJAtayUEGzgPdiRgaNkU/9VB/vMce
         T4pgELFc98aQSbIGACl+rkSljqQTYH025iWCU6DAmrihmD3c57c2ra1aVpGTURXaILm2
         4aGQK4SCjdm1u6pWzeCAW6UnJaiyX/vQuEAhv4GHUeyKVGwxkOv99kTOPZE5tmmwKmoR
         nlUHDMSa+ozwjk1GmXdt+XZlzoyC/WnZmxdzcX7bhwF6LAMGVrwYxEfXVzZGUNxMVxTH
         J2JlwjtsoJ99aPIpYIEcGWsKRkzCEnnA7dqk0HyR7Jp3fIrdubOW9+9uQr941r6+cQU4
         e9pw==
X-Gm-Message-State: ACgBeo1/HOVFj0nPsaS6+7c04WLE9WZ4m+R4bbXd/vsfxw6UGqWzLTHY
        cVWZ0ItAGDorplMGTd+xNCqIvdleqy6EVCiwsSUIKl/beyf7AEjcsVptX9Za9GGI2pkdlnnlCYe
        f0n29zlOl1nqxXKU0
X-Received: by 2002:a5d:59a5:0:b0:222:c5a5:59c4 with SMTP id p5-20020a5d59a5000000b00222c5a559c4mr3791046wrr.656.1660904672393;
        Fri, 19 Aug 2022 03:24:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4UobtwGkKhtvRtmvWs5RTtIa0uu+mihO6JQ7YoZdSMlNd0HYG8d+3BDeBwZzHjqohIks9ljg==
X-Received: by 2002:a5d:59a5:0:b0:222:c5a5:59c4 with SMTP id p5-20020a5d59a5000000b00222c5a559c4mr3791015wrr.656.1660904672084;
        Fri, 19 Aug 2022 03:24:32 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id m9-20020a7bce09000000b003a3442f1229sm7950701wmc.29.2022.08.19.03.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 03:24:31 -0700 (PDT)
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v2 2/5] cpumask: Introduce for_each_cpu_andnot()
In-Reply-To: <Yv6/SAj6kQ/UIKvu@yury-laptop>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220817175812.671843-3-vschneid@redhat.com>
 <Yv6/SAj6kQ/UIKvu@yury-laptop>
Date:   Fri, 19 Aug 2022 11:24:29 +0100
Message-ID: <xhsmhlerka5uq.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/22 15:38, Yury Norov wrote:
> On Wed, Aug 17, 2022 at 06:58:09PM +0100, Valentin Schneider wrote:
>> for_each_cpu_and() is very convenient as it saves having to allocate a
>> temporary cpumask to store the result of cpumask_and(). The same issue
>> applies to cpumask_andnot() which doesn't actually need temporary storage
>> for iteration purposes.
>>
>> Following what has been done for for_each_cpu_and(), introduce
>> for_each_cpu_andnot().
>>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>
> I'm concerned that this series doesn't give us real examples and tests
> for the new API. If we take it as-is, we'll end up with a dead code for
> a while, quite probably for long.
>

Tariq has at least two uses of for_each_numa_hop_cpu() (which uses
for_each_cpu_andnot()) in net/mlx5e and net/enic). My plan here is to make
sure the cpumask and sched/topology changes are OK, and then I'd let Tariq
carry the whole set with actual users on top.

I wouldn't want to see this merged without users, especially given the
EXPORT_SYMBOL_GPL() in 3/5.

> Can you please submit a new code with a real application for the new API?
> Alternatively, you can rework some existing code.
>
> Briefly grepping, I found good candidate in a core code: __sched_core_flip(),
> and one candidate in arch code: arch/powerpc/kernel/smp.c: update_coregroup_mask.
> I believe there are much more.
>

Some of these look fairly trivial, I'll have a look around.

> Regarding the test, I don't think it's strictly necessary to have it as soon as
> we'll have real users, but it's always good to backup with tests.
>

That sounds sensible enough, I'll have a look at that.

> Thanks,
> Yury

