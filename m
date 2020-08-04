Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AF823BE29
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgHDQcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 12:32:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726027AbgHDQcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 12:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596558751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=j9V+gTlssMRevtKd/lBIjqmGOHHv08UaijZNfxpImIc=;
        b=QbaAsRjQRrFpNZAucxyXu8Hk1BeJZEM1V3FfBnmkwUi40fSUaP6r5oqOGunuk2HquQ6yxC
        Whv4QY8DtoPvp8aWpSaem7GkNTiq1+rHRxc/Y+DheZs1Gb24mXActSeAIXmRy1oTu6tJHA
        lWG/0r2WW/VAC9m8VAkMax1KD8Pkgng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-EBmKu7AiPXulOTPglffOXA-1; Tue, 04 Aug 2020 12:32:29 -0400
X-MC-Unique: EBmKu7AiPXulOTPglffOXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED74C1800D42;
        Tue,  4 Aug 2020 16:32:27 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-132.ams2.redhat.com [10.36.114.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C4F072E48;
        Tue,  4 Aug 2020 16:32:26 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>
Subject: [PATCH net] mptcp: be careful on subflow creation
Date:   Tue,  4 Aug 2020 18:31:06 +0200
Message-Id: <61e82de664dffde9ff445ed6f776d6809b198693.1596558566.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas reported the following oops:

[ 1521.392541] BUG: kernel NULL pointer dereference, address: 00000000000000c0
[ 1521.394189] #PF: supervisor read access in kernel mode
[ 1521.395376] #PF: error_code(0x0000) - not-present page
[ 1521.396607] PGD 0 P4D 0
[ 1521.397156] Oops: 0000 [#1] SMP PTI
[ 1521.398020] CPU: 0 PID: 22986 Comm: kworker/0:2 Not tainted 5.8.0-rc4+ #109
[ 1521.399618] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 1521.401728] Workqueue: events mptcp_worker
[ 1521.402651] RIP: 0010:mptcp_subflow_create_socket+0xf1/0x1c0
[ 1521.403954] Code: 24 08 89 44 24 04 48 8b 7a 18 e8 2a 48 d4 ff 8b 44 24 04 85 c0 75 7a 48 8b 8b 78 02 00 00 48 8b 54 24 08 48 8d bb 80 00 00 00 <48> 8b 89 c0 00 00 00 48 89 8a c0 00 00 00 48 8b 8b 78 02 00 00 8b
[ 1521.408201] RSP: 0000:ffffabc4002d3c60 EFLAGS: 00010246
[ 1521.409433] RAX: 0000000000000000 RBX: ffffa0b9ad8c9a00 RCX: 0000000000000000
[ 1521.411096] RDX: ffffa0b9ae78a300 RSI: 00000000fffffe01 RDI: ffffa0b9ad8c9a80
[ 1521.412734] RBP: ffffa0b9adff2e80 R08: ffffa0b9af02d640 R09: ffffa0b9ad923a00
[ 1521.414333] R10: ffffabc4007139f8 R11: fefefefefefefeff R12: ffffabc4002d3cb0
[ 1521.415918] R13: ffffa0b9ad91fa58 R14: ffffa0b9ad8c9f9c R15: 0000000000000000
[ 1521.417592] FS:  0000000000000000(0000) GS:ffffa0b9af000000(0000) knlGS:0000000000000000
[ 1521.419490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1521.420839] CR2: 00000000000000c0 CR3: 000000002951e006 CR4: 0000000000160ef0
[ 1521.422511] Call Trace:
[ 1521.423103]  __mptcp_subflow_connect+0x94/0x1f0
[ 1521.425376]  mptcp_pm_create_subflow_or_signal_addr+0x200/0x2a0
[ 1521.426736]  mptcp_worker+0x31b/0x390
[ 1521.431324]  process_one_work+0x1fc/0x3f0
[ 1521.432268]  worker_thread+0x2d/0x3b0
[ 1521.434197]  kthread+0x117/0x130
[ 1521.435783]  ret_from_fork+0x22/0x30

on some unconventional configuration.

The MPTCP protocol is trying to create a subflow for an
unaccepted server socket. That is allowed by the RFC, even
if subflow creation will likely fail.
Unaccepted sockets have still a NULL sk_socket field,
avoid the issue by failing earlier.

Reported-and-tested-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Fixes: 7d14b0d2b9b3 ("mptcp: set correct vfs info for subflows")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3838a0b3a21f..3c31a8160f19 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1032,6 +1032,12 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	struct socket *sf;
 	int err;
 
+	/* un-accepted server sockets can reach here - on bad configuration
+	 * bail early to avoid greater trouble later
+	 */
+	if (unlikely(!sk->sk_socket))
+		return -EINVAL;
+
 	err = sock_create_kern(net, sk->sk_family, SOCK_STREAM, IPPROTO_TCP,
 			       &sf);
 	if (err)
-- 
2.26.2

