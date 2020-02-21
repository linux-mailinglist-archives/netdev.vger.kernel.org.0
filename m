Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE8167B7F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBULHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:07:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52533 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbgBULHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:07:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582283231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4kIIIjMqTYsRdUJ8TW9Ts/lWmHycKGBkTxfc9vga4Ow=;
        b=i4ICu2M8p7HKp7nA54qNyn7Lgx7lXWgoJ/1IFB4NysRzgp/RcpI//EO2ivp7HV7eMwfuu9
        TOBhvXLEyHbOXf86DY6RsHcZKFm43NQ2XoAC8TtBuUaNIkUIv4kdp6nvWkVu7vDB7oKm53
        402bMEFwOIxOIuRzcWyKY+ER7l0B6/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-B40GITilO5aQ4FQuPBp4bA-1; Fri, 21 Feb 2020 06:07:06 -0500
X-MC-Unique: B40GITilO5aQ4FQuPBp4bA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C4681882CCC;
        Fri, 21 Feb 2020 11:07:04 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-117-58.ams2.redhat.com [10.36.117.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7B1319C6A;
        Fri, 21 Feb 2020 11:06:59 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        eperezma@redhat.com
Subject: [PATCH] vhost: Check docket sk_family instead of call getname
Date:   Fri, 21 Feb 2020 12:06:56 +0100
Message-Id: <20200221110656.11811-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing so, we save one call to get data we already have in the struct.

Also, since there is no guarantee that getname use sockaddr_ll
parameter beyond its size, we add a little bit of security here.
It should do not do beyond MAX_ADDR_LEN, but syzbot found that
ax25_getname writes more (72 bytes, the size of full_sockaddr_ax25,
versus 20 + 32 bytes of sockaddr_ll + MAX_ADDR_LEN in syzbot repro).

Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
Reported-by: syzbot+f2a62d07a5198c819c7b@syzkaller.appspotmail.com
Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/net.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e158159671fa..18e205eeb9af 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1414,10 +1414,6 @@ static int vhost_net_release(struct inode *inode, =
struct file *f)
=20
 static struct socket *get_raw_socket(int fd)
 {
-	struct {
-		struct sockaddr_ll sa;
-		char  buf[MAX_ADDR_LEN];
-	} uaddr;
 	int r;
 	struct socket *sock =3D sockfd_lookup(fd, &r);
=20
@@ -1430,11 +1426,7 @@ static struct socket *get_raw_socket(int fd)
 		goto err;
 	}
=20
-	r =3D sock->ops->getname(sock, (struct sockaddr *)&uaddr.sa, 0);
-	if (r < 0)
-		goto err;
-
-	if (uaddr.sa.sll_family !=3D AF_PACKET) {
+	if (sock->sk->sk_family !=3D AF_PACKET) {
 		r =3D -EPFNOSUPPORT;
 		goto err;
 	}
--=20
2.18.1

