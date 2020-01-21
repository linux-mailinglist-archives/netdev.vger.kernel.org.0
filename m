Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7538B1440FA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAUPv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:51:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728829AbgAUPv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579621887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/nUcM4vTCnu2rHce5yQG5m5djPMEq07EL0pdQ4LTGS0=;
        b=Ud9rQutT6pfoHjdzcXV6u16H/vLdV8PPJC4uWPiQ6gHJlbngia97/Nur5DqJloW62FVygs
        ZMnUGTtDVGhSDdcz19wmwTIL9tYK4AUUXCQbhjju/34NS46nBNZCdpWqZ4aRDdORT/z+hS
        dAAXBysFs5IhRXo9lgttxZ93nvSurNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-wZh746tjPsK-IlW6wE_aag-1; Tue, 21 Jan 2020 10:51:25 -0500
X-MC-Unique: wZh746tjPsK-IlW6wE_aag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC5D6100550E;
        Tue, 21 Jan 2020 15:51:24 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.34.246.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3EF21001B05;
        Tue, 21 Jan 2020 15:51:23 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net] Revert "udp: do rmem bulk free even if the rx sk queue is empty"
Date:   Tue, 21 Jan 2020 16:50:49 +0100
Message-Id: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0d4a6608f68c7532dcbfec2ea1150c9761767d03.

Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
free even if the rx sk queue is empty") the memory allocated by
an almost idle system with many UDP sockets can grow a lot.

For stable kernel keep the solution as simple as possible and revert
the offending commit.

Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Diagnosed-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is e=
mpty")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 93a355b6b092..030d43c7c957 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1368,7 +1368,8 @@ static void udp_rmem_release(struct sock *sk, int s=
ize, int partial,
 	if (likely(partial)) {
 		up->forward_deficit +=3D size;
 		size =3D up->forward_deficit;
-		if (size < (sk->sk_rcvbuf >> 2))
+		if (size < (sk->sk_rcvbuf >> 2) &&
+		    !skb_queue_empty(&up->reader_queue))
 			return;
 	} else {
 		size +=3D up->forward_deficit;
--=20
2.21.0

