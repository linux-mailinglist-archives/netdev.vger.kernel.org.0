Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DF32CEF25
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgLDOA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 09:00:26 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56580 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgLDOA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 09:00:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UHW1wWO_1607090342;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UHW1wWO_1607090342)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Dec 2020 21:59:02 +0800
Date:   Fri, 4 Dec 2020 21:59:02 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     yunhong-cgl jiang <xintian1976@gmail.com>, horms@verge.net.au,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        Yunhong Jiang <yunhjiang@ebay.com>
Subject: Re: Long delay on estimation_timer causes packet latency
Message-ID: <20201204135902.GA14129@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com>
 <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg>
 <F48099A3-ECB3-46AF-8330-B829ED2ADA3F@gmail.com>
 <d89672f8-a028-8690-0e6a-517631134ef6@linux.alibaba.com>
 <2cf7e20-89c0-2a40-d27e-3d663e7080cb@ssi.bg>
 <81aff736-70f0-9e14-de24-ba943f244bd2@linux.alibaba.com>
 <47e05b8-a4fc-24a1-e796-2a44cf7bbd77@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47e05b8-a4fc-24a1-e796-2a44cf7bbd77@ssi.bg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 07:42:56AM +0200, Julian Anastasov wrote:
>
>	Hello,
>
>On Fri, 4 Dec 2020, dust.li wrote:
>
>> 
>> On 12/3/20 4:48 PM, Julian Anastasov wrote:
>> >
>> > - work will use spin_lock_bh(&s->lock) to protect the
>> > entries, we do not want delays between /proc readers and
>> > the work if using mutex. But _bh locks stop timers and
>> > networking for short time :( Not sure yet if just spin_lock
>> > is safe for both /proc and estimator's work.
>
>	Here stopping BH is may be not so fatal if some
>CPUs are used for networking and others for workqueues.
>
>> Thanks for sharing your thoughts !
>> 
>> 
>> I think it's a good idea to split the est_list into different
>> 
>> slots, I believe it will dramatically reduce the delay brought
>> 
>> by estimation.
>
>	268ms/64 => 4ms average. As the estimation with single
>work does not utilize many CPUs simultaneously, this can be a
>problem for 300000-400000 services but this looks crazy.
Yes. Consider the largest server we use now, which has 256 HT
servers with 4 NUMA nodes. Even that should not be a big problem.

>
>> My only concern is the cost of the estimation when the number of
>> 
>> services is large. Splitting the est_list won't reduce the real
>> 
>> work to do.
>> 
>> In our case, each estimation cost at most 268ms/2000ms, which is
>> 
>> about 13% of one CPU hyper-thread, and this should be a common case
>> 
>> in a large K8S cluster with lots of services.
>> 
>> Since the estimation is not needed in our environment at all, it's
>> 
>> just a waste of CPU resource. Have you ever consider add a switch to
>> 
>> let the user turn the estimator off ?
>
>	No problem to add sysctl var for this, we usually add function
>to check which can be used in ip_vs_in_stats, ip_vs_out_stats,
>ip_vs_conn_stats. If switch can be changed at any time, what should
>we do? Add/Del est entries as normally but do not start the
>delayed work if flag disables stats. When flag is enabled counters
>will increase and we will start delayed work.

Yes, this would be perfect for me !
