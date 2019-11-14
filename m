Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC4FC352
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfKNJ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:59:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40726 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbfKNJ7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:59:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPRT3RdAnjmUAI+8hXqxtD1gQcxUr+7rHQkk20HvAA0=;
        b=LM4ZH7PklFdQmv1tcSxEunUPlg//ZN1r4fVZIhfXZtBB9NIljxKG3FlCWGaWo52f6mQDRb
        JB1gadWnbSWFYjHnSe1TSnwhnIfukkU5gvQ9xgSXhKTnu4GG/u/SwKQMUD2ZCOqkUZ64oP
        yITIGCZhX5TnRpLo4nugwx+vWN1bado=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-4Oe8ysdwNt-ixXAyBeJz3A-1; Thu, 14 Nov 2019 04:59:06 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2C90800C73;
        Thu, 14 Nov 2019 09:59:03 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FEE219757;
        Thu, 14 Nov 2019 09:59:00 +0000 (UTC)
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
Subject: [PATCH net-next v2 12/15] vsock/vmci: register vmci_transport only when VMCI guest/host are active
Date:   Thu, 14 Nov 2019 10:57:47 +0100
Message-Id: <20191114095750.59106-13-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 4Oe8ysdwNt-ixXAyBeJz3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow other transports to be loaded with vmci_transport,
we register the vmci_transport as G2H or H2G only when a VMCI guest
or host is active.

To do that, this patch adds a callback registered in the vmci driver
that will be called when the host or guest becomes active.
This callback will register the vmci_transport in the VSOCK core.

Cc: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v1 -> v2
- removed features variable in vmci_transport_init() [Stefan]
- added a flag to register only once the host [Jorgen]
---
 drivers/misc/vmw_vmci/vmci_driver.c | 67 +++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_driver.h |  2 +
 drivers/misc/vmw_vmci/vmci_guest.c  |  2 +
 drivers/misc/vmw_vmci/vmci_host.c   |  7 +++
 include/linux/vmw_vmci_api.h        |  2 +
 net/vmw_vsock/vmci_transport.c      | 33 +++++++++-----
 6 files changed, 102 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/vm=
ci_driver.c
index 819e35995d32..95fed4664a2d 100644
--- a/drivers/misc/vmw_vmci/vmci_driver.c
+++ b/drivers/misc/vmw_vmci/vmci_driver.c
@@ -28,6 +28,10 @@ MODULE_PARM_DESC(disable_guest,
 static bool vmci_guest_personality_initialized;
 static bool vmci_host_personality_initialized;
=20
+static DEFINE_MUTEX(vmci_vsock_mutex); /* protects vmci_vsock_transport_cb=
 */
+static vmci_vsock_cb vmci_vsock_transport_cb;
+bool vmci_vsock_cb_host_called;
+
 /*
  * vmci_get_context_id() - Gets the current context ID.
  *
@@ -45,6 +49,69 @@ u32 vmci_get_context_id(void)
 }
 EXPORT_SYMBOL_GPL(vmci_get_context_id);
=20
+/*
+ * vmci_register_vsock_callback() - Register the VSOCK vmci_transport call=
back.
+ *
+ * The callback will be called when the first host or guest becomes active=
,
+ * or if they are already active when this function is called.
+ * To unregister the callback, call this function with NULL parameter.
+ *
+ * Returns 0 on success. -EBUSY if a callback is already registered.
+ */
+int vmci_register_vsock_callback(vmci_vsock_cb callback)
+{
+=09int err =3D 0;
+
+=09mutex_lock(&vmci_vsock_mutex);
+
+=09if (vmci_vsock_transport_cb && callback) {
+=09=09err =3D -EBUSY;
+=09=09goto out;
+=09}
+
+=09vmci_vsock_transport_cb =3D callback;
+
+=09if (!vmci_vsock_transport_cb) {
+=09=09vmci_vsock_cb_host_called =3D false;
+=09=09goto out;
+=09}
+
+=09if (vmci_guest_code_active())
+=09=09vmci_vsock_transport_cb(false);
+
+=09if (vmci_host_users() > 0) {
+=09=09vmci_vsock_cb_host_called =3D true;
+=09=09vmci_vsock_transport_cb(true);
+=09}
+
+out:
+=09mutex_unlock(&vmci_vsock_mutex);
+=09return err;
+}
+EXPORT_SYMBOL_GPL(vmci_register_vsock_callback);
+
+void vmci_call_vsock_callback(bool is_host)
+{
+=09mutex_lock(&vmci_vsock_mutex);
+
+=09if (!vmci_vsock_transport_cb)
+=09=09goto out;
+
+=09/* In the host, this function could be called multiple times,
+=09 * but we want to register it only once.
+=09 */
+=09if (is_host) {
+=09=09if (vmci_vsock_cb_host_called)
+=09=09=09goto out;
+
+=09=09vmci_vsock_cb_host_called =3D true;
+=09}
+
+=09vmci_vsock_transport_cb(is_host);
+out:
+=09mutex_unlock(&vmci_vsock_mutex);
+}
+
 static int __init vmci_drv_init(void)
 {
 =09int vmci_err;
diff --git a/drivers/misc/vmw_vmci/vmci_driver.h b/drivers/misc/vmw_vmci/vm=
ci_driver.h
index aab81b67670c..990682480bf6 100644
--- a/drivers/misc/vmw_vmci/vmci_driver.h
+++ b/drivers/misc/vmw_vmci/vmci_driver.h
@@ -36,10 +36,12 @@ extern struct pci_dev *vmci_pdev;
=20
 u32 vmci_get_context_id(void);
 int vmci_send_datagram(struct vmci_datagram *dg);
+void vmci_call_vsock_callback(bool is_host);
=20
 int vmci_host_init(void);
 void vmci_host_exit(void);
 bool vmci_host_code_active(void);
+int vmci_host_users(void);
=20
 int vmci_guest_init(void);
 void vmci_guest_exit(void);
diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmc=
i_guest.c
index 7a84a48c75da..cc8eeb361fcd 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -637,6 +637,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev=
,
 =09=09  vmci_dev->iobase + VMCI_CONTROL_ADDR);
=20
 =09pci_set_drvdata(pdev, vmci_dev);
+
+=09vmci_call_vsock_callback(false);
 =09return 0;
=20
 err_free_irq:
diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci=
_host.c
index 833e2bd248a5..ff3c396146ff 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -108,6 +108,11 @@ bool vmci_host_code_active(void)
 =09     atomic_read(&vmci_host_active_users) > 0);
 }
