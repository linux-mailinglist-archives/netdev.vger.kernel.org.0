Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE2E316EE7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhBJSj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:39:29 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8365 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbhBJSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:35:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602427560000>; Wed, 10 Feb 2021 10:35:02 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:35:01 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v5 4/5] utils: Add helper to map string to unsigned int
Date:   Wed, 10 Feb 2021 20:34:44 +0200
Message-ID: <20210210183445.1009795-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210183445.1009795-1-parav@nvidia.com>
References: <20210210183445.1009795-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612982102; bh=wb+dkpPaTiWpTz3BlBWkumEuJWVmUA/mgN3gQd43q88=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=iH7uuOwp92t21QGALRaCPgn4B9YX9YJY4k8FX1ddXR5pLn4GCUaBKPixY16c3jc2A
         Ivt4cW7UB9B+vbQVEhF25+a97OUzTxVFUXTcXCJWN77xI3qcSQ2797iH8MBjpB2C+Z
         0Wlj0LUOpOmNE47TMRBeTKbf3hK9je4MINy0PAQCE0PKgeRxjGw2VvqwX7zNgK0XWQ
         hulcfYbLtzU/G231hw+XCi7KMErBQseXCdCSh858v+CcaPK5SSt3dmQ7FnhJ4P6g33
         IM7x7QvcHPzi1VuW8oroZHTs0TWoEyHIqhpUSKogqFUJnw/fFei73ixGYdsxsrr2V4
         Lc48+wM5rdCrQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In subsequent patch need to map a string to a unsigned int.
Hence, add an API to map a string to unsigned int.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v2->v3:
 - new patch to reuse string to unsigned int mapping
---
 include/utils.h |  4 +++-
 lib/utils.c     | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 9b76c92a..b29c3798 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -342,10 +342,12 @@ int parse_mapping(int *argcp, char ***argvp, bool all=
ow_all,
=20
 struct str_num_map {
 	const char *str;
-	int num;
+	unsigned int num;
 };
=20
 int str_map_lookup_str(const struct str_num_map *map, const char *needle);
+const char *str_map_lookup_uint(const struct str_num_map *map,
+				unsigned int val);
 const char *str_map_lookup_u16(const struct str_num_map *map, uint16_t val=
);
 const char *str_map_lookup_u8(const struct str_num_map *map, uint8_t val);
=20
diff --git a/lib/utils.c b/lib/utils.c
index cc6d0e34..633f6359 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1953,9 +1953,22 @@ int str_map_lookup_str(const struct str_num_map *map=
, const char *needle)
 	return -EINVAL;
 }
=20
+const char *str_map_lookup_uint(const struct str_num_map *map, unsigned in=
t val)
+{
+	unsigned int num =3D val;
+
+	while (map && map->str) {
+		if (num =3D=3D map->num)
+			return map->str;
+
+		map++;
+	}
+	return NULL;
+}
+
 const char *str_map_lookup_u16(const struct str_num_map *map, uint16_t val=
)
 {
-	int num =3D val;
+	unsigned int num =3D val;
=20
 	while (map && map->str) {
 		if (num =3D=3D map->num)
@@ -1968,7 +1981,7 @@ const char *str_map_lookup_u16(const struct str_num_m=
ap *map, uint16_t val)
=20
 const char *str_map_lookup_u8(const struct str_num_map *map, uint8_t val)
 {
-	int num =3D val;
+	unsigned int num =3D val;
=20
 	while (map && map->str) {
 		if (num =3D=3D map->num)
--=20
2.26.2

