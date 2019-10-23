Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A386E1711
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404264AbfJWJ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:58:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404288AbfJWJ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4hlyQY7efj0/bE9XNJxDmJdAwsinzkA8wmlvgDq7ouo=;
        b=LkwAFtJxZx4d9g6scNqz3O61ZS2i3JD8o5XKPzdy0WzXyXys+edt4zzustuTI9YzG0Ssa8
        fBgoiuC00vSuH7hYP+Isjq6A+8r79y3L/8wJc811r6h1HLscSNUv05+3IAjOsQ+GJWhLZ3
        HGljaNTNRfx5anLeDVDUwBCbsjUGwE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-ra2LyVtEPBinyv25NmhJEg-1; Wed, 23 Oct 2019 05:58:27 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5DE41005500;
        Wed, 23 Oct 2019 09:58:25 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 156735C1B2;
        Wed, 23 Oct 2019 09:58:19 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 14/14] vsock: fix bind() behaviour taking care of CID
Date:   Wed, 23 Oct 2019 11:55:54 +0200
Message-Id: <20191023095554.11340-15-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ra2LyVtEPBinyv25NmhJEg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we are looking for a socket bound to a specific address,
we also have to take into account the CID.

This patch is useful with multi-transports support because it
allows the binding of the same port with different CID, and
it prevents a connection to a wrong socket bound to the same
port, but with different CID.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 1f2e707cae66..7183de277072 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -228,10 +228,16 @@ static struct sock *__vsock_find_bound_socket(struct =
sockaddr_vm *addr)
 {
 =09struct vsock_sock *vsk;
=20
-=09list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table)
-=09=09if (addr->svm_port =3D=3D vsk->local_addr.svm_port)
+=09list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
+=09=09if (vsock_addr_equals_addr(addr, &vsk->local_addr))
 =09=09=09return sk_vsock(vsk);
=20
+=09=09if (addr->svm_port =3D=3D vsk->local_addr.svm_port &&
+=09=09    (vsk->local_addr.svm_cid =3D=3D VMADDR_CID_ANY ||
+=09=09     addr->svm_cid =3D=3D VMADDR_CID_ANY))
+=09=09=09return sk_vsock(vsk);
+=09}
+
 =09return NULL;
 }
=20
--=20
2.21.0

