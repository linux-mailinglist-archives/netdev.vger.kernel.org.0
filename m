Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562364B0040
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiBIW22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:28:28 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiBIW2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:28:25 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0E1E019D0D
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:27:38 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id k4so3181597qvt.6
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AoeSGIFKDFsOKzYaQ8dlCFXs0nV+HPcZ36Zoh0gvrgQ=;
        b=E0eaEQdwhB1Vtot4JvTCkatoDq+T/f1GBEEfFesuwakvLwHrThe8f2XcPck+GbLoI5
         oSEKuWCH/N4b2I6NxAyfYn1XYgIKKVaLZIds8p7R5/CaOL3HT/APZ+hbCJmbLZua2wYD
         WO4i8NcDitTLn+DDVF3HtUd732VY4qaxcyVDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AoeSGIFKDFsOKzYaQ8dlCFXs0nV+HPcZ36Zoh0gvrgQ=;
        b=kUXVCIHlbL4AgJ3PWEMMcunsW9vn6i9nFzAuHAqUrWRTiEO7gQDz/5Iz6Ix1BYwSwA
         q12JzuGN6tzDcEiYtKBz96D6RcfBQHenP6ewXzENXrqMI0CwOocdDdgsrGoqJmIZNqHZ
         +RcFv/BeXz6z2+gV+XQMu6k2Vo+gVXuQJEiExi3wB7GDrFPiE+Zn3vwpM+QJ8w/RXroj
         XoOtgHHY1cyEWLjgNYwHDZAgvUZU/Lap20HD47lub0cfWBaWZOSENJKfwXL0R+GNNu2M
         TXQfOOQ98FQaQEET49yPWQkNKTccJxoVfBrHb94+/5vZGZ3XqZG1yFzZe4+j/kqssI31
         1GVA==
X-Gm-Message-State: AOAM533unMqPByDzIqdlzR2SIU5HmTOKUNR1sTSlxkNEXxOhcl4oHs1c
        GzET2KelzsJLudsn3RenuCo+W2PyV6v/3dn2MpcoDqfGq5RkK211URIAn1/xBFpBIYNg2ZXW8l7
        78cWf9o2Wt1AzEN9FaUsjI+/qh/EAHIFTAduUnjTDYbKIvPfPVUdL1Orb/tSKUphzWs7kEg==
X-Google-Smtp-Source: ABdhPJw8SBdHOJkyNJaDUzMw/zo5rlaJrPdABrCrS/DcEaHac8sQbuVu+jHHPrLQUVkB9Tx1wNFH5w==
X-Received: by 2002:a05:6214:2a85:: with SMTP id jr5mr2932956qvb.3.1644445656529;
        Wed, 09 Feb 2022 14:27:36 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h6sm9706287qtx.65.2022.02.09.14.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:27:36 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v6 3/7] bpftool: Add gen min_core_btf command
Date:   Wed,  9 Feb 2022 17:26:42 -0500
Message-Id: <20220209222646.348365-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209222646.348365-1-mauricio@kinvolk.io>
References: <20220209222646.348365-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This command is implemented under the "gen" command in bpftool and the
syntax is the following:

$ bpftool gen min_core_btf INPUT OUTPUT OBJECT [OBJECT...]

INPUT is the file that contains all the BTF types for a kernel and
OUTPUT is the path of the minimize BTF file that will be created with
only the types needed by the objects.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/bash-completion/bpftool |  6 +++-
 tools/bpf/bpftool/gen.c                   | 42 +++++++++++++++++++++--
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 493753a4962e..958e1fd71b5c 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -1003,9 +1003,13 @@ _bpftool()
                             ;;
                     esac
                     ;;
+                min_core_btf)
+                    _filedir
+                    return 0
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'object skeleton help' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'object skeleton help min_core_btf' -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index eacfc6a2060d..582c20602639 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1087,6 +1087,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FILE...]\n"
 		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
+		"       %1$s %2$s min_core_btf INPUT OUTPUT OBJECT [OBJECT...]\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
@@ -1097,10 +1098,45 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
+/* Create minimized BTF file for a set of BPF objects */
+static int minimize_btf(const char *src_btf, const char *dst_btf, const char *objspaths[])
+{
+	return -EOPNOTSUPP;
+}
+
+static int do_min_core_btf(int argc, char **argv)
+{
+	const char *input, *output, **objs;
+	int i, err;
+
+	if (!REQ_ARGS(3)) {
+		usage();
+		return -1;
+	}
+
+	input = GET_ARG();
+	output = GET_ARG();
+
+	objs = (const char **) calloc(argc + 1, sizeof(*objs));
+	if (!objs) {
+		p_err("failed to allocate array for object names");
+		return -ENOMEM;
+	}
+
+	i = 0;
+	while (argc)
+		objs[i++] = GET_ARG();
+
+	err = minimize_btf(input, output, objs);
+	free(objs);
+	return err;
+}
+
 static const struct cmd cmds[] = {
-	{ "object",	do_object },
-	{ "skeleton",	do_skeleton },
-	{ "help",	do_help },
+	{ "object",		do_object },
+	{ "skeleton",		do_skeleton },
+	{ "min_core_btf",	do_min_core_btf},
+	{ "help",		do_help },
 	{ 0 }
 };
 
-- 
2.25.1

