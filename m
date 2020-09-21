Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E5C27323A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgIUSuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:50:04 -0400
Received: from mail.efficios.com ([167.114.26.124]:39944 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgIUSuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:50:04 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 14:50:03 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A31F52CDD80;
        Mon, 21 Sep 2020 14:44:39 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WBvPMP2SvqHB; Mon, 21 Sep 2020 14:44:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 5A6D22CD77F;
        Mon, 21 Sep 2020 14:44:39 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 5A6D22CD77F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600713879;
        bh=GVyop2Bxa1u83OR49HR6MQZ3Oln7khuYox267XJGLIA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=CuiHiBDsd1vmweBJ35jYBnwQqbUBu+d/tFcHJO2+uynaIBn0rMDTcLoaQwzGrFe/b
         3P9HZka8NsGT6H67f0sEjOwxVnjSmShJjYLSvqTgcw8cyrl8vfwB8sv1Py5qtqT0Ao
         +lfXcGrSIgFItqMmmWTODM+9sl1tG5FK/rvw0J0oGiOsTXNHPifkCEd1UGm/6dha9g
         VlTV4d6H646/NMPno6plOftOskb+4DHNY6iJ/xiMEyC1t2+rlLV6O+hwNC0OH37p+d
         FXSUaRKveGMZ3ruHuRh1g5GzwyoXj9diL7WLSef0Lz+3+mYXe7Cpag4OYjbh00utQ4
         6B5zJMMueoiYg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qJk3hvE_jpDr; Mon, 21 Sep 2020 14:44:39 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 50B642CD77E;
        Mon, 21 Sep 2020 14:44:39 -0400 (EDT)
Date:   Mon, 21 Sep 2020 14:44:39 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
In-Reply-To: <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com> <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3965 (ZimbraWebClient - FF80 (Linux)/8.8.15_GA_3963)
Thread-Topic: l3mdev icmp error route lookup fixes
Thread-Index: 0yf8zWzCKvQf9eZ37AP1IEyfvMk3gQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Sep 21, 2020, at 2:36 PM, David Ahern dsahern@gmail.com wrote:

> On 9/18/20 12:17 PM, Mathieu Desnoyers wrote:
>> Hi,
>> 
>> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
>> the route lookup is performed on the right routing table in VRF
>> configurations when sending TTL expired icmp errors (useful for
>> traceroute).
>> 
>> It includes tests for both ipv4 and ipv6.
>> 
>> These fixes address specifically address the code paths involved in
>> sending TTL expired icmp errors. As detailed in the individual commit
>> messages, those fixes do not address similar issues related to network
>> namespaces and unreachable / fragmentation needed messages, which appear
>> to use different code paths.
>> 
> 
> New selftests are failing:
> TEST: Ping received ICMP frag needed                       [FAIL]
> 
> Both IPv4 and IPv6 versions are failing.

Indeed, this situation is discussed in each patch commit message:

ipv4:

[ It has also been pointed out that a similar issue exists with
  unreachable / fragmentation needed messages, which can be triggered by
  changing the MTU of eth1 in r1 to 1400 and running:

  ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2

  Some investigation points to raw_icmp_error() and raw_err() as being
  involved in this last scenario. The focus of this patch is TTL expired
  ICMP messages, which go through icmp_route_lookup.
  Investigation of failure modes related to raw_icmp_error() is beyond
  this investigation's scope. ]

ipv6:

[ Testing shows that similar issues exist with ipv6 unreachable /
  fragmentation needed messages.  However, investigation of this
  additional failure mode is beyond this investigation's scope. ]

I do not have the time to investigate further unfortunately, so I
thought it best to post what I have.

Note that network namespaces also probably have the same problem,
but those are not covered by the test cases.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
