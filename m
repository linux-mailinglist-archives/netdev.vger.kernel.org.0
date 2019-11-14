Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76930FC35A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfKNJ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:59:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56742 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727468AbfKNJ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:59:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nu0yPVo2t8kvxGjmnqTgJhZpgUXn70sTDOZCfKce5fY=;
        b=PJ9W57fcos19PWf9BZjw876Hau8ZmEEDTDoTMbiXkdrEWbLVwlMdfqeypUEwMTKiOyvbWM
        bhcnAzUbrASPAjeMfMITVco5ISjuKkAV8fYKRN15leRd752dz7tb1cky6CIXnghqOLgmQN
        sJY210jmI9aU4gL/iojpscpzIT87rn8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-wx_r584HNmK06xdQQpHKZg-1; Thu, 14 Nov 2019 04:59:16 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E28D1100550E;
        Thu, 14 Nov 2019 09:59:13 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEC87A7F1;
        Thu, 14 Nov 2019 09:59:07 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Subject: [PATCH net-next v2 14/15] vsock: fix bind() behaviour taking care of CID
Date:   Thu, 14 Nov 2019 10:57:49 +0100
Message-Id: <20191114095750.59106-15-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: wx_r584HNmK06xdQQpHKZg-1
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
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5cb0ae42d916..cc8659838bf2 100644
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

