Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9F48E8B
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbfFQT1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31876 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726964AbfFQT1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:10 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJCpDG019174
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5y3vxn2DFcdSf4r61of7ffwjsaM4VR7L3hH5wL9Pfv4=;
 b=OcUnaD6VBC281RtwauT7fNWYhU/O/yv0EWBhcDe2t45dpDqV4pohKIMgASxd9Cps6w9a
 mmKQZMSM7YIMdN/rTc+/L2z2eraNm2BUYPHytg95LoHHdfSq5UsxYUTwROmMqrcVBD1D
 j7vJANXq5Wk2IsdUqNe9kSSDUjZu/hP2TNc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6e8erpwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:09 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B297786173A; Mon, 17 Jun 2019 12:27:07 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 03/11] libbpf: streamline ELF parsing error-handling
Date:   Mon, 17 Jun 2019 12:26:52 -0700
Message-ID: <20190617192700.2313445-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify ELF parsing logic by exiting early, as there is no common clean
up path to execute. That makes it unnecessary to track when err was set
and when it was cleared. It also reduces nesting in some places.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 44 +++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 49d3a808e754..7ee44d8877c5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1154,24 +1154,21 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 		if (gelf_getshdr(scn, &sh) != &sh) {
 			pr_warning("failed to get section(%d) header from %s\n",
 				   idx, obj->path);
-			err = -LIBBPF_ERRNO__FORMAT;
-			goto out;
+			return -LIBBPF_ERRNO__FORMAT;
 		}
 
 		name = elf_strptr(elf, ep->e_shstrndx, sh.sh_name);
 		if (!name) {
 			pr_warning("failed to get section(%d) name from %s\n",
 				   idx, obj->path);
-			err = -LIBBPF_ERRNO__FORMAT;
-			goto out;
+			return -LIBBPF_ERRNO__FORMAT;
 		}
 
 		data = elf_getdata(scn, 0);
 		if (!data) {
 			pr_warning("failed to get section(%d) data from %s(%s)\n",
 				   idx, name, obj->path);
-			err = -LIBBPF_ERRNO__FORMAT;
-			goto out;
+			return -LIBBPF_ERRNO__FORMAT;
 		}
 		pr_debug("section(%d) %s, size %ld, link %d, flags %lx, type=%d\n",
 			 idx, name, (unsigned long)data->d_size,
@@ -1182,10 +1179,14 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 			err = bpf_object__init_license(obj,
 						       data->d_buf,
 						       data->d_size);
+			if (err)
+				return err;
 		} else if (strcmp(name, "version") == 0) {
 			err = bpf_object__init_kversion(obj,
 							data->d_buf,
 							data->d_size);
+			if (err)
+				return err;
 		} else if (strcmp(name, "maps") == 0) {
 			obj->efile.maps_shndx = idx;
 		} else if (strcmp(name, BTF_ELF_SEC) == 0) {
@@ -1196,11 +1197,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 			if (obj->efile.symbols) {
 				pr_warning("bpf: multiple SYMTAB in %s\n",
 					   obj->path);
-				err = -LIBBPF_ERRNO__FORMAT;
-			} else {
-				obj->efile.symbols = data;
-				obj->efile.strtabidx = sh.sh_link;
+				return -LIBBPF_ERRNO__FORMAT;
 			}
+			obj->efile.symbols = data;
+			obj->efile.strtabidx = sh.sh_link;
 		} else if (sh.sh_type == SHT_PROGBITS && data->d_size > 0) {
 			if (sh.sh_flags & SHF_EXECINSTR) {
 				if (strcmp(name, ".text") == 0)
@@ -1214,6 +1214,7 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 
 					pr_warning("failed to alloc program %s (%s): %s",
 						   name, obj->path, cp);
+					return err;
 				}
 			} else if (strcmp(name, ".data") == 0) {
 				obj->efile.data = data;
@@ -1225,8 +1226,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 				pr_debug("skip section(%d) %s\n", idx, name);
 			}
 		} else if (sh.sh_type == SHT_REL) {
+			int nr_reloc = obj->efile.nr_reloc;
 			void *reloc = obj->efile.reloc;
-			int nr_reloc = obj->efile.nr_reloc + 1;
 			int sec = sh.sh_info; /* points to other section */
 
 			/* Only do relo for section with exec instructions */
@@ -1236,28 +1237,24 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 				continue;
 			}
 
-			reloc = reallocarray(reloc, nr_reloc,
+			reloc = reallocarray(reloc, nr_reloc + 1,
 					     sizeof(*obj->efile.reloc));
 			if (!reloc) {
 				pr_warning("realloc failed\n");
-				err = -ENOMEM;
-			} else {
-				int n = nr_reloc - 1;
+				return -ENOMEM;
+			}
 
-				obj->efile.reloc = reloc;
-				obj->efile.nr_reloc = nr_reloc;
+			obj->efile.reloc = reloc;
+			obj->efile.nr_reloc++;
 
-				obj->efile.reloc[n].shdr = sh;
-				obj->efile.reloc[n].data = data;
-			}
+			obj->efile.reloc[nr_reloc].shdr = sh;
+			obj->efile.reloc[nr_reloc].data = data;
 		} else if (sh.sh_type == SHT_NOBITS && strcmp(name, ".bss") == 0) {
 			obj->efile.bss = data;
 			obj->efile.bss_shndx = idx;
 		} else {
 			pr_debug("skip section(%d) %s\n", idx, name);
 		}
-		if (err)
-			goto out;
 	}
 
 	if (!obj->efile.strtabidx || obj->efile.strtabidx >= idx) {
@@ -1270,10 +1267,9 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 	if (bpf_object__has_maps(obj)) {
 		err = bpf_object__init_maps(obj, flags);
 		if (err)
-			goto out;
+			return err;
 	}
 	err = bpf_object__init_prog_names(obj);
-out:
 	return err;
 }
 
-- 
2.17.1

