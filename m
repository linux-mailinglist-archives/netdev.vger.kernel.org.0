Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF59D3BEB9C
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhGGPzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:55:10 -0400
Received: from novek.ru ([213.148.174.62]:35692 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231533AbhGGPzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 11:55:10 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 78E155038AC;
        Wed,  7 Jul 2021 18:50:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 78E155038AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625673019; bh=iUGmLIlTcUdYgfNNKt8PXf+W7B6OTnfKM2vhBIWMn4A=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=0EWw6jDYnoJJgDrQ1x6HKFiaLX+yUm02W5/OxWl44rGi1lSIcv/pVd1wZKHt89aOJ
         9HxMTzU2ZK04/HXtAAh9huSEleC62u/5nSrPxSXNhvABmpC4IW1qZc1eNWuz1u1hTc
         MqhfxUwcwkhNrtjC5ILRlLW8xsWJTBUd4PE0WGr8=
Subject: Re: Fw: [Bug 213669] New: PMTU dicovery not working for IPsec
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20210707070752.47946d92@hermes.local>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <3957720a-874b-6e89-e58c-3e16dc4570af@novek.ru>
Date:   Wed, 7 Jul 2021 16:52:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707070752.47946d92@hermes.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.07.2021 15:07, Stephen Hemminger wrote:
> 
> 
> Begin forwarded message:
> 
> Date: Wed, 07 Jul 2021 09:08:07 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 213669] New: PMTU dicovery not working for IPsec
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=213669
> 
>              Bug ID: 213669
>             Summary: PMTU dicovery not working for IPsec
>             Product: Networking
>             Version: 2.5
>      Kernel Version: 5.12.13
>            Hardware: x86-64
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: high
>            Priority: P1
>           Component: IPV4
>            Assignee: stephen@networkplumber.org
>            Reporter: marek.gresko@protonmail.com
>          Regression: No
> 
> Hello,
> 
> I have two sites interconnected using ipsec (libreswan)
> 
> the situation is as follows:
> 
> X <=> (a) <=> (Internet) <=> (b) <=> Y
> 
> So you have two gateways a and b connected to the internet and their
> corresponding internal subnets X and Y. The gateway a is connected to the
> provider p using pppoe. The ipsec tunnel is created between a and b to
> interconnect subnets X and Y. When gateway b with internal address y itself is
> communication to the gateway a using its internal address x. Addresses x and y
> are defined by leftsourceif and rightsourceip in the libreswan configuration,
> you get this behavior:
> 
> b# ping -M do x -s 1392 -c 1
> PING x (x.x.x.x) 1392(1420) bytes of data.
> 
> --- ping statistics ---
> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
> 
> b# ping -M do a -s 1460 -c 3
> PING a (a.a.a.a) 1460(1488) bytes of data.
>  From p (p.p.p.p) icmp_seq=1 Frag needed and DF set (mtu = 1480)
> ping: local error: message too long, mtu=1480
> ping: local error: message too long, mtu=1480
> 
> --- ping statistics ---
> 3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2014ms
> 
> b# ping -M do x -s 1392 -c 3
> PING x (x.x.x.x) 1392(1420) bytes of data.
> ping: local error: message too long, mtu=1418
> ping: local error: message too long, mtu=1418
> ping: local error: message too long, mtu=1418
> 
> --- ping statistics ---
> 3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2046ms
> 
> 
> Legend:
> x.x.x.x is an inner ip address if the gateway (a) (or x from the inside).
> a.a.a.a is an outer address of the gateway (a).
> p.p.p.p is some address in the provider's network of the (a) side.
> 
> So definitely the ipsec tunnel is aware of the mtu only when some outer
> communication is in progress. The inner communication itself is not aware of
> icmp packets using for PMTU discovery. I had also a situation when also the
> outer pings did not help the ipsec to be aware of the MTU and after reboot it
> started to behave like discribed again.
> 
> Did I describe it understandably or should I clarify things?
> 
> Thanks
> 
> Marek
> 

Looks like I didn't cover one more case in my MTU patch series. I'll try to look
deeper
