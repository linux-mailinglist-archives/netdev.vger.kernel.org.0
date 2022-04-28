Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB0513247
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbiD1LVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiD1LVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:21:00 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8016C5B3F8;
        Thu, 28 Apr 2022 04:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651144666; x=1682680666;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YSpDATXy/AEnQCqNpDDdMNwfxMpapZmzIYX8S6XiNuc=;
  b=UNCEw+9uLr5Fn5MbiSDzlVu+rRI5AlBUArUaSc3XLcD79z9Vu0VA6EdT
   XKy6vO8vqDM5NavO1+sawdmeTAZ4Ltc5POW1WXvyUH4Z8Zq7+yW9nQBq0
   hOVsLuvqoAxrfzKdS8cPmbWY+Pm0WoGNSag89B0zSre+ykrBj+VQm77Uy
   KXNI1KNZamSMaLbJgwkafRugh4O17n0hSQZU1MHDcQb7+xR1J3MXGG2PR
   AHAiucQ5hWqwooEThuqV8ygn7skZqk9cvy1I5kkpew8zdhz0ee4VuXy6m
   NusN34vx6l785y2/OyNiLhGcCK0Cun6mFX8jEDnRzIpZeaMx2XPAixr2k
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="266069735"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="266069735"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 04:17:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="682532655"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 28 Apr 2022 04:17:43 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23SBHfQK002736;
        Thu, 28 Apr 2022 12:17:42 +0100
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
Subject: [PATCH] bpftool: Use sysfs vmlinux when dumping BTF by ID
Date:   Thu, 28 Apr 2022 13:08:40 +0200
Message-Id: <20220428110839.111042-1-larysa.zaremba@intel.com>
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

