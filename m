Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E95F2CE797
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgLDFns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:43:48 -0500
Received: from mg.ssi.bg ([178.16.128.9]:51322 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLDFns (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 00:43:48 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 4DBA32CFC1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:43:06 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id A01142CFB8
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:43:05 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id C41633C09BA;
        Fri,  4 Dec 2020 07:43:01 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 0B45gvsL004018;
        Fri, 4 Dec 2020 07:43:01 +0200
Date:   Fri, 4 Dec 2020 07:42:56 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     "dust.li" <dust.li@linux.alibaba.com>
cc:     yunhong-cgl jiang <xintian1976@gmail.com>, horms@verge.net.au,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        Yunhong Jiang <yunhjiang@ebay.com>
Subject: Re: Long delay on estimation_timer causes packet latency
In-Reply-To: <81aff736-70f0-9e14-de24-ba943f244bd2@linux.alibaba.com>
Message-ID: <47e05b8-a4fc-24a1-e796-2a44cf7bbd77@ssi.bg>
References: <D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com> <alpine.LFD.2.21.2004171029240.3962@ja.home.ssi.bg> <F48099A3-ECB3-46AF-8330-B829ED2ADA3F@gmail.com> <d89672f8-a028-8690-0e6a-517631134ef6@linux.alibaba.com> <2cf7e20-89c0-2a40-d27e-3d663e7080cb@ssi.bg>
 <81aff736-70f0-9e14-de24-ba943f244bd2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 4 Dec 2020, dust.li wrote:

> 
> On 12/3/20 4:48 PM, Julian Anastasov wrote:
> >
> > - work will use spin_lock_bh(&s->lock) to protect the
> > entries, we do not want delays between /proc readers and
> > the work if using mutex. But _bh locks stop timers and
> > networking for short time :( Not sure yet if just spin_lock
> > is safe for both /proc and estimator's work.

	Here stopping BH is may be not so fatal if some
CPUs are used for networking and others for workqueues.

> Thanks for sharing your thoughts !
> 
> 
> I think it's a good idea to split the est_list into different
> 
> slots, I believe it will dramatically reduce the delay brought
> 
> by estimation.

	268ms/64 => 4ms average. As the estimation with single
work does not utilize many CPUs simultaneously, this can be a
problem for 300000-400000 services but this looks crazy.

> My only concern is the cost of the estimation when the number of
> 
> services is large. Splitting the est_list won't reduce the real
> 
> work to do.
> 
> In our case, each estimation cost at most 268ms/2000ms, which is
> 
> about 13% of one CPU hyper-thread, and this should be a common case
> 
> in a large K8S cluster with lots of services.
> 
> Since the estimation is not needed in our environment at all, it's
> 
> just a waste of CPU resource. Have you ever consider add a switch to
> 
> let the user turn the estimator off ?

	No problem to add sysctl var for this, we usually add function
to check which can be used in ip_vs_in_stats, ip_vs_out_stats,
ip_vs_conn_stats. If switch can be changed at any time, what should
we do? Add/Del est entries as normally but do not start the
delayed work if flag disables stats. When flag is enabled counters
will increase and we will start delayed work.

Regards

--
Julian Anastasov <ja@ssi.bg>

