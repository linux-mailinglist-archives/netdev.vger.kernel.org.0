Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6D6104EB9
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKUJGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:06:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47557 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726536AbfKUJGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:06:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574327189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9egh5b7xwjsLTuVN/9DiNDAdsm4VcF1D2PQsDXwp8QU=;
        b=foBHqsN9sLUYjuDKXmduN1JVEdiK94BgPYWOSjMoLJr8xGB/+ABiw0lgwsoFVqxe2XCS55
        cacu3EsVpwSf2oVu8WVXtpUlnjAP504hSU9Rfs1JdgDIP5TWEP5kifE0igsTQQut6mCXkO
        EhSN/2in+H8A0PngdAlEbpWRpDFVT+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-0jgRSI1QNcu9t_LkI622xw-1; Thu, 21 Nov 2019 04:06:16 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9B8C107ACC4;
        Thu, 21 Nov 2019 09:06:14 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-84.ams2.redhat.com [10.36.117.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9732E60BC9;
        Thu, 21 Nov 2019 09:06:10 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net-next] vsock: avoid to assign transport if its initialization fails
Date:   Thu, 21 Nov 2019 10:06:09 +0100
Message-Id: <20191121090609.13048-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 0jgRSI1QNcu9t_LkI622xw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If transport->init() fails, we can't assign the transport to the
socket, because it's not initialized correctly, and any future
calls to the transport callbacks would have an unexpected behavior.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reported-and-tested-by: syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.c=
om
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index cc8659838bf2..74db4cd637a7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -412,6 +412,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, stru=
ct vsock_sock *psk)
 =09const struct vsock_transport *new_transport;
 =09struct sock *sk =3D sk_vsock(vsk);
 =09unsigned int remote_cid =3D vsk->remote_addr.svm_cid;
+=09int ret;
=20
 =09switch (sk->sk_type) {
 =09case SOCK_DGRAM:
@@ -443,9 +444,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, str=
uct vsock_sock *psk)
 =09if (!new_transport || !try_module_get(new_transport->module))
 =09=09return -ENODEV;
=20
+=09ret =3D new_transport->init(vsk, psk);
+=09if (ret) {
+=09=09module_put(new_transport->module);
+=09=09return ret;
+=09}
+
 =09vsk->transport =3D new_transport;
=20
-=09return vsk->transport->init(vsk, psk);
+=09return 0;
 }
 EXPORT_SYMBOL_GPL(vsock_assign_transport);
=20
--=20
2.21.0

