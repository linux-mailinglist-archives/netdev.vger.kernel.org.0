Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2E316EDE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhBJShq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:37:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2780 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhBJSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:35:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602427540000>; Wed, 10 Feb 2021 10:35:00 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:34:59 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v5 2/5] utils: Add helper routines for indent handling
Date:   Wed, 10 Feb 2021 20:34:42 +0200
Message-ID: <20210210183445.1009795-3-parav@nvidia.com>
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
        t=1612982100; bh=HDT133gXudxB52omx1TuwZ9j1XEiBgbv7aS9W5cuFWc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=qovEt/aNZm8cNdWoxgtoG1wAoo2wPoXam1XfJyMOCoxUb5rR5a9OE+vAg1MrqmLzn
         QJJXF7UR/SkXphE65UZx1RuU86gqLkAWfNkXzRs1kgYGcN5/z+vuXtbUMjdPnueJwE
         LjcTV8oYisISjVUG1UuTPY2wPW3UCK5a3yrXbT7mgtdTF6csL9BLmw8ghzGR8wQrwb
         Cj8cJQCVN2NE5dwTaAY/LtRrmKL6WHEeaWcLL0sLr9uZ17h244uIoVCg+mDTmKcT34
         9NocNSiaKaUJ7GBUi1+zG/OEJyxTHu+92g4rdXbYwrZg/fwhitN8oN+WnsLMKNs+I8
         QszP42j67CSFQ==
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

