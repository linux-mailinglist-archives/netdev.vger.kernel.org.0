Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729E121985A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGIGQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:16:16 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:33962 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGIGQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:16:16 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2020 02:16:15 EDT
Received: from pa49-197-58-130.pa.qld.optusnet.com.au ([49.197.58.130]:58645 helo=localhost)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1jtPlU-0000xP-HJ
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 16:10:57 +1000
Date:   Thu, 9 Jul 2020 16:10:34 +1000
From:   Russell Strong <russell@strong.id.au>
To:     netdev@vger.kernel.org
Subject: amplifying qdisc
Message-ID: <20200709161034.71bf8e09@strong.id.au>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm attempting to fill a link with background traffic that is sent
whenever the link is idle.  To do this I've creates a qdisc that will
repeat the last packet in the queue for a defined number of times
(possibly infinite in the future). I am able to control the contents of
the fill traffic by sending the occasional packet through this qdisc.

This is works as the root qdisc and below a TBF.  When I try it as a
leaf of HTB unexpected behaviour ensues.  I suspect my approach is
violating some rules for qdiscs?  Any help/ideas/pointers would be
appreciated.

// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * net/sched/sch_amp.c	amplifying qdisc
 *
 * Authors:	Russell Strong <russell@strong.id.au>
 */

#include <linux/module.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/skbuff.h>
#include <net/pkt_sched.h>

struct amp_sched_data {
	u32 duplicates;
	u32 remaining;
};

static int amp_enqueue(struct sk_buff *skb, struct Qdisc *sch,
			 struct sk_buff **to_free)
{
	struct amp_sched_data *asd = qdisc_priv(sch);

	printk(KERN_DEBUG "amp_enqueue: qlen %d\n", sch->q.qlen);

	asd->remaining = asd->duplicates;

	if (likely(sch->q.qlen < sch->limit))
		return qdisc_enqueue_tail(skb, sch);

	return qdisc_drop(skb, sch, to_free);
}

static struct sk_buff *amp_dequeue(struct Qdisc *sch)
{
	struct sk_buff *skb;
	struct amp_sched_data *asd = qdisc_priv(sch);

	printk(KERN_DEBUG "amp_dequeue: qlen %d, remaining %d\n",
		sch->q.qlen, asd->remaining);

	if (sch->q.qlen == 1 && asd->remaining > 0) {
		skb = qdisc_peek_head(sch);
		skb = skb_clone(skb, GFP_ATOMIC);
		asd->remaining -= 1;
	} else
		skb = qdisc_dequeue_head(sch);

	return skb;
}

static int amp_init(struct Qdisc *sch, struct nlattr *opt,
		     struct netlink_ext_ack *extack)
{
	struct amp_sched_data *asd = qdisc_priv(sch);
	u32 limit = qdisc_dev(sch)->tx_queue_len;

	sch->limit = limit;
	asd->duplicates = 10;
	asd->remaining = 0;

	printk(KERN_DEBUG "amp_init\n");

	return 0;
}

static void amp_reset_queue(struct Qdisc *sch)
{
	struct amp_sched_data *asd = qdisc_priv(sch);
	asd->remaining = 0;

	qdisc_reset_queue(sch);
}

static int amp_dump(struct Qdisc *sch, struct sk_buff *skb)
{
	return skb->len;
}

struct Qdisc_ops amp_qdisc_ops __read_mostly = {
	.id		=	"amp",
	.priv_size	=	sizeof(struct amp_sched_data),
	.enqueue	=	amp_enqueue,
	.dequeue	=	amp_dequeue,
	.peek		=	qdisc_peek_head,
	.init		=	amp_init,
	.reset		=	amp_reset_queue,
	.change		=	amp_init,
	.dump		=	amp_dump,
	.owner		=	THIS_MODULE,
};

static int __init amp_module_init(void)
{
        return register_qdisc(&amp_qdisc_ops);
}

static void __exit amp_module_exit(void)
{
        unregister_qdisc(&amp_qdisc_ops);
}

module_init(amp_module_init)
module_exit(amp_module_exit)
MODULE_LICENSE("GPL");
