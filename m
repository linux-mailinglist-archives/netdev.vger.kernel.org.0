Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C666513266
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiD1L04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiD1L0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:26:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A505E16C;
        Thu, 28 Apr 2022 04:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651145020; x=1682681020;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YSpDATXy/AEnQCqNpDDdMNwfxMpapZmzIYX8S6XiNuc=;
  b=Meg06O/KeVEOvbcvwHOkss7GumVYJbLxc7P6jPEMBnqpwHb/QLaA6cgV
   O5K1DarW7M96UkAn6pPR19Ajk+0uAjvYBE+PVtdj9vSTKsHgovLKg6yAM
   7oVH33UaGpGYGUxDOtTES+uhH/5+t4OHzEGCkl+JSYYrbcmUujm3JMrs2
   eqy6VWYmVRbak3YIZlcumeibMrbOyQk9bnwXIxIwjkvNwAss4JfeO9/JM
   S40mPfl6MM5wYCcZYRhGFaARym7sxnII1RC10yfGnNXDt+N6/XUCuR1/u
   A2/7x2saHMNYbo2IMD7qj7uTXSzzWxb0LZhiNnLIic3qhMOIUk8feNvzq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="352692120"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="352692120"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 04:23:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="541152152"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 28 Apr 2022 04:23:37 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23SBNZi8003960;
        Thu, 28 Apr 2022 12:23:35 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH RESEND bpf-next] bpftool: Use sysfs vmlinux when dumping BTF by ID
Date:   Thu, 28 Apr 2022 13:14:42 +0200
Message-Id: <20220428111442.111805-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, dumping almost all BTFs specified by id requires
using the -B option to pass the base BTF. For most cases
the vmlinux BTF sysfs path should work.

This patch simplifies dumping by ID usage by attempting to
use vmlinux BTF from sysfs, if the first try of loading BTF by ID
fails with certain conditions.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/bpf/bpftool/btf.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index a2c665beda87..557f65e2de5c 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -459,6 +459,22 @@ static int dump_btf_c(const struct btf *btf,
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
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL, *base = NULL;
@@ -536,18 +552,11 @@ static int do_dump(int argc, char **argv)
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
@@ -593,6 +602,14 @@ static int do_dump(int argc, char **argv)
 	if (!btf) {
 		btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
 		err = libbpf_get_error(btf);
+		if (err == -EINVAL && !base_btf) {
+			btf__free(base);
+			base = get_vmlinux_btf_from_sysfs();
+			p_info("Warning: valid base BTF was not specified with -B option, falling back on standard base BTF (sysfs vmlinux)");
+			btf = btf__load_from_kernel_by_id_split(btf_id, base);
+			err = libbpf_get_error(btf);
+		}
+
 		if (err) {
 			p_err("get btf by id (%u): %s", btf_id, strerror(err));
 			goto done;
-- 
2.35.1

