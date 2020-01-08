Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4608E1347DE
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAHQYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:24:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:32990 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgAHQYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 11:24:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D7EA1B224;
        Wed,  8 Jan 2020 16:24:45 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        Peter Wu <peter@lekensteyn.nl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 2/2] bpftool: Add misc section and probe for large INSN limit
Date:   Wed,  8 Jan 2020 17:23:53 +0100
Message-Id: <20200108162428.25014-3-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200108162428.25014-1-mrostecki@opensuse.org>
References: <20200108162428.25014-1-mrostecki@opensuse.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new probe section (misc) for probes not related to concrete
map types, program types, functions or kernel configuration. Introduce a
probe for large INSN limit as the first one in that section.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/bpf/bpftool/feature.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 03bdc5b3ac49..94735d968c34 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -572,6 +572,18 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 		printf("\n");
 }
 
+static void
+probe_large_insn_limit(const char *define_prefix, __u32 ifindex)
+{
+	bool res;
+
+	res = bpf_probe_large_insn_limit(ifindex);
+	print_bool_feature("have_large_insn_limit",
+			   "Large program size limit",
+			   "HAVE_LARGE_INSN_LIMIT",
+			   res, define_prefix);
+}
+
 static int do_probe(int argc, char **argv)
 {
 	enum probe_component target = COMPONENT_UNSPEC;
@@ -724,6 +736,12 @@ static int do_probe(int argc, char **argv)
 		probe_helpers_for_progtype(i, supported_types[i],
 					   define_prefix, ifindex);
 
+	print_end_then_start_section("misc",
+				     "Scanning miscellaneous eBPF features...",
+				     "/*** eBPF misc features ***/",
+				     define_prefix);
+	probe_large_insn_limit(define_prefix, ifindex);
+
 exit_close_json:
 	if (json_output) {
 		/* End current "section" of probes */
-- 
2.16.4

