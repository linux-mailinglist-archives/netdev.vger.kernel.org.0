Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCE2E16FE
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404181AbfJWJ6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:58:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404163AbfJWJ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571824685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqP3dJ1brA8cGs8/CpAJOebSHgUeA3445b36b/tPldY=;
        b=bGQafF94Ck8ePqBhwFS7/Y4CoaEexh4606NxCyDAy867lY9Z9HBjLLf/WAzPUvlE/sgf1S
        NazwyGBKs4wVdS+2kx/qvVt8KzVax9TFpIP8mMhZBOB90eCIQlar696MQYHU52r+CQ6Wzi
        pZoXkVbdJHtd/AVNFoXqbso9FaoHrFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-qOIRmXb2Pr6t1CnVGBFM1A-1; Wed, 23 Oct 2019 05:58:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 226C6107AD33;
        Wed, 23 Oct 2019 09:58:00 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.36.118.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF2B05C1B2;
        Wed, 23 Oct 2019 09:57:56 +0000 (UTC)
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
Subject: [PATCH net-next 09/14] vsock: move vsock_insert_unbound() in the vsock_create()
Date:   Wed, 23 Oct 2019 11:55:49 +0200
Message-Id: <20191023095554.11340-10-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-1-sgarzare@redhat.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: qOIRmXb2Pr6t1CnVGBFM1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsock_insert_unbound() was called only when 'sock' parameter of
__vsock_create() was not null. This only happened when
__vsock_create() was called by vsock_create().

In order to simplify the multi-transports support, this patch
moves vsock_insert_unbound() at the end of vsock_create().

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 95878bed2c67..d89381166028 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -634,9 +634,6 @@ static struct sock *__vsock_create(struct net *net,
 =09=09return NULL;
 =09}
=20
-=09if (sock)
-=09=09vsock_insert_unbound(vsk);
-
 =09return sk;
 }
=20
@@ -1889,6 +1886,8 @@ static const struct proto_ops vsock_stream_ops =3D {
 static int vsock_create(struct net *net, struct socket *sock,
 =09=09=09int protocol, int kern)
 {
+=09struct sock *sk;
+
 =09if (!sock)
 =09=09return -EINVAL;
=20
@@ -1908,7 +1907,13 @@ static int vsock_create(struct net *net, struct sock=
et *sock,
=20
 =09sock->state =3D SS_UNCONNECTED;
=20
-=09return __vsock_create(net, sock, NULL, GFP_KERNEL, 0, kern) ? 0 : -ENOM=
EM;
+=09sk =3D __vsock_create(net, sock, NULL, GFP_KERNEL, 0, kern);
+=09if (!sk)
+=09=09return -ENOMEM;
+
+=09vsock_insert_unbound(vsock_sk(sk));
+
+=09return 0;
 }
=20
 static const struct net_proto_family vsock_family_ops =3D {
--=20
2.21.0

