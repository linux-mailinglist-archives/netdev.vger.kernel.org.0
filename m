Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E2126F7A1
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgIRID0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:03:26 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2885 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgIRIDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 04:03:22 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64696f0000>; Fri, 18 Sep 2020 01:01:51 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 08:03:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 3/3] devlink: Show controller number of a devlink port
Date:   Fri, 18 Sep 2020 11:03:00 +0300
Message-ID: <20200918080300.35132-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918080300.35132-1-parav@nvidia.com>
References: <20200918080300.35132-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600416112; bh=uQ/QcLv1+9MA/ubZ4df6U77ijj75W6I7tjCeM/LhxoE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=JJzGoczihmx3t8WrZz8e5ZWwLS3W1IU8xxYaQTJniLpROTtu4H5GuqzOA9CBeh5zq
         FF5k9s38ANA02fe2XMXwABdb2FKEeoBmqFpPAz5lmff99K310gR+hLyY0Z7vXZONXi
         tsfwP3ljugmLicFh8wdAJZJrBcIk3faRO8AZWZ7QxKUStJVtaNHW6440tlM16j3Grp
         16nfoV+YICfEHjWae5pZ4g2wB+12lt6ehF4HaLA3rayYHxf74MB3XxKTLapnpI+qFo
         RiRJRtdlLBY9AUsq91Oa4jnZQZrb51Xl7hqdRoikhriA74AW4nWkLP6mLhIBTiI9xu
         AAUoQl0PAI/IQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show the controller number of the devlink port whenever kernel reports
it.

Example of a PCI VF port for an external controller number 1:

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev ens2f0c1pf0vf1 flavour pcivf controller=
 1 pfnum 0 vfnum 1 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "ens2f0c1pf0vf1",
            "flavour": "pcivf",
            "controller": 1,
            "pfnum": 0,
            "vfnum": 1,
            "external": true,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 9f99c031..0374175e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3343,6 +3343,9 @@ static void pr_out_port_pfvf_num(struct dl *dl, struc=
t nlattr **tb)
 {
 	uint16_t fn_num;
=20
+	if (tb[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER])
+		print_uint(PRINT_ANY, "controller", " controller %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]));
 	if (tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
 		fn_num =3D mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
 		print_uint(PRINT_ANY, "pfnum", " pfnum %u", fn_num);
--=20
2.26.2

