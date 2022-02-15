Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652D94B7AF1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244729AbiBOW7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:59:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiBOW7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:59:47 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D607E61CD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:30 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id o25so201649qkj.7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dUoNVzQd4tS2PRRRezKZ0/UPTa4dRXCSBMWAvOz+mKc=;
        b=CCYdJjTFdVJ6EMjggu+D7OXeR0bMTTF6sn/Nz+JhdtOFV4qsw07LF3lb9PpUtvXdtG
         Sh0joJgowkAlbeaoMC5v/dgPD39yoeJZI0OsYfgGCoQfshE4Bxz6wy91JQjMePbdSI5f
         OZfXh6CLqqQhDNEYLL/+YO2oozBwGhlsBaWeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dUoNVzQd4tS2PRRRezKZ0/UPTa4dRXCSBMWAvOz+mKc=;
        b=WJICGrWsK8mYmijiS44er58LAL0Lx26QNIAmqr9TvKtHzz2zQx+0kftnfDJq43Vf3c
         /qEe/Z7AVryENQsZdoj8HFOYokCq2XtlVIDhtGPQBvlNSTGH8Gkj8hbKA86035IMNdMC
         SJMF0DhyeGRgavegQpr9RlsuVTMuhYbI/Z2yW0JSft83GsUyuSmbnj+T63Gwz2tseARG
         JvUxpx/dQVInaBaOSN5F++CkTtvpiFwo5XBUFozMYcrCo4u/igTozLo8YAM0wEMy9hI4
         USw8Doaqm3aqI2QPz9ba+hTyKoY7E8hpimSOTOg156gxGERjve+GB4W1l+dgalM2lnQh
         VrOQ==
X-Gm-Message-State: AOAM533g+ym5dplcYx7zBxJw05mwT5d2m9VgFaNj96q03CY1rMrHWBIb
        lqGv6r7TxbxljSDrD7mLVP7kbBo4R4k+0KHSf4iu6JQZOms7mAgQSe01cM1VJ2zRtqrY26Ijpgv
        HcgvFjNmnqdEKgy8v+t2IeqcyFUT7qFJKXEqF6kLAVmE/jY+JU/+AdhUbIFL+iJ09fdzR3g==
X-Google-Smtp-Source: ABdhPJwpuLKOrkxFmW4pN0qTDfOhCyD2IGz+j8ccsw+ZqTs4sgLlQBH0n193tPNstP1qnzSIEXcYYw==
X-Received: by 2002:a05:620a:152a:b0:46d:5918:e7cd with SMTP id n10-20020a05620a152a00b0046d5918e7cdmr66549qkk.494.1644965966870;
        Tue, 15 Feb 2022 14:59:26 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id w19sm15520021qkp.6.2022.02.15.14.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:59:26 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v7 3/7] bpftool: Add gen min_core_btf command
Date:   Tue, 15 Feb 2022 17:58:52 -0500
Message-Id: <20220215225856.671072-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215225856.671072-1-mauricio@kinvolk.io>
References: <20220215225856.671072-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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
index 022f30490567..8e066c747691 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1108,6 +1108,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FILE...]\n"
 		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
+		"       %1$s %2$s min_core_btf INPUT OUTPUT OBJECT [OBJECT...]\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
@@ -1118,10 +1119,45 @@ static int do_help(int argc, char **argv)
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

