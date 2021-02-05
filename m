Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E604310FB2
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 19:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhBEQb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 11:31:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13116 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhBEQ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 11:29:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601d8a2c0000>; Fri, 05 Feb 2021 10:10:52 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 18:10:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v4 4/5] utils: Add helper to map string to unsigned int
Date:   Fri, 5 Feb 2021 20:10:28 +0200
Message-ID: <20210205181029.365461-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210205181029.365461-1-parav@nvidia.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210205181029.365461-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612548652; bh=wb+dkpPaTiWpTz3BlBWkumEuJWVmUA/mgN3gQd43q88=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=KT/9t2HrAlGVTZTatkZfxoExmMHe07MZLz0cSAfKOt4BalM1FdRlIJ/iXT4Q8AkqF
         jF9HgTvR0uht5Eo3srfHH1v2P28Zbl85/a5uVZVnEY2SumolDwhqQlD7lXK0JSAQqZ
         j6NY5cTUUstGo08Z1oKM7P1l5hTGBh6lmxIolamoj4Ak/+2S0j3rTfpkJ8Tcvj6p3f
         41m9UmQtao9w1vh03BHRk3863xM91NRbRVTA14j7pncnGBERs6ghof3kk39zb/+EJV
         HbJ8e0w+olu8uoFESSZQ8kB/0XRPhCmXbbaLTzDV93a5VbJ8OMyRq8y0S9Gqa/oMFN
         dNcQUKqMTgjKA==
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

