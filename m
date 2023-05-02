Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C976F48C2
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjEBRAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbjEBRAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712B5D7
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 10:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683046802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=soAlhU+u59r6N3bBwieU8qJXFtY5WnxjTNdmvTWn4Lo=;
        b=KOxnz1H8J+RzNbQ6c0yqdoVvXawq8tHxJYU5bpdLY/FwVGygT+uRcKieSqlhGc6/PyOJHz
        yz1JsMK9V0EpdDpiOQ7WSOBpyocpvvkE8AKncEqLaM6GeOhg5VbkNeeFJLHhw8UXAuikb1
        0L8KSsa/orHePVsdxLEf6CLmWUqE9Fs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-4Sl8x0UdOluWwoN6_QUUrA-1; Tue, 02 May 2023 13:00:01 -0400
X-MC-Unique: 4Sl8x0UdOluWwoN6_QUUrA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f1749c63c9so12333295e9.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 09:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683046798; x=1685638798;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soAlhU+u59r6N3bBwieU8qJXFtY5WnxjTNdmvTWn4Lo=;
        b=i2uj6evMSsxkk+OGgSnzdV6ChUhb+iG9LHzfFDrl5lN48VsUVK7BwCi3eAGJ6qMMOa
         H8xd2rj7JC/xnIU+1PQroCqW2M5Epk6BLPCkko3cscZMj/KO363g0F3qJrqwPyVcfX1+
         1F0MfH6iQxt+Q8e4j+zGgGCjW/rMn/eJ3FKK6fegWyiqWTDqsxjVw0wNLB4o8QPwqgDr
         pTpZ+ymdmkrSunV7lBHFaWH33hNciOUWCYdcAIgrFp/V7NOp3UO7U2tvNZyWAIo6GIM4
         z8yp6asV3jyOoSxCHW8caTutdJtnbbhG9bKBZdOxGRjMn3+e4EhYkhZDlNmIqx5G5fGs
         1vng==
X-Gm-Message-State: AC+VfDwLknih3+WLvbx9DaYiuGniq5Eyq2ZnLOO8mx/FMWxgAgu+G+Sg
        /UHDh9f42UGZzXiStQ5IjSONnvizvOtXtRSOOGi5ykmRXuInp45CAe+lEvtMwCqm5a3i38Yn7Mn
        MwYZS2L6Eqzvu8r+t
X-Received: by 2002:a7b:cb45:0:b0:3f3:3063:f904 with SMTP id v5-20020a7bcb45000000b003f33063f904mr7647296wmj.31.1683046798734;
        Tue, 02 May 2023 09:59:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6bgoJ5+HeAaUwQyiueqwOdAyKf1FkpCEunCJteQTqQPYvQ3mhYBOMFixVzHFsCiv8wckCqOg==
X-Received: by 2002:a7b:cb45:0:b0:3f3:3063:f904 with SMTP id v5-20020a7bcb45000000b003f33063f904mr7647289wmj.31.1683046798409;
        Tue, 02 May 2023 09:59:58 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c314f00b003f1978bbcd6sm41882983wmo.3.2023.05.02.09.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 09:59:57 -0700 (PDT)
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
Subject: Re: [PATCH v2 0/8] sched/topology: add for_each_numa_cpu() macro
In-Reply-To: <20230430171809.124686-1-yury.norov@gmail.com>
References: <20230430171809.124686-1-yury.norov@gmail.com>
Date:   Tue, 02 May 2023 17:59:55 +0100
Message-ID: <xhsmhildak6t0.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/23 10:18, Yury Norov wrote:
> for_each_cpu() is widely used in kernel, and it's beneficial to create
> a NUMA-aware version of the macro.
>
> Recently added for_each_numa_hop_mask() works, but switching existing
> codebase to it is not an easy process.
>
> This series adds for_each_numa_cpu(), which is designed to be similar to
> the for_each_cpu(). It allows to convert existing code to NUMA-aware as
> simple as adding a hop iterator variable and passing it inside new macro.
> for_each_numa_cpu() takes care of the rest.
>
> At the moment, we have 2 users of NUMA-aware enumerators. One is
> Melanox's in-tree driver, and another is Intel's in-review driver:
>
> https://lore.kernel.org/lkml/20230216145455.661709-1-pawel.chmielewski@intel.com/
>
> Both real-life examples follow the same pattern:
>
>         for_each_numa_hop_mask(cpus, prev, node) {
>                 for_each_cpu_andnot(cpu, cpus, prev) {
>                         if (cnt++ == max_num)
>                                 goto out;
>                         do_something(cpu);
>                 }
>                 prev = cpus;
>         }
>
> With the new macro, it has a more standard look, like this:
>
>         for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
>                 if (cnt++ == max_num)
>                         break;
>                 do_something(cpu);
>         }
>
> Straight conversion of existing for_each_cpu() codebase to NUMA-aware
> version with for_each_numa_hop_mask() is difficult because it doesn't
> take a user-provided cpu mask, and eventually ends up with open-coded
> double loop. With for_each_numa_cpu() it shouldn't be a brainteaser.
> Consider the NUMA-ignorant example:
>
>         cpumask_t cpus = get_mask();
>         int cnt = 0, cpu;
>
>         for_each_cpu(cpu, cpus) {
>                 if (cnt++ == max_num)
>                         break;
>                 do_something(cpu);
>         }
>
> Converting it to NUMA-aware version would be as simple as:
>
>         cpumask_t cpus = get_mask();
>         int node = get_node();
>         int cnt = 0, hop, cpu;
>
>         for_each_numa_cpu(cpu, hop, node, cpus) {
>                 if (cnt++ == max_num)
>                         break;
>                 do_something(cpu);
>         }
>
> The latter looks more verbose and avoids from open-coding that annoying
> double loop. Another advantage is that it works with a 'hop' parameter with
> the clear meaning of NUMA distance, and doesn't make people not familiar
> to enumerator internals bothering with current and previous masks machinery.
>

LGTM, I ran the tests on a few NUMA topologies and that all seems to behave
as expected. Thanks for working on this! 

Reviewed-by: Valentin Schneider <vschneid@redhat.com>

