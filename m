Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210CB51C062
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378927AbiEENUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354075AbiEENUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:20:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E4B18E18;
        Thu,  5 May 2022 06:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651756622; x=1683292622;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+6MCbEQSUwrgaPZw/EyhSqJQGKL9MpyVEdD0/n5EPeI=;
  b=NidSsoJSQWI7Xil2Da5FncYmC4RR9xPSXdoS0FD3sT+aCpqFaMydh0jR
   zTZYYVArzsQ22RV7a2W8ipjYbtZJxEEEgTmJHHbmjR5mx9PqHVidT6mz7
   CbwMiqbM7zp8ZJx1xJzfYTbSmtwT6tv/+pJQjgxRWaWRXCkYzQao5cbdY
   CUMFjfjAPphXSC22xGGUKV1jtcWZ+LckTt+h9Zhc6ZXYVuo7FpF9eASsY
   LP5uAPQvvxNJyDRV18g8K7q95evwEIK9nYhYwsORjzNjVMV95YwKVEEZr
   PG4QZN2+LAKlCsHZE+5JrJ/bAN9gTRPyN3/BBoD4ztn59bY2EdyEDiL5z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="331090656"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="331090656"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 06:17:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="563235590"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 05 May 2022 06:16:58 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 245DGuYS009371;
        Thu, 5 May 2022 14:16:56 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH bpf-next v2] bpftool: Use sysfs vmlinux when dumping BTF by ID
Date:   Thu,  5 May 2022 15:05:08 +0200
Message-Id: <20220505130507.130670-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, dumping almost all BTFs specified by id requires
using the -B option to pass the base BTF. For kernel module
BTFs the vmlinux BTF sysfs path should work.

This patch simplifies dumping by ID usage by attempting to
use vmlinux BTF from sysfs, if the first try of loading BTF by ID
fails with certain conditions and the ID corresponds to a kernel
module BTF.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/bpf/bpftool/btf.c | 67 +++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index a2c665beda87..070e0c1595d7 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -459,6 +459,56 @@ static int dump_btf_c(const struct btf *btf,
 	return err;
 }
 
+static const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
+
+static struct btf *get_vmlinux_btf_from_sysfs(void)
+{
+	struct btf *base;
+
+	base = btf__parse(sysfs_vmlinux, NULL);
+	if (libbpf_get_error(base)) {
+		p_err("failed to parse vmlinux BTF at '%s': %ld\n",
+		      sysfs_vmlinux, libbpf_get_error(base));
+		base = NULL;
+	}
+
+	return base;
+}
+
+static struct btf *btf_try_load_with_vmlinux(__u32 btf_id, struct btf **base)
+{
+	struct bpf_btf_info btf_info = {};
+	unsigned int len;
+	int btf_fd;
+	int err;
+
+	btf_fd = bpf_btf_get_fd_by_id(btf_id);
+	if (btf_fd < 0) {
+		p_err("can't get BTF object by id (%u): %s",
+		      btf_id, strerror(errno));
+		return ERR_PTR(btf_fd);
+	}
+
+	len = sizeof(btf_info);
+	err = bpf_obj_get_info_by_fd(btf_fd, &btf_info, &len);
+	close(btf_fd);
+
+	if (err) {
+		p_err("can't get BTF (ID %u) object info: %s",
+		      btf_id, strerror(errno));
+		return ERR_PTR(err);
+	}
+
+	if (!btf_info.kernel_btf) {
+		p_err("BTF with ID %u is not a kernel module BTF, cannot use vmlinux as base",
+		      btf_id);
+		return ERR_PTR(-EINVAL);
+	}
+
+	*base = get_vmlinux_btf_from_sysfs();
+	return btf__load_from_kernel_by_id_split(btf_id, *base);
+}
+
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL, *base = NULL;
@@ -536,18 +586,11 @@ static int do_dump(int argc, char **argv)
 		NEXT_ARG();
 	} else if (is_prefix(src, "file")) {
 		const char sysfs_prefix[] = "/sys/kernel/btf/";
-		const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
 
 		if (!base_btf &&
 		    strncmp(*argv, sysfs_prefix, sizeof(sysfs_prefix) - 1) == 0 &&
-		    strcmp(*argv, sysfs_vmlinux) != 0) {
-			base = btf__parse(sysfs_vmlinux, NULL);
-			if (libbpf_get_error(base)) {
-				p_err("failed to parse vmlinux BTF at '%s': %ld\n",
-				      sysfs_vmlinux, libbpf_get_error(base));
-				base = NULL;
-			}
-		}
+		    strcmp(*argv, sysfs_vmlinux))
+			base = get_vmlinux_btf_from_sysfs();
 
 		btf = btf__parse_split(*argv, base ?: base_btf);
 		err = libbpf_get_error(btf);
@@ -593,6 +636,12 @@ static int do_dump(int argc, char **argv)
 	if (!btf) {
 		btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
 		err = libbpf_get_error(btf);
+		if (err == -EINVAL && !base_btf) {
+			p_info("Warning: valid base BTF was not specified with -B option, falling back on standard base BTF (sysfs vmlinux)");
+			btf = btf_try_load_with_vmlinux(btf_id, &base);
+			err = libbpf_get_error(btf);
+		}
+
 		if (err) {
 			p_err("get btf by id (%u): %s", btf_id, strerror(err));
 			goto done;
-- 
2.35.1

