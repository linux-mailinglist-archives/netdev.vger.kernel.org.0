Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21DA196F70
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgC2SpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:45:24 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21406 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgC2SpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:45:24 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2020 14:45:23 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1585506615; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Gnz5i7zHhx3IcbvzMlmWDQnrh0sR4zto57trVmDlWHXCoqi97GnlySWHSZwCHJVpXxoFxxRJFA79+Sc5jtaOmw+XvgCCYJ+/+0MwR4/FDAPoxnr9MYfGZTiif69skBq6lg81l31e2A840IhfQHOnnL3tSAiOKo9SPbBuV59nW1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1585506615; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=hqPCegPJeX/Ry7agpxmBok0vX/8k1cwBMc60UNQIMGc=; 
        b=jo1R6Ef+IV8X1KTtlIbl0iRh/hm9GeB8s4e+1FU5zCAwpXTUftK1eue2XMTj6uXlnad1dGpqe5GxCMZw+TzUoeN0dEqjDKEWuzEVnFSi5b4k3WyelLDhAtSNzVRkic2XQfQjMfXCq1GUmSDWx5JZ5xwGaW2+9NzqNtf/LizNSKo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=meresinski.eu;
        spf=pass  smtp.mailfrom=tomasz@meresinski.eu;
        dmarc=pass header.from=<tomasz@meresinski.eu> header.from=<tomasz@meresinski.eu>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585506615;
        s=zoho; d=meresinski.eu; i=tomasz@meresinski.eu;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=hqPCegPJeX/Ry7agpxmBok0vX/8k1cwBMc60UNQIMGc=;
        b=NPVa0VJstiyOaSTToNKVS1OU5UupuHHoOwXKsojUesZJEyO6AjsT9x+LpBgGB+g7
        FV40TBOIguUZqNmzN1m3xIT6UwxwkoPsjtjotCgu8sdDKX6dyk1ms0NMeVlCubtbLz5
        3M3VnGm/UMbnk0rKuSOKgg/R76LSXWGiCMCNR0kg=
Received: from localhost.localdomain (78-11-200-65.static.ip.netia.com.pl [78.11.200.65]) by mx.zohomail.com
        with SMTPS id 1585506613099417.6913837527152; Sun, 29 Mar 2020 11:30:13 -0700 (PDT)
From:   =?UTF-8?q?Tomasz=20Meresi=C5=84ski?= <tomasz@meresinski.eu>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Tomasz=20Meresi=C5=84ski?= <tomasz@meresinski.eu>
Message-ID: <20200329182503.754-1-tomasz@meresinski.eu>
Subject: [PATCH RFC net-next] af_unix: eof in recvmsg after shutdown for nonblocking dgram socket
Date:   Sun, 29 Mar 2020 20:25:03 +0200
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling recvmsg() after shutdown(SHUT_RD) is a some kind of undocumented
behaviour. For blocking socket it just returns 0 (EOF), but for nonblocking
socket it returns -EAGAIN. It can cause some event loops to infinitely wait
for an event on this socket (https://github.com/tokio-rs/tokio/issues/1679)

Simple Python test case:
| import socket
|
| print('BLOCKING TEST')
| a =3D socket.socket(family=3Dsocket.AF_UNIX, type=3Dsocket.SOCK_DGRAM)
| a.shutdown(socket.SHUT_RD)
|
| result =3D a.recv(1)
| print('recv result ', result)
|
| a.close()
|
| print('NONBLOCKING TEST')
| type =3D socket.SOCK_DGRAM | socket.SOCK_NONBLOCK
| a =3D socket.socket(family=3Dsocket.AF_UNIX, type=3Dtype)
| a.shutdown(socket.SHUT_RD)
|
| try:
|     result =3D a.recv(1)
| except BlockingIOError:
|     print('Got Blocking IO Error')
| else:
|     print('recv result ', result)
|
| a.close()

Signed-off-by: Tomasz Meresi=C5=84ski <tomasz@meresinski.eu>
---
I'm not so sure about this patch because it can be called userspace API bre=
ak.=20
This sequence is now some kind of undefined behaviour - it's documented now=
here.
In the first place, I think that shutdown(SHUT_RD) should fail here as it d=
oes with AF_INET dgram socket.
On the other hand, there may be some user of this kind of shutdown() behavi=
our so it'd be too risky.

The problem here is that EAGAIN errno is used in event loops as we should w=
ait for the next events indicator.
It's not true here because there won't be any new events with this socket a=
s it's shut down.

 net/unix/af_unix.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3385a7a0b231..9458b11289c2 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2123,9 +2123,8 @@ static int unix_dgram_recvmsg(struct socket *sock, st=
ruct msghdr *msg,
=20
 =09if (!skb) { /* implies iolock unlocked */
 =09=09unix_state_lock(sk);
-=09=09/* Signal EOF on disconnected non-blocking SEQPACKET socket. */
-=09=09if (sk->sk_type =3D=3D SOCK_SEQPACKET && err =3D=3D -EAGAIN &&
-=09=09    (sk->sk_shutdown & RCV_SHUTDOWN))
+=09=09/* Signal EOF on disconnected socket. */
+=09=09if (err =3D=3D -EAGAIN && (sk->sk_shutdown & RCV_SHUTDOWN))
 =09=09=09err =3D 0;
 =09=09unix_state_unlock(sk);
 =09=09goto out;
--=20
2.17.1


