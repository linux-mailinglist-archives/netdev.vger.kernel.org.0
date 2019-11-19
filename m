Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D176E10228D
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfKSLCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:02:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25126 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727574AbfKSLBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:01:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574161297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T66mtYm8lDvmwsPXa8hv/C73lP40srzfZe7JrCqVWC4=;
        b=RmHjFvaxHvwzWzyOJiBVvsezAIv0r/OB43GPB5pVK4BCvJyJUaHHAZq8Md7iDUP0xkyghN
        uvCp46v4fbDTJSi0dvUlmxN6kNq/vE7s5AfQ3+XZ3FKnZMkVIfLW+S4iE6c2ftdJCkTann
        ipNDJ4h+oIZGDo9MzU29hmyM+zDBw9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-eXNRSMGfNiiN3YXcMwWmdQ-1; Tue, 19 Nov 2019 06:01:33 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 216D51005511;
        Tue, 19 Nov 2019 11:01:32 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-41.ams2.redhat.com [10.36.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5AB60BE0;
        Tue, 19 Nov 2019 11:01:30 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net-next 2/6] vsock: add VMADDR_CID_LOCAL definition
Date:   Tue, 19 Nov 2019 12:01:17 +0100
Message-Id: <20191119110121.14480-3-sgarzare@redhat.com>
In-Reply-To: <20191119110121.14480-1-sgarzare@redhat.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: eXNRSMGfNiiN3YXcMwWmdQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VMADDR_CID_RESERVED (1) was used by VMCI, but now it is not
used anymore, so we can reuse it for local communication
(loopback) adding the new well-know CID: VMADDR_CID_LOCAL.

Cc: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/uapi/linux/vm_sockets.h | 8 +++++---
 net/vmw_vsock/vmci_transport.c  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_socket=
s.h
index 68d57c5e99bc..fd0ed7221645 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -99,11 +99,13 @@
=20
 #define VMADDR_CID_HYPERVISOR 0
=20
-/* This CID is specific to VMCI and can be considered reserved (even VMCI
- * doesn't use it anymore, it's a legacy value from an older release).
+/* Use this as the destination CID in an address when referring to the
+ * local communication (loopback).
+ * (This was VMADDR_CID_RESERVED, but even VMCI doesn't use it anymore,
+ * it was a legacy value from an older release).
  */
=20
-#define VMADDR_CID_RESERVED 1
+#define VMADDR_CID_LOCAL 1
=20
 /* Use this as the destination CID in an address when referring to the hos=
t
  * (any process other than the hypervisor).  VMCI relies on it being 2, bu=
t
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 644d32e43d23..4b8b1150a738 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -648,7 +648,7 @@ static int vmci_transport_recv_dgram_cb(void *data, str=
uct vmci_datagram *dg)
 static bool vmci_transport_stream_allow(u32 cid, u32 port)
 {
 =09static const u32 non_socket_contexts[] =3D {
-=09=09VMADDR_CID_RESERVED,
+=09=09VMADDR_CID_LOCAL,
 =09};
 =09int i;
=20
--=20
2.21.0

