Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C815426FA3D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIRKRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:17:06 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8795 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgIRKRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:17:05 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6489130004>; Fri, 18 Sep 2020 03:16:51 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 10:17:03 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <dsahern@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next RESEND 2/3] devlink: Show external port attribute
Date:   Fri, 18 Sep 2020 13:16:48 +0300
Message-ID: <20200918101649.60086-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918101649.60086-1-parav@nvidia.com>
References: <20200918080300.35132-1-parav@nvidia.com>
 <20200918101649.60086-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600424211; bh=20ZMItL7Pb8V8pDrbeTlVH92pzsGbajazG5oc+PmN+g=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fkVsTUSSOPro45xxLwdlygGVkH1qABki3WIQocYM7PijT5f/RPvPctby4bHUBshqT
         bxMuMCQ56l1egJAn2Dlk2hlIweh8xMNyd/39u84lUW0bGwRFR4dWmFQ6k3KVfTVcfy
         asalTOmWngqo8PUjeKiH/+bbpFsa9yYSoMu4qk5MyGqHfT95+EplGC2bceLVwpWHUM
         uGQGlDMHQI3cpUi/zRlNraGU6h2vl9xUBR/Y/zxdAkwuF4ZWHKqgNg8CwJXEc8ONcC
         G6qXD4/u8KDOWpDT1qO1GPQzu/746N3q6s8zsHsYQzTLR7Zg8dNqYgkIlkxb0DcQtE
         m5kHUo89qVzSg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a port is for an external controller, port's external attribute is
set. Show such external attribute.

An example of an external controller port for PCI VF:

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev ens2f0c1pf0vf1 flavour pcivf pfnum 0 vf=
num 1 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "ens2f0c1pf0vf1",
            "flavour": "pcivf",
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
 devlink/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 007677a5..9f99c031 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3351,6 +3351,12 @@ static void pr_out_port_pfvf_num(struct dl *dl, stru=
ct nlattr **tb)
 		fn_num =3D mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]);
 		print_uint(PRINT_ANY, "vfnum", " vfnum %u", fn_num);
 	}
+	if (tb[DEVLINK_ATTR_PORT_EXTERNAL]) {
+		uint8_t external;
+
+		external =3D mnl_attr_get_u8(tb[DEVLINK_ATTR_PORT_EXTERNAL]);
+		print_bool(PRINT_ANY, "external", " external %s", external);
+	}
 }
=20
 static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
--=20
2.26.2

