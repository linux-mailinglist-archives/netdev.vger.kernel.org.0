Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EBD18213F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbgCKSw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:52:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730715AbgCKSw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583952746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=srq/U62li7EzILgjmi4HuVqDvu12aT3mwBZ0vpD24sg=;
        b=eA+pMvgHV5I2ERaEXwb0j3UD34jbaVGlfS4MIS0ra268a1F+xvPlk4r9SL0HmA7qW9b72W
        kWlHibjLR2Cq/n7kiRoQ1DJ0OoU1rINtj1zgeOAk6m8PJ2Z544s7KsGH86t5Ld0FRjtcK0
        psnvlWXRw8VOhBJasj0rOa8preZpGns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-xJRNJzPVMeuC5MUzthvEdA-1; Wed, 11 Mar 2020 14:52:24 -0400
X-MC-Unique: xJRNJzPVMeuC5MUzthvEdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1CF6800EBC;
        Wed, 11 Mar 2020 18:52:22 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-206-72.brq.redhat.com [10.40.206.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76E775C1C3;
        Wed, 11 Mar 2020 18:52:20 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next] net: mptcp: don't hang before sending 'MP capable with data'
Date:   Wed, 11 Mar 2020 19:50:53 +0100
Message-Id: <da448d7e0a2459519394ab0c398875061f2bf1d0.1583952277.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following packetdrill script

  socket(..., SOCK_STREAM, IPPROTO_MPTCP) =3D 3
  fcntl(3, F_GETFL) =3D 0x2 (flags O_RDWR)
  fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) =3D 0
  connect(3, ..., ...) =3D -1 EINPROGRESS (Operation now in progress)
  > S 0:0(0) <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8,mpcapable v1 =
flags[flag_h] nokey>
  < S. 0:0(0) ack 1 win 65535 <mss 1460,sackOK,TS val 700 ecr 100,nop,wsc=
ale 8,mpcapable v1 flags[flag_h] key[skey=3D2]>
  > . 1:1(0) ack 1 win 256 <nop, nop, TS val 100 ecr 700,mpcapable v1 fla=
gs[flag_h] key[ckey,skey]>
  getsockopt(3, SOL_SOCKET, SO_ERROR, [0], [4]) =3D 0
  fcntl(3, F_SETFL, O_RDWR) =3D 0
  write(3, ..., 1000) =3D 1000

doesn't transmit 1KB data packet after a successful three-way-handshake,
using mp_capable with data as required by protocol v1, and write() hangs
forever:

 PID: 973    TASK: ffff97dd399cae80  CPU: 1   COMMAND: "packetdrill"
  #0 [ffffa9b94062fb78] __schedule at ffffffff9c90a000
  #1 [ffffa9b94062fc08] schedule at ffffffff9c90a4a0
  #2 [ffffa9b94062fc18] schedule_timeout at ffffffff9c90e00d
  #3 [ffffa9b94062fc90] wait_woken at ffffffff9c120184
  #4 [ffffa9b94062fcb0] sk_stream_wait_connect at ffffffff9c75b064
  #5 [ffffa9b94062fd20] mptcp_sendmsg at ffffffff9c8e801c
  #6 [ffffa9b94062fdc0] sock_sendmsg at ffffffff9c747324
  #7 [ffffa9b94062fdd8] sock_write_iter at ffffffff9c7473c7
  #8 [ffffa9b94062fe48] new_sync_write at ffffffff9c302976
  #9 [ffffa9b94062fed0] vfs_write at ffffffff9c305685
 #10 [ffffa9b94062ff00] ksys_write at ffffffff9c305985
 #11 [ffffa9b94062ff38] do_syscall_64 at ffffffff9c004475
 #12 [ffffa9b94062ff50] entry_SYSCALL_64_after_hwframe at ffffffff9ca0008=
c
     RIP: 00007f959407eaf7  RSP: 00007ffe9e95a910  RFLAGS: 00000293
     RAX: ffffffffffffffda  RBX: 0000000000000008  RCX: 00007f959407eaf7
     RDX: 00000000000003e8  RSI: 0000000001785fe0  RDI: 0000000000000008
     RBP: 0000000001785fe0   R8: 0000000000000000   R9: 0000000000000003
     R10: 0000000000000007  R11: 0000000000000293  R12: 00000000000003e8
     R13: 00007ffe9e95ae30  R14: 0000000000000000  R15: 0000000000000000
     ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

Fix it ensuring that socket state is TCP_ESTABLISHED on reception of the
third ack.

Fixes: 1954b86016cf ("mptcp: Check connection state before attempting sen=
d")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 95007e433109..c0cef07f4382 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1049,6 +1049,10 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
+	if (inet_sk_state_load(sk) !=3D TCP_ESTABLISHED) {
+		inet_sk_state_store(sk, TCP_ESTABLISHED);
+		sk->sk_state_change(sk);
+	}
 }
=20
 static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
--=20
2.24.1

