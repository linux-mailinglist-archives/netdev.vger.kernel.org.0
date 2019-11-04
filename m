Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F60EE046
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 13:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfKDMoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 07:44:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729006AbfKDMoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 07:44:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572871443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kyIvhY3BXMqZ4TEtR3KTmpEF86AeFHO8xa0fKWzJeAE=;
        b=hQx3J7wwzZYathJFMs1CPLKp1dRrrstUaIudRdC+DnrIXwucqXpAi+Y6Ek/jH2RPqDeUfZ
        MyEzihIjzH5I+gTCnwjoEJ9QwLuGsdfkaf31ajfnv8mj1LB9IbV4ab+9Ph6vsKIRKzx/+z
        WaSzWT6q+c4a31yuuV61/pZvoJfketk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-vRISspVuMJ6kcJukeiQ94w-1; Mon, 04 Nov 2019 07:43:57 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 738DC1005500;
        Mon,  4 Nov 2019 12:43:53 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DDB060CD0;
        Mon,  4 Nov 2019 12:43:00 +0000 (UTC)
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
Subject: [PATCH V7 2/6] modpost: add support for mdev class id
Date:   Mon,  4 Nov 2019 20:39:48 +0800
Message-Id: <20191104123952.17276-3-jasowang@redhat.com>
In-Reply-To: <20191104123952.17276-1-jasowang@redhat.com>
References: <20191104123952.17276-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: vRISspVuMJ6kcJukeiQ94w-1
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

