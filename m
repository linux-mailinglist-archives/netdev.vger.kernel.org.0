Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3695321604D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgGFU3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFU3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:29:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EE0C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:29:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 374E6120F19C4;
        Mon,  6 Jul 2020 13:29:48 -0700 (PDT)
Date:   Mon, 06 Jul 2020 13:29:47 -0700 (PDT)
Message-Id: <20200706.132947.1139798465163322137.davem@davemloft.net>
To:     xiangning.yu@alibaba-inc.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB)
 Qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 13:29:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Date: Tue, 07 Jul 2020 02:08:13 +0800

> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
> use of outbound bandwidth on a shared link. With the help of lockless
> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
> designed to scale in the cloud data centers.
> 
> Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>

I'm very skeptical about having a kthread for each qdisc, that doesn't
sound like a good idea at all.

Also:

> +static inline struct ltb_skb_cb *ltb_skb_cb(const struct sk_buff *skb)

No inline functions in foo.c files please.

> +static inline s64 get_linkspeed(struct net_device *dev)

Likewise.

> +static inline int ltb_drain(struct ltb_class *cl)
> +{
> +	typeof(&cl->drain_queue) queue;

Use the actual type not typeof().

> +	struct sk_buff *skb;
> +	int npkts, bytes;
> +	unsigned long now = NOW();
> +	int cpu;
> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
> +	struct ltb_pcpu_sched *pcpu_q;
> +	s64 timestamp;
> +	bool need_watchdog = false;
> +	struct cpumask cpumask;

Please order local variables in reverse christmas tree order.

> +static void ltb_aggregate(struct ltb_class *cl)
> +{
> +	s64 timestamp = ktime_get_ns();
> +	struct ltb_sched *ltb = qdisc_priv(cl->root_qdisc);
> +	int num_cpus = ltb->num_cpus;
> +	int i;

Likewise.

> +static inline void ltb_fanout(struct ltb_sched *ltb)
> +{

No inline please.

> +/* How many classes within the same group want more bandwidth */
> +static inline int bw_class_want_more_count(struct list_head *head)
> +{
> +	int n = 0;
> +	struct ltb_class *cl;

No inline, and reverse christmas tree ordering for local variables.

> +/* Redistribute bandwidth among classes with the same priority */
> +static int bw_redistribute_prio(struct list_head *lhead, int bw_available,
> +				int n, bool *all_reached_ceil)
> +{
> +	struct ltb_class *cl;
> +	int avg = 0;
> +	int orig_bw_allocated;
> +	int safe_loop = 0;
> +

Likewise.

> +static int bw_redistribute(struct ltb_sched *ltb, int bw_available)
> +{
> +	int prio = 0;
> +	int n;
> +	int highest_non_saturated_prio = TC_LTB_NUMPRIO;
> +	bool all_reached_ceil;

Likewise.

> +static void bw_balance(struct ltb_sched *ltb)
> +{
> +	struct ltb_class *cl;
> +	s64 link_speed = ltb->link_speed;
> +	int bw_available = link_speed;
> +	s64 total = 0;
> +	int high = TC_LTB_NUMPRIO;
> +	int is_light_traffic = 1;
> +	int i;

Likewise.

And so on and so forth.  This code needs a lot of style fixes
and removal of the per-qdisc kthread design.

Thank you.
