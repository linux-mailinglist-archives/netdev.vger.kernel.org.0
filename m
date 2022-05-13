Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2D05261CC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiEMM1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiEMM0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:26:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24868E7A;
        Fri, 13 May 2022 05:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652444812; x=1683980812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JzsGeBssR2YonK6spqkj4DYYmCy1pfIl6z6FfG0gbLY=;
  b=fhOyQhnX9huVW3xhj2s3wwUlFqBiG8vdnLs11/MvVdcGXT6uLW9p9Etx
   q/qMIAAXYvWIkmYH/GkLnTuR0gF7A56PZ0moPsZ+7qX5zmrjZCfL6f6iW
   a4qXnNvkkxKItB/hya7uRsXa8gr8FDFM+dLb93NBEqJ2J9jJPNScozcy2
   f8r2Vnu4o84cju69NiGdfY8c3pM12gtPWmQeOIejM+yfhqn9qeyIz+PI1
   v438E8SLsLScapRR6dDEsp/tFGlBmRPrE129GkNgJEO2fo3fE2jEjbxwc
   lV2SduVhZ6IJCRydbg4gl0pZau4dYEVEDIkt0MBSFoqMrVvkEexiPRxUH
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270228370"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270228370"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 05:26:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="624848359"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 13 May 2022 05:26:48 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 24DCQkFI015654;
        Fri, 13 May 2022 13:26:46 +0100
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
Subject: [PATCH bpf-next v3] bpftool: Use sysfs vmlinux when dumping BTF by ID
Date:   Fri, 13 May 2022 14:17:43 +0200
Message-Id: <20220513121743.12411-1-larysa.zaremba@intel.com>
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

This patch simplifies dumping by ID usage by loading
vmlinux BTF from sysfs as base, if base BTF was not specified
and the ID corresponds to a kernel module BTF.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
From v2[0]:
- instead of using vmlinux as base only after the first unsuccessful
  attempt, set base to vmlinux before loading in applicable cases, precisely
  if no base was provided by user and id belongs to a kernel module BTF.

From v1[1]:
- base BTF is assumed to be vmlinux only for kernel BTFs.

[0] https://lore.kernel.org/bpf/20220505130507.130670-1-larysa.zaremba@intel.com/
[1] https://lore.kernel.org/bpf/20220428111442.111805-1-larysa.zaremba@intel.com/
---
 tools/bpf/bpftool/btf.c | 65 +++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index a2c665beda87..0eb105c416fc 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -459,6 +459,54 @@ static int dump_btf_c(const struct btf *btf,
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
+#define BTF_NAME_BUFF_LEN 64
+
+static bool btf_is_kernel_module(__u32 btf_id)
+{
+	struct bpf_btf_info btf_info = {};
+	char btf_name[BTF_NAME_BUFF_LEN];
+	int btf_fd;
+	__u32 len;
+	int err;
+
+	btf_fd = bpf_btf_get_fd_by_id(btf_id);
+	if (btf_fd < 0) {
+		p_err("can't get BTF object by id (%u): %s",
+		      btf_id, strerror(errno));
+		return false;
+	}
+
+	len = sizeof(btf_info);
+	btf_info.name = ptr_to_u64(btf_name);
+	btf_info.name_len = sizeof(btf_name);
+	err = bpf_obj_get_info_by_fd(btf_fd, &btf_info, &len);
+	close(btf_fd);
+
+	if (err) {
+		p_err("can't get BTF (ID %u) object info: %s",
+		      btf_id, strerror(errno));
+		return false;
+	}
+
+	return strncmp(btf_name, "vmlinux", sizeof(btf_name)) && btf_info.kernel_btf;
+}
+
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL, *base = NULL;
@@ -536,18 +584,11 @@ static int do_dump(int argc, char **argv)
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
@@ -591,6 +632,12 @@ static int do_dump(int argc, char **argv)
 	}
 
 	if (!btf) {
+		if (!base_btf && btf_is_kernel_module(btf_id)) {
+			p_info("Warning: valid base BTF was not specified with -B option, falling back on standard base BTF (%s)",
+			       sysfs_vmlinux);
+			base_btf = get_vmlinux_btf_from_sysfs();
+		}
+
 		btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
 		err = libbpf_get_error(btf);
 		if (err) {
-- 
2.35.1

