Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDFE1AD7E8
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgDQHrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:47:52 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33596 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgDQHrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 03:47:51 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 03H7lYlV005268;
        Fri, 17 Apr 2020 10:47:34 +0300
Date:   Fri, 17 Apr 2020 10:47:34 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     yunhong-cgl jiang <xintian1976@gmail.com>
cc:     horms@verge.net.au, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, Yunhong Jiang <yunhjiang@ebay.com>
Subject: Re: Long delay on estimation_timer causes packet latency
In-Reply-To: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
Message-ID: <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg>
References: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 16 Apr 2020, yunhong-cgl jiang wrote:

> Hi, Simon & Julian,
> 	We noticed that on our kubernetes node utilizing IPVS, the estimation_timer() takes very long (>200sm as shown below). Such long delay on timer softirq causes long packet latency.  
> 
>           <idle>-0     [007] dNH. 25652945.670814: softirq_raise: vec=1 [action=TIMER]
> .....
>           <idle>-0     [007] .Ns. 25652945.992273: softirq_exit: vec=1 [action=TIMER]
> 
> 	The long latency is caused by the big service number (>50k) and large CPU number (>80 CPUs),
> 
> 	We tried to move the timer function into a kernel thread so that it will not block the system and seems solves our problem. Is this the right direction? If yes, we will do more testing and send out the RFC patch. If not, can you give us some suggestion?

	Using kernel thread is a good idea. For this to work, we can
also remove the est_lock and to use RCU for est_list.
The writers ip_vs_start_estimator() and ip_vs_stop_estimator() already
run under common mutex __ip_vs_mutex, so they not need any
synchronization. We need _bh lock usage in estimation_timer().
Let me know if you need any help with the patch.

Regards

--
Julian Anastasov <ja@ssi.bg>
