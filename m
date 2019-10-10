Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19163D2CF1
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfJJOwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:52:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfJJOwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:52:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0458A64467;
        Thu, 10 Oct 2019 14:52:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-84.rdu2.redhat.com [10.10.121.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BB4A196B2;
        Thu, 10 Oct 2019 14:52:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix possible NULL pointer access in ICMP handling
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Oct 2019 15:52:34 +0100
Message-ID: <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 10 Oct 2019 14:52:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an ICMP packet comes in on the UDP socket backing an AF_RXRPC socket as
the UDP socket is being shut down, rxrpc_error_report() may get called to
deal with it after sk_user_data on the UDP socket has been cleared, leading
to a NULL pointer access when this local endpoint record gets accessed.

Fix this by just returning immediately if sk_user_data was NULL.

The oops looks like the following:

#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
...
RIP: 0010:rxrpc_error_report+0x1bd/0x6a9
...
Call Trace:
 ? sock_queue_err_skb+0xbd/0xde
 ? __udp4_lib_err+0x313/0x34d
 __udp4_lib_err+0x313/0x34d
 icmp_unreach+0x1ee/0x207
 icmp_rcv+0x25b/0x28f
 ip_protocol_deliver_rcu+0x95/0x10e
 ip_local_deliver+0xe9/0x148
 __netif_receive_skb_one_core+0x52/0x6e
 process_backlog+0xdc/0x177
 net_rx_action+0xf9/0x270
 __do_softirq+0x1b6/0x39a
 ? smpboot_register_percpu_thread+0xce/0xce
 run_ksoftirqd+0x1d/0x42
 smpboot_thread_fn+0x19e/0x1b3
 kthread+0xf1/0xf6
 ? kthread_delayed_work_timer_fn+0x83/0x83
 ret_from_fork+0x24/0x30

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Reported-by: syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/peer_event.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index c97ebdc043e4..61451281d74a 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -151,6 +151,9 @@ void rxrpc_error_report(struct sock *sk)
 	struct rxrpc_peer *peer;
 	struct sk_buff *skb;
 
+	if (unlikely(!local))
+		return;
+
 	_enter("%p{%d}", sk, local->debug_id);
 
 	/* Clear the outstanding error value on the socket so that it doesn't

