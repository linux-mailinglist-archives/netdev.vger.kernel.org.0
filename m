Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60D9308ABD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhA2Q6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:58:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7923 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhA2Q5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:57:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60143e530000>; Fri, 29 Jan 2021 08:56:51 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 16:56:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 4/5] devlink: Support get port function state
Date:   Fri, 29 Jan 2021 18:56:07 +0200
Message-ID: <20210129165608.134965-5-parav@nvidia.com>
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
        t=1611939411; bh=tUtPGk8jRz74ATIdOu3RFyrGGheiaPs5Dibv7fjAh54=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=nxtiF38EbUJmwqQ/yBKb0cIs5PWzyUwcQWu4H5a0l+E7oJLpDXY+aJTOlnPFNTEnS
         npOCDbwBX/x3rzjwCM5OlvlQ7ScRVqS8Ko9m2035DsmLkRO7BSdT7ozdtdcOzh39Q1
         QXNt2Gl+L/IXFEMNoQj8i8V1L9soYcgCn9c4nOduV63vn5bQrtuztRWJX4rN4Pajal
         hWPIrn9NEz8ZuYChI71bF+xUXTlLf4ZQLmm8kefkzkSBt2xdMFGLiOQuyOZA3PcAbL
         JLNPyX5JJgtbVaf8DufjBpehQIxKO8HyHJzBCpzQuLqMJXmmP0sh2jFD2gcLXcBYvn
         3w1uV35IWTEKQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print port function state and operational state whenever reported by
kernel.

Example of a PCI SF port function which supports the state:

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
8

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
                "state": "inactive",
                "opstate": "detached"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 55 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 515dadc8..85b9bce9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3833,6 +3833,30 @@ static void pr_out_port_pfvfsf_num(struct dl *dl, st=
ruct nlattr **tb)
 	}
 }
=20
+static const char *port_function_state(uint8_t state)
+{
+	switch (state) {
+	case DEVLINK_PORT_FN_STATE_INACTIVE:
+		return "inactive";
+	case DEVLINK_PORT_FN_STATE_ACTIVE:
+		return "active";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *port_function_opstate(uint8_t state)
+{
+	switch (state) {
+	case DEVLINK_PORT_FN_OPSTATE_DETACHED:
+		return "detached";
+	case DEVLINK_PORT_FN_OPSTATE_ATTACHED:
+		return "attached";
+	default:
+		return "unknown";
+	}
+}
+
 static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 {
 	struct nlattr *tb[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] =3D {};
@@ -3849,16 +3873,31 @@ static void pr_out_port_function(struct dl *dl, str=
uct nlattr **tb_port)
 	if (err !=3D MNL_CB_OK)
 		return;
=20
-	if (!tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR])
-		return;
-
-	len =3D mnl_attr_get_payload_len(tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR]);
-	data =3D mnl_attr_get_payload(tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR]);
-
 	pr_out_object_start(dl, "function");
 	check_indent_newline(dl);
-	print_string(PRINT_ANY, "hw_addr", "hw_addr %s",
-		     ll_addr_n2a(data, len, 0, hw_addr, sizeof(hw_addr)));
+
+	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR]) {
+		len =3D mnl_attr_get_payload_len(tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR])=
;
+		data =3D mnl_attr_get_payload(tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR]);
+
+		print_string(PRINT_ANY, "hw_addr", "hw_addr %s",
+			     ll_addr_n2a(data, len, 0, hw_addr, sizeof(hw_addr)));
+	}
+	if (tb[DEVLINK_PORT_FN_ATTR_STATE]) {
+		uint8_t state;
+
+		state =3D mnl_attr_get_u8(tb[DEVLINK_PORT_FN_ATTR_STATE]);
+
+		print_string(PRINT_ANY, "state", " state %s", port_function_state(state)=
);
+	}
+	if (tb[DEVLINK_PORT_FN_ATTR_OPSTATE]) {
+		uint8_t state;
+
+		state =3D mnl_attr_get_u8(tb[DEVLINK_PORT_FN_ATTR_OPSTATE]);
+
+		print_string(PRINT_ANY, "opstate", " opstate %s", port_function_opstate(=
state));
+	}
+
 	if (!dl->json_output)
 		__pr_out_indent_dec();
 	pr_out_object_end(dl);
--=20
2.26.2

