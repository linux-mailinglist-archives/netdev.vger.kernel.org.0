Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A73655E67E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbiF1PbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347026AbiF1PbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:31:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EAAB60F2;
        Tue, 28 Jun 2022 08:31:23 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9A61153B;
        Tue, 28 Jun 2022 08:31:22 -0700 (PDT)
Received: from [192.168.4.21] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 413043F66F;
        Tue, 28 Jun 2022 08:31:18 -0700 (PDT)
Message-ID: <57e275bd-11c1-233a-e716-317f20139efe@arm.com>
Date:   Tue, 28 Jun 2022 16:31:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v2 net-next 4/4] time64.h: consolidate uses of
 PSEC_PER_NSEC
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
 <20220628145238.3247853-5-vladimir.oltean@nxp.com>
Content-Language: en-US
In-Reply-To: <20220628145238.3247853-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/22 15:52, Vladimir Oltean wrote:
> Time-sensitive networking code needs to work with PTP times expressed in
> nanoseconds, and with packet transmission times expressed in
> picoseconds, since those would be fractional at higher than gigabit
> speed when expressed in nanoseconds.
> 
> Convert the existing uses in tc-taprio and the ocelot/felix DSA driver
> to a PSEC_PER_NSEC macro. This macro is placed in include/linux/time64.h
> as opposed to its relatives (PSEC_PER_SEC etc) from include/vdso/time64.h
> because the vDSO library does not (yet) need/use it.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com> # for the vDSO parts

> ---
> v1->v2:
> - move PSEC_PER_NSEC to include/linux/time64.h
> - add missing include of linux/time.h
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 5 +++--
>  include/linux/time64.h                 | 3 +++
>  net/sched/sch_taprio.c                 | 5 +++--
>  3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 27d8b56cc21c..28bd4892c30a 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -16,6 +16,7 @@
>  #include <linux/iopoll.h>
>  #include <linux/mdio.h>
>  #include <linux/pci.h>
> +#include <linux/time.h>
>  #include "felix.h"
>  
>  #define VSC9959_NUM_PORTS		6
> @@ -1235,7 +1236,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
>  		u32 max_sdu;
>  
>  		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
> -		    min_gate_len[tc] * 1000 > needed_bit_time_ps) {
> +		    min_gate_len[tc] * PSEC_PER_NSEC > needed_bit_time_ps) {
>  			/* Setting QMAXSDU_CFG to 0 disables oversized frame
>  			 * dropping.
>  			 */
> @@ -1249,7 +1250,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
>  			 * frame, make sure to enable oversize frame dropping
>  			 * for frames larger than the smallest that would fit.
>  			 */
> -			max_sdu = div_u64(min_gate_len[tc] * 1000,
> +			max_sdu = div_u64(min_gate_len[tc] * PSEC_PER_NSEC,
>  					  picos_per_byte);
>  			/* A TC gate may be completely closed, which is a
>  			 * special case where all packets are oversized.
> diff --git a/include/linux/time64.h b/include/linux/time64.h
> index 81b9686a2079..2fb8232cff1d 100644
> --- a/include/linux/time64.h
> +++ b/include/linux/time64.h
> @@ -20,6 +20,9 @@ struct itimerspec64 {
>  	struct timespec64 it_value;
>  };
>  
> +/* Parameters used to convert the timespec values: */
> +#define PSEC_PER_NSEC			1000L
> +
>  /* Located here for timespec[64]_valid_strict */
>  #define TIME64_MAX			((s64)~((u64)1 << 63))
>  #define TIME64_MIN			(-TIME64_MAX - 1)
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index b9c71a304d39..0b941dd63d26 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -18,6 +18,7 @@
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> +#include <linux/time.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -176,7 +177,7 @@ static ktime_t get_interval_end_time(struct sched_gate_list *sched,
>  
>  static int length_to_duration(struct taprio_sched *q, int len)
>  {
> -	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
> +	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
>  }
>  
>  /* Returns the entry corresponding to next available interval. If
> @@ -551,7 +552,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
>  static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
>  {
>  	atomic_set(&entry->budget,
> -		   div64_u64((u64)entry->interval * 1000,
> +		   div64_u64((u64)entry->interval * PSEC_PER_NSEC,
>  			     atomic64_read(&q->picos_per_byte)));
>  }
>  

-- 
Regards,
Vincenzo
