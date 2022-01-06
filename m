Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113984860D8
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 08:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiAFHFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 02:05:32 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43881 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234429AbiAFHFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 02:05:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V15.y8s_1641452728;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V15.y8s_1641452728)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jan 2022 15:05:29 +0800
Date:   Thu, 6 Jan 2022 15:05:28 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, dust.li@linux.alibaba.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
 <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 08:13:23PM +0100, Karsten Graul wrote:
> On 05/01/2022 16:06, D. Wythe wrote:
> > LGTM. Fallback makes the restrictions on SMC dangling
> > connections more meaningful to me, compared to dropping them.
> > 
> > Overall, i see there are two scenario.
> > 
> > 1. Drop the overflow connections limited by userspace application
> > accept.
> > 
> > 2. Fallback the overflow connections limited by the heavy process of
> > current SMC handshake. ( We can also control its behavior through
> > sysctl.)
> > 
> 
> I vote for (2) which makes the behavior from user space applications point of view more like TCP.

Fallback when smc reaches itself limit is a good idea. I'm curious
whether the fallback reason is suitable, it more like a non-negative
issue. Currently, smc fallback for negative issues, such as resource not
available or internal error. This issue doesn't like a non-negative
reason.

And I have no idea about to mix the normal and fallback connections at
same time, meanwhile there is no error happened or hard limit reaches,
is a easy to maintain for users? Maybe let users misunderstanding, a
parameter from userspace control this limit, and the behaviour (drop or
fallback).
 
> One comment to sysctl: our current approach is to add new switches to the existing 
> netlink interface which can be used with the smc-tools package (or own implementations of course). 
> Is this prereq problematic in your environment? 
> We tried to avoid more sysctls and the netlink interface keeps use more flexible.

I agree with you about using netlink is more flexible. There are
something different in our environment to use netlink to control the
behaves of smc.

Compared with netlink, sysctl is:
- easy to use on clusters. Applications who want to use smc, don't need
  to deploy additional tools or developing another netlink logic,
  especially for thousands of machines or containers. With smc forward,
  we should make sure the package or logic is compatible with current
  kernel, but sysctl's API compatible is easy to discover.

- config template and default maintain. We are using /etc/sysctl.conf to
  make sure the systeml configures update to date, such as pre-tuned smc
  config parameters. So that we can change this default values on boot,
  and generate lots of machines base on this machine template. Userspace
  netlink tools doesn't suit for it, for example ip related config, we
  need additional NetworkManager or netctl to do this.

- TCP-like sysctl entries. TCP provides lots of sysctl to configure
  itself, somethings it is hard to use and understand. However, it is
  accepted by most of users and system. Maybe we could use sysctl for
  the item that frequently and easy to change, netlink for the complex
  item.

We are gold to contribute to smc-tools. Use netlink and sysctl both
time, I think, is a more suitable choice.

Thanks,
Tony Lu
