Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1523CE3CF
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfJGNe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfJGNe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 09:34:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636482064A;
        Mon,  7 Oct 2019 13:34:55 +0000 (UTC)
Date:   Mon, 7 Oct 2019 09:34:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marco Elver <elver@google.com>
Cc:     syzbot <syzbot+134336b86f728d6e55a0@syzkaller.appspotmail.com>,
        paulmck@kernel.org, josh@joshtriplett.org,
        mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Subject: Re: KCSAN: data-race in find_next_bit / rcu_report_exp_cpu_mult
Message-ID: <20191007093453.2d9852ce@gandalf.local.home>
In-Reply-To: <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
References: <000000000000604e8905944f211f@google.com>
        <CANpmjNNmSOagbTpffHr4=Yedckx9Rm2NuGqC9UqE+AOz5f1-ZQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 12:04:16 +0200
Marco Elver <elver@google.com> wrote:

> +RCU maintainers
> This might be a data-race in RCU itself.
> 
> >
> > write to 0xffffffff85a7f140 of 8 bytes by task 7 on cpu 0:
> >   rcu_report_exp_cpu_mult+0x4f/0xa0 kernel/rcu/tree_exp.h:244

Here we have:

	raw_spin_lock_irqsave_rcu_node(rnp, flags);
	if (!(rnp->expmask & mask)) {
		raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
		return;
	}
	rnp->expmask &= ~mask;
	__rcu_report_exp_rnp(rnp, wake, flags); /* Releases rnp->lock. */

> >
> > read to 0xffffffff85a7f140 of 8 bytes by task 7251 on cpu 1:
> >   _find_next_bit lib/find_bit.c:39 [inline]
> >   find_next_bit+0x57/0xe0 lib/find_bit.c:70
> >   sync_rcu_exp_select_node_cpus+0x28e/0x510 kernel/rcu/tree_exp.h:375

and here we have:


	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);

	/* IPI the remaining CPUs for expedited quiescent state. */
	for_each_leaf_node_cpu_mask(rnp, cpu, rnp->expmask) {


The write to rnp->expmask is done under the rnp->lock, but on the read
side, that lock is released before the for loop. Should we have
something like:

	unsigned long expmask;
	[...]

	expmask = rnp->expmask;
	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);

	/* IPI the remaining CPUs for expedited quiescent state. */
	for_each_leaf_node_cpu_mask(rnp, cpu, expmask) {

?

-- Steve
