Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24DCCB7E2
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfJDKHZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 4 Oct 2019 06:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729466AbfJDKHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 06:07:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2722C05AA56;
        Fri,  4 Oct 2019 10:07:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED85600C4;
        Fri,  4 Oct 2019 10:07:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190911052849.7344-1-hdanton@sina.com>
References: <20190911052849.7344-1-hdanton@sina.com> 
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com>,
        MAILER_DAEMON@email.uscc.net, davem@davemloft.net,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in rxrpc_send_keepalive
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7411.1570183641.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 04 Oct 2019 11:07:21 +0100
Message-ID: <7412.1570183641@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 04 Oct 2019 10:07:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the fix, I think.

David
---
rxrpc: Fix call ref leak

When sendmsg() finds a call to continue on with, if the call is in an
inappropriate state, it doesn't release the ref it just got on that call
before returning an error.

This causes the following symptom to show up with kasan:

        BUG: KASAN: use-after-free in rxrpc_send_keepalive+0x8a2/0x940
        net/rxrpc/output.c:635
        Read of size 8 at addr ffff888064219698 by task kworker/0:3/11077

where line 635 is:

        whdr.epoch      = htonl(peer->local->rxnet->epoch);

The local endpoint (which cannot be pinned by the call) has been released,
but not the peer (which is pinned by the call).

Fixes: 37411cad633f ("rxrpc: Fix potential NULL-pointer exception")
Reported-by: syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---
 sendmsg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 6cd55b1d79f9..79b5b23db4c1 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -661,6 +661,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
 		case RXRPC_CALL_SERVER_ACCEPTING:
+			rxrpc_put_call(call, rxrpc_call_put);
 			ret = -EBUSY;
 			goto error_release_sock;
 		default:
