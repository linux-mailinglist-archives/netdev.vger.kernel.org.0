Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDC11989F4
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgCaC3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:29:17 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40251 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727524AbgCaC3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585621755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bMxprIBQqQRMXCnOZLQWsN8Wcsho2mjRA6po32bViiM=;
        b=L5IcHvCtjzQac/jCBW09vs/1Jq+CFiV6I6xI9IyQDft50eQ7Y5uCZJdpgRm/sBYFoFZw+C
        iOkC3Ky1+TGkCaiK5QnTJW2UUV6IYIxkVNT7uRlrcbXZA3BpsieZbIlDEJShN1dMignjD+
        R0ZYmnuyuZE2lWweQxBv2zRi/W4cHjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-ZKHOHFzsO8yWiccJCaSzJg-1; Mon, 30 Mar 2020 22:29:11 -0400
X-MC-Unique: ZKHOHFzsO8yWiccJCaSzJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 873B38017CE;
        Tue, 31 Mar 2020 02:29:10 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0C0D5DA60;
        Tue, 31 Mar 2020 02:29:04 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] vhost: make CONFIG_VHOST depend on CONFIG_EVENTFD
Date:   Tue, 31 Mar 2020 10:29:02 +0800
Message-Id: <20200331022902.12229-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit ec9d8449a99b ("vhost: refine vhost and vringh kconfig"),
CONFIG_VHOST could be enabled independently. This means we need make
CONFIG_VHOST depend on CONFIG_EVENTFD, otherwise we break compiling
without CONFIG_EVENTFD.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: ec9d8449a99b ("vhost: refine vhost and vringh kconfig")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 2a4efe39d79b..2be84b949e11 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -13,6 +13,7 @@ config VHOST_RING
=20
 menuconfig VHOST
 	tristate "Host kernel accelerator for virtio (VHOST)"
+	depends on EVENTFD
 	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
@@ -22,7 +23,7 @@ if VHOST
=20
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net"
-	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
+	depends on NET && (TUN || !TUN) && (TAP || !TAP)
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
@@ -33,7 +34,7 @@ config VHOST_NET
=20
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
-	depends on TARGET_CORE && EVENTFD
+	depends on TARGET_CORE
 	default n
 	---help---
 	Say M here to enable the vhost_scsi TCM fabric module
@@ -41,7 +42,7 @@ config VHOST_SCSI
=20
 config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
-	depends on VSOCKETS && EVENTFD
+	depends on VSOCKETS
 	select VIRTIO_VSOCKETS_COMMON
 	default n
 	---help---
@@ -54,7 +55,6 @@ config VHOST_VSOCK
=20
 config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
-	depends on EVENTFD
 	select VDPA
 	help
 	  This kernel module can be loaded in host kernel to accelerate
--=20
2.20.1

