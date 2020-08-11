Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613D9242020
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKTLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 15:11:05 -0400
Received: from mail.efficios.com ([167.114.26.124]:47324 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKTLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 15:11:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 529BD2CF2E0;
        Tue, 11 Aug 2020 15:11:04 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hgoaOP9Sff08; Tue, 11 Aug 2020 15:11:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EE8232CF534;
        Tue, 11 Aug 2020 15:11:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com EE8232CF534
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1597173063;
        bh=aX5VywJt4AvedzVTU+00PoSO60+jsYPIe8N+NMnuuug=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=DIs9NLMS2FYpHh94Q10fjl+V6SBbPVR01oX0qwjrLguaKAqnFi0TVrLl3CXcfviqE
         qbH6eO/X1BD8RVhuQ12hUCpLfiGHLK0L1McWyeW8NkUMi6HHCAYZfy0dbzo9LV+FIM
         EOgfLWhM82MePWHTY1kZbisd2TtJPjHM2/Et0jzGOAPVbzAoqqldRa23i7Og5bOiky
         jzJJi+00KyxItp1zpr/72YGD3/Ul52rkQo5EVqBv39oY0RtFBC/YlhvsKuKukWeos5
         igSPkh2hI/v+//AD6i+o+X2OIvPikNr5KpvY4MlsDeQOQ20vj+22LzqsMzy8KJ5Uzo
         Zup9/QpDcGV+Q==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CuFNI7mpAn5G; Tue, 11 Aug 2020 15:11:03 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id E29242CF351;
        Tue, 11 Aug 2020 15:11:03 -0400 (EDT)
Date:   Tue, 11 Aug 2020 15:11:03 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michael Jeanson <mjeanson@efficios.com>,
        David Ahern <dsahern@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Message-ID: <699475546.4794.1597173063863.JavaMail.zimbra@efficios.com>
In-Reply-To: <f43a9397-c506-9270-b423-efaf6f520a80@gmail.com>
References: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com> <20200806185121.19688-1-mjeanson@efficios.com> <20200811.102856.864544731521589077.davem@davemloft.net> <f43a9397-c506-9270-b423-efaf6f520a80@gmail.com>
Subject: Re: [PATCH] selftests: Add VRF icmp error route lookup test
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3959 (ZimbraWebClient - FF79 (Linux)/8.8.15_GA_3953)
Thread-Topic: selftests: Add VRF icmp error route lookup test
Thread-Index: K9OU1fUupPJcTCWW0BAtiweVmt3suA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Aug 11, 2020, at 2:57 PM, David Ahern dsahern@gmail.com wrote:

> On 8/11/20 11:28 AM, David Miller wrote:
>> From: Michael Jeanson <mjeanson@efficios.com>
>> Date: Thu,  6 Aug 2020 14:51:21 -0400
>> 
>>> The objective is to check that the incoming vrf routing table is selected
>>> to send an ICMP error back to the source when the ttl of a packet reaches 1
>>> while it is forwarded between different vrfs.
>>>
>>> The first test sends a ping with a ttl of 1 from h1 to h2 and parses the
>>> output of the command to check that a ttl expired error is received.
>>>
>>> [This may be flaky, I'm open to suggestions of a more robust approch.]
>>>
>>> The second test runs traceroute from h1 to h2 and parses the output to
>>> check for a hop on r1.
>>>
>>> Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
>> 
>> This patch does not apply cleanly to the current net tree.
>> 
> 
> It is also out of context since the tests fail on current net and net-next.
> 
> The tests along with the patches that fix the problem should be sent
> together.

One thing I am missing before this series can be considered for upstreaming
is an Acked-by of the 2 fixes for ipv4 and ipv6 from you, as maintainer
of l3mdev, if you think the approach I am taking with those fixes makes sense.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
