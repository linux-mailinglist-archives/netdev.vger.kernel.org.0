Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2EDC2D7D0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfE2I34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:29:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:39754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725935AbfE2I34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 04:29:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8F12AE56;
        Wed, 29 May 2019 08:29:54 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] libbpf: Return btf_fd in libbpf__probe_raw_btf
Date:   Wed, 29 May 2019 10:29:41 +0200
Message-Id: <20190529082941.9440-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function load_sk_storage_btf expects that libbpf__probe_raw_btf is
returning a btf descriptor, but before this change it was returning
an information about whether the probe was successful (0 or 1).
load_sk_storage_btf was using that value as an argument to the close
function, which was resulting in closing stdout and thus terminating the
process which used that dunction.

That bug was visible in bpftool. `bpftool feature` subcommand was always
exiting too early (because of closed stdout) and it didn't display all
requested probes. `bpftool -j feature` or `bpftool -p feature` were not
returning a valid json object.

Fixes: d7c4b3980c18 ("libbpf: detect supported kernel BTF features and sanitize BTF")
Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/lib/bpf/libbpf.c        | 36 +++++++++++++++++++++--------------
 tools/lib/bpf/libbpf_probes.c |  7 +------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574406b3..bc2dca36bced 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1645,15 +1645,19 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
 		/* FUNC x */                                    /* [3] */
 		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
 	};
-	int res;
+	int btf_fd;
+	int ret;
 
-	res = libbpf__probe_raw_btf((char *)types, sizeof(types),
-				    strs, sizeof(strs));
-	if (res < 0)
-		return res;
-	if (res > 0)
+	btf_fd = libbpf__probe_raw_btf((char *)types, sizeof(types),
+				       strs, sizeof(strs));
+	if (btf_fd < 0)
+		ret = 0;
+	else {
+		ret = 1;
 		obj->caps.btf_func = 1;
-	return 0;
+	}
+	close(btf_fd);
+	return ret;
 }
 
 static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
@@ -1670,15 +1674,19 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
 		BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
 		BTF_VAR_SECINFO_ENC(2, 0, 4),
 	};
-	int res;
+	int btf_fd;
+	int ret;
 
-	res = libbpf__probe_raw_btf((char *)types, sizeof(types),
-				    strs, sizeof(strs));
-	if (res < 0)
-		return res;
-	if (res > 0)
+	btf_fd = libbpf__probe_raw_btf((char *)types, sizeof(types),
+				       strs, sizeof(strs));
+	if (btf_fd < 0)
+		ret = 0;
+	else {
+		ret = 1;
 		obj->caps.btf_datasec = 1;
-	return 0;
+	}
+	close(btf_fd);
+	return ret;
 }
 
 static int
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 5e2aa83f637a..2c2828345514 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -157,14 +157,9 @@ int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
 	memcpy(raw_btf + hdr.hdr_len + hdr.type_len, str_sec, hdr.str_len);
 
 	btf_fd = bpf_load_btf(raw_btf, btf_len, NULL, 0, false);
-	if (btf_fd < 0) {
-		free(raw_btf);
-		return 0;
-	}
 
-	close(btf_fd);
 	free(raw_btf);
-	return 1;
+	return btf_fd;
 }
 
 static int load_sk_storage_btf(void)
-- 
2.21.0

