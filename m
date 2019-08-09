Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25E687B2E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407078AbfHINdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:33:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41767 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406635AbfHINdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:33:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so35534778pgg.8
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pSPBCOQsipUpi/w8TeYgZo0bQ2ucr5W5pdWf7JAzoqA=;
        b=cAqr1TnPF0w6AgcjyxCcj5txeTxqgLfHaB+js5l/VD2CHPbZ1hCZxTHSAvS93RJTrv
         J2MsTlYCL6BxddtBH+GiAd1pnx4sFAMtUP+ZSmOmQiEOudelaUh7Ld7h1A/A5AfbgMUt
         6CzTa/JJVHMRwCxYy3aIrWuXV8qGycIkvlPVwiwiZsgwP5jnWipqanQUkZ6X2tmy+66R
         j4ORHDpTxwwsnX6L+RExeILCu++wE1J2FrGaAk+EEP1hMJqrX9XQB3IISdF9FzOnj1s1
         zBkp1g9+ULIeKvtcCtDT96yZlCLIZIwopiM8BIPiYe5qMqROxV3QHC6XQoPN5Uf1PRTB
         s5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pSPBCOQsipUpi/w8TeYgZo0bQ2ucr5W5pdWf7JAzoqA=;
        b=cbEZj1H6T0GuoIEvv38MnmIzNSdLhqOewQ+V84r0P4B2Q+/qb+eZzQDFqDE9JOFcWM
         nqI7pdF5KGl8ruZwdVdpuVG+GHVVgm8HauETVULs1yVkl+HKJrJvPcK0Ustr6+b2g7oG
         F4CPmHU6YDqepFbLvyWncnBL50FDaPh+8MyHjz346JnOc6Xnx8gToslG6wbICPMfmupM
         c+FJfnBYGMjt2caraGxQgnpAU50/3JjP8Q+ja1e2LtZNOH9STC6dIpLoCcagTcwlZ7Or
         BuK6QL7vEvGvuO/PDgntVuX0dUrN4ydW2tGVBSZlTSLBitXd3N2jqFTXKo6WX8ts42QX
         vOPQ==
X-Gm-Message-State: APjAAAVtkiUliUzObZBYR/tR5FJdZ291ggsxLdWDIzhvDzETdqvEBVxo
        gGQQugTdIS3hYPEQ6Pxj1g==
X-Google-Smtp-Source: APXvYqxqnVdEv/s+0fe75cY0m6mbZ0SQNVcelsJ5xcC86bdGptMmRiCy3Tr9HCaMtuoGrfq5SoZ7Mw==
X-Received: by 2002:a62:834d:: with SMTP id h74mr22480227pfe.254.1565357590886;
        Fri, 09 Aug 2019 06:33:10 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f15sm7242912pje.17.2019.08.09.06.33.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:33:09 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v4,2/4] tools: bpftool: add net detach command to detach XDP on interface
Date:   Fri,  9 Aug 2019 22:32:46 +0900
Message-Id: <20190809133248.19788-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133248.19788-1-danieltimlee@gmail.com>
References: <20190809133248.19788-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net detach`, the attached XDP prog can
be detached. Detaching the BPF prog will be done through libbpf
'bpf_set_link_xdp_fd' with the progfd set to -1.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 74cc346c36cd..ef1e576c6dba 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
 	return 0;
 }
 
+static int do_detach(int argc, char **argv)
+{
+	enum net_attach_type attach_type;
+	int progfd, ifindex, err = 0;
+
+	/* parse detach args */
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
+	attach_type = parse_attach_type(*argv);
+	if (attach_type == net_attach_type_size) {
+		p_err("invalid net attach/detach type: %s", *argv);
+		return -EINVAL;
+	}
+	NEXT_ARG();
+
+	ifindex = net_parse_dev(&argc, &argv);
+	if (ifindex < 1)
+		return -EINVAL;
+
+	/* detach xdp prog */
+	progfd = -1;
+	if (is_prefix("xdp", attach_type_strings[attach_type]))
+		err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);
+
+	if (err < 0) {
+		p_err("interface %s detach failed: %s",
+		      attach_type_strings[attach_type], strerror(errno));
+		return err;
+	}
+
+	if (json_output)
+		jsonw_null(json_wtr);
+
+	return 0;
+}
+
 static int do_show(int argc, char **argv)
 {
 	struct bpf_attach_info attach_info = {};
@@ -422,6 +459,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
 		"       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
+		"       %s %s detach ATTACH_TYPE dev <devname>\n"
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
@@ -432,7 +470,8 @@ static int do_help(int argc, char **argv)
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -441,6 +480,7 @@ static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
 	{ "attach",	do_attach },
+	{ "detach",	do_detach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

