Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE5430B22B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhBAVhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:37:32 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4943 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhBAVha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:37:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018744d0000>; Mon, 01 Feb 2021 13:36:13 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 21:36:12 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next v2 5/6] devlink: Support get port function state
Date:   Mon, 1 Feb 2021 23:35:50 +0200
Message-ID: <20210201213551.8503-6-parav@nvidia.com>
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
        t=1612215373; bh=rfGEe/B2bfz6vwN4e4d5pvxWPaOieLUuJW8rMZKP0ps=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OQG3lA3ovrqJD0Sd/4pTTplgQamvdOWjmK0Gh5g0F5W98jMssQWDF5Mo3gipr4EZC
         Y1ia+I2fcs9bTOZgnFAd+/u9HMBkqwPICYBkl52gZdxTxoSdM7H37IhCVNJnKGAzax
         1QP0dMF27pnv3/ptuGZlxLsZVCM6EKdsjxD7L7K8Y4Zmmo+XP4Utg1ml+YE5a8SoZg
         WP94LHSnhuoXRQM4RJ+HG5UqpEhcTyLB1smihkpPH91RGssTufkejtib9faiz5onxj
         I00f2Y47Gl3q8QOp8SCGP6DAIqdqyArH4QBDI6gNwaOUmHyCveR0Q7HJsScZ9hTu5U
         tp6LQqUSwiIOw==
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
changelog:
v1->v2:
 - using helper routine to perform string<->u8 mapping for state and
   operational state
---
 devlink/devlink.c | 61 ++++++++++++++++++++++++++++++++++++++++-------
 include/utils.h   |  1 +
 lib/utils.c       | 13 ++++++++++
 3 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 76ea7cac..17db8623 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1400,6 +1400,18 @@ static struct str_num_map port_flavour_map[] =3D {
 	{ .str =3D NULL, },
 };
=20
+static struct str_num_map port_fn_state_map[] =3D {
+	{ .str =3D "inactive", .num =3D DEVLINK_PORT_FN_STATE_INACTIVE},
+	{ .str =3D "active", .num =3D DEVLINK_PORT_FN_STATE_ACTIVE },
+	{ .str =3D NULL, }
+};
+
+static struct str_num_map port_fn_opstate_map[] =3D {
+	{ .str =3D "attached", .num =3D DEVLINK_PORT_FN_OPSTATE_ATTACHED},
+	{ .str =3D "detached", .num =3D DEVLINK_PORT_FN_OPSTATE_DETACHED},
+	{ .str =3D NULL, }
+};
+
 static int port_flavour_parse(const char *flavour, uint16_t *value)
 {
 	int num;
@@ -3810,6 +3822,22 @@ static void pr_out_port_pfvfsf_num(struct dl *dl, st=
ruct nlattr **tb)
 	}
 }
=20
+static const char *port_fn_state(uint8_t state)
+{
+	const char *str;
+
+	str =3D str_map_lookup_u8(port_fn_state_map, state);
+	return str ? str : "<unknown state>";
+}
+
+static const char *port_fn_opstate(uint8_t state)
+{
+	const char *str;
+
+	str =3D str_map_lookup_u8(port_fn_opstate_map, state);
+	return str ? str : "<unknown state>";
+}
+
 static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 {
 	struct nlattr *tb[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] =3D {};
@@ -3826,16 +3854,33 @@ static void pr_out_port_function(struct dl *dl, str=
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
+		print_string(PRINT_ANY, "state", " state %s",
+			     port_fn_state(state));
+	}
+	if (tb[DEVLINK_PORT_FN_ATTR_OPSTATE]) {
+		uint8_t state;
+
+		state =3D mnl_attr_get_u8(tb[DEVLINK_PORT_FN_ATTR_OPSTATE]);
+
+		print_string(PRINT_ANY, "opstate", " opstate %s",
+			     port_fn_opstate(state));
+	}
+
 	if (!dl->json_output)
 		__pr_out_indent_dec();
 	pr_out_object_end(dl);
diff --git a/include/utils.h b/include/utils.h
index 1d67443e..e66090ae 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -347,5 +347,6 @@ struct str_num_map {
=20
 int str_map_lookup_str(const struct str_num_map *map, const char *needle);
 const char *str_map_lookup_u16(const struct str_num_map *map, uint16_t val=
);
+const char *str_map_lookup_u8(const struct str_num_map *map, uint8_t val);
=20
 #endif /* __UTILS_H__ */
diff --git a/lib/utils.c b/lib/utils.c
index 9fef2d76..af1b553c 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1965,3 +1965,16 @@ const char *str_map_lookup_u16(const struct str_num_=
map *map, uint16_t val)
 	}
 	return NULL;
 }
+
+const char *str_map_lookup_u8(const struct str_num_map *map, uint8_t val)
+{
+	int num =3D val;
+
+	while (map && map->str) {
+		if (num =3D=3D map->num)
+			return map->str;
+
+		map++;
+	}
+	return NULL;
+}
--=20
2.26.2

