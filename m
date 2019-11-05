Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D31EF983
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbfKEJfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:35:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47702 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730556AbfKEJfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572946531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kyIvhY3BXMqZ4TEtR3KTmpEF86AeFHO8xa0fKWzJeAE=;
        b=cuBY46yaKkkgRzyTHANatBlK/jcMqCt7aXwPYvbKyE8qnazUZkq60/+s2juvIGLIdfBcIb
        FxczS0h/r1iRwLm5/IPEXjaSesapWEHsfTIUtzxT4Xc8kMjV72+PwdZwGmt0c3ZG8/Pim0
        oS4IvIUzTfwL7UHQh+3k4ztC+jLmVW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-3k4XrvtANoupEgdGxq9KMA-1; Tue, 05 Nov 2019 04:35:26 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 310D8107ACC2;
        Tue,  5 Nov 2019 09:35:22 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-252.pek2.redhat.com [10.72.12.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5F955C28D;
        Tue,  5 Nov 2019 09:34:25 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V8 2/6] modpost: add support for mdev class id
Date:   Tue,  5 Nov 2019 17:32:36 +0800
Message-Id: <20191105093240.5135-3-jasowang@redhat.com>
In-Reply-To: <20191105093240.5135-1-jasowang@redhat.com>
References: <20191105093240.5135-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 3k4XrvtANoupEgdGxq9KMA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to parse mdev class id table.

Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vfio/mdev/vfio_mdev.c     |  2 ++
 scripts/mod/devicetable-offsets.c |  3 +++
 scripts/mod/file2alias.c          | 11 +++++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 38431e9ef7f5..a6641cd8b5a3 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -125,6 +125,8 @@ static const struct mdev_class_id vfio_id_table[] =3D {
 =09{ 0 },
 };
=20
+MODULE_DEVICE_TABLE(mdev, vfio_id_table);
+
 static struct mdev_driver vfio_mdev_driver =3D {
 =09.name=09=3D "vfio_mdev",
 =09.probe=09=3D vfio_mdev_probe,
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-of=
fsets.c
index 054405b90ba4..6cbb1062488a 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -231,5 +231,8 @@ int main(void)
 =09DEVID(wmi_device_id);
 =09DEVID_FIELD(wmi_device_id, guid_string);
=20
+=09DEVID(mdev_class_id);
+=09DEVID_FIELD(mdev_class_id, id);
+
 =09return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index c91eba751804..45f1c22f49be 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1335,6 +1335,16 @@ static int do_wmi_entry(const char *filename, void *=
symval, char *alias)
 =09return 1;
 }
=20
+/* looks like: "mdev:cN" */
+static int do_mdev_entry(const char *filename, void *symval, char *alias)
+{
+=09DEF_FIELD(symval, mdev_class_id, id);
+
+=09sprintf(alias, "mdev:c%02X", id);
+=09add_wildcard(alias);
+=09return 1;
+}
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
@@ -1407,6 +1417,7 @@ static const struct devtable devtable[] =3D {
 =09{"typec", SIZE_typec_device_id, do_typec_entry},
 =09{"tee", SIZE_tee_client_device_id, do_tee_entry},
 =09{"wmi", SIZE_wmi_device_id, do_wmi_entry},
+=09{"mdev", SIZE_mdev_class_id, do_mdev_entry},
 };
=20
 /* Create MODULE_ALIAS() statements.
--=20
2.19.1

