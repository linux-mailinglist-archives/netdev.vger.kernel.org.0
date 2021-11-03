Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ED4443D72
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 07:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhKCG7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 02:59:47 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56286 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhKCG7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 02:59:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UurSxW9_1635922627;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UurSxW9_1635922627)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Nov 2021 14:57:08 +0800
Date:   Wed, 3 Nov 2021 14:57:07 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net/smc: Introduce tracepoint for smcr link
 down
Message-ID: <YYIywxTUwl2xp4+/@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211101073912.60410-1-tonylu@linux.alibaba.com>
 <20211101073912.60410-4-tonylu@linux.alibaba.com>
 <11f17a34-fd35-f2ec-3f20-dd0c34e55fde@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f17a34-fd35-f2ec-3f20-dd0c34e55fde@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 10:30:22AM +0100, Karsten Graul wrote:
> On 01/11/2021 08:39, Tony Lu wrote:
> > +
> > +	    TP_printk("lnk=%p lgr=%p state=%d dev=%s location=%p",
> > +		      __entry->lnk, __entry->lgr,
> > +		      __entry->state, __get_str(name),
> > +		      __entry->location)
> 
> The location is printed as pointer (which might even be randomized?),
> is it possible to print the function name of the caller, as described
> here: https://stackoverflow.com/questions/4141324/function-caller-in-linux-kernel
> 
>   printk("Caller is %pS\n", __builtin_return_address(0));
> 
> Not sure if this is possible with the trace points, but it would be
> easier to use. You plan to use a dump to find out about the function caller?

Yes, I am going to find out where caused the SMC-R link down. In our
test environment, the tracepoint for link down help me to debug the root
cause of link termination, without eBPF or systemtap.

By using "%pS", it makes the trace log easy to show the function caller
name without additional translating.

  <idle>-0       [000] ..s.    69.087164: smcr_link_down: lnk=00000000dab41cdc lgr=000000007d5d8e24 state=0 rc=1 dev=mlx5_0 location=smc_wr_tx_tasklet_fn+0x5ef/0x6f0 [smc]

I will improve it in the next patch.

Cheers,
Tony Lu
