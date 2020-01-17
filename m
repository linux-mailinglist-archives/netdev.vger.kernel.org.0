Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C558D140FD9
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAQR2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:28:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726684AbgAQR2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:28:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579282109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nnDVwL6ae3QyhFeIcB4JQfpYK+ehG3sFe0H6YhnXEs=;
        b=OnjWCskAs+odL3WRrYXAI1vhIavyFGeCGJuxWgDdOW/DPc1kDLi0WTQcH6GyjgpR8gF3of
        YoXb0No+VsMSiiJ6BDnos++5MdytRKn9W3fZfkDPXLEBwQWI2ZimoezSclYOOYYBUWMow0
        Vqz3IHh68H1nj6scEUj7ISVQadOTu6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-KHZ6OgrCN7KR5ZCnK-msSg-1; Fri, 17 Jan 2020 12:28:28 -0500
X-MC-Unique: KHZ6OgrCN7KR5ZCnK-msSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EABBA1800D4F;
        Fri, 17 Jan 2020 17:28:26 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC0C35D9CD;
        Fri, 17 Jan 2020 17:28:25 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net 1/3] net: generic enter_memory_pressure implementation.
Date:   Fri, 17 Jan 2020 18:27:54 +0100
Message-Id: <1dc63f795a2dc9fc6dd55d55f6349069ba8497cf.1579281705.git.pabeni@redhat.com>
In-Reply-To: <cover.1579281705.git.pabeni@redhat.com>
References: <cover.1579281705.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently sk_leave_memory_pressure() offers a generic implementation
for protocol lacking the leave_memory_pressure() helper, but
supporting the memory pressure model.

sk_enter_memory_pressure() lacks such bits. As a result we get code
duplication and additional, avoidable indirect calls.

This change provides a generic implementation for entering memory pressur=
e,
similar to the existing sk_leave_memory_pressure().

Note: no existing protocol is affected, until the existing
enter_memory_pressure helper is removed from the relevant 'proto'
struct.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/sock.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 8459ad579f73..8cf24dca9bde 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2323,10 +2323,14 @@ EXPORT_SYMBOL(sock_cmsg_send);
=20
 static void sk_enter_memory_pressure(struct sock *sk)
 {
-	if (!sk->sk_prot->enter_memory_pressure)
-		return;
+	if (sk->sk_prot->enter_memory_pressure) {
+		sk->sk_prot->enter_memory_pressure(sk);
+	} else {
+		unsigned long *memory_pressure =3D sk->sk_prot->memory_pressure;
=20
-	sk->sk_prot->enter_memory_pressure(sk);
+		if (memory_pressure && !READ_ONCE(*memory_pressure))
+			WRITE_ONCE(*memory_pressure, 1);
+	}
 }
=20
 static void sk_leave_memory_pressure(struct sock *sk)
--=20
2.21.0

