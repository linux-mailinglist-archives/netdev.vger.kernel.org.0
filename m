Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC8445B910
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbhKXLaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:30:01 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52498 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240520AbhKXLaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:30:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uy7WWG6_1637753209;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uy7WWG6_1637753209)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 19:26:49 +0800
Date:   Wed, 24 Nov 2021 19:26:48 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH RFC net] net/smc: Ensure the active closing peer first
 closes clcsock
Message-ID: <YZ4heNX49qcOUnFS@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211116033011.16658-1-tonylu@linux.alibaba.com>
 <d83109fe-ae25-def0-b28e-f8695d4535c7@linux.ibm.com>
 <YZ3+ihxIU5l8mvWY@TonyMac-Alibaba>
 <1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f67548e-cbf6-0dce-82b5-10288a4583bd@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 11:08:23AM +0100, Karsten Graul wrote:
> On 24/11/2021 09:57, Tony Lu wrote:
> > IMHO, given that, it is better to not ignore smc_close_final(), and move 
> > kernel_sock_shutdown() to __smc_release(), because smc_shutdown() also
> > calls kernel_sock_shutdown() after smc_close_active() and
> > smc_close_shutdown_write(), then enters SMC_PEERCLOSEWAIT1. It's no need
> > to call it twice with SHUT_WR and SHUT_RDWR. 
> 
> Since the idea is to shutdown the socket before the remote peer shutdowns it
> first, are you sure that this shutdown in smc_release() is not too late?

Hi Graul,

Yes, I have tested this idea, it will be too late sometime. I won't fix
this issue.

> Is it sure that smc_release() is called in time for this processing?
> 
> Maybe its better to keep the shutdown in smc_close_active() and to use an rc1
> just like shown in your proposal, and return either the rc of smc_close_final() 
> or the rc of kernel_sock_shutdown().

Yep, I am testing this approach in my environment. I am going to keep
these return codes and return the available one.

> I see the possibility of calling shutdown twice for the clcsocket, but does it
> harm enough to give a reason to check it before in smc_shutdown()? I expect TCP
> to handle this already.

TCP could handle this already, but it doesn't make much sense to call it twice. When
call smc_shutdown(), we can check sk_shutdown before call kernel_sock_shutdown(),
so that it can slightly speed up the release process.

I will send this soon, thanks for your advice.

Tony Lu
