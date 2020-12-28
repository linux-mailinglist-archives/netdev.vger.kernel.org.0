Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B062E6BF4
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgL1Wzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44046 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbgL1WqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 17:46:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 99E164CE686C5;
        Mon, 28 Dec 2020 14:45:27 -0800 (PST)
Date:   Mon, 28 Dec 2020 14:45:22 -0800 (PST)
Message-Id: <20201228.144522.2164224163258675861.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv4: Ignore ECN bits for fib lookups in
 fib_compute_spec_dst()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <49ff39b1f55c914847cd58678bae6282112db701.1608836260.git.gnault@redhat.com>
References: <49ff39b1f55c914847cd58678bae6282112db701.1608836260.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 14:45:27 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Thu, 24 Dec 2020 20:01:09 +0100

> RT_TOS() only clears one of the ECN bits. Therefore, when
> fib_compute_spec_dst() resorts to a fib lookup, it can return
> different results depending on the value of the second ECN bit.
> 
> For example, ECT(0) and ECT(1) packets could be treated differently.
> 
>   $ ip netns add ns0
>   $ ip netns add ns1
>   $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
>   $ ip -netns ns0 link set dev lo up
>   $ ip -netns ns1 link set dev lo up
>   $ ip -netns ns0 link set dev veth01 up
>   $ ip -netns ns1 link set dev veth10 up
> 
>   $ ip -netns ns0 address add 192.0.2.10/24 dev veth01
>   $ ip -netns ns1 address add 192.0.2.11/24 dev veth10
> 
>   $ ip -netns ns1 address add 192.0.2.21/32 dev lo
>   $ ip -netns ns1 route add 192.0.2.10/32 tos 4 dev veth10 src 192.0.2.21
>   $ ip netns exec ns1 sysctl -wq net.ipv4.icmp_echo_ignore_broadcasts=0
> 
> With TOS 4 and ECT(1), ns1 replies using source address 192.0.2.21
> (ping uses -Q to set all TOS and ECN bits):
> 
>   $ ip netns exec ns0 ping -c 1 -b -Q 5 192.0.2.255
>   [...]
>   64 bytes from 192.0.2.21: icmp_seq=1 ttl=64 time=0.544 ms
> 
> But with TOS 4 and ECT(0), ns1 replies using source address 192.0.2.11
> because the "tos 4" route isn't matched:
> 
>   $ ip netns exec ns0 ping -c 1 -b -Q 6 192.0.2.255
>   [...]
>   64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.597 ms
> 
> After this patch the ECN bits don't affect the result anymore:
> 
>   $ ip netns exec ns0 ping -c 1 -b -Q 6 192.0.2.255
>   [...]
>   64 bytes from 192.0.2.21: icmp_seq=1 ttl=64 time=0.591 ms
> 
> Fixes: 35ebf65e851c ("ipv4: Create and use fib_compute_spec_dst() helper.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied and queued up for -stable, thanks.

