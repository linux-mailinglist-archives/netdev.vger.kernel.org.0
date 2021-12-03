Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DEF4670DD
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354586AbhLCDvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:51:03 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:24409 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348654AbhLCDvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:51:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UzEvBPB_1638503246;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UzEvBPB_1638503246)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Dec 2021 11:47:27 +0800
Date:   Fri, 3 Dec 2021 11:47:22 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Clear memory when release and reuse buffer
Message-ID: <YamTSiiDp2mpeaXc@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211125122858.90726-1-tonylu@linux.alibaba.com>
 <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 11:28:55AM -0800, Jakub Kicinski wrote:
> On Thu, 25 Nov 2021 20:28:59 +0800 Tony Lu wrote:
> > Currently, buffers are clear when smc create connections and reuse
> > buffer. It will slow down the speed of establishing new connection. In
> > most cases, the applications hope to establish connections as quickly as
> > possible.
> > 
> > This patch moves memset() from connection creation path to release and
> > buffer unuse path, this trades off between speed of establishing and
> > release.
> > 
> > Test environments:
> > - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4
> > - socket sndbuf / rcvbuf: 16384 / 131072 bytes
> > - w/o first round, 5 rounds, avg, 100 conns batch per round
> > - smc_buf_create() use bpftrace kprobe, introduces extra latency
> > 
> > Latency benchmarks for smc_buf_create():
> >   w/o patch : 19040.0 ns
> >   w/  patch :  1932.6 ns
> >   ratio :        10.2% (-89.8%)
> > 
> > Latency benchmarks for socket create and connect:
> >   w/o patch :   143.3 us
> >   w/  patch :   102.2 us
> >   ratio :        71.3% (-28.7%)
> > 
> > The latency of establishing connections is reduced by 28.7%.
> > 
> > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> 
> The tag in the subject seems incorrect, we tag things as [PATCH net] 
> if they are fixes, and as [PATCH net-next] if they are new features,
> code refactoring or performance improvements.
> 
> Is this a fix for a regression? In which case we need a Fixes tag to
> indicate where it was introduced. Otherwise it needs to be tagged as
> [PATCH net-next].
> 
> I'm assuming Karsten will take it via his tree, otherwise you'll need
> to repost.

Sorry to miss Graul¡¯s email, he said he would put it in his own tree. I
would send v2 out if he needed. Thank you.

Thanks,
Tony Lu
