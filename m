Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589C81922A5
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCYI3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 04:29:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:30798 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727272AbgCYI3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585124943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQAMj9E7pnEO97gxazN0awVnwRs79iDcGQ6g5ZjNfoc=;
        b=NKhz9wsoP2r+XrbId9UXhxV9iY+hQ3OkG3YsAFSncWLLz9VPOdrjiprxPMRGgkP4zttVxi
        1kg+0dk4R9XEQjDKT+/4iZ45E+Em5qaqLfvf5U9XkiPvRkpkYe6J/oyvcLlHuLr9uHwWfK
        C6g2bsh7A9r4/pZjDY3eI2kmApGKZxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-VuGpK1WMOQyXGxruIzwHmA-1; Wed, 25 Mar 2020 04:28:58 -0400
X-MC-Unique: VuGpK1WMOQyXGxruIzwHmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34C9CDBA3;
        Wed, 25 Mar 2020 08:28:56 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-14-13.pek2.redhat.com [10.72.14.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0E371C947;
        Wed, 25 Mar 2020 08:28:06 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V8 1/9] vhost: refine vhost and vringh kconfig
Date:   Wed, 25 Mar 2020 16:27:03 +0800
Message-Id: <20200325082711.1107-2-jasowang@redhat.com>
In-Reply-To: <20200325082711.1107-1-jasowang@redhat.com>
References: <20200325082711.1107-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
not necessarily for VM since it's a generic userspace and kernel
communication protocol. Such dependency may prevent archs without
virtualization support from using vhost.

To solve this, a dedicated vhost menu is created under drivers so
CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.

While at it, also squash Kconfig.vringh into vhost Kconfig file. This
avoids the trick of conditional inclusion from VOP or CAIF. Then it
will be easier to introduce new vringh users and common dependency for
both vringh and vhost.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 arch/arm/kvm/Kconfig         |  2 --
 arch/arm64/kvm/Kconfig       |  2 --
 arch/mips/kvm/Kconfig        |  2 --
 arch/powerpc/kvm/Kconfig     |  2 --
 arch/s390/kvm/Kconfig        |  4 ----
 arch/x86/kvm/Kconfig         |  4 ----
 drivers/Kconfig              |  2 ++
 drivers/misc/mic/Kconfig     |  4 ----
 drivers/net/caif/Kconfig     |  4 ----
 drivers/vhost/Kconfig        | 23 ++++++++++++++---------
 drivers/vhost/Kconfig.vringh |  6 ------
 11 files changed, 16 insertions(+), 39 deletions(-)
 delete mode 100644 drivers/vhost/Kconfig.vringh

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index f591026347a5..be97393761bf 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -54,6 +54,4 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
=20
-source "drivers/vhost/Kconfig"
-
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a475c68cbfec..449386d76441 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -64,6 +64,4 @@ config KVM_ARM_PMU
 config KVM_INDIRECT_VECTORS
        def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
=20
-source "drivers/vhost/Kconfig"
-
 endif # VIRTUALIZATION
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index eac25aef21e0..b91d145aa2d5 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -72,6 +72,4 @@ config KVM_MIPS_DEBUG_COP0_COUNTERS
=20
 	  If unsure, say N.
=20
-source "drivers/vhost/Kconfig"
-
 endif # VIRTUALIZATION
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 711fca9bc6f0..12885eda324e 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -204,6 +204,4 @@ config KVM_XIVE
 	default y
 	depends on KVM_XICS && PPC_XIVE_NATIVE && KVM_BOOK3S_HV_POSSIBLE
=20
-source "drivers/vhost/Kconfig"
-
 endif # VIRTUALIZATION
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index d3db3d7ed077..def3b60f1fe8 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -55,8 +55,4 @@ config KVM_S390_UCONTROL
=20
 	  If unsure, say N.
=20
-# OK, it's a little counter-intuitive to do this, but it puts it neatly =
under
-# the virtualization menu.
-source "drivers/vhost/Kconfig"
-
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 991019d5eee1..0dfe70e17af9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -94,8 +94,4 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
=20
-# OK, it's a little counter-intuitive to do this, but it puts it neatly =
under
-# the virtualization menu.
-source "drivers/vhost/Kconfig"
-
 endif # VIRTUALIZATION
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 8befa53f43be..7a6d8b2b68b4 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -138,6 +138,8 @@ source "drivers/virt/Kconfig"
=20
 source "drivers/virtio/Kconfig"
=20
+source "drivers/vhost/Kconfig"
+
 source "drivers/hv/Kconfig"
=20
 source "drivers/xen/Kconfig"
diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index b6841ba6d922..8f201d019f5a 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -133,8 +133,4 @@ config VOP
 	  OS and tools for MIC to use with this driver are available from
 	  <http://software.intel.com/en-us/mic-developer>.
=20
-if VOP
-source "drivers/vhost/Kconfig.vringh"
-endif
-
 endmenu
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index e74e2bb61236..9db0570c5beb 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -58,8 +58,4 @@ config CAIF_VIRTIO
 	---help---
 	  The CAIF driver for CAIF over Virtio.
=20
-if CAIF_VIRTIO
-source "drivers/vhost/Kconfig.vringh"
-endif
-
 endif # CAIF_DRIVERS
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 3d03ccbd1adc..4aef10a54cd1 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,8 +1,20 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config VHOST_RING
+	tristate
+	help
+	  This option is selected by any driver which needs to access
+	  the host side of a virtio ring.
+
+menuconfig VHOST
+	tristate "Host kernel accelerator for virtio (VHOST)"
+	help
+	  This option is selected by any driver which needs to access
+	  the core of vhost.
+if VHOST
+
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net"
 	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
-	select VHOST
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest networking with virtio_net. Not to be confused with virtio_net
@@ -14,7 +26,6 @@ config VHOST_NET
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
 	depends on TARGET_CORE && EVENTFD
-	select VHOST
 	default n
 	---help---
 	Say M here to enable the vhost_scsi TCM fabric module
@@ -24,7 +35,6 @@ config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
 	depends on VSOCKETS && EVENTFD
 	select VIRTIO_VSOCKETS_COMMON
-	select VHOST
 	default n
 	---help---
 	This kernel module can be loaded in the host kernel to provide AF_VSOCK
@@ -34,12 +44,6 @@ config VHOST_VSOCK
 	To compile this driver as a module, choose M here: the module will be c=
alled
 	vhost_vsock.
=20
-config VHOST
-	tristate
-	---help---
-	  This option is selected by any driver which needs to access
-	  the core of vhost.
-
 config VHOST_CROSS_ENDIAN_LEGACY
 	bool "Cross-endian support for vhost"
 	default n
@@ -54,3 +58,4 @@ config VHOST_CROSS_ENDIAN_LEGACY
 	  adds some overhead, it is disabled by default.
=20
 	  If unsure, say "N".
+endif
diff --git a/drivers/vhost/Kconfig.vringh b/drivers/vhost/Kconfig.vringh
deleted file mode 100644
index c1fe36a9b8d4..000000000000
--- a/drivers/vhost/Kconfig.vringh
+++ /dev/null
@@ -1,6 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-config VHOST_RING
-	tristate
-	---help---
-	  This option is selected by any driver which needs to access
-	  the host side of a virtio ring.
--=20
2.20.1