=20
+int vmci_host_users(void)
+{
+=09return atomic_read(&vmci_host_active_users);
+}
+
 /*
  * Called on open of /dev/vmci.
  */
@@ -338,6 +343,8 @@ static int vmci_host_do_init_context(struct vmci_host_d=
ev *vmci_host_dev,
 =09vmci_host_dev->ct_type =3D VMCIOBJ_CONTEXT;
 =09atomic_inc(&vmci_host_active_users);
=20
+=09vmci_call_vsock_callback(true);
+
 =09retval =3D 0;
=20
 out:
diff --git a/include/linux/vmw_vmci_api.h b/include/linux/vmw_vmci_api.h
index acd9fafe4fc6..f28907345c80 100644
--- a/include/linux/vmw_vmci_api.h
+++ b/include/linux/vmw_vmci_api.h
@@ -19,6 +19,7 @@
 struct msghdr;
 typedef void (vmci_device_shutdown_fn) (void *device_registration,
 =09=09=09=09=09void *user_data);
+typedef void (*vmci_vsock_cb) (bool is_host);
=20
 int vmci_datagram_create_handle(u32 resource_id, u32 flags,
 =09=09=09=09vmci_datagram_recv_cb recv_cb,
@@ -37,6 +38,7 @@ int vmci_doorbell_destroy(struct vmci_handle handle);
 int vmci_doorbell_notify(struct vmci_handle handle, u32 priv_flags);
 u32 vmci_get_context_id(void);
 bool vmci_is_context_owner(u32 context_id, kuid_t uid);
+int vmci_register_vsock_callback(vmci_vsock_cb callback);
=20
 int vmci_event_subscribe(u32 event,
 =09=09=09 vmci_event_cb callback, void *callback_data,
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.=
c
index 86030ecb53dd..d9c9c834ad6f 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2054,19 +2054,21 @@ static bool vmci_check_transport(struct vsock_sock =
*vsk)
 =09return vsk->transport =3D=3D &vmci_transport;
 }
=20
-static int __init vmci_transport_init(void)
+void vmci_vsock_transport_cb(bool is_host)
 {
-=09int features =3D VSOCK_TRANSPORT_F_DGRAM | VSOCK_TRANSPORT_F_H2G;
-=09int cid;
-=09int err;
+=09int features;
=20
-=09cid =3D vmci_get_context_id();
+=09if (is_host)
+=09=09features =3D VSOCK_TRANSPORT_F_H2G;
+=09else
+=09=09features =3D VSOCK_TRANSPORT_F_G2H;
=20
-=09if (cid =3D=3D VMCI_INVALID_ID)
-=09=09return -EINVAL;
+=09vsock_core_register(&vmci_transport, features);
+}
=20
-=09if (cid !=3D VMCI_HOST_CONTEXT_ID)
-=09=09features |=3D VSOCK_TRANSPORT_F_G2H;
+static int __init vmci_transport_init(void)
+{
+=09int err;
=20
 =09/* Create the datagram handle that we will use to send and receive all
 =09 * VSocket control messages for this context.
@@ -2080,7 +2082,6 @@ static int __init vmci_transport_init(void)
 =09=09pr_err("Unable to create datagram handle. (%d)\n", err);
 =09=09return vmci_transport_error_to_vsock_error(err);
 =09}
-
 =09err =3D vmci_event_subscribe(VMCI_EVENT_QP_RESUMED,
 =09=09=09=09   vmci_transport_qp_resumed_cb,
 =09=09=09=09   NULL, &vmci_transport_qp_resumed_sub_id);
@@ -2091,12 +2092,21 @@ static int __init vmci_transport_init(void)
 =09=09goto err_destroy_stream_handle;
 =09}
=20
-=09err =3D vsock_core_register(&vmci_transport, features);
+=09/* Register only with dgram feature, other features (H2G, G2H) will be
+=09 * registered when the first host or guest becomes active.
+=09 */
+=09err =3D vsock_core_register(&vmci_transport, VSOCK_TRANSPORT_F_DGRAM);
 =09if (err < 0)
 =09=09goto err_unsubscribe;
=20
+=09err =3D vmci_register_vsock_callback(vmci_vsock_transport_cb);
+=09if (err < 0)
+=09=09goto err_unregister;
+
 =09return 0;
=20
+err_unregister:
+=09vsock_core_unregister(&vmci_transport);
 err_unsubscribe:
 =09vmci_event_unsubscribe(vmci_transport_qp_resumed_sub_id);
 err_destroy_stream_handle:
@@ -2122,6 +2132,7 @@ static void __exit vmci_transport_exit(void)
 =09=09vmci_transport_qp_resumed_sub_id =3D VMCI_INVALID_ID;
 =09}
=20
+=09vmci_register_vsock_callback(NULL);
 =09vsock_core_unregister(&vmci_transport);
 }
 module_exit(vmci_transport_exit);
--=20
2.21.0

