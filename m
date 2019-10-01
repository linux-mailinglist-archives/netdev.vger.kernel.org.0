Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22986C30B1
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfJAJyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:54:20 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34398 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfJAJyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:54:20 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 665AB25BDFF;
        Tue,  1 Oct 2019 19:54:17 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 5EC7094046A; Tue,  1 Oct 2019 11:54:15 +0200 (CEST)
Date:   Tue, 1 Oct 2019 11:54:15 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ipvs: speedup ipvs netns dismantle
Message-ID: <20191001095415.fari4ntiszkbkgxr@verge.net.au>
References: <1569560091-20553-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <alpine.LFD.2.21.1909302205360.2706@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1909302205360.2706@ja.home.ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 10:08:23PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Fri, 27 Sep 2019, Haishuang Yan wrote:
> 
> > Implement exit_batch() method to dismantle more ipvs netns
> > per round.
> > 
> > Tested:
> > $  cat add_del_unshare.sh
> > #!/bin/bash
> > 
> > for i in `seq 1 100`
> >     do
> >      (for j in `seq 1 40` ; do  unshare -n ipvsadm -A -t 172.16.$i.$j:80 >/dev/null ; done) &
> >     done
> > wait; grep net_namespace /proc/slabinfo
> > 
> > Befor patch:
> > $  time sh add_del_unshare.sh
> > net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0
> > 
> > real    0m8.086s
> > user    0m2.025s
> > sys     0m36.956s
> > 
> > After patch:
> > $  time sh add_del_unshare.sh
> > net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0
> > 
> > real    0m7.623s
> > user    0m2.003s
> > sys     0m32.935s
> > 
> > Haishuang Yan (2):
> >   ipvs: batch __ip_vs_cleanup
> >   ipvs: batch __ip_vs_dev_cleanup
> > 
> >  include/net/ip_vs.h             |  2 +-
> >  net/netfilter/ipvs/ip_vs_core.c | 47 ++++++++++++++++++++++++-----------------
> >  net/netfilter/ipvs/ip_vs_ctl.c  | 12 ++++++++---
> >  3 files changed, 38 insertions(+), 23 deletions(-)
> 
> 	Both patches in v2 look good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> 	This is for the -next kernels...

Thanks, applied to ipvs-next.
