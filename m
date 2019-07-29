Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB9797EA
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfG2UD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:03:56 -0400
Received: from ja.ssi.bg ([178.16.129.10]:52746 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729843AbfG2UDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 16:03:55 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x6TK3VOW005690;
        Mon, 29 Jul 2019 23:03:32 +0300
Date:   Mon, 29 Jul 2019 23:03:31 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next 1/2] ipvs: batch __ip_vs_cleanup
In-Reply-To: <8441EA26-E197-4F40-A6D7-5B7D59AA7F7F@cmss.chinamobile.com>
Message-ID: <alpine.LFD.2.21.1907292300580.2909@ja.home.ssi.bg>
References: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com> <1563031186-2101-2-git-send-email-yanhaishuang@cmss.chinamobile.com> <alpine.LFD.2.21.1907152333300.5700@ja.home.ssi.bg>
 <8441EA26-E197-4F40-A6D7-5B7D59AA7F7F@cmss.chinamobile.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 18 Jul 2019, Haishuang Yan wrote:

> As the following benchmark testing results show, there is a little performance improvement:

	OK, can you send v2 after removing the LIST_HEAD(list) from
both patches, I guess, it is not needed. If you prefer, you can
include these benchmark results too.

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
> 
> > 
> >> +		ipvs = net_ipvs(net);
> >> +		ip_vs_conn_net_cleanup(ipvs);
> >> +		ip_vs_app_net_cleanup(ipvs);
> >> +		ip_vs_protocol_net_cleanup(ipvs);
> >> +		ip_vs_control_net_cleanup(ipvs);
> >> +		ip_vs_estimator_net_cleanup(ipvs);
> >> +		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
> >> +		net->ipvs = NULL;

Regards

--
Julian Anastasov <ja@ssi.bg>
