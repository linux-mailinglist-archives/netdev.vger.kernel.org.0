Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A376BFC357
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfKNJ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:59:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28771 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727498AbfKNJ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6p99asKfS17+1LG2xwN+D8QSOUVOyNnDSLD47Fl13g=;
        b=aGh47xNqfzE9HVzs0pywmRl9zAvBrLZr5l0oVvMtsiJXFkz0Zu7zPQJX6fEXvm8YBf61Qv
        6SNxXZBD9KTVuQlyrnmp5B0fSyVzABV49aswz5kgxCpAOjU8zho7dnRDb4C2XXJ/CPU4JG
        pq2nxoXerhmb9wWjOwFBSzvOxgQdeW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-e3OCytPZPqa2rbdTCFHZcQ-1; Thu, 14 Nov 2019 04:59:21 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F308E800052;
        Thu, 14 Nov 2019 09:59:19 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D826165DB;
        Thu, 14 Nov 2019 09:59:14 +0000 (UTC)
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
Subject: [PATCH net-next v2 15/15] vhost/vsock: refuse CID assigned to the guest->host transport
Date:   Thu, 14 Nov 2019 10:57:50 +0100
Message-Id: <20191114095750.59106-16-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: e3OCytPZPqa2rbdTCFHZcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a nested VM environment, we have to refuse to assign to a nested
guest the same CID assigned to our guest->host transport.
In this way, the user can use the local CID for loopback.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index fdda9ec625ad..dde392b91bb3 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -718,6 +718,12 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vso=
ck, u64 guest_cid)
 =09if (guest_cid > U32_MAX)
 =09=09return -EINVAL;
=20
+=09/* Refuse if CID is assigned to the guest->host transport (i.e. nested
+=09 * VM), to make the loopback work.
+=09 */
+=09if (vsock_find_cid(guest_cid))
+=09=09return -EADDRINUSE;
+
 =09/* Refuse if CID is already in use */
 =09mutex_lock(&vhost_vsock_mutex);
 =09other =3D vhost_vsock_get(guest_cid);
--=20
2.21.0

