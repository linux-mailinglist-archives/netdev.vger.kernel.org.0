Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11FD1BE0CB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgD2OX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:23:27 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59573 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgD2OX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:23:26 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N7iOw-1j8KpB09eU-014iMZ; Wed, 29 Apr 2020 16:23:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Tiwei Bie <tiwei.bie@intel.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: fix default for vhost_iotlb
Date:   Wed, 29 Apr 2020 16:23:04 +0200
Message-Id: <20200429142317.1847441-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:b3pbp/XZSd+qFAXvZ9I7UjuleCw3GTy1vtyionbvaNjSrD6kYrH
 y/IBPt43A5XriZwjpg/iVL+DG+MEIGNcDlWlMfkFbLwqZGn3pMma6Xx0viUdy8bDJdYLpx4
 Lt9B3isKWwO+iGzLngj6QapH5GuypPJSDv//HUUaylj17ZdCqAsqXaqYgEDbLhcGG+xHkJk
 FAgf2eV+mFETYygqDSJbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cHnxtw5s88I=:liybKe0ZyJzauaYbhV1tR4
 v+detTxqBVhe77qXrhR+LJDZDMNMOV9mkaPORuAXHIO5xefWpUdkz7/jiaLp1rVYj2t2+IZXW
 gshFy77aTRiWP9IpwdC7VXhAMHccPlBSLN3hOlCaY8AuVBKJbH4zlgAI6RriDPkTOroUsBhQu
 Bub16qn/gv6uBFl5q8Mv6yfgOGbDoMBT+Iy59/H9BOg6yCTIBNZNaR0kKt55xjXZRFY9nCeIz
 fprxjDfT8ScG5bD0YZXz8EpefMvdPdPekIcs/ntCx4f5Brr9ND7oq8cpkWPdCpSrI0gLsnpdi
 oTc1r8Xe87uRzZXf8hQ6sjtoBmS7kj8RaIEsyERkpCXyoES858LWCSlfQHpSxkNVZ6XSAP7OY
 Ir3zR49Q5LlOIx5i6GpH5DLsCrOpenvCyZ4SeKcBvwrZCMeXvJaMLqfCYo8MsTRSwKbPokI01
 1mNrqwi3kWN45VD/6TFDZ5fbTjlzmzwIz2/8aZhVjtSITAgicPam99N3mDGx0k6Vs8TFnhhcp
 rO1P5mJi5QQhgvmGKXLkBJAIH7DfNPKIuzBL0GWXOQFAzMfM4W0BJbTQcSAhh8cShtglo/RsN
 lAOvUduj4mF3d/+TzX8M/wA0ciSJd/K37cwbwyrSOXHTHwe9f/cwweHkCPwYBl4snwOFa7lKF
 S+dQUFMv9GoCpx4RCmGtGm3hnL/EUd+moTge+fJmVdqv79d7rIx+kiZXeTay19bhIB4NWeB4K
 HSJJK8hYrPtPyRvsAAH4oJnDSlMvq9s2gDZ8OGRC37fKsYgkiDOthoi3KmKJbELyTstVJ0w5c
 tS93kyVDjAmyLIv1AtkY5kjjiIpVAnOkIKdLzwZcK39cVbgrKg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During randconfig build testing, I ran into a configuration that has
CONFIG_VHOST=m, CONFIG_VHOST_IOTLB=m and CONFIG_VHOST_RING=y, which
makes the iotlb implementation left out from vhost_ring, and in turn
leads to a link failure of the vdpa_sim module:

ERROR: modpost: "vringh_set_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
ERROR: modpost: "vringh_init_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
ERROR: modpost: "vringh_iov_push_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
ERROR: modpost: "vringh_iov_pull_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
ERROR: modpost: "vringh_complete_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!
ERROR: modpost: "vringh_getdesc_iotlb" [drivers/vdpa/vdpa_sim/vdpa_sim.ko] undefined!

Work around it by setting the default for VHOST_IOTLB to avoid this
configuration.

Fixes: e6faeaa12841 ("vhost: drop vring dependency on iotlb")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I fixed this a while ago locally but never got around to sending the
fix. If the problem has been addressed differently in the meantime,
please ignore this one.
---
 drivers/vhost/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 2c75d164b827..ee5f85761024 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VHOST_IOTLB
 	tristate
+	default y if VHOST=m && VHOST_RING=y
 	help
 	  Generic IOTLB implementation for vhost and vringh.
 	  This option is selected by any driver which needs to support
-- 
2.26.0

