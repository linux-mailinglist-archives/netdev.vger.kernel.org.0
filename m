Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8305C58FF32
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiHKPVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiHKPVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:21:13 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D281861D54;
        Thu, 11 Aug 2022 08:21:10 -0700 (PDT)
Received: from dev010.ch-qa.sw.ru ([172.29.1.15])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1oM9xi-00FExA-NK;
        Thu, 11 Aug 2022 17:20:17 +0200
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        kernel@openvz.org, devel@openvz.org
Subject: [PATCH v3 0/2] neighbour: fix possible DoS due to net iface start/stop loop
Date:   Thu, 11 Aug 2022 18:20:10 +0300
Message-Id: <20220811152012.319641-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear friends,

Recently one of OpenVZ users reported that they have issues with network
availability of some containers. It was discovered that the reason is absence
of ARP replies from the Host Node on the requests about container IPs.

Of course, we started from tcpdump analysis and noticed that ARP requests
successfuly comes to the problematic node external interface. So, something
was wrong from the kernel side.

I've played a lot with arping and perf in attempts to understand what's
happening. And the key observation was that we experiencing issues only
with ARP requests with broadcast source ip (skb->pkt_type == PACKET_BROADCAST).
But for packets skb->pkt_type == PACKET_HOST everything works flawlessly.

Let me show a small piece of code:

static int arp_process(struct sock *sk, struct sk_buff *skb)
...
				if (NEIGH_CB(skb)->flags & LOCALLY_ENQUEUED ||
				    skb->pkt_type == PACKET_HOST ||
				    NEIGH_VAR(in_dev->arp_parms, PROXY_DELAY) == 0) { // reply instantly
					arp_send_dst(ARPOP_REPLY, ETH_P_ARP,
						     sip, dev, tip, sha,
						     dev->dev_addr, sha,
						     reply_dst);
				} else {
					pneigh_enqueue(&arp_tbl,                     // reply with delay
						       in_dev->arp_parms, skb);
					goto out_free_dst;
				}

The problem was that for PACKET_BROADCAST packets we delaying replies and use pneigh_enqueue() function.
For some reason, queued packets were lost almost all the time! The reason for such behaviour is pneigh_queue_purge()
function which cleanups all the queue, and this function called everytime once some network device in the system
gets link down.

neigh_ifdown -> pneigh_queue_purge

Now imagine that we have a node with 500+ containers with microservices. And some of that microservices are buggy
and always restarting... in this case, pneigh_queue_purge function will be called very frequently.

This problem is reproducible only with so-called "host routed" setup. The classical scheme bridge + veth
is not affected.

Minimal reproducer

Suppose that we have a network 172.29.1.1/16 brd 172.29.255.255
and we have free-to-use IP, let it be 172.29.128.3

1. Network configuration. I showing the minimal configuration, it makes no sense
as we have both veth devices stay at the same net namespace, but for demonstation and simplicity sake it's okay.

ip l a veth31427 type veth peer name veth314271
ip l s veth31427 up
ip l s veth314271 up

# setup static arp entry and publish it
arp -Ds -i br0 172.29.128.3 veth31427 pub
# setup static route for this address
route add 172.29.128.3/32 dev veth31427

2. "attacker" side (kubernetes pod with buggy microservice :) )

unshare -n
ip l a type veth
ip l s veth0 up
ip l s veth1 up
for i in {1..100000}; do ip link set veth0 down; sleep 0.01; ip link set veth0 up; done

This will totaly block ARP replies for 172.29.128.3 address. Just try
# arping -I eth0 172.29.128.3 -c 4

Our proposal is simple:
1. Let's cleanup queue partially. Remove only skb's that related to the net namespace
of the adapter which link is down.

2. Let's account proxy_queue limit properly per-device. Current limitation looks
not fully correct because we comparing per-device configurable limit with the
"global" qlen of proxy_queue.

Thanks,
Alex

v2:
	- only ("neigh: fix possible DoS due to net iface start/stop") is changed
		do del_timer_sync() if queue is empty after pneigh_queue_purge()

v3:
	- rebase to net tree

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Denis V. Lunev <den@openvz.org>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: kernel@openvz.org
Cc: devel@openvz.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

Alexander Mikhalitsyn (1):
  neighbour: make proxy_queue.qlen limit per-device

Denis V. Lunev (1):
  neigh: fix possible DoS due to net iface start/stop loop

 include/net/neighbour.h |  1 +
 net/core/neighbour.c    | 46 +++++++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 9 deletions(-)

-- 
2.36.1

