Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9359F8B01
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 09:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfKLIrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 03:47:19 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57005 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbfKLIrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 03:47:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ThsxEsr_1573548435;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThsxEsr_1573548435)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Nov 2019 16:47:15 +0800
Date:   Tue, 12 Nov 2019 16:47:14 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>, shemminger@osdl.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: remove static inline from dev_put/dev_hold
Message-ID: <20191112084714.GC67139@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20191111140502.17541-1-tonylu@linux.alibaba.com>
 <CAM_iQpUaPsFHrDmd7fLjWZLbbo8j1uD6opuT+zKqPTVuQPKniA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUaPsFHrDmd7fLjWZLbbo8j1uD6opuT+zKqPTVuQPKniA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 01:26:13PM -0800, Cong Wang wrote:
> On Mon, Nov 11, 2019 at 6:12 AM Tony Lu <tonylu@linux.alibaba.com> wrote:
> >
> > This patch removes static inline from dev_put/dev_hold in order to help
> > trace the pcpu_refcnt leak of net_device.
> >
> > We have sufferred this kind of issue for several times during
> > manipulating NIC between different net namespaces. It prints this
> > log in dmesg:
> >
> >   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> 
> I debugged a nasty dst refcnt leak in TCP a long time ago, so I can
> feel your pain.
> 
> 
> >
> > However, it is hard to find out who called and leaked refcnt in time. It
> > only left the crime scene but few evidence. Once leaked, it is not
> > safe to fix it up on the running host. We can't trace dev_put/dev_hold
> > directly, for the functions are inlined and used wildly amoung modules.
> > And this issue is common, there are tens of patches fix net_device
> > refcnt leak for various causes.
> >
> > To trace the refcnt manipulating, this patch removes static inline from
> > dev_put/dev_hold. We can use handy tools, such as eBPF with kprobe, to
> > find out who holds but forgets to put refcnt. This will not be called
> > frequently, so the overhead is limited.
> 
> I think tracepoint serves the purpose of tracking function call history,
> you can add tracepoint for each of dev_put()/dev_hold(), which could
> also inherit the trace filter and trigger too.

Thanks for your advice. I already made a patch set to add a pair of
tracepoints to trace dev_hold()/dev_put() as an available solution. I
used to want to give a flexible approach for people who want to choose.
I will send it out later.

> 
> The netdev refcnt itself is not changed very frequently, but it is
> refcnt'ed by other things like dst too which is changed frequently.
> This is why usually when you see the netdev refcnt leak warning,
> the problem is probably somewhere else, like dst refcnt leak.

We also suffered dst refcnt leak issue before. It is really hard to
investigate. I will think about this place well.

> 
> Hope this helps.
> 
> Thanks.


Thanks.
Tony Lu
