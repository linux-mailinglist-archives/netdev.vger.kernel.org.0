Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4BE1B593C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 12:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgDWKdN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Apr 2020 06:33:13 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:46216 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbgDWKdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 06:33:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TwQbxH7_1587637980;
Received: from 30.225.76.131(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TwQbxH7_1587637980)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 18:33:01 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net-next] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
From:   Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <beaecc68abcc4b268d68ce558fc5766e@AcuMS.aculab.com>
Date:   Thu, 23 Apr 2020 18:33:00 +0800
Cc:     netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9B9D6296-2A39-4096-9C91-ED5012BE43D8@linux.alibaba.com>
References: <20200421121737.3269-1-cambda@linux.alibaba.com>
 <beaecc68abcc4b268d68ce558fc5766e@AcuMS.aculab.com>
To:     David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 23, 2020, at 16:52, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Cambda Zhu
>> Sent: 21 April 2020 13:18
>> 
>> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
>> option has same behavior as TCP_LINGER2, except the tp->linger2 value
>> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
>> with CAP_NET_ADMIN.
> 
> Did you consider adding an extra sysctl so that the limit
> for TCP_LINGER2 could be greater than the default?
> 
> It might even be sensible to set the limit to a few times
> the default.
> 
> All users can set the socket buffer sizes to twice the default.
> Being able to do the same for the linger timeout wouldn't be a problem.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

The default tcp_fin_timeout is 60s which may be too long for a server with
tens of thousands connections or qps. To reduce the connections as many as
possible, the system administer may set the sysctl_tcp_fin_timeout and most
of the connections would use the default timeout. The timeout may be very
sensitive. For example if sysctl_tcp_fin_timeout is 10s, 20s may cause double
the FIN-WAIT connections and server load needs to be reevaluated.

Besides from my experience a longer FIN-WAIT timeout will have a better
experience for clients, because there’re some clients, such as video player,
needing to finish the play before closing the connection. If we add a sysctl
with default/max timeout for all users, all connections should be set to the
max timeout except some special requirements which can also be set with
TCP_LINGER2 to use a smaller one.

Maybe my experience is not correct for your scenes, so could you describe
a situation that the timeout with default/max value is better?

Regards,
Cambda
