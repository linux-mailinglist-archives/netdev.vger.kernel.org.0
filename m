Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0BDC26039
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 11:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfEVJOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 05:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbfEVJOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 05:14:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8ADD309264F;
        Wed, 22 May 2019 09:14:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E0B666D3B;
        Wed, 22 May 2019 09:14:38 +0000 (UTC)
Message-ID: <365843b0b605d272a7ec3cf4ebf4cb5ea70b42e6.camel@redhat.com>
Subject: Re: [PATCH net] net: sched: sch_ingress: do not report ingress
 filter info in egress path
From:   Davide Caratti <dcaratti@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
In-Reply-To: <738244fd5863e6228275ee8f71e81d6baafca243.1558442828.git.lorenzo.bianconi@redhat.com>
References: <cover.1558442828.git.lorenzo.bianconi@redhat.com>
         <738244fd5863e6228275ee8f71e81d6baafca243.1558442828.git.lorenzo.bianconi@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 22 May 2019 11:14:37 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 22 May 2019 09:14:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-05-21 at 14:59 +0200, Lorenzo Bianconi wrote:
> Currently if we add a filter to the ingress qdisc (e.g matchall) the
> filter data are reported even in the egress path. The issue can be
> triggered with the following reproducer:
> 
> $tc qdisc add dev lo ingress
> $tc filter add dev lo ingress matchall action ok
> $tc filter show dev lo ingress
> filter protocol all pref 49152 matchall chain 0
> filter protocol all pref 49152 matchall chain 0 handle 0x1
>   not_in_hw
> 	action order 1: gact action pass
> 		 random type none pass val 0
> 		 	 index 1 ref 1 bind 1
> 
> $tc filter show dev lo egress
> filter protocol all pref 49152 matchall chain 0
> filter protocol all pref 49152 matchall chain 0 handle 0x1
>   not_in_hw
> 	action order 1: gact action pass
> 		 random type none pass val 0
> 		 	 index 1 ref 1 bind 1
> 
> Fix it reporting NULL for non-ingress filters in ingress_tcf_block
> routine
> 
> Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infrastructure")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  net/sched/sch_ingress.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 0bac926b46c7..1825347fed3a 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -31,7 +31,7 @@ static struct Qdisc *ingress_leaf(struct Qdisc *sch, unsigned long arg)
>  
>  static unsigned long ingress_find(struct Qdisc *sch, u32 classid)
>  {
> -	return TC_H_MIN(classid) + 1;
> +	return TC_H_MIN(classid);

probably this breaks a command that was wrong before, but it's worth
mentioning. Because of the above hunk, the following command

# tc qdisc add dev test0 ingress
# tc filter add dev test0 parent ffff:fff1 matchall action drop
# tc filter add dev test0 parent ffff: matchall action continue

gave no errors, and dropped packets on unpatched kernel. With this patch,
the kernel refuses to add the 'matchall' rules (and because of that,
traffic passes).

running TDC, it seems that a patched kernel does not pass anymore
some of the test cases belonging to the 'filter' category:

# ./tdc.py -e 901f
Test 901f: Add fw filter with prio at 32-bit maxixum
exit: 2
exit: 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel, -1

All test results:
1..1
not ok 1 901f - Add fw filter with prio at 32-bit maxixum
        Command exited with 2, expected 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel, -1

(the same test is passing on a unpatched kernel)

Do you think it's worth fixing those test cases too?

thanks a lot!
-- 
davide

>  }
>  
>  static unsigned long ingress_bind_filter(struct Qdisc *sch,
> @@ -53,7 +53,12 @@ static struct tcf_block *ingress_tcf_block(struct Qdisc *sch, unsigned long cl,
>  {
>  	struct ingress_sched_data *q = qdisc_priv(sch);
>  
> -	return q->block;
> +	switch (cl) {
> +	case TC_H_MIN(TC_H_MIN_INGRESS):
> +		return q->block;
> +	default:
> +		return NULL;
> +	}
>  }
>  
>  static void clsact_chain_head_change(struct tcf_proto *tp_head, void *priv)


