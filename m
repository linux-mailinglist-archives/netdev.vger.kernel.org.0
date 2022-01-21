Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB6049588D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiAUDYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:24:36 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:39232 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230304AbiAUDYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:24:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V2OrEC9_1642735473;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2OrEC9_1642735473)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 Jan 2022 11:24:33 +0800
Date:   Fri, 21 Jan 2022 11:24:32 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Use kvzalloc for allocating
 smc_link_group
Message-ID: <YeoncJZoa3ELWyxM@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220120140928.7137-1-tonylu@linux.alibaba.com>
 <4c600724-3306-0f0e-36dc-52f4f23825bc@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c600724-3306-0f0e-36dc-52f4f23825bc@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 03:50:26PM +0100, Karsten Graul wrote:
> On 20/01/2022 15:09, Tony Lu wrote:
> > When analyzed memory usage of SMC, we found that the size of struct
> > smc_link_group is 16048 bytes, which is too big for a busy machine to
> > allocate contiguous memory. Using kvzalloc instead that falls back to
> > vmalloc if there has not enough contiguous memory.
> 
> I am wondering where the needed contiguous memory for the required RMB buffers should come from when 
> you don't even get enough storage for the initial link group?

Yes, this is what I want to talking about. The RMB buffers size inherits
from TCP, we cannot assume that RMB is always larger than 16k bytes, the
tcp_mem can be changed on the fly, and it can be tuned to very small for
saving memory. Also, If we freed existed link group or somewhere else,
we can allocate enough contiguous memory for the new link group.

> The idea is that when the system is so low on contiguous memory then a link group creation should fail 
> early, because most of the later buffer allocations will also fail then later.

IMHO, it is not a "pre-checker" for allocating buffer, it is a reminder
for us to save contiguous memory, this is a precious resource, and a
possible way to do this. This patch is not the best approach to solve
this problem, but the simplest one. A possible approach to allocate
link array in link group with a pointer to another memory. Glad to hear
your advice.

Thanks,
Tony Lu
