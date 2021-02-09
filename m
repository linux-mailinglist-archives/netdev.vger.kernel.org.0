Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A09E314E7F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhBIL6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:58:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6174 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBIL4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:56:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6022781a0002>; Tue, 09 Feb 2021 03:55:06 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 11:55:06 +0000
Received: from yaviefel (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021 11:55:04
 +0000
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jian Yang <jianyang.kernel@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to UP
In-Reply-To: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
Date:   Tue, 9 Feb 2021 12:54:59 +0100
Message-ID: <87czx978x8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612871706; bh=aegypDXr+8IR3JMPfc+C8psFduede0a9I2TflVS0M1E=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=eumHX7Mz17JIFmdGnsj5Jxy38Db63Mae6v9EIqSC/JQjyxyMmqpSoxLV/p6TV7SUv
         QmLBCf9TYwjLwHj96iF5kSXV1LR7oVJqYjAbGCAvwCOTRJYmpETNzptUV1THuurYna
         ynsqm6FiYhIqC2nag54AGATDqYx8ntcmqsbbil8lqHXcNslaZ9x5tyyvaQV+JNuIX9
         JRERUJ3/j9wpO+MTVgxi3RRFkoaeDg0JZuDCkHeOzOy3+53OR0EukqCRkBzVAvyk3p
         A3HuZaQNII49cSASjWSm8C3XdpQb+MkfP5WjPhdE4Ga5wWjSfENwn8CkS1hS4wLqVV
         fPhIT1yJVtafg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jian Yang <jianyang.kernel@gmail.com> writes:

> From: Jian Yang <jianyang@google.com>
>
> Traditionally loopback devices come up with initial state as DOWN for
> any new network-namespace. This would mean that anyone needing this
> device would have to bring this UP by issuing something like 'ip link
> set lo up'. This can be avoided if the initial state is set as UP.

This will break user scripts, and it fact breaks kernel's very own
selftest. We currently have this internally:

    diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
    index 4c7d33618437..bf8ed24ab3ba 100755
    --- a/tools/testing/selftests/net/fib_nexthops.sh
    +++ b/tools/testing/selftests/net/fib_nexthops.sh
    @@ -121,8 +121,6 @@ create_ns()
     	set -e
     	ip netns add ${n}
     	ip netns set ${n} $((nsid++))
    -	ip -netns ${n} addr add 127.0.0.1/8 dev lo
    -	ip -netns ${n} link set lo up

     	ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=1
     	ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_neigh=1
    -- 
    2.26.2

This now fails because the ip commands are run within a "set -e" block,
and kernel rejects addition of a duplicate address.
