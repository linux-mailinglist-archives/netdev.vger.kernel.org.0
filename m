Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C828D2732E8
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgIUTdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:33:43 -0400
Received: from mail.efficios.com ([167.114.26.124]:33714 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgIUTdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:33:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id BD1732CE2C5;
        Mon, 21 Sep 2020 15:33:41 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id oTjYbC3pBeDf; Mon, 21 Sep 2020 15:33:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 805DD2CDC6F;
        Mon, 21 Sep 2020 15:33:41 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 805DD2CDC6F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600716821;
        bh=h88mv0FQ3OhKhiNjYOnq0mQrk0XSJtXcZ4X4L7aUy/s=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=olBRC4jFV81xtcGsuEpSQZPuSK3a4yxMPBCyFXDDjWdH7r9s26tWbSrYuK+BjS2fH
         BrPDnw66cpY0V+UkdgJCTX3p9D69DsX11xCahblzALKpt8galWZbS6FwYrTq1fAtbw
         Zn34D4iIEfnwRTAX0vSD3wpkqU6oeWWu8nBup8ucpADiKH8y9t8h7/sig1G0qYA3zj
         5VMS14HgqjWv6k/pqBDNTLMST0EvQi4Gik8hYrXXZaNGtoBvT/rmgO2Ob9ZExovluI
         ZK2fZt0J+hQ1Q74T2LAhs4WkXe7h9JBhTCrBCIKePatu6w8Ss6FklEwflRjMeZaXku
         KOMPyNm4IYw0g==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id N3QvS-qFQ2BA; Mon, 21 Sep 2020 15:33:41 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 764462CE2C4;
        Mon, 21 Sep 2020 15:33:41 -0400 (EDT)
Date:   Mon, 21 Sep 2020 15:33:41 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@gmail.com>,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
In-Reply-To: <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com> <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com> <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com> <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3965 (ZimbraWebClient - FF80 (Linux)/8.8.15_GA_3963)
Thread-Topic: l3mdev icmp error route lookup fixes
Thread-Index: oGKu+N8sth3SnnZ9IlBxnz5gbNJQTg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Sep 21, 2020, at 3:11 PM, David Ahern dsahern@gmail.com wrote:

> On 9/21/20 12:44 PM, Mathieu Desnoyers wrote:
>> ----- On Sep 21, 2020, at 2:36 PM, David Ahern dsahern@gmail.com wrote:
>> 
>>> On 9/18/20 12:17 PM, Mathieu Desnoyers wrote:
>>>> Hi,
>>>>
>>>> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
>>>> the route lookup is performed on the right routing table in VRF
>>>> configurations when sending TTL expired icmp errors (useful for
>>>> traceroute).
>>>>
>>>> It includes tests for both ipv4 and ipv6.
>>>>
>>>> These fixes address specifically address the code paths involved in
>>>> sending TTL expired icmp errors. As detailed in the individual commit
>>>> messages, those fixes do not address similar issues related to network
>>>> namespaces and unreachable / fragmentation needed messages, which appear
>>>> to use different code paths.
>>>>
>>>
>>> New selftests are failing:
>>> TEST: Ping received ICMP frag needed                       [FAIL]
>>>
>>> Both IPv4 and IPv6 versions are failing.
>> 
>> Indeed, this situation is discussed in each patch commit message:
>> 
>> ipv4:
>> 
>> [ It has also been pointed out that a similar issue exists with
>>   unreachable / fragmentation needed messages, which can be triggered by
>>   changing the MTU of eth1 in r1 to 1400 and running:
>> 
>>   ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2
>> 
>>   Some investigation points to raw_icmp_error() and raw_err() as being
>>   involved in this last scenario. The focus of this patch is TTL expired
>>   ICMP messages, which go through icmp_route_lookup.
>>   Investigation of failure modes related to raw_icmp_error() is beyond
>>   this investigation's scope. ]
>> 
>> ipv6:
>> 
>> [ Testing shows that similar issues exist with ipv6 unreachable /
>>   fragmentation needed messages.  However, investigation of this
>>   additional failure mode is beyond this investigation's scope. ]
>> 
>> I do not have the time to investigate further unfortunately, so I
>> thought it best to post what I have.
>> 
> 
> the test setup is bad. You have r1 dropping the MTU in VRF red, but not
> telling VRF red how to send back the ICMP. e.g., for IPv4 add:
> 
>    ip -netns r1 ro add vrf red 172.16.1.0/24 dev blue
> 
> do the same for v6.
> 
> Also, I do not see a reason for r2; I suggest dropping it. What you are
> testing is icmp crossing VRF with route leaking, so there should not be
> a need for r2 which leads to asymmetrical routing (172.16.1.0 via r1 and
> the return via r2).

CCing Michael Jeanson, author of the selftests patch.

Thanks for your feedback,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
