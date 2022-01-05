Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF7448556C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiAEPG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:06:28 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:52896 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241261AbiAEPGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:06:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V11NqwO_1641395172;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V11NqwO_1641395172)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 23:06:13 +0800
Date:   Wed, 5 Jan 2022 23:06:12 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     dust.li@linux.alibaba.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <20220105150612.GA75522@e02h04389.eu6sqa>
Reply-To: "D. Wythe" <alibuda@linux.alibaba.com>
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM. Fallback makes the restrictions on SMC dangling
connections more meaningful to me, compared to dropping them.

Overall, i see there are two scenario.

1. Drop the overflow connections limited by userspace application
accept.

2. Fallback the overflow connections limited by the heavy process of
current SMC handshake. ( We can also control its behavior through
sysctl.)

I'll follow those advise to improve my patch, more advise will be highly
appreciated.

Thanks all. 


On Wed, Jan 05, 2022 at 02:17:41PM +0100, Karsten Graul wrote:
> On 05/01/2022 09:57, dust.li wrote:
> > On Wed, Jan 05, 2022 at 12:40:49PM +0800, D. Wythe wrote:
> > I'm thinking maybe we can actively fall back to TCP in this case ? Not
> > sure if this is a good idea.
> 
> I think its a good decision to switch new connections to use the TCP fallback when the
> current queue of connections waiting for a SMC handshake is too large.
> With this the application is able to accept all incoming connections and they are not
> dropped. The only thing that is be different compared to TCP is that the order of the
> accepted connections is changed, connections that came in later might reach the user space 
> application earlier than connections that still run the SMC hand shake processing. 
> But I think that is semantically okay.
