Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86003177FEA
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbgCCRxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:53:38 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:65153 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731683AbgCCRxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583258017; x=1614794017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=34azqmFeRaFzM4vO53SvciGSZLKjRCjz923ORM9sBr4=;
  b=k9L5i4hOoGGofPts5jgFxXq95UDVig3VEouR8ta413nM0WKQuoT43LdP
   R0uVVIeUE004nywK8LIjcQqqm/ta8JWMCD643poeXiobOYznoxYt3dYtt
   loOOqcxnhc+9HlTCPcvBptnjEVhiQOBIDHWg/oxXkAywYVBj6eDxb2dyh
   o=;
IronPort-SDR: j+T/5jka0KWLwSKijd2DYIDqBjMHVH2vWoW4leXQDE1Kp4yfmScGdl89lzyO1AjKPbca5+E6eP
 /faX/djAPGXA==
X-IronPort-AV: E=Sophos;i="5.70,511,1574121600"; 
   d="scan'208";a="30307745"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 Mar 2020 17:53:36 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id D46C1A274A;
        Tue,  3 Mar 2020 17:53:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 3 Mar 2020 17:53:34 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.8) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 3 Mar 2020 17:53:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Wed, 4 Mar 2020 02:53:25 +0900
Message-ID: <20200303175325.36937-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <74eacd0e-5519-3e39-50f3-1add05983ba3@gmail.com>
References: <74eacd0e-5519-3e39-50f3-1add05983ba3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D03UWC004.ant.amazon.com (10.43.162.49) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Sun, 1 Mar 2020 20:49:49 -0800
> On 3/1/20 8:31 PM, Kuniyuki Iwashima wrote:
>> From:   Eric Dumazet <eric.dumazet@gmail.com>
>> Date:   Sun, 1 Mar 2020 19:42:25 -0800
>>> On 2/29/20 3:35 AM, Kuniyuki Iwashima wrote:
>>>> Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
>>>> condition for bind_conflict") introduced a restriction to forbid to bind
>>>> SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
>>>> assign ports dispersedly so that we can connect to the same remote host.
>>>>
>>>> The change results in accelerating port depletion so that we fail to bind
>>>> sockets to the same local port even if we want to connect to the different
>>>> remote hosts.
>>>>
>>>> You can reproduce this issue by following instructions below.
>>>>   1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
>>>>   2. set SO_REUSEADDR to two sockets.
>>>>   3. bind two sockets to (address, 0) and the latter fails.
>>>>
>>>> Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
>>>> fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
>>>> it possible to connect to different remote (addr, port) tuples.
>>>>
>>>> This patch allows us to bind SO_REUSEADDR enabled sockets to the same
>>>> (addr, port) only when all ephemeral ports are exhausted.
>>>>
>>>> The only notable thing is that if all sockets bound to the same port have
>>>> both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
>>>> ephemeral port and also do listen().
>>>>
>>>> Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
>>>>
>>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>>
>>> I am unsure about this, since this could double the time taken by this
>>> function, which is already very time consuming.
>> 
>> This patch doubles the time on choosing a port only when all ephemeral ports
>> are exhausted, and this fallback behaviour can eventually decreases the time
>> on waiting for ports to be released. We cannot know when the ports are
>> released, so we may not be able to reuse ports without this patch. This
>> patch gives more chace and raises the probability to succeed to bind().
>> 
>>> We added years ago IP_BIND_ADDRESS_NO_PORT socket option, so that the kernel
>>> has more choices at connect() time (instead of bind()) time to choose a source port.
>>>
>>> This considerably lowers time taken to find an optimal source port, since
>>> the kernel has full information (source address, destination address & port)
>> 
>> I also think this option is usefull, but it does not allow us to reuse
>> ports that is reserved by bind(). This is because connect() can reuse ports
>> only when their tb->fastresue and tb->fastreuseport is -1. So we still
>> cannot fully utilize 4-tuples.
> 
> The thing is : We do not want to allow active connections to use a source port
> that is used for passive connections.

When calling bind(addr, 0) without these patches, this problem does not
occur. Certainly these patches could make it possible to do bind(addr, 0)
and listen() on the port which is already reserved by connect(). However,
whether these patches are applied or not, this problem can be occurred by
calling bind with specifying the port.


> Many supervisions use dump commands like "ss -t src :40000" to list all connections
> for a 'server' listening on port 40000,
> or use ethtool to direct all traffic for this port on a particular RSS queue.
> 
> Some firewall setups also would need to be changed, since suddenly the port could
> be used by unrelated applications.

I think these are on promise that the server application specifies the port
and we know which port is used in advance. Moreover the port nerver be used
by unrelated application suddenly. When connect() and listen() share the
port, listen() is always called after connect().


I would like to think about two sockets (sk1 and sk2) in three cases.

1st case: sk1 is in TCP_LISTEN.
In this case, sk2 cannot get the port and my patches does not change the behaviour.

2nd case: sk1 is in TCP_ESTABLISHED and call bind(addr, 40000) for sk2.
In this case, sk2 can get the port by specifying the port, so listen() of
sk2 can share the port with connect() of sk1. This is because reuseport_ok
is true, but my patches add changes only for when reuseport_ok is false.
Therefore, whether my patches are applied or not, this problem can happen.

3rd case: sk1 is in TCP_ESTABLISHED and call bind(addr, 0) for sk2.
In this case, sk2 come to be able to get the port with my patches if both
sockets have SO_REUSEADDR enabled.
So, listen() also can share the port with connect().

However, I do not think this can be problem for two reasons:
  - the same problem already can happen in 2nd case, and the possibility of
    this case is lower than 2nd case because 3rd case is when the ports are exhausted.
  - I am unsure that there is supervisions that monitor the server
    applications which randomly select the ephemeral ports to listen on.

Although this may be a stupid question, is there famous server software
that do bind(addr, 0) and listen() ?


Hence, I think these patches are safe.
What would you think about this?

But also I think this depends on use cases. So I would like to ask for another opinion.
If we can enable/disable the fallback behaviour by sysctl or proc,
it is more useful because some people can fully utilize 4-tuples.
How would you think about this option?
