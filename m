Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141F01C96E9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEGQyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:54:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55676 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725949AbgEGQyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588870439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lRyCCHtqD2ugnTKtNjOaqqDPYhRh1IzwBWdHRRd2dY8=;
        b=gIRHEfO8w9Di7goOxo/Sn8Y2yTZ/61dI8bUhLfXz55nIlFY8oC3G5j632t6FC7j27Tu5g4
        kEKZpKfw+tM0rLHy5qmzTFCkX6S7NdK3w0LgVC4QG2H1p8iLB83SBdpvkX3VcKYasMsE4U
        nEqWTsl2SAyNGnYQGAVBTQIbLkIuIeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-VuOuRZ_DMOqtZ2T8seO3jA-1; Thu, 07 May 2020 12:53:57 -0400
X-MC-Unique: VuOuRZ_DMOqtZ2T8seO3jA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3410518FF660;
        Thu,  7 May 2020 16:53:56 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-91.ams2.redhat.com [10.36.114.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92AA662A10;
        Thu,  7 May 2020 16:53:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: set correct vfs info for subflows
Date:   Thu,  7 May 2020 18:53:24 +0200
Message-Id: <a2fde8fb93863b0ffdeea94b5f44ba64b7601c5d.1588865446.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a subflow is created via mptcp_subflow_create_socket(),
a new 'struct socket' is allocated, with a new i_ino value.

When inspecting TCP sockets via the procfs and or the diag
interface, the above ones are not related to the process owning
the MPTCP master socket, even if they are a logical part of it
('ss -p' shows an empty process field)

Additionally, subflows created by the path manager get
the uid/gid from the running workqueue.

Subflows are part of the owning MPTCP master socket, let's
adjust the vfs info to reflect this.

After this patch, 'ss' correctly displays subflows as belonging
to the msk socket creator.

Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 67a4e35d4838..4931a29a6f08 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1012,6 +1012,16 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	if (err)
 		return err;
 
+	/* the newly created socket really belongs to the owning MPTCP master
+	 * socket, even if for additional subflows the allocation is performed
+	 * by a kernel workqueue. Adjust inode references, so that the
+	 * procfs/diag interaces really show this one belonging to the correct
+	 * user.
+	 */
+	SOCK_INODE(sf)->i_ino = SOCK_INODE(sk->sk_socket)->i_ino;
+	SOCK_INODE(sf)->i_uid = SOCK_INODE(sk->sk_socket)->i_uid;
+	SOCK_INODE(sf)->i_gid = SOCK_INODE(sk->sk_socket)->i_gid;
+
 	subflow = mptcp_subflow_ctx(sf->sk);
 	pr_debug("subflow=%p", subflow);
 
-- 
2.21.1

