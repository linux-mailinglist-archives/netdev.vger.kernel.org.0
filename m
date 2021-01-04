Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B193D2E8F96
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 04:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbhADDc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 22:32:59 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10280 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbhADDc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 22:32:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff28c430000>; Sun, 03 Jan 2021 19:32:19 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 03:32:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v2 2/7] vdpa_sim_net: Add module param to disable default vdpa net device
Date:   Mon, 4 Jan 2021 05:31:36 +0200
Message-ID: <20210104033141.105876-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104033141.105876-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609731139; bh=Mq/ykPzI3k+3JEWZA9fI1HI4hQdmUcrsKx+CN5j4kAo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=pc8HkD229BC7vBaJnF5d+8NKy+4Dgr7aWhHt2gU3JyJzDSRIBgXAXWqPhwSmmpIZS
         M1UpMYNyHshd4Rh7szkdlyS3jY1LwNhYDkUBybsT7+NPSDYFSbVtNy4eG6RLNQdRHd
         EbE+WF24lG2iWXLROxKSSlRp5njaEDr/YhiSVOWSakIOqAv/I+aMGUqAfFDPSOjZC3
         monOT1PILwB2wfT+R0U8R2+tRpkg1draNBHqAj+BGvLIYPYxfMZECN2bWyANM3P6qx
         Cd2QfacKDOZNxxncJwS2uyNW0IhSmArXArIybQyyR6taLdeyuWVr5NUL94nTUgD/jd
         q+YDcLiiOFpFA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support creating multiple vdpa devices and to allow user to
manage them, add a knob to disable a default vdpa net device.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
Changelog:
v1->v2:
 - new patch
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 41 ++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim_net.c
index f0482427186b..34155831538c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -33,6 +33,10 @@ static char *macaddr;
 module_param(macaddr, charp, 0);
 MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
=20
+static bool default_device =3D true;
+module_param(default_device, bool, 0);
+MODULE_PARM_DESC(default_device, "Support single default VDPA device");
+
 static u8 macaddr_buf[ETH_ALEN];
=20
 static struct vdpasim *vdpasim_net_dev;
@@ -120,21 +124,11 @@ static void vdpasim_net_get_config(struct vdpasim *vd=
pasim, void *config)
 	memcpy(net_config->mac, macaddr_buf, ETH_ALEN);
 }
=20
-static int __init vdpasim_net_init(void)
+static int vdpasim_net_default_dev_register(void)
 {
 	struct vdpasim_dev_attr dev_attr =3D {};
 	int ret;
=20
-	if (macaddr) {
-		mac_pton(macaddr, macaddr_buf);
-		if (!is_valid_ether_addr(macaddr_buf)) {
-			ret =3D -EADDRNOTAVAIL;
-			goto out;
-		}
-	} else {
-		eth_random_addr(macaddr_buf);
-	}
-
 	dev_attr.id =3D VIRTIO_ID_NET;
 	dev_attr.supported_features =3D VDPASIM_NET_FEATURES;
 	dev_attr.nvqs =3D VDPASIM_NET_VQ_NUM;
@@ -161,13 +155,36 @@ static int __init vdpasim_net_init(void)
 	return ret;
 }
=20
-static void __exit vdpasim_net_exit(void)
+static void vdpasim_net_default_dev_unregister(void)
 {
 	struct vdpa_device *vdpa =3D &vdpasim_net_dev->vdpa;
=20
 	vdpa_unregister_device(vdpa);
 }
=20
+static int __init vdpasim_net_init(void)
+{
+	int ret =3D 0;
+
+	if (macaddr) {
+		mac_pton(macaddr, macaddr_buf);
+		if (!is_valid_ether_addr(macaddr_buf))
+			return -EADDRNOTAVAIL;
+	} else {
+		eth_random_addr(macaddr_buf);
+	}
+
+	if (default_device)
+		ret =3D vdpasim_net_default_dev_register();
+	return ret;
+}
+
+static void __exit vdpasim_net_exit(void)
+{
+	if (default_device)
+		vdpasim_net_default_dev_unregister();
+}
+
 module_init(vdpasim_net_init);
 module_exit(vdpasim_net_exit);
=20
--=20
2.26.2

