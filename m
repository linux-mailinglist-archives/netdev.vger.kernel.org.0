Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987A230C398
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhBBPXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:23:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235361AbhBBPQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:16:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BED64FA9;
        Tue,  2 Feb 2021 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278477;
        bh=7HAX9sU+l6BNdNYSlFXNawad2Tcj2aC8xHHqNBYP1s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKvx3yKCr3Aet+YOW3UkW7IkbzSa74OLdT8mMUHQNwg6a9eXn3X4XRVquyJ601nlO
         frR1KPWYwsQzVaX+PA0SGq4yHP3diH9dXNc8h55udX2VkaITK8mWJvAzsFPKKtTViq
         HIn6mOKkh2xsqGeVFdx/loynQiJZHBGXWPBF6UNief//5VSQvo9UwUBEtJgBfLmTfk
         MFqfsj6R2xOoecDMYaRp8MsaE7UvX/uMXRu7SGVZ/0HjCZL4V9K72j5s12qjmbEyD4
         25b9KJNwDKfwEullOzRoVGxGudaStqbdgjTohcNjr+gsaE70sQkokjW2LYBYxb7+zs
         tCKyoYTseOVqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/5] SUNRPC: Handle 0 length opaque XDR object data properly
Date:   Tue,  2 Feb 2021 10:07:50 -0500
Message-Id: <20210202150750.1864953-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150750.1864953-1-sashal@kernel.org>
References: <20210202150750.1864953-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit e4a7d1f7707eb44fd953a31dd59eff82009d879c ]

When handling an auth_gss downcall, it's possible to get 0-length
opaque object for the acceptor.  In the case of a 0-length XDR
object, make sure simple_get_netobj() fills in dest->data = NULL,
and does not continue to kmemdup() which will set
dest->data = ZERO_SIZE_PTR for the acceptor.

The trace event code can handle NULL but not ZERO_SIZE_PTR for a
string, and so without this patch the rpcgss_context trace event
will crash the kernel as follows:

[  162.887992] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  162.898693] #PF: supervisor read access in kernel mode
[  162.900830] #PF: error_code(0x0000) - not-present page
[  162.902940] PGD 0 P4D 0
[  162.904027] Oops: 0000 [#1] SMP PTI
[  162.905493] CPU: 4 PID: 4321 Comm: rpc.gssd Kdump: loaded Not tainted 5.10.0 #133
[  162.908548] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  162.910978] RIP: 0010:strlen+0x0/0x20
[  162.912505] Code: 48 89 f9 74 09 48 83 c1 01 80 39 00 75 f7 31 d2 44 0f b6 04 16 44 88 04 11 48 83 c2 01 45 84 c0 75 ee c3 0f 1f 80 00 00 00 00 <80> 3f 00 74 10 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 c3 31
[  162.920101] RSP: 0018:ffffaec900c77d90 EFLAGS: 00010202
[  162.922263] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000fffde697
[  162.925158] RDX: 000000000000002f RSI: 0000000000000080 RDI: 0000000000000010
[  162.928073] RBP: 0000000000000010 R08: 0000000000000e10 R09: 0000000000000000
[  162.930976] R10: ffff8e698a590cb8 R11: 0000000000000001 R12: 0000000000000e10
[  162.933883] R13: 00000000fffde697 R14: 000000010034d517 R15: 0000000000070028
[  162.936777] FS:  00007f1e1eb93700(0000) GS:ffff8e6ab7d00000(0000) knlGS:0000000000000000
[  162.940067] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  162.942417] CR2: 0000000000000010 CR3: 0000000104eba000 CR4: 00000000000406e0
[  162.945300] Call Trace:
[  162.946428]  trace_event_raw_event_rpcgss_context+0x84/0x140 [auth_rpcgss]
[  162.949308]  ? __kmalloc_track_caller+0x35/0x5a0
[  162.951224]  ? gss_pipe_downcall+0x3a3/0x6a0 [auth_rpcgss]
[  162.953484]  gss_pipe_downcall+0x585/0x6a0 [auth_rpcgss]
[  162.955953]  rpc_pipe_write+0x58/0x70 [sunrpc]
[  162.957849]  vfs_write+0xcb/0x2c0
[  162.959264]  ksys_write+0x68/0xe0
[  162.960706]  do_syscall_64+0x33/0x40
[  162.962238]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  162.964346] RIP: 0033:0x7f1e1f1e57df

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/auth_gss_internal.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss_internal.h b/net/sunrpc/auth_gss/auth_gss_internal.h
index c5603242b54bf..f6d9631bd9d00 100644
--- a/net/sunrpc/auth_gss/auth_gss_internal.h
+++ b/net/sunrpc/auth_gss/auth_gss_internal.h
@@ -34,9 +34,12 @@ simple_get_netobj(const void *p, const void *end, struct xdr_netobj *dest)
 	q = (const void *)((const char *)p + len);
 	if (unlikely(q > end || q < p))
 		return ERR_PTR(-EFAULT);
-	dest->data = kmemdup(p, len, GFP_NOFS);
-	if (unlikely(dest->data == NULL))
-		return ERR_PTR(-ENOMEM);
+	if (len) {
+		dest->data = kmemdup(p, len, GFP_NOFS);
+		if (unlikely(dest->data == NULL))
+			return ERR_PTR(-ENOMEM);
+	} else
+		dest->data = NULL;
 	dest->len = len;
 	return q;
 }
-- 
2.27.0

