Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE085140FDB
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgAQR2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:28:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41515 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726684AbgAQR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579282112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcP7hHlWdAUxywMEFD11jicRkgWRTWEbxH+E/kXnY34=;
        b=hq2KTZOB6IVces0gXKJ1jn6YfbBFSXMj2tsv5Yy6zS1SSNsgYwgBPtrfPLr+d9Ppe5Fw4j
        zhvJFQjUCoGuIEA/pNMu0qjoDsy3b3JdSELhcsgIqqrL1KKrTI2vyysbbWI0zldjBMD072
        aGoWFYxq8/w43erc3weznA3ZsiwICAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34--uNJKsQyOhysMA9aDlbcPw-1; Fri, 17 Jan 2020 12:28:29 -0500
X-MC-Unique: -uNJKsQyOhysMA9aDlbcPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BBDB107ACC4;
        Fri, 17 Jan 2020 17:28:28 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AF285D9CD;
        Fri, 17 Jan 2020 17:28:27 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net 2/3] net: add annotations to memory_pressure lockless access
Date:   Fri, 17 Jan 2020 18:27:55 +0100
Message-Id: <95c0cdd32c2fa3bfbd5c00bc7ee8d61985fa9ae6.1579281705.git.pabeni@redhat.com>
In-Reply-To: <cover.1579281705.git.pabeni@redhat.com>
References: <cover.1579281705.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The proto memory pressure status is updated without any related lock
held. This patch adds annotations to document this fact and avoid
future syzbot complains.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8dff68b4c316..08383624b8cb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1264,7 +1264,7 @@ static inline bool sk_under_memory_pressure(const s=
truct sock *sk)
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
=20
-	return !!*sk->sk_prot->memory_pressure;
+	return !!READ_ONCE(*sk->sk_prot->memory_pressure);
 }
=20
 static inline long
@@ -1318,7 +1318,7 @@ proto_memory_pressure(struct proto *prot)
 {
 	if (!prot->memory_pressure)
 		return false;
-	return !!*prot->memory_pressure;
+	return !!READ_ONCE(*prot->memory_pressure);
 }
=20
=20
--=20
2.21.0

