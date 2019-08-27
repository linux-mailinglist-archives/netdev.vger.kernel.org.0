Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2819E584
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbfH0KPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfH0KPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:15:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2C72308A9E0;
        Tue, 27 Aug 2019 10:15:22 +0000 (UTC)
Received: from wlan-180-156.mxp.redhat.com (wlan-180-156.mxp.redhat.com [10.32.180.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5946460610;
        Tue, 27 Aug 2019 10:15:20 +0000 (UTC)
Message-ID: <1a78da3c526ef6e631cadd39c596aeabbcb27ea1.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: pfifo_fast: fix wrong dereference when
 qdisc is reset
From:   Davide Caratti <dcaratti@redhat.com>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Li Shuang <shuali@redhat.com>
In-Reply-To: <20190827115031.43fcbac5@redhat.com>
References: <0598164c6e32684e57c7656f0b8aca0813c51f42.1566861256.git.dcaratti@redhat.com>
         <20190827115031.43fcbac5@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 27 Aug 2019 12:15:19 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 27 Aug 2019 10:15:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Stefano,

thanks for looking at this.

On Tue, 2019-08-27 at 11:50 +0200, Stefano Brivio wrote:
> On Tue, 27 Aug 2019 01:15:16 +0200
> Davide Caratti <dcaratti@redhat.com> wrote:
[...]
> @@ -688,12 +688,14 @@ static void pfifo_fast_reset(struct Qdisc *qdisc)
> >  			kfree_skb(skb);
> >  	}
> >  
> > -	for_each_possible_cpu(i) {
> > -		struct gnet_stats_queue *q = per_cpu_ptr(qdisc->cpu_qstats, i);
> > +	if (qdisc_is_percpu_stats(qdisc))
> 
> This needs curly brackets, as the block has multiple lines (for coding
> style only).

If I well read Documentation/process/coding-style.rst, at the end of
section 3), this rule should apply to loops. But I'm fine with the curly
brace here, if checkpatch doesn't say anything.

I will add it in v2. 

> > +		for_each_possible_cpu(i) {
> > +			struct gnet_stats_queue *q =
> > +				per_cpu_ptr(qdisc->cpu_qstats, i);
> 
> And you could split declaration and assignment here, it takes two lines
> anyway and becomes more readable.

ok, I will do that in v2.

thanks!
-- 
davide

