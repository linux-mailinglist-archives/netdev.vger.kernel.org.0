Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D911E1360B3
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388661AbgAITFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:05:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbgAITFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:05:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B72701584B060;
        Thu,  9 Jan 2020 11:05:14 -0800 (PST)
Date:   Thu, 09 Jan 2020 11:05:14 -0800 (PST)
Message-Id: <20200109.110514.747612850299504416.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net
Subject: Re: [PATCH net-next v7 02/11] sock: Make sk_protocol a 16-bit value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109155924.30122-3-mathew.j.martineau@linux.intel.com>
References: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
        <20200109155924.30122-3-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 11:05:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Thu,  9 Jan 2020 07:59:15 -0800

> Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
> sizeof(struct sock) does not change.
> 
> Also take care of BPF field access for sk_type/sk_protocol. Both of them
> are now outside the bitfield, so we can use load instructions without
> further shifting/masking.
> 
> v5 -> v6:
>  - update eBPF accessors, too (Intel's kbuild test robot)
> v2 -> v3:
>  - keep 'sk_type' 2 bytes aligned (Eric)
> v1 -> v2:
>  - preserve sk_pacing_shift as bit field (Eric)
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: bpf@vger.kernel.org
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

This is worrisome for me.

We have lots of places that now are going to be assigning  sk->sk_protocol
into a u8 somewhere else.  A lot of them are ok because limits are enforced
in various places, but for example:

net/ipv6/udp.c:	fl6.flowi6_proto = sk->sk_protocol;
net/l2tp/l2tp_ip6.c:	fl6.flowi6_proto = sk->sk_protocol;

net/ipv6/inet6_connection_sock.c:	fl6->flowi6_proto = sk->sk_protocol;

net/ipv6/af_inet6.c:		fl6.flowi6_proto = sk->sk_protocol;
net/ipv6/datagram.c:	fl6->flowi6_proto = sk->sk_protocol;

This is one just one small example situation, where flowi6_proto is a u8.
