Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E12A331C9
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfFCOLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:11:37 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40824 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfFCOLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:11:37 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x53EBUUZ087080;
        Mon, 3 Jun 2019 09:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559571090;
        bh=F9ovSNJ8pDqF9kA6NVwjoTkBocL8Rs5YT81yp+BPz2s=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=k6oFIlFqQgX7nGFYOs1BIV5kKgBeWSN/x3spaAL5cJrvhcAfz4icbQ51rpnpvQPWh
         9CtGdzGXaWfO0xPEpbcZ4/89vdXu+qujKWL1UKKSPMbXutaEUUIvNTO1REnEjChoxA
         k2j2DxL3Yrb6ZpJZ5gkdmuD7Jd6scObf7+HVhMaE=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x53EBUGs087600
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Jun 2019 09:11:30 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 3 Jun
 2019 09:11:30 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 3 Jun 2019 09:11:30 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x53EBTZ3054818;
        Mon, 3 Jun 2019 09:11:29 -0500
Subject: Re: [PATCH net-next v1 5/7] taprio: Add support for txtime offload
 mode.
To:     Vedang Patel <vedang.patel@intel.com>, <netdev@vger.kernel.org>
CC:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <intel-wired-lan@lists.osuosl.org>, <vinicius.gomes@intel.com>,
        <l@dorileo.org>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
 <1559065608-27888-6-git-send-email-vedang.patel@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <55c2daae-c69b-4847-f995-4df85c4ee8b8@ti.com>
Date:   Mon, 3 Jun 2019 10:15:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1559065608-27888-6-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vedang,

On 05/28/2019 01:46 PM, Vedang Patel wrote:
> Currently, we are seeing non-critical packets being transmitted outside
> of their timeslice. We can confirm that the packets are being dequeued
> at the right time. So, the delay is induced in the hardware side.  The
> most likely reason is the hardware queues are starving the lower
> priority queues.
> 
> In order to improve the performance of taprio, we will be making use of the
> txtime feature provided by the ETF qdisc. For all the packets which do not have
> the SO_TXTIME option set, taprio will set the transmit timestamp (set in
> skb->tstamp) in this mode. TAPrio Qdisc will ensure that the transmit time for
> the packet is set to when the gate is open. If SO_TXTIME is set, the TAPrio
> qdisc will validate whether the timestamp (in skb->tstamp) occurs when the gate
> corresponding to skb's traffic class is open.
> 
> Following is the example configuration for enabling txtime offload:
> 
> tc qdisc replace dev eth0 parent root handle 100 taprio \\
>        num_tc 3 \\
>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
>        queues 1@0 1@0 1@0 \\
>        base-time 1558653424279842568 \\
>        sched-entry S 01 300000 \\
>        sched-entry S 02 300000 \\
>        sched-entry S 04 400000 \\
>        offload 2 \\
>        txtime-delay 40000 \\
>        clockid CLOCK_TAI
> 
> tc qdisc replace dev $IFACE parent 100:1 etf skip_sock_check \\
>        offload delta 200000 clockid CLOCK_TAI
> 
> Here, the "offload" parameter is indicating that the TXTIME_OFFLOAD mode is
> enabled. Also, all the traffic classes are mapped to the same queue.  This is
> only possible in taprio when txtime offload is enabled. Also note that the ETF
> Qdisc is enabled with offload mode set.
> 
> In this mode, if the packet's traffic class is open and the complete packet can
> be transmitted, taprio will try to transmit the packet immediately. This will
> be done by setting skb->tstamp to current_time + the time delta indicated in
> the txtime_delay parameter. This parameter indicates the time taken (in
> software) for packet to reach the network adapter.

In TSN Time aware shaper, packets are sent when gate for a specific
traffic class is open. So packets that are available in the queues are
sent by the scheduler. So the ETF is not strictly required for this
function. I understand if the application needs to send packets with
some latency expectation should use ETF to schedule the packet in sync
with the next gate open time. So txtime_delay is used to account for
the delay for packets to travel from user space to nic. So it is ETF
that need to inspect the skb->tstamp and allow or if time match or
discard if late. Is this the case?

For offload case, the h/w that offload ETF needs to send a trigger to
software to get packet for transmission ahead of the Gate open event?

Thanks

