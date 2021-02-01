Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D330B229
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhBAVhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:37:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16086 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbhBAVgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:36:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018744c0000>; Mon, 01 Feb 2021 13:36:12 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 21:36:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next v2 3/6] devlink: Introduce PCI SF port flavour and attribute
Date:   Mon, 1 Feb 2021 23:35:48 +0200
Message-ID: <20210201213551.8503-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201213551.8503-1-parav@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210201213551.8503-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612215372; bh=r4zp+qYy7Dwqsu2g0+0IFjqX9rx8uIYw8s4zTu4kLXo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Dz/cxcK4dHhkDrsVMTR87PDU3hTmyQwsmk0TCdBJKFXe8vxrCQZC+VYBARXxcYiUZ
         yh8HZJ8g/1o8RswBrH9HjpsfKFqXGoOLzPqGBBkQM1Ldgi6D7oEJ3+0gYj6pw3sJn/
         5BsKnHY/ZFFi8/ZLtmE5167bPt5h+S2ohvX3JHHVJ60JTq23dWuT3PqmkVHMsV0h15
         5oALjwhNqclr1nExrb5VvaBFCl0M54rxQPPVSKSQc8Wy9CYMFB115avVCef9vwFBCA
         uH+169ry2hJ/BqAeeSTA2kh82sYPq3uEVr8AoCdgn8y8iQYql1AbSVxozu71R+zNjy
         ViGu/INMuOohQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce PCI SF port flavour and port attributes such as PF
number and SF number.

$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfn=
um 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf contro=
ller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:8=
8 state active

$ devlink port show pci/0000:06:00.0/32768 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "ens2f0npf0sf88",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 88,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:88:88",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index d21a7c4d..338cb035 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1389,6 +1389,7 @@ static struct str_num_map port_flavour_map[] =3D {
 	{ .str =3D "dsa", .num =3D DEVLINK_PORT_FLAVOUR_DSA },
 	{ .str =3D "pcipf", .num =3D DEVLINK_PORT_FLAVOUR_PCI_PF },
 	{ .str =3D "pcivf", .num =3D DEVLINK_PORT_FLAVOUR_PCI_VF },
+	{ .str =3D "pcisf", .num =3D DEVLINK_PORT_FLAVOUR_PCI_SF },
 	{ .str =3D "virtual", .num =3D DEVLINK_PORT_FLAVOUR_VIRTUAL},
 	{ .str =3D NULL, },
 };
@@ -3733,7 +3734,7 @@ static const char *port_flavour_name(uint16_t flavour=
)
 	return str ? str : "<unknown flavour>";
 }
=20
-static void pr_out_port_pfvf_num(struct dl *dl, struct nlattr **tb)
+static void pr_out_port_pfvfsf_num(struct dl *dl, struct nlattr **tb)
 {
 	uint16_t fn_num;
=20
@@ -3748,6 +3749,10 @@ static void pr_out_port_pfvf_num(struct dl *dl, stru=
ct nlattr **tb)
 		fn_num =3D mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]);
 		print_uint(PRINT_ANY, "vfnum", " vfnum %u", fn_num);
 	}
+	if (tb[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]) {
+		fn_num =3D mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]);
+		print_uint(PRINT_ANY, "sfnum", " sfnum %u", fn_num);
+	}
 	if (tb[DEVLINK_ATTR_PORT_EXTERNAL]) {
 		uint8_t external;
=20
@@ -3825,7 +3830,8 @@ static void pr_out_port(struct dl *dl, struct nlattr =
**tb)
 		switch (port_flavour) {
 		case DEVLINK_PORT_FLAVOUR_PCI_PF:
 		case DEVLINK_PORT_FLAVOUR_PCI_VF:
-			pr_out_port_pfvf_num(dl, tb);
+		case DEVLINK_PORT_FLAVOUR_PCI_SF:
+			pr_out_port_pfvfsf_num(dl, tb);
 			break;
 		default:
 			break;
--=20
2.26.2

