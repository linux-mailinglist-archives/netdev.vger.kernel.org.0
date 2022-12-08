Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CAD64771E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLHURk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLHURj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:17:39 -0500
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11A06165;
        Thu,  8 Dec 2022 12:17:35 -0800 (PST)
Date:   Thu, 08 Dec 2022 20:17:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=n8pjl.ca;
        s=protonmail; t=1670530652; x=1670789852;
        bh=XDr9OU9uLvDybQvM4E4TClVzCFExjZb/R4pcEYzFNcM=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=r7V12HGieDYlc1YW4cn7A2k7cTeu55Aw4HBD38EeiSyxRrLT5souB/WgEEimolI7q
         uS+Guulf83OZ8C3QthpVzKWbbEVD1aDJBerOqy4+YJ6uX9XHrPOre0Sq30OTQIQYMv
         pNuX2uuKxsZ6Wta8CkX0RoFolqo1Bd/M7Bcmjedr7tiqLGaWcUjqx5A2jtPN7oezQa
         y2CaVgnAXNwAsLbySDSD/ByopOW6H0/Fqk00AUEnJiTNYsVUmr6SlnpdnnneI4juHL
         5I3AslsG/VPBmq1Ctwsu2TM8KF46USl4ktkeXljd8w94rIevfRBqflXJ3M4IzVpneB
         dWql3SZoyzqcg==
To:     Yury Norov <yury.norov@gmail.com>
From:   Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 5/5] lib/cpumask: reorganize cpumask_local_spread() logic
Message-ID: <KQCC2QYXZ6BtFjiUQO-XQNUO5Ub3kGfpKzjfIeUfCQEvMUEMKiZ7ofEMqoZElMYxYFtuRqW6v3UzCpDzDR-QYZk-tpMDVLl_HSl8BEi1hZk=@n8pjl.ca>
In-Reply-To: <20221208183101.1162006-6-yury.norov@gmail.com>
References: <20221208183101.1162006-1-yury.norov@gmail.com> <20221208183101.1162006-6-yury.norov@gmail.com>
Feedback-ID: 53133685:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Now after moving all NUMA logic into sched_numa_find_nth_cpu(),
> else-branch of cpumask_local_spread() is just a function call, and
> we can simplify logic by using ternary operator.
>
> While here, replace BUG() with WARN().
Why make this change? It's still as bad to hit the WARN_ON as it was before=
.

> Signed-off-by: Yury Norov yury.norov@gmail.com
>
> ---
> lib/cpumask.c | 16 ++++++----------
> 1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/lib/cpumask.c b/lib/cpumask.c
> index 255974cd6734..c7029fb3c372 100644
> --- a/lib/cpumask.c
> +++ b/lib/cpumask.c
> @@ -127,16 +127,12 @@ unsigned int cpumask_local_spread(unsigned int i, i=
nt node)
> /* Wrap: we always want a cpu. */
> i %=3D num_online_cpus();
>
> - if (node =3D=3D NUMA_NO_NODE) {
> - cpu =3D cpumask_nth(i, cpu_online_mask);
> - if (cpu < nr_cpu_ids)
> - return cpu;
> - } else {
> - cpu =3D sched_numa_find_nth_cpu(cpu_online_mask, i, node);
> - if (cpu < nr_cpu_ids)
> - return cpu;
> - }
> - BUG();
> + cpu =3D node =3D=3D NUMA_NO_NODE ?
> + cpumask_nth(i, cpu_online_mask) :
> + sched_numa_find_nth_cpu(cpu_online_mask, i, node);
I find the if version clearer, and cleaner too if you drop the brackets.

For the ternary version it would be nice to parenthesize the equality
like you did in cmp() in 3/5.

> +
> + WARN_ON(cpu >=3D nr_cpu_ids);
>
> + return cpu;
> }
> EXPORT_SYMBOL(cpumask_local_spread);
>
> --
> 2.34.1

Minor nit: cmp() in 3/5 could use a longer name. The file's long, and
cmp() doesn't explain _what_ it's comparing. How about cmp_cpumask() or
something related to the function using it?

Other than the above particularities, the whole series looks good to me.
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>

