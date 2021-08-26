Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A13F8C03
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243079AbhHZQYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:24:01 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52950 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243027AbhHZQX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 12:23:59 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id C5B94200DFA5;
        Thu, 26 Aug 2021 18:23:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be C5B94200DFA5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1629994989;
        bh=LTwQdGPjmbsP5y/zIvgoNIgfLXWYBuRlEh0bKTGx7/A=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=ARry6yZIdH/Qv5izIrhJLIPGZLPuR7tSJtN9WsedfPRhLOBClBbR3F5VNqvL0b2Qn
         8GDcczO9CkSkZMT2dByR8YnxwXTDMWPneyN7+xgppctA/Sjzw/k/LInSA1HTinwtIT
         SCYuDSoIKocEZqqFXkZOEjZLWoP0FjZDeWgpat/1fYuCpJRQ5ezmxdQrmq8w0jyMCh
         Kj/96sDvd7E+4o3I9aea9cGNd8wqymd1mS3YoEpjj8bC0n2jpGxETm5JyaUxKEVXds
         nPE/EgfhsWemX9Hb//wOzJsirqyghh6w1Efowk1j3Axj8E7FmwipdHafNHbAQKdnTq
         iYqJ04IealWnw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BBDAC60D6708E;
        Thu, 26 Aug 2021 18:23:09 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id s6llkRKRHMn2; Thu, 26 Aug 2021 18:23:09 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id A2335603B13C9;
        Thu, 26 Aug 2021 18:23:09 +0200 (CEST)
Date:   Thu, 26 Aug 2021 18:23:09 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     nicolas dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com,
        edumazet@google.com
Message-ID: <1977792481.53611744.1629994989620.JavaMail.zimbra@uliege.be>
In-Reply-To: <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com>
References: <20210826140150.19920-1-justin.iurman@uliege.be> <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com>
Subject: Re: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF91 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: Support for anonymous tunnel decapsulation
Thread-Index: ZVMnr86+4/LxtFc0PY1cUNycU86rww==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas,

>> Based on the above, here is a generic solution to introduce anonymous tunnels
>> for IPv6. We know that the tunnel6 module is, when loaded, already responsible
>> for handling IPPROTO_IPV6 from an IPv6 context (= ip6ip6). Therefore, when
>> tunnel6 is loaded, it handles ip6ip6 with its tunnel6_rcv handler. Inside the
>> handler, we add a check for anonymous tunnel decapsulation and, if enabled,
>> perform the decap. When tunnel6 is unloaded, it gives the responsability back to
>> tunnel6_anonymous and its own handler. Note that the introduced sysctl to
>> enable anonymous decapsulation is equal to 0 (= disabled) by default. Indeed,
>> as opposed to what Tom suggested, I think it should be disabled by default in
>> order to make sure that users won't have it enabled without knowing it (for
>> security reasons, obviously).
>> 
>> Thoughts?
> I'm not sure to understand why the current code isn't enough. The fallback
> tunnels created by legacy IP tunnels drivers are able to receive and decapsulate
> any encapsulated packets.

Because, right now, you need to use the ip6_tunnel module and explicitly configure a tunnel, as you described below. The goal of this patch is to provide a way to apply an ip6ip6 decapsulation *without* having to configure a tunnel.

> I made a quick try with an ip6 tunnel and it works perfectly:
> 
> host1 -- router1 -- router2 -- host2
> 
> A ping is done from host1 to host2. router1 is configured with a standard ip6
> tunnel and screenshots are done on router2:
> 
> $ modprobe ip6_tunnel
> $ ip l s ip6tnl0 up
> $ tcpdump -ni ip6tnl0
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on ip6tnl0, link-type LINUX_SLL (Linux cooked), capture size 262144
> bytes
> 17:22:22.749246 IP6 fd00:100::1 > fd00:200::1: ICMP6, echo request, seq 0,
> length 64
> 
> And a tcpdump on the link interface:
> $ tcpdump -ni ntfp2
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on ntfp2, link-type EN10MB (Ethernet), capture size 262144 bytes
> 17:23:41.587252 IP6 fd00:125::1 > fd00:125::2: IP6 fd00:100::1 > fd00:200::1:
> ICMP6, echo request, seq 0, length 64
> 17:23:41.589291 IP6 fd00:200::1 > fd00:100::1: ICMP6, echo reply, seq 0, length
> 64
> 
> $ ip -d a l dev ip6tnl0
> 6: ip6tnl0@NONE: <NOARP,UP,LOWER_UP> mtu 1452 qdisc noqueue state UNKNOWN group
> default qlen 1000
>    link/tunnel6 :: brd :: promiscuity 0 minmtu 68 maxmtu 65407
>    ip6tnl ip6ip6 remote any local any hoplimit inherit encaplimit 0 tclass 0x00
> flowlabel 0x00000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs
> 65535
>    inet6 fe80::b47d:abff:feac:ec09/64 scope link
>       valid_lft forever preferred_lft forever
> 
> Am I missing something?
