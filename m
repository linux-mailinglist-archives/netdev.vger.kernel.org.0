Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D87A607934
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiJUOHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiJUOHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:07:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE8427B085
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666361225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3QGZu1yFvyf6/rAbNjced6K1/QFYwLbCoSzwaCS4YJw=;
        b=UQ6d3f1bLiXRSuHhKB9st1L2SNYwn5fhiyRqfF0omjQlW18Q/zsjTl8s8eFRh86fj9k/wG
        zhT2rIAOtMrNZTUW1pd+5GAE/FxdfEzJIxAW8hYXqDStZfBDzBE+xlXW9zu9e5EknvK499
        F6uE/f2KCNl8M76Kw49ub2OlpxVlwZM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-55-wuAyh1UzPBSKKfz8JVjryg-1; Fri, 21 Oct 2022 10:07:04 -0400
X-MC-Unique: wuAyh1UzPBSKKfz8JVjryg-1
Received: by mail-qv1-f71.google.com with SMTP id 71-20020a0c804d000000b004b2fb260447so2399826qva.10
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3QGZu1yFvyf6/rAbNjced6K1/QFYwLbCoSzwaCS4YJw=;
        b=M21yb7cgSbDZKYLRkuoNnWGD8IJXUFtjV99JJYq3rdodkXc0RxS0wU3LxjP4b1J6yO
         Rc1cLh/axcobeOKISopzmVmFgTn3/pAwirGtXywu89hWW5tPtVdYs1KrQqHKogVsAjub
         HPJI9znzJh7XK+YSE1X5/unan0pNo5ZcYeArJ+utBfAfwhtVsFn7MuA1C9Sca79VmUTv
         uB3tsEoY3LWeWcYucX+QxRRvlyBls4pxe+U1PzdLvwPGivUoxSPiduIkzcRhKxvuELHo
         U4H8mkP2kbZnNUKCvBhllmv3pNIzrvqHV8JOj38pJ75GbzbNP0WkxQEtMma8AuR00SHf
         hIPw==
X-Gm-Message-State: ACrzQf3JjcWa/d26QmnUjeGekuWh5QJNq4/kDZHflGv0cDFnXP+citvt
        IhB7E/XiuzqY+fWHSGvkhgmcCPnwKUqAr4UMs1NMUffyPZEZsYkMAKxfQ5LJI4m/QeETXo24axq
        eBcIRUebDMfn5z1V9
X-Received: by 2002:a05:622a:11c9:b0:39c:dce3:280b with SMTP id n9-20020a05622a11c900b0039cdce3280bmr15989697qtk.376.1666361211838;
        Fri, 21 Oct 2022 07:06:51 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5PUFH3m6ZTTlU33UA2PdaYuGQE9STy2VAbagGXGo9HRDsPB0Do+jHqX5qJCpNPyjJaSVkgmg==
X-Received: by 2002:ac8:5d49:0:b0:399:c50c:7171 with SMTP id g9-20020ac85d49000000b00399c50c7171mr17149746qtx.564.1666361200452;
        Fri, 21 Oct 2022 07:06:40 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id n12-20020a05620a294c00b006ced5d3f921sm9926015qkp.52.2022.10.21.07.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 07:06:39 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
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
Subject: Re: [PATCH v5 2/3] sched/topology: Introduce for_each_numa_hop_mask()
In-Reply-To: <Y1Kf+aZPIxGCbksM@smile.fi.intel.com>
References: <20221021121927.2893692-1-vschneid@redhat.com>
 <20221021121927.2893692-3-vschneid@redhat.com>
 <Y1KboXN0f8dLjqit@smile.fi.intel.com>
 <Y1Kf+aZPIxGCbksM@smile.fi.intel.com>
Date:   Fri, 21 Oct 2022 15:06:36 +0100
Message-ID: <xhsmhilkdw9sj.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/22 16:34, Andy Shevchenko wrote:
> On Fri, Oct 21, 2022 at 04:16:17PM +0300, Andy Shevchenko wrote:
>> On Fri, Oct 21, 2022 at 01:19:26PM +0100, Valentin Schneider wrote:
>
> ...
>
>> > +#define for_each_numa_hop_mask(mask, node)				     \
>> > +	for (unsigned int __hops = 0;					     \
>> > +	     /*								     \
>> > +	      * Unsightly trickery required as we can't both initialize	     \
>> > +	      * @mask and declare __hops in for()'s first clause	     \
>> > +	      */							     \
>> > +	     mask = __hops > 0 ? mask :					     \
>> > +		    node == NUMA_NO_NODE ?				     \
>> > +		    cpu_online_mask : sched_numa_hop_mask(node, 0),	     \
>> > +	     !IS_ERR_OR_NULL(mask);					     \
>>
>> > +	     __hops++,							     \
>> > +	     mask = sched_numa_hop_mask(node, __hops))
>>
>> This can be unified with conditional, see for_each_gpio_desc_with_flag() as
>> example how.
>
> Something like
>
>       mask = (__hops || node != NUMA_NO_NODE) ? sched_numa_hop_mask(node, __hops) : cpu_online_mask
>

That does simplify things somewhat, thanks!

> --
> With Best Regards,
> Andy Shevchenko

