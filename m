Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BD1308ABB
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhA2Q56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:57:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19370 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhA2Q5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:57:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60143e520000>; Fri, 29 Jan 2021 08:56:50 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 16:56:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 2/5] devlink: Introduce PCI SF port flavour and attribute
Date:   Fri, 29 Jan 2021 18:56:05 +0200
Message-ID: <20210129165608.134965-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129165608.134965-1-parav@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611939410; bh=YQIjfcjwbqmoFhFxgeDLpwLc53Eb3BlQdWa9PRmD5ZY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=D/H1Di34iWYa/d031shLwOJV/45YosGb2xEpuF/wB/qmPLXwEonmYFQXFvGt9RzQi
         Bxwjh7DeA7qMm7rQMsDRfQrhZuduVcTjgi5PPq2vzNOmHPhODbcnWHfWtFLg3+QVLD
         aDij9qMo2KtVMn3qcUA+xu1hCU5+g9PUyi08mBTl2zqYYBDVv8d3Y9OYzDbnaf/kKc
         wpKp8d1Kfj2VzWMW5CuNQ7yX2QRYuQ8L4dGz3+h/hqP7y3vI5KieY/W9UmVeC5pccf
         Qkbn/SRRTHXXT24Rlbbd2gffaBbSVCPrQLs0rs08/oyzyVkYKmzHvC1xYFoaayiSft
         brpuwIG0r+g0g==
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
 devlink/devlink.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a2e06644..ceafd179 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3728,6 +3728,8 @@ static const char *port_flavour_name(uint16_t flavour=
)
 		return "pcipf";
 	case DEVLINK_PORT_FLAVOUR_PCI_VF:
 		return "pcivf";
+	case DEVLINK_PORT_FLAVOUR_PCI_SF:
+		return "pcisf";
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		return "virtual";
 	default:
@@ -3735,7 +3737,7 @@ static const char *port_flavour_name(uint16_t flavour=
)
 	}
 }
=20
-static void pr_out_port_pfvf_num(struct dl *dl, struct nlattr **tb)
+static void pr_out_port_pfvfsf_num(struct dl *dl, struct nlattr **tb)
 {
 	uint16_t fn_num;
=20
@@ -3750,6 +3752,10 @@ static void pr_out_port_pfvf_num(struct dl *dl, stru=
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
@@ -3827,7 +3833,8 @@ static void pr_out_port(struct dl *dl, struct nlattr =
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