Murali
> 
> If the packet cannot be transmitted in the current interval or if the packet's
> traffic is not currently transmitting, the skb->tstamp is set to the next
> available timestamp value. This is tracked in the next_launchtime parameter in
> the struct sched_entry.
> 
> The behaviour w.r.t admin and oper schedules is not changed from what is
> present in software mode.
> 
> The transmit time is already known in advance. So, we do not need the HR timers
> to advance the schedule and wakeup the dequeue side of taprio.  So, HR timer
> won't be run when this mode is enabled.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>   include/uapi/linux/pkt_sched.h |   1 +
>   net/sched/sch_taprio.c         | 326 ++++++++++++++++++++++++++++++---
>   2 files changed, 306 insertions(+), 21 deletions(-)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 3319255ffa25..afffda24e055 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1174,6 +1174,7 @@ enum {
>   	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
>   	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>   	TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, /* u32 */
> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
>   	__TCA_TAPRIO_ATTR_MAX,
>   };
>   
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8d87ba099130..1cd19eabc53b 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -21,6 +21,7 @@
>   #include <net/pkt_sched.h>
>   #include <net/pkt_cls.h>
>   #include <net/sch_generic.h>
> +#include <net/sock.h>
>   
>   static LIST_HEAD(taprio_list);
>   static DEFINE_SPINLOCK(taprio_list_lock);
> @@ -40,6 +41,7 @@ struct sched_entry {
>   	 * packet leaves after this time.
>   	 */
>   	ktime_t close_time;
> +	ktime_t next_txtime;
>   	atomic_t budget;
>   	int index;
>   	u32 gate_mask;
> @@ -76,6 +78,7 @@ struct taprio_sched {
>   	struct sk_buff *(*peek)(struct Qdisc *sch);
>   	struct hrtimer advance_timer;
>   	struct list_head taprio_list;
> +	int txtime_delay;
>   };
>   
>   static ktime_t sched_base_time(const struct sched_gate_list *sched)
> @@ -116,6 +119,235 @@ static void switch_schedules(struct taprio_sched *q,
>   	*admin = NULL;
>   }
>   
> +/* Get how much time has been already elapsed in the current cycle. */
> +static inline s32 get_cycle_time_elapsed(struct sched_gate_list *sched, ktime_t time)
> +{
> +	ktime_t time_since_sched_start;
> +	s32 time_elapsed;
> +
> +	time_since_sched_start = ktime_sub(time, sched->base_time);
> +	div_s64_rem(time_since_sched_start, sched->cycle_time, &time_elapsed);
> +
> +	return time_elapsed;
> +}
> +
> +static ktime_t get_interval_end_time(struct sched_gate_list *sched,
> +				     struct sched_gate_list *admin,
> +				     struct sched_entry *entry,
> +				     ktime_t intv_start)
> +{
> +	s32 cycle_elapsed = get_cycle_time_elapsed(sched, intv_start);
> +	ktime_t intv_end, cycle_ext_end, cycle_end;
> +
> +	cycle_end = ktime_add_ns(intv_start, sched->cycle_time - cycle_elapsed);
> +	intv_end = ktime_add_ns(intv_start, entry->interval);
> +	cycle_ext_end = ktime_add(cycle_end, sched->cycle_time_extension);
> +
> +	if (ktime_before(intv_end, cycle_end))
> +		return intv_end;
> +	else if (admin && admin != sched &&
> +		 ktime_after(admin->base_time, cycle_end) &&
> +		 ktime_before(admin->base_time, cycle_ext_end))
> +		return admin->base_time;
> +	else
> +		return cycle_end;
> +}
> +
> +static inline int length_to_duration(struct taprio_sched *q, int len)
> +{
> +	return (len * atomic64_read(&q->picos_per_byte)) / 1000;
> +}
> +
> +/* Returns the entry corresponding to next available interval. If
> + * validate_interval is set, it only validates whether the timestamp occurs
> + * when the gate corresponding to the skb's traffic class is open.
> + */
> +static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
> +						  struct Qdisc *sch,
> +						  struct sched_gate_list *sched,
> +						  struct sched_gate_list *admin,
> +						  ktime_t time,
> +						  ktime_t *interval_start,
> +						  ktime_t *interval_end,
> +						  bool validate_interval)
> +{
> +	ktime_t curr_intv_start, curr_intv_end, cycle_end, packet_transmit_time;
> +	ktime_t earliest_txtime = KTIME_MAX, txtime, cycle, transmit_end_time;
> +	struct sched_entry *entry = NULL, *entry_found = NULL;
> +	struct taprio_sched *q = qdisc_priv(sch);
> +	struct net_device *dev = qdisc_dev(sch);
> +	int tc, entry_available = 0, n;
> +	s32 cycle_elapsed;
> +
> +	tc = netdev_get_prio_tc_map(dev, skb->priority);
> +	packet_transmit_time = length_to_duration(q, qdisc_pkt_len(skb));
> +
> +	*interval_start = 0;
> +	*interval_end = 0;
> +
> +	if (!sched)
> +		return NULL;
> +
> +	cycle = sched->cycle_time;
> +	cycle_elapsed = get_cycle_time_elapsed(sched, time);
> +	curr_intv_end = ktime_sub_ns(time, cycle_elapsed);
> +	cycle_end = ktime_add_ns(curr_intv_end, cycle);
> +
> +	list_for_each_entry(entry, &sched->entries, list) {
> +		curr_intv_start = curr_intv_end;
> +		curr_intv_end = get_interval_end_time(sched, admin, entry,
> +						      curr_intv_start);
> +
> +		if (ktime_after(curr_intv_start, cycle_end))
> +			break;
> +
> +		if (!(entry->gate_mask & BIT(tc)) ||
> +		    packet_transmit_time > entry->interval)
> +			continue;
> +
> +		txtime = entry->next_txtime;
> +
> +		if (ktime_before(txtime, time) || validate_interval) {
> +			transmit_end_time = ktime_add_ns(time, packet_transmit_time);
> +			if ((ktime_before(curr_intv_start, time) &&
> +			     ktime_before(transmit_end_time, curr_intv_end)) ||
> +			    (ktime_after(curr_intv_start, time) && !validate_interval)) {
> +				entry_found = entry;
> +				*interval_start = curr_intv_start;
> +				*interval_end = curr_intv_end;
> +				break;
> +			} else if (!entry_available && !validate_interval) {
> +				/* Here, we are just trying to find out the
> +				 * first available interval in the next cycle.
> +				 */
> +				entry_available = 1;
> +				entry_found = entry;
> +				*interval_start = ktime_add_ns(curr_intv_start, cycle);
> +				*interval_end = ktime_add_ns(curr_intv_end, cycle);
> +			}
> +		} else if (ktime_before(txtime, earliest_txtime) &&
> +			   !entry_available) {
> +			earliest_txtime = txtime;
> +			entry_found = entry;
> +			n = div_s64(ktime_sub(txtime, curr_intv_start), cycle);
> +			*interval_start = ktime_add(curr_intv_start, n * cycle);
> +			*interval_end = ktime_add(curr_intv_end, n * cycle);
> +		}
> +	}
> +
> +	return entry_found;
> +}
> +
> +static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
> +{
> +	struct taprio_sched *q = qdisc_priv(sch);
> +	struct sched_gate_list *sched, *admin;
> +	ktime_t interval_start, interval_end;
> +	struct sched_entry *entry;
> +
> +	rcu_read_lock();
> +	sched = rcu_dereference(q->oper_sched);
> +	admin = rcu_dereference(q->admin_sched);
> +
> +	entry = find_entry_to_transmit(skb, sch, sched, admin, skb->tstamp,
> +				       &interval_start, &interval_end, true);
> +	rcu_read_unlock();
> +
> +	return entry;
> +}
> +
> +static inline ktime_t get_cycle_start(struct sched_gate_list *sched,
> +				      ktime_t time)
> +{
> +	ktime_t cycle_elapsed;
> +
> +	cycle_elapsed = get_cycle_time_elapsed(sched, time);
> +
> +	return ktime_sub(time, cycle_elapsed);
> +}
> +
> +/* There are a few scenarios where we will have to modify the txtime from
> + * what is read from next_txtime in sched_entry. They are:
> + * 1. If txtime is in the past,
> + *    a. The gate for the traffic class is currently open and packet can be
> + *       transmitted before it closes, schedule the packet right away.
> + *    b. If the gate corresponding to the traffic class is going to open later
> + *       in the cycle, set the txtime of packet to the interval start.
> + * 2. If txtime is in the future, there are packets corresponding to the
> + *    current traffic class waiting to be transmitted. So, the following
> + *    possibilities exist:
> + *    a. We can transmit the packet before the window containing the txtime
> + *       closes.
> + *    b. The window might close before the transmission can be completed
> + *       successfully. So, schedule the packet in the next open window.
> + */
> +static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
> +{
> +	ktime_t transmit_end_time, interval_end, interval_start;
> +	int len, packet_transmit_time, sched_changed;
> +	struct taprio_sched *q = qdisc_priv(sch);
> +	ktime_t minimum_time, now, txtime;
> +	struct sched_gate_list *sched, *admin;
> +	struct sched_entry *entry;
> +
> +	now = q->get_time();
> +	minimum_time = ktime_add_ns(now, q->txtime_delay);
> +
> +	rcu_read_lock();
> +	admin = rcu_dereference(q->admin_sched);
> +	sched = rcu_dereference(q->oper_sched);
> +	if (admin && ktime_after(minimum_time, admin->base_time))
> +		switch_schedules(q, &admin, &sched);
> +
> +	/* Until the schedule starts, all the queues are open */
> +	if (!sched || ktime_before(minimum_time, sched->base_time)) {
> +		txtime = minimum_time;
> +		goto done;
> +	}
> +
> +	len = qdisc_pkt_len(skb);
> +	packet_transmit_time = length_to_duration(q, len);
> +
> +	do {
> +		sched_changed = 0;
> +
> +		entry = find_entry_to_transmit(skb, sch, sched, admin,
> +					       minimum_time,
> +					       &interval_start, &interval_end,
> +					       false);
> +		if (!entry) {
> +			txtime = 0;
> +			goto done;
> +		}
> +
> +		txtime = entry->next_txtime;
> +		txtime = max_t(ktime_t, txtime, minimum_time);
> +		txtime = max_t(ktime_t, txtime, interval_start);
> +
> +		if (admin && admin != sched &&
> +		    ktime_after(txtime, admin->base_time)) {
> +			sched = admin;
> +			sched_changed = 1;
> +			continue;
> +		}
> +
> +		transmit_end_time = ktime_add(txtime, packet_transmit_time);
> +		minimum_time = transmit_end_time;
> +
> +		/* Update the txtime of current entry to the next time it's
> +		 * interval starts.
> +		 */
> +		if (ktime_after(transmit_end_time, interval_end))
> +			entry->next_txtime = ktime_add(interval_start, sched->cycle_time);
> +	} while (sched_changed || ktime_after(transmit_end_time, interval_end));
> +
> +	entry->next_txtime = transmit_end_time;
> +
> +done:
> +	rcu_read_unlock();
> +	return txtime;
> +}
> +
>   static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>   			  struct sk_buff **to_free)
>   {
> @@ -129,6 +361,15 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>   	if (unlikely(!child))
>   		return qdisc_drop(skb, sch, to_free);
>   
> +	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
> +		if (!is_valid_interval(skb, sch))
> +			return qdisc_drop(skb, sch, to_free);
> +	} else if (TXTIME_OFFLOAD_IS_ON(q->offload_flags)) {
> +		skb->tstamp = get_packet_txtime(skb, sch);
> +		if (!skb->tstamp)
> +			return qdisc_drop(skb, sch, to_free);
> +	}
> +
>   	qdisc_qstats_backlog_inc(sch, skb);
>   	sch->q.qlen++;
>   
> @@ -206,11 +447,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
>   	return q->peek(sch);
>   }
>   
> -static inline int length_to_duration(struct taprio_sched *q, int len)
> -{
> -	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
> -}
> -
>   static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
>   {
>   	atomic_set(&entry->budget,
> @@ -594,7 +830,8 @@ static int parse_taprio_schedule(struct nlattr **tb,
>   
>   static int taprio_parse_mqprio_opt(struct net_device *dev,
>   				   struct tc_mqprio_qopt *qopt,
> -				   struct netlink_ext_ack *extack)
> +				   struct netlink_ext_ack *extack,
> +				   u32 offload_flags)
>   {
>   	int i, j;
>   
> @@ -642,6 +879,9 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
>   			return -EINVAL;
>   		}
>   
> +		if (TXTIME_OFFLOAD_IS_ON(offload_flags))
> +			continue;
> +
>   		/* Verify that the offset and counts do not overlap */
>   		for (j = i + 1; j < qopt->num_tc; j++) {
>   			if (last > qopt->offset[j]) {
> @@ -804,6 +1044,9 @@ static int taprio_enable_offload(struct net_device *dev,
>   	const struct net_device_ops *ops = dev->netdev_ops;
>   	int err = 0;
>   
> +	if (TXTIME_OFFLOAD_IS_ON(offload_flags))
> +		goto done;
> +
>   	if (!FULL_OFFLOAD_IS_ON(offload_flags)) {
>   		NL_SET_ERR_MSG(extack, "Offload mode is not supported");
>   		return -EOPNOTSUPP;
> @@ -816,15 +1059,28 @@ static int taprio_enable_offload(struct net_device *dev,
>   
>   	/* FIXME: enable offloading */
>   
> -	q->dequeue = taprio_dequeue_offload;
> -	q->peek = taprio_peek_offload;
> -
> -	if (err == 0)
> +done:
> +	if (err == 0) {
> +		q->dequeue = taprio_dequeue_offload;
> +		q->peek = taprio_peek_offload;
>   		q->offload_flags = offload_flags;
> +	}
>   
>   	return err;
>   }
>   
> +static void setup_txtime(struct taprio_sched *q,
> +			 struct sched_gate_list *sched, ktime_t base)
> +{
> +	struct sched_entry *entry;
> +	u32 interval = 0;
> +
> +	list_for_each_entry(entry, &sched->entries, list) {
> +		entry->next_txtime = ktime_add_ns(base, interval);
> +		interval += entry->interval;
> +	}
> +}
> +
>   static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   			 struct netlink_ext_ack *extack)
>   {
> @@ -846,7 +1102,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
>   		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
>   
> -	err = taprio_parse_mqprio_opt(dev, mqprio, extack);
> +	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
> +		offload_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
> +
> +	err = taprio_parse_mqprio_opt(dev, mqprio, extack, offload_flags);
>   	if (err < 0)
>   		return err;
>   
> @@ -887,6 +1146,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   		goto free_sched;
>   	}
>   
> +	/* preserve offload flags when changing the schedule. */
> +	if (q->offload_flags)
> +		offload_flags = q->offload_flags;
> +
>   	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
>   		clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
>   
> @@ -914,7 +1177,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   	/* Protects against enqueue()/dequeue() */
>   	spin_lock_bh(qdisc_lock(sch));
>   
> -	if (!hrtimer_active(&q->advance_timer)) {
> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
> +		q->txtime_delay = nla_get_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
> +
> +	if (!TXTIME_OFFLOAD_IS_ON(offload_flags) && !hrtimer_active(&q->advance_timer)) {
>   		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
>   		q->advance_timer.function = advance_sched;
>   	}
> @@ -966,20 +1232,35 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   		goto unlock;
>   	}
>   
> -	setup_first_close_time(q, new_admin, start);
> +	if (TXTIME_OFFLOAD_IS_ON(offload_flags)) {
> +		setup_txtime(q, new_admin, start);
> +
> +		if (!oper) {
> +			rcu_assign_pointer(q->oper_sched, new_admin);
> +			err = 0;
> +			new_admin = NULL;
> +			goto unlock;
> +		}
> +
> +		rcu_assign_pointer(q->admin_sched, new_admin);
> +		if (admin)
> +			call_rcu(&admin->rcu, taprio_free_sched_cb);
> +	} else {
> +		setup_first_close_time(q, new_admin, start);
>   
> -	/* Protects against advance_sched() */
> -	spin_lock_irqsave(&q->current_entry_lock, flags);
> +		/* Protects against advance_sched() */
> +		spin_lock_irqsave(&q->current_entry_lock, flags);
>   
> -	taprio_start_sched(sch, start, new_admin);
> +		taprio_start_sched(sch, start, new_admin);
>   
> -	rcu_assign_pointer(q->admin_sched, new_admin);
> -	if (admin)
> -		call_rcu(&admin->rcu, taprio_free_sched_cb);
> -	new_admin = NULL;
> +		rcu_assign_pointer(q->admin_sched, new_admin);
> +		if (admin)
> +			call_rcu(&admin->rcu, taprio_free_sched_cb);
>   
> -	spin_unlock_irqrestore(&q->current_entry_lock, flags);
> +		spin_unlock_irqrestore(&q->current_entry_lock, flags);
> +	}
>   
> +	new_admin = NULL;
>   	err = 0;
>   
>   unlock:
> @@ -1225,6 +1506,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
>   	if (nla_put_u32(skb, TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, q->offload_flags))
>   		goto options_error;
>   
> +	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
> +		goto options_error;
> +
>   	if (oper && dump_schedule(skb, oper))
>   		goto options_error;
>   
> 

