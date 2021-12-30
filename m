Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B748148192A
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 05:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhL3EAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 23:00:25 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:44413 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229558AbhL3EAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 23:00:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0Ii-rQ_1640836822;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V0Ii-rQ_1640836822)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 30 Dec 2021 12:00:23 +0800
Date:   Thu, 30 Dec 2021 12:00:22 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tonylu@linux.alibaba.com
Subject: Re: [RFC PATCH net v2 2/2] net/smc: Resolve the race between SMC-R
 link access and clear
Message-ID: <20211230040022.GC55356@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-3-git-send-email-guwen@linux.alibaba.com>
 <7311029c-2c56-d9c7-9ed5-87bc6a36511f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7311029c-2c56-d9c7-9ed5-87bc6a36511f@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 01:51:27PM +0100, Karsten Graul wrote:
>On 28/12/2021 16:13, Wen Gu wrote:
>> We encountered some crashes caused by the race between SMC-R
>> link access and link clear triggered by link group termination
>> in abnormal case, like port error.
>
>Without to dig deeper into this, there is already a refcount for links, see smc_wr_tx_link_hold().
>In smc_wr_free_link() there are waits for the refcounts to become zero.
>
>Why do you need to introduce another refcounting instead of using the existing?
>And if you have a good reason, do we still need the existing refcounting with your new
>implementation?
>
>Maybe its enough to use the existing refcounting in the other functions like smc_llc_flow_initiate()?
>
>Btw: it is interesting what kind of crashes you see, we never met them in our setup.

We are trying to using SMC + RDMA to boost application performance,
we now have a product in the cloud called ERDMA which can be used
in the virtual machine.

We are testing SMC with link down/up with short flow cases since
in the cloud environment the RDMA device may be plugged in/out
frequently, and there are many different applications, some of them
may have pretty much short flows.

>Its great to see you evaluating SMC in a cloud environment!

Thanks! We are trying to use SMC to boost performance for cloud
applications, and we hope SMC can be more generic and widely used.

