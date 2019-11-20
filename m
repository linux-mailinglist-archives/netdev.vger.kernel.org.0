Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9710361C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 09:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfKTIjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 03:39:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:47600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbfKTIjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 03:39:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2DF1AAD00;
        Wed, 20 Nov 2019 08:39:20 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6EE71E1EB1; Wed, 20 Nov 2019 09:39:19 +0100 (CET)
Date:   Wed, 20 Nov 2019 09:39:19 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Firo Yang <firo.yang@suse.com>
Subject: possible race in __inet_lookup_established()
Message-ID: <20191120083919.GH27852@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

we are investigating a crash in socket lookup in a distribution kernel
based on v4.12 but the possible problem we found seems to also apply to
current mainline (or net) code.

The common pattern is:

- the crash always happens in __inet_lookup_established() in

	sk_nulls_for_each_rcu(sk, node, &head->chain) {
		if (sk->sk_hash != hash)     <-----------------
			continue;

  as sk is an invalid pointer; in particular, &sk->sk_nulls_node is null
  so dereferencing sk->sk_hash faults

- the reason is that previous sk value pointed to a listening socket
  rather than an established one; as listening socket uses sk_node, end
  of the chain is marked by a null pointer which is not detected as
  a chain end by sk_nulls_for_each_rcu()

- there is no socket matching skb which is a TCP pure ACK having
  127.0.0.1 as both source and destination

- the chain pointed to by head variable is empty

Firo Yang came with the theory that this could be a race between socket
lookup and freing the socket and replacing it with a listening one:

1. CPU A gets a pointer to an established socket as sk in the
sk_nulls_for_each_rcu() loop in __inet_lookup_established() but does not
thake a reference to it.

2. CPU B frees the socket

3. Slab object pointed to by sk is reused for a new listening socket.
This socket has null sk->sk_node->next which uses the same spot as
sk->sk_nulls_node->next

4. CPU A tests sk->sk_nulls_node->next with is_a_nulls() (false) and
follows the pointer, resulting in a fault dereferencing sk->sk_hash.

Unless we missed something, there is no protection against established
socket being freed and replaced by a new listening one while
__inet_lookup_established() has a pointer to it. The RCU loop only
prevents the slab object being reused for a different slab cache or
something completely different but as established and listening sockets
share the same slab cache, it does not protect us from switching from
established to listening.

As far as I can say, this kind of race could have happened for quite
long but before your commit 3b24d854cb35 ("tcp/dccp: do not touch
listener sk_refcnt under synflood"), the worst that could happen would
be switching to a chain in listener lookup table, following it to its
end and then (most likely) restarting the lookup or failing. Now that
established and listening sockets use different list types, replacing
one with the other can be deadly.

Do you agree that this race is possible or is there something we missed
that would prevent it?

Michal
