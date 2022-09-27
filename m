Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F475EC9D8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiI0QpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiI0QpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7FFDE93
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664297110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c4zpEMVgKEJ6X/NCf2FSWoSyU56nFr5gW/Csuv/JCqE=;
        b=NsI5rgTfStm+SiqFJAIrQVvXyGTRQaYkz7YqDVpvpL60O4kFjj+w8g7UWIY4OmVOgT6ZDI
        b+Lmm+KM+LvksTyql32381z8+gmnjUaBBrEKBnrRA/KZUWzRrGyW3AEY+4x42lJbvWK3Q6
        zG7abjwOIrBXrKP8Q5/IqpOLu0SPTao=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-606-Ta5GqnDEPMalHoB3DcNPFw-1; Tue, 27 Sep 2022 12:45:08 -0400
X-MC-Unique: Ta5GqnDEPMalHoB3DcNPFw-1
Received: by mail-wm1-f71.google.com with SMTP id v125-20020a1cac83000000b003b5359afd97so3726955wme.0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=c4zpEMVgKEJ6X/NCf2FSWoSyU56nFr5gW/Csuv/JCqE=;
        b=bNtFAbzIWNUsGj/NnIMnZYHDRUAD7FRTdkVroZoIOQ6hysmE1sOvreVkknhjl4M93S
         XUdR813y+fU2oZP1UNpxvWPqSiJRN0K7KWQoKBfJ9MfE6BZP9br7aeC/eGQwe/895WHM
         17O5zDn/xZE+qed3Y3cXDiFP7gPfi+H3NugDyqdjUAxzQ3o1QRZoCkSZEkyzA5Q+h8is
         WK4e466P9JTBE87H3di4MkBz0N99TKj13Cy7KX8nwOwi0tPYQmUUJ6I63/A5bEXePkk7
         +SIkHEf3HuJx4DyIiYXbOg0Uo+YZjkMCBP+x6IYt+HVcFNs4nsKlRu9ZxO6mXmvKOzbj
         A6vw==
X-Gm-Message-State: ACrzQf0tbpLFP94uX636sVxKBhATiM9pFScWxCzRyyYYxxYQ1Weuxkh/
        vCdNSuQ5WLdxBkKJkLOtNV+zNEpP1DXI7H1xEcPLaH6W/kQ1DYxpEZY8nvbHCKtOhMmEXvv27b8
        1hMDkd/py5UICKzRN
X-Received: by 2002:adf:bc13:0:b0:228:6d28:d2cb with SMTP id s19-20020adfbc13000000b002286d28d2cbmr17593954wrg.375.1664297106878;
        Tue, 27 Sep 2022 09:45:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6lvlJObzVFZ3sIA+eGCVCk/+VNcknRY9PKQA48CP81E8RCaN2GO5TrzDrcrMvDqqFdzbcObA==
X-Received: by 2002:adf:bc13:0:b0:228:6d28:d2cb with SMTP id s19-20020adfbc13000000b002286d28d2cbmr17593942wrg.375.1664297106690;
        Tue, 27 Sep 2022 09:45:06 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id j1-20020a5d4481000000b0022ae401e9e0sm2155607wrq.78.2022.09.27.09.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 09:45:06 -0700 (PDT)
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
Subject: Re: [PATCH v4 2/7] cpumask: Introduce for_each_cpu_andnot()
In-Reply-To: <YzBycCwecSUlGgjX@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-1-vschneid@redhat.com>
 <YzBycCwecSUlGgjX@yury-laptop>
Date:   Tue, 27 Sep 2022 17:45:04 +0100
Message-ID: <xhsmhill84vhr.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/09/22 08:23, Yury Norov wrote:
> On Fri, Sep 23, 2022 at 04:55:37PM +0100, Valentin Schneider wrote:
>> +/**
>> + * for_each_cpu_andnot - iterate over every cpu present in one mask, excluding
>> + *			 those present in another.
>> + * @cpu: the (optionally unsigned) integer iterator
>> + * @mask1: the first cpumask pointer
>> + * @mask2: the second cpumask pointer
>> + *
>> + * This saves a temporary CPU mask in many places.  It is equivalent to:
>> + *	struct cpumask tmp;
>> + *	cpumask_andnot(&tmp, &mask1, &mask2);
>> + *	for_each_cpu(cpu, &tmp)
>> + *		...
>> + *
>> + * After the loop, cpu is >= nr_cpu_ids.
>> + */
>> +#define for_each_cpu_andnot(cpu, mask1, mask2)				\
>> +	for ((cpu) = -1;						\
>> +		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
>> +		(cpu) < nr_cpu_ids;)
>
> This would raise cpumaks_check() warning at the very last iteration.
> Because cpu is initialized insize the loop, you don't need to check it
> at all. You can do it like this:
>
>  #define for_each_cpu_andnot(cpu, mask1, mask2)				\
>          for_each_andnot_bit(...)
>
> Check this series for details (and please review).
> https://lore.kernel.org/all/20220919210559.1509179-8-yury.norov@gmail.com/T/
>

Thanks, I'll have a look.

> Thanks,
> Yury

