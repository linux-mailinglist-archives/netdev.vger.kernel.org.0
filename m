Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2554A4845DD
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiADQRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:17:30 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:41964 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbiADQR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:17:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V0yrv7C_1641313047;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V0yrv7C_1641313047)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 00:17:27 +0800
Date:   Wed, 5 Jan 2022 00:17:27 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <20220104161727.GA123107@e02h04389.eu6sqa>
Reply-To: "D. Wythe" <alibuda@linux.alibaba.com>
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


It's seems last mail has been rejected by some reason, resend it for
confirm. sry to bother you if you already seen it.

Thanks.

-- 

Got your point, it's quite a problem within this patch. 
As you noted, may be we can use the backlog parameter of the listen socket
to limit the dangling connections,  just like tcp does.   

I'll work on it in the next few days. Please let me know if you have more suggestions for it.
 
Thanks.


On Tue, Jan 04, 2022 at 02:45:35PM +0100, Karsten Graul wrote:
> On 04/01/2022 14:12, D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > In nginx/wrk multithread and 10K connections benchmark, the
> > backend TCP connection established very slowly, and lots of TCP
> > connections stay in SYN_SENT state.
> 
> I see what you are trying to solve here.
> So what happens with your patch now is that we are accepting way more connections
> in advance and queue them up for the SMC connection handshake worker.
> The connection handshake worker itself will not run faster with this change, so overall
> it should be the same time that is needed to establish all connections.
> What you solve is that when 10k connections are started at the same time, some of them
> will be dropped due to tcp 3-way handshake timeouts. Your patch avoids that but one can now flood
> the stack with an ~infinite amount of dangling sockets waiting for the SMC handshake, maybe even 
> causing oom conditions.
> 
> What should be respected with such a change would be the backlog parameter for the listen socket,
> i.e. how many backlog connections are requested by the user space application?
> There is no such handling of backlog right now, and due to the 'braking' workers we avoided
> to flood the kernel with too many dangling connections. With your change there should be a way to limit
> this ind of connections in some way.
