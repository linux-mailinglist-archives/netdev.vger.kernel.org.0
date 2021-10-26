Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3F643B45F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhJZOjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:39:22 -0400
Received: from hyperium.qtmlabs.xyz ([194.163.182.183]:48510 "EHLO
        hyperium.qtmlabs.xyz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbhJZOjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:39:13 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2021 10:39:12 EDT
Received: from dong.kernal.eu (unknown [14.231.159.161])
        by hyperium.qtmlabs.xyz (Postfix) with ESMTPSA id 019BB82000A;
        Tue, 26 Oct 2021 16:28:08 +0200 (CEST)
Received: from [192.168.43.218] (unknown [27.78.4.72])
        by dong.kernal.eu (Postfix) with ESMTPSA id 82DA9444968D;
        Tue, 26 Oct 2021 21:24:56 +0700 (+07)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qtmlabs.xyz; s=syka;
        t=1635258297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xv0gm2nvo9oj8B1zbj9L5t/DZvRs9gtu0orGPoXZIUY=;
        b=rtuFhr1Aifg8JtlsDemsoCMU2zj3Css6IUMXRKkd3aDmBtk/ibvmjt54JRk01A7mFrWPM7
        dSwfhFguIHYT30ZGVsicVXeTrLDIgNdVuwZtdD03WsdB0vOaoLat+CMgCibg+DCfVzeaVl
        TPNisZZUsTy+KQ1xp3YKafJPnC2itS19+hzWS4dZfMc2OujUZDRwr/vYjOh0NqQbausPq9
        Sxi4zMKlaJNC8V3u2QUTdPTiunpMbEWKvzdyWuskPxnCLXLtQL4UjrgNfly/EsAqd85E8y
        KsiTgNQj0NVRPjLJTb9JTatCyKH79dlCj1QI8ShNI5UECN87+2owbgVrT5AVPw==
Message-ID: <e022d597-302d-c061-0830-6ed20aa61e56@qtmlabs.xyz>
Date:   Tue, 26 Oct 2021 21:24:50 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   msizanoen <msizanoen@qtmlabs.xyz>
Subject: Kernel leaks memory in ip6_dst_cache when suppress_prefix is present
 in ipv6 routing rules and a `fib` rule is present in ipv6 nftables rules
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel leaks memory when a `fib` rule is present in ipv6 nftables firewall rules and a suppress_prefix rule
is present in the IPv6 routing rules (used by certain tools such as wg-quick). In such scenarios, every incoming
packet will leak an allocation in ip6_dst_cache slab cache.

After some hours of `bpftrace`-ing and source code reading, I tracked down the issue to this commit:
	https://github.com/torvalds/linux/commit/ca7a03c4175366a92cee0ccc4fec0038c3266e26

The problem with that patch is that the generic args->flags always have FIB_LOOKUP_NOREF set[1][2] but the
ip6-specific flag RT6_LOOKUP_F_DST_NOREF might not be specified, leading to fib6_rule_suppress not
decreasing the refcount when needed. This can be fixed by exposing the protocol-specific flags to the
protocol specific `suppress` function, and check the protocol-specific `flags` argument for
RT6_LOOKUP_F_DST_NOREF instead of the generic FIB_LOOKUP_NOREF when decreasing the refcount.

How to reproduce:
- Add the following nftables rule to a prerouting chain: `meta nfproto ipv6 fib saddr . mark . iif oif missing drop`
- Run `sudo ip -6 rule add table main suppress_prefixlength 0`
- Watch `sudo slabtop -o | grep ip6_dst_cache` memory usage increase with every incoming ipv6 packet

Example patch:https://gist.github.com/msizanoen1/36a2853467a9bd34fadc5bb3783fde0f

[1]:https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L71
[2]:https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L99


