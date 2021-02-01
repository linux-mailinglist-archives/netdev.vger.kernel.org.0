Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7D30B227
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhBAVg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:36:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4881 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhBAVgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:36:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018744b0000>; Mon, 01 Feb 2021 13:36:11 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 21:36:10 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v2 2/6] devlink: Introduce and use string to number mapper
Date:   Mon, 1 Feb 2021 23:35:47 +0200
Message-ID: <20210201213551.8503-3-parav@nvidia.com>
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
        t=1612215371; bh=DmoYw24NVxfhN4UhaA68PbXSRpSBExJ76fxFkzEO4zA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=N2Hims0DxdmzwAOm7TGDzTtms/oT4EDcHHLngGiyx8e48lNKQI/g9Gx4CCBXmEbcO
         0D7bU7i8pGojOsNQyNDiIqY0MSh5NpPFwNTVtAZ7zGdvfawlg8BVV1j6XXvlD3E3+T
         FMks3kmKZrU81FdhxC2St1jJDHxO3WH/1My5S3j29YsCldw5y1FJnywc8mormgeyL+
         dQtc8oVuB7EqPVPHboLEnz/DK34aPEavZ/eCrHj3Uu8CKQzJ3cwywV2dFHRZvhAugQ
         YAQyQhWrO1ZGHLc6flCj3K5acQKDvLVa1oYi/NA+nI0nKMeeVZfWDIEwjKZLiVwE34
         zIqg4GSLvaHQA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using static mapping in code, introduce a helper routine to
map a value to string.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2:
 - addressed David's comment to use helper routine to map num->string
---
 devlink/devlink.c | 30 ++++++++++++++----------------
 include/utils.h   |  8 ++++++++
 lib/utils.c       | 28 ++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a2e06644..d21a7c4d 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1383,6 +1383,16 @@ static int reload_limit_get(struct dl *dl, const cha=
r *limitstr,
 	return 0;
 }
=20
+static struct str_num_map port_flavour_map[] =3D {
+	{ .str =3D "physical", .num =3D DEVLINK_PORT_FLAVOUR_PHYSICAL },
+	{ .str =3D "cpu", .num =3D DEVLINK_PORT_FLAVOUR_CPU },
+	{ .str =3D "dsa", .num =3D DEVLINK_PORT_FLAVOUR_DSA },
+	{ .str =3D "pcipf", .num =3D DEVLINK_PORT_FLAVOUR_PCI_PF },
+	{ .str =3D "pcivf", .num =3D DEVLINK_PORT_FLAVOUR_PCI_VF },
+	{ .str =3D "virtual", .num =3D DEVLINK_PORT_FLAVOUR_VIRTUAL},
+	{ .str =3D NULL, },
+};
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -3717,22 +3727,10 @@ static const char *port_type_name(uint32_t type)
=20
 static const char *port_flavour_name(uint16_t flavour)
 {
-	switch (flavour) {
-	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
-		return "physical";
-	case DEVLINK_PORT_FLAVOUR_CPU:
-		return "cpu";
-	case DEVLINK_PORT_FLAVOUR_DSA:
-		return "dsa";
-	case DEVLINK_PORT_FLAVOUR_PCI_PF:
-		return "pcipf";
-	case DEVLINK_PORT_FLAVOUR_PCI_VF:
-		return "pcivf";
-	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-		return "virtual";
-	default:
-		return "<unknown flavour>";
-	}
+	const char *str;
+
+	str =3D str_map_lookup_u16(port_flavour_map, flavour);
+	return str ? str : "<unknown flavour>";
 }
=20
 static void pr_out_port_pfvf_num(struct dl *dl, struct nlattr **tb)
diff --git a/include/utils.h b/include/utils.h
index f1403f73..1d67443e 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -340,4 +340,12 @@ int parse_mapping(int *argcp, char ***argvp, bool allo=
w_all,
 		  int (*mapping_cb)(__u32 key, char *value, void *data),
 		  void *mapping_cb_data);
=20
+struct str_num_map {
+	const char *str;
+	int num;
+};
+
+int str_map_lookup_str(const struct str_num_map *map, const char *needle);
+const char *str_map_lookup_u16(const struct str_num_map *map, uint16_t val=
);
+
 #endif /* __UTILS_H__ */
diff --git a/lib/utils.c b/lib/utils.c
index 90e58fa3..9fef2d76 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1937,3 +1937,31 @@ int parse_mapping(int *argcp, char ***argvp, bool al=
low_all,
 		return parse_mapping_gen(argcp, argvp, parse_mapping_num,
 					 mapping_cb, mapping_cb_data);
 }
+
+int str_map_lookup_str(const struct str_num_map *map, const char *needle)
+{
+	if (!needle)
+		return -EINVAL;
+
+	/* Process array which is NULL terminated by the string. */
+	while (map && map->str) {
+		if (strcmp(map->str, needle) =3D=3D 0)
+			return map->num;
+
+		map++;
+	}
+	return -EINVAL;
+}
+
+const char *str_map_lookup_u16(const struct str_num_map *map, uint16_t val=
)
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

