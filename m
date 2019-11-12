Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA78F8C2A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKLJsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:48:13 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58690 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbfKLJsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 04:48:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ThtTQAE_1573552089;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0ThtTQAE_1573552089)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Nov 2019 17:48:10 +0800
Date:   Tue, 12 Nov 2019 17:48:09 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, shemminger@osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove static inline from dev_put/dev_hold
Message-ID: <20191112094809.GA981@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20191111140502.17541-1-tonylu@linux.alibaba.com>
 <c6230ad9-e859-4bee-dacb-4d7910a3f120@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6230ad9-e859-4bee-dacb-4d7910a3f120@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 09:21:58AM -0800, Eric Dumazet wrote:
> 
> 
> On 11/11/19 6:05 AM, Tony Lu wrote:
> > This patch removes static inline from dev_put/dev_hold in order to help
> > trace the pcpu_refcnt leak of net_device.
> > 
> > We have sufferred this kind of issue for several times during
> > manipulating NIC between different net namespaces. It prints this
> > log in dmesg:
> > 
> >   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
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
> >
> 
> This looks as a first step.

Yes, I used to want to give a flexible approach for people, and they
could choose tools what they want. And I already made a patch, putting a
pair tracepoints into dev_put()/dev_hold() to trace that. I will send it out
later.

> 
> But I would rather get a full set of scripts/debugging features,
> instead of something that most people can not use right now.
> 
> Please share the whole thing.

Thanks.
Tony Lu
