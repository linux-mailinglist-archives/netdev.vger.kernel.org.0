Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09E430BC24
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhBBKgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:36:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1352 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhBBKgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:36:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60192af90002>; Tue, 02 Feb 2021 02:35:37 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 10:35:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v3 2/5] utils: Add helper routines for indent handling
Date:   Tue, 2 Feb 2021 12:35:15 +0200
Message-ID: <20210202103518.3858-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202103518.3858-1-parav@nvidia.com>
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612262137; bh=HDT133gXudxB52omx1TuwZ9j1XEiBgbv7aS9W5cuFWc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=F0kHY59seyuMIo83PNO700wEQKWx/LGg2pWsTnPsgm2xuLlGaZiY8lopzEdksj28v
         JqSQNS0+0u4IFyjuPICUZ868WR1AjbZtzSeLwESS1tcY313aHvoN3J6Iynrrpm0Ols
         b2V7uFKTK/B5p3rc6Xrcz5T0VVCAHefePb1F24oUhZet7iUqVFu2wpEu8rt2XIG5/w
         l/J5ypU9osePvD9H+2AEU7U2nlWgcXIxIYBLfWDEvnsa94yUvbpOGQke8O8BWaaO8H
         HX2XoUkQPxpPJYpt9oij3Fhlznm47GPdaGungMX+ARRQH8Xy4bC41poY3rM6Xasl9x
         d26ApxyZeeHyA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patch needs to use 2 char indentation for nested objects.
Hence introduce a generic helpers to allocate, deallocate, increment,
decrement and to print indent block.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v2->v3:
 - patch split from vdpa tool patch
---
 include/utils.h | 16 ++++++++++++
 lib/utils.c     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index e66090ae..9b76c92a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -349,4 +349,20 @@ int str_map_lookup_str(const struct str_num_map *map, =
const char *needle);
 const char *str_map_lookup_u16(const struct str_num_map *map, uint16_t val=
);
 const char *str_map_lookup_u8(const struct str_num_map *map, uint8_t val);
=20
+unsigned int get_str_char_count(const char *str, int match);
+int str_split_by_char(char *str, char **before, char **after, int match);
+
+#define INDENT_STR_MAXLEN 32
+
+struct indent_mem {
+	int indent_level;
+	char indent_str[INDENT_STR_MAXLEN + 1];
+};
+
+struct indent_mem *alloc_indent_mem(void);
+void free_indent_mem(struct indent_mem *mem);
+void inc_indent(struct indent_mem *mem);
+void dec_indent(struct indent_mem *mem);
+void print_indent(struct indent_mem *mem);
+
 #endif /* __UTILS_H__ */
diff --git a/lib/utils.c b/lib/utils.c
index af1b553c..cc6d0e34 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1978,3 +1978,69 @@ const char *str_map_lookup_u8(const struct str_num_m=
ap *map, uint8_t val)
 	}
 	return NULL;
 }
+
+unsigned int get_str_char_count(const char *str, int match)
+{
+	unsigned int count =3D 0;
+	const char *pos =3D str;
+
+	while ((pos =3D strchr(pos, match))) {
+		count++;
+		pos++;
+	}
+	return count;
+}
+
+int str_split_by_char(char *str, char **before, char **after, int match)
+{
+	char *slash;
+
+	slash =3D strrchr(str, match);
+	if (!slash)
+		return -EINVAL;
+	*slash =3D '\0';
+	*before =3D str;
+	*after =3D slash + 1;
+	return 0;
+}
+
+struct indent_mem *alloc_indent_mem(void)
+{
+	struct indent_mem *mem =3D malloc(sizeof(*mem));
+
+	if (!mem)
+		return NULL;
+	strcpy(mem->indent_str, "");
+	mem->indent_level =3D 0;
+	return mem;
+}
+
+void free_indent_mem(struct indent_mem *mem)
+{
+	free(mem);
+}
+
+#define INDENT_STR_STEP 2
+
+void inc_indent(struct indent_mem *mem)
+{
+	if (mem->indent_level + INDENT_STR_STEP > INDENT_STR_MAXLEN)
+		return;
+	mem->indent_level +=3D INDENT_STR_STEP;
+	memset(mem->indent_str, ' ', sizeof(mem->indent_str));
+	mem->indent_str[mem->indent_level] =3D '\0';
+}
+
+void dec_indent(struct indent_mem *mem)
+{
+	if (mem->indent_level - INDENT_STR_STEP < 0)
+		return;
+	mem->indent_level -=3D INDENT_STR_STEP;
+	mem->indent_str[mem->indent_level] =3D '\0';
+}
+
+void print_indent(struct indent_mem *mem)
+{
+	if (mem->indent_level)
+		printf("%s", mem->indent_str);
+}
--=20
2.26.2

