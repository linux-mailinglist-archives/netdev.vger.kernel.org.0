Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E2B275E25
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIWRDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:03:05 -0400
Received: from mail.efficios.com ([167.114.26.124]:51846 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgIWRDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:03:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 1B4B22CBF57;
        Wed, 23 Sep 2020 13:03:04 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id UtFJwFqFqI9A; Wed, 23 Sep 2020 13:03:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D4A562CC076;
        Wed, 23 Sep 2020 13:03:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D4A562CC076
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600880583;
        bh=F8UBWvDOoZ47q2doq5ED60G9uh3N3lilVQ/T/onXtlA=;
        h=From:To:Message-ID:Date:MIME-Version;
        b=KE0td2akdrkYy0OjNq2iKGyXrqi78FpRXBhHLTd8mAZt9Ij59DtIXN7m96NjBoRS8
         JTFc/kvFdann7gDSNQzKv70dUym2lp2iQ6C7TbU+AyogVDb3MXcbb8MOPftj+TsgiU
         QDg1xE8Axke7sJpBh/rKwYBYy4c/1jLS292H642gqKLKAcaf3Ga8NFJgo89tjew8ND
         +AGWuoRqlndZU+HF+JT9c5W6xB43pOxEk383yofag4PxRUiKqkKqoc/kIL2o1GJMLb
         ZA5jE6D9YtG1IjU2w4I1rw24hx92Geh9Y68o+brM5ZaJZDuDAwnKSNkchTWSCoc+u2
         BzLjedffI0EwA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6tPWE3jsjytB; Wed, 23 Sep 2020 13:03:03 -0400 (EDT)
Received: from [10.10.0.55] (96-127-212-112.qc.cable.ebox.net [96.127.212.112])
        by mail.efficios.com (Postfix) with ESMTPSA id B45ED2CC1C5;
        Wed, 23 Sep 2020 13:03:03 -0400 (EDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
From:   Michael Jeanson <mjeanson@efficios.com>
To:     David Ahern <dsahern@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
 <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
 <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
 <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
 <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
 <730d8a09-7d3b-1033-4131-520dc42e8855@efficios.com>
Message-ID: <47175ae8-e7e8-473c-5103-90bf444db16c@efficios.com>
Date:   Wed, 23 Sep 2020 13:03:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <730d8a09-7d3b-1033-4131-520dc42e8855@efficios.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-23 12 h 04, Michael Jeanson wrote:
>> It should work without asymmetric routing; adding the return route to
>> the second vrf as I mentioned above fixes the FRAG_NEEDED problem. It
>> should work for TTL as well.
>>
>> Adding a second pass on the tests with the return through r2 is fine,
>> but add a first pass for the more typical case.
> 
> Hi,
> 
> Before writing new tests I just want to make sure we are trying to fix 
> the same issue. If I add a return route to the red VRF then we don't
> need this patchset because whether the ICMP error are routed using the
> table from the source or destination interface they will reach the 
> source host.
> 
> The issue for which this patchset was sent only happens when the 
> destination interface's VRF doesn't have a route back to the source 
> host. I guess we might question if this is actually a bug or not.
> 
> So the question really is, when a packet is forwarded between VRFs 
> through route leaking and an icmp error is generated, which table should 
> be used for the route lookup? And does it depend on the type of icmp 
> error? (e.g. TTL=1 happens before forwarding, but fragmentation needed 
> happens after when on the destination interface)

As a side note, I don't mind reworking the tests as you requested even 
if the patchset as a whole ends up not being needed and if you think 
they are still useful. I just wanted to make sure we understood each other.

Cheers,

Michael
