Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA70333BE9
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhCJMBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:01:37 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:38566 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231867AbhCJMBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:01:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0URJJq9b_1615377675;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URJJq9b_1615377675)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 20:01:15 +0800
Date:   Wed, 10 Mar 2021 20:01:15 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, rostedt@goodmis.org,
        mingo@redhat.com, Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <YEi1C5XXNYWW/ZWn@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <203c49a3-6dd8-105e-e12a-0e15da0d4df7@gmail.com>
 <CACAyw9-tacJC-5Cimars4Ncu0PzZ6gg-qfj7g_yz_UgX5h6H-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-tacJC-5Cimars4Ncu0PzZ6gg-qfj7g_yz_UgX5h6H-Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 09:22:34AM +0000, Lorenz Bauer wrote:
> On Tue, 9 Mar 2021 at 20:12, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > On 3/9/21 5:43 AM, Tony Lu wrote:
> > > There are lots of net namespaces on the host runs containers like k8s.
> > > It is very common to see the same interface names among different net
> > > namespaces, such as eth0. It is not possible to distinguish them without
> > > net namespace inode.
> > >
> > > This adds net namespace inode for all net_dev events, help us
> > > distinguish between different net devices.
> > >
> > > Output:
> > >   <idle>-0       [006] ..s.   133.306989: net_dev_xmit: net_inum=4026531992 dev=eth0 skbaddr=0000000011a87c68 len=54 rc=0
> > >
> > > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> > > ---
> > >
> >
> > There was a proposal from Lorenz to use netns cookies (SO_NETNS_COOKIE) instead.
> >
> > They have a guarantee of being not reused.
> >
> > After 3d368ab87cf6681f9 ("net: initialize net->net_cookie at netns setup")
> > net->net_cookie is directly available.
> 
> The patch set is at
> https://lore.kernel.org/bpf/20210219154330.93615-1-lmb@cloudflare.com/
> but I decided to abandon it. I can work around my issue by comparing
> the netns inode of two processes, which is "good enough" for now.

Without the patch set, it is impossible to get net_cookie from
userspace, except bpf prog. AFAIK, netns inode has been widely used to
distinguish different netns, it is easy to use for docker
(/proc/${container_pid}/ns/net). It would be better to provide a unified
approach to do so.


Cheers,
Tony Lu

> 
> -- 
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> 
> www.cloudflare.com
