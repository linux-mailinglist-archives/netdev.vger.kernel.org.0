Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4479250D
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfHSNcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfHSNcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 09:32:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4F851089041;
        Mon, 19 Aug 2019 13:32:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E5151C0;
        Mon, 19 Aug 2019 13:32:10 +0000 (UTC)
Message-ID: <b765aa08456ef258615a46e7ff106703a240ddb5.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] tcp: ulp: add functions to dump
 ulp-specific information
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
In-Reply-To: <20190815143810.3a190c81@cakuba.netronome.com>
References: <cover.1565882584.git.dcaratti@redhat.com>
         <f9b5663d28547b0d1c187d874c7b5e5ece8fe8fa.1565882584.git.dcaratti@redhat.com>
         <228db5cc-9b10-521f-9031-e0f86f5ded3e@gmail.com>
         <20190815143810.3a190c81@cakuba.netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 19 Aug 2019 15:32:09 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Mon, 19 Aug 2019 13:32:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-15 at 14:38 -0700, Jakub Kicinski wrote:
> On Thu, 15 Aug 2019 20:46:01 +0200, Eric Dumazet wrote:

hello Eric and Jakub, thanks a lot for looking at this.

> > On 8/15/19 6:00 PM, Davide Caratti wrote:
> > 
> > >  
> > > +	if (net_admin) {
> > > +		const struct tcp_ulp_ops *ulp_ops;
> > > +
> > > +		rcu_read_lock();
> > > +		ulp_ops = icsk->icsk_ulp_ops;
> > > +		if (ulp_ops)
> > > +			err = tcp_diag_put_ulp(skb, sk, ulp_ops);
> > > +		rcu_read_unlock();
> > > +		if (err)
> > > +			return err;
> > > +	}
> > >  	return 0;  
> > 
> > Why is rcu_read_lock() and rcu_read_unlock() used at all ?
> > 
> > icsk->icsk_ulp_ops does not seem to be rcu protected ?
> > 
> > If this was, then an rcu_dereference() would be appropriate.
> 
> Indeed it's ulp_data not ulp_ops that are protected. 

the goal is to protect execution of 'ss -tni' against concurrent removal
of tls.ko module, similarly to what was done in inet_sk_diag_fill() when
INET_DIAG_CONG is requested [1]. But after reading more carefully, the
assignment of ulp_ops needs to be:

	ulp_ops = READ_ONCE(icsk->icsk_ulp_ops);

which I lost in internal reviews, with some additional explanatory
comment. Ok if I correct the above hunk with READ_ONCE() and add a
comment?

> Davide, perhaps we could push the RCU lock into tls_get_info(), after all?

It depends on whether concurrent dump / module removal is an issue for TCP
ULPs, like it was for congestion control schemes [1]. Any advice?

> And tls_context has to use rcu_deference there, as Eric points out, 
> plus we should probably NULL-check it.

yes, it makes sense, for patch 3/3, in the assignment of 'ctx'. Instead of
calling tls_get_ctx() in tls_get_info() I will do

	ctx = rcu_dereference(inet_csk(sk)->icsk_ulp_data);

and let it return 0 in case of NULL ctx (as it doesn't look like a faulty
situation). Ok? 

-- 
davide


[1] see:
commit 521f1cf1dbb9d5ad858dca5dc75d1b45f64b6589
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Apr 16 18:10:35 2015 -0700

    inet_diag: fix access to tcp cc information

