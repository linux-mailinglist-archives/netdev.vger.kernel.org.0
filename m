Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6994C26BB
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbfI3Uje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:39:34 -0400
Received: from ja.ssi.bg ([178.16.129.10]:40674 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729636AbfI3Ujd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 16:39:33 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x8UJ8Nek011621;
        Mon, 30 Sep 2019 22:08:24 +0300
Date:   Mon, 30 Sep 2019 22:08:23 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v2 0/2] ipvs: speedup ipvs netns dismantle
In-Reply-To: <1569560091-20553-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Message-ID: <alpine.LFD.2.21.1909302205360.2706@ja.home.ssi.bg>
References: <1569560091-20553-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 27 Sep 2019, Haishuang Yan wrote:

> Implement exit_batch() method to dismantle more ipvs netns
> per round.
> 
> Tested:
> $  cat add_del_unshare.sh
> #!/bin/bash
> 
> for i in `seq 1 100`
>     do
>      (for j in `seq 1 40` ; do  unshare -n ipvsadm -A -t 172.16.$i.$j:80 >/dev/null ; done) &
>     done
> wait; grep net_namespace /proc/slabinfo
> 
> Befor patch:
> $  time sh add_del_unshare.sh
> net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0
> 
> real    0m8.086s
> user    0m2.025s
> sys     0m36.956s
> 
> After patch:
> $  time sh add_del_unshare.sh
> net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0
> 
> real    0m7.623s
> user    0m2.003s
> sys     0m32.935s
> 
> Haishuang Yan (2):
>   ipvs: batch __ip_vs_cleanup
>   ipvs: batch __ip_vs_dev_cleanup
> 
>  include/net/ip_vs.h             |  2 +-
>  net/netfilter/ipvs/ip_vs_core.c | 47 ++++++++++++++++++++++++-----------------
>  net/netfilter/ipvs/ip_vs_ctl.c  | 12 ++++++++---
>  3 files changed, 38 insertions(+), 23 deletions(-)

	Both patches in v2 look good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	This is for the -next kernels...

Regards

--
Julian Anastasov <ja@ssi.bg>
