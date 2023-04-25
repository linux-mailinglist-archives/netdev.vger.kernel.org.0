Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA06EDFC5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjDYJze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjDYJzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD5A6E87
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682416493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a3xd0KrM8HR0k4omEObz64GX2cGiGQ4SAWRK/6hdxxY=;
        b=VnDTIJj/XWDBEHnpEZDZtndIHWaKBkOqZTDpsxVpw7rXLR+6ctPWkT711LyAFvoMtMbAlb
        W+xzcadQETyuoMJaqMJ8vInakrElkrcbwyLFE4IFE73rjirtHol8MICSQaCukBWbKkDBMt
        HzOJ4JUegXuu2nNIL46sgQ+sHsVG60M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-UWHjay2wMziW0QyWK-Btog-1; Tue, 25 Apr 2023 05:54:51 -0400
X-MC-Unique: UWHjay2wMziW0QyWK-Btog-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f1754de18cso32094765e9.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682416490; x=1685008490;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a3xd0KrM8HR0k4omEObz64GX2cGiGQ4SAWRK/6hdxxY=;
        b=Zqgl2iOtIvDiM4rfJs3+vmdG/E/CivG8b6H8s7LlHVUyjT7oiw/DvtfFLrYZe1qxgz
         x4eOINTLG37NZbNve9rgH424PTU7F05ch4F7fOiCD9ENBQlxGWkG47l8FvXWcdg4VR7b
         +fYBKdE/001jnXCt0myIeM7UuCyrb4NbSl+iDvBbEasfyTVRZtf8xmhOMKntqZi4YMzM
         egixHcTaHopj6z1bmvwHQZMYaenp6FJVOm7TwJREJ4jggC2i5y5t6zkTKuk1/JA9VkQP
         G/Uroza7Mwdz3yzC9hNUFWL81iVJ5V1dzp5jJezYqLfrgsAUcXXUOadIbzhGG4D2ZiZQ
         qvAw==
X-Gm-Message-State: AAQBX9duw08Nk2EJ7ZVmaoQZ7IU/7+Ec+Whq8FjiEBn1oNXgtWlF+oPH
        11AY8I2hdMau+LaCCZVuZWM8ubduyyO1GrChac8ZW78xXbYkt9+zLHQjv9fNXdOJXnO3AqME1n5
        QLK1s7mzQuVLCpN7G
X-Received: by 2002:a1c:7714:0:b0:3f1:7277:ea6 with SMTP id t20-20020a1c7714000000b003f172770ea6mr9713889wmi.31.1682416490255;
        Tue, 25 Apr 2023 02:54:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350aRmEdQe4zxabwm2pwPMYUidyFQgdgpzZ9JnHFgTD+Y5Jp9VdMFTOZRy9bxOM0CAGUsECTCdg==
X-Received: by 2002:a1c:7714:0:b0:3f1:7277:ea6 with SMTP id t20-20020a1c7714000000b003f172770ea6mr9713872wmi.31.1682416489997;
        Tue, 25 Apr 2023 02:54:49 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id t12-20020a5d690c000000b002f74578f494sm12734891wru.41.2023.04.25.02.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 02:54:49 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
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
In-Reply-To: <20230420051946.7463-4-yury.norov@gmail.com>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-4-yury.norov@gmail.com>
Date:   Tue, 25 Apr 2023 10:54:48 +0100
Message-ID: <xhsmh4jp4l21j.mognet@vschneid.remote.csb>
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

On 19/04/23 22:19, Yury Norov wrote:
> +/**
> + * for_each_numa_cpu - iterate over cpus in increasing order taking into account
> + *		       NUMA distances from a given node.
> + * @cpu: the (optionally unsigned) integer iterator
> + * @hop: the iterator variable, must be initialized to a desired minimal hop.
> + * @node: the NUMA node to start the search from.
> + * @mask: the cpumask pointer
> + *
> + * Requires rcu_lock to be held.
> + */
> +#define for_each_numa_cpu(cpu, hop, node, mask)					\
> +	for ((cpu) = 0, (hop) = 0;						\
> +		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
> +		(cpu) < nr_cpu_ids;						\
> +		(cpu)++)
> +

I think we can keep sched_numa_find_next_cpu() as-is, but could we make
that macro use cpu_possible_mask by default? We can always add a variant
if/when we need to feed in a different mask.

>  #endif /* _LINUX_TOPOLOGY_H */
> -- 
> 2.34.1

