Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35361DFD5
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfD2Jwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 05:52:47 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54719 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfD2Jwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:52:45 -0400
Received: by mail-wm1-f65.google.com with SMTP id b10so500359wmj.4
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 02:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eUEvq1ZZP5fAahJx3cvB+6G7/DCNm265wzSKCNJscfc=;
        b=OlPzI37wp5Q8kwqaYmuSWrTMVDmWNqOZcIGD5lEDtKoMm+dn44RGYcaOdz+n0OFzqA
         htOQuaJkTsvIJleuoJ9lA63jBJUYNLJTtdYhvkjDQVskjINfuzlpIroJaxPr+IVs/FbM
         1RAN4omqKALTA3n9YSoG0YzrrX6yxVsYZthRmWgaVrAUy0QeQ+v7OlhcWCfR4CnsZHW0
         xI76ZLzadwTzlvzPi09n+TBqc0N065TJis34KpBCvpCq8suokDZDrh4dpom2d8p9nwzD
         upPFIGg8HYkLAXb/7xAgDL7QfdysVRCA+MAWkOhUk1TZVfKqMjJD/dVjY4gE0exacuwt
         2Rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eUEvq1ZZP5fAahJx3cvB+6G7/DCNm265wzSKCNJscfc=;
        b=czTxX/b+cxJLHpWtVEkjQbNgDRTvJGmsAPX1NOgmzkzyrOhJZMU/ebQNEzZQN9Ic60
         RCl43R5LMAr2kfuXaLGRuJ1K2xSDih0snFrNzEYRGzXoBQ+0zlGuyC7V7IvwoVgTOZut
         pwh3lGyWe0tY7Jt/VXQyTr2VQJFgV5znWbj62ZuAis/yZaqIycMciirr0Y99RnpZKFwF
         6PHP36R8CifLdzfz9m/zRfaOmLGAgK2yUu+pWh3n38YK/gSDYZuodbaoQ8dPEp1d4f3Q
         H2AcPvkVDC2yWGe8ziZH4ykWeoEqrAagbO1E/4ETtV3oFGMTwSi4IW2R/pJsw8qyqf7J
         9G9g==
X-Gm-Message-State: APjAAAWUuRphKHshtFiqpegg5z8xCrp1VUc8DK+uEsVWZ4LOUBiduETL
        95vLEYXZy1MyJU4ESNob6TlT3A==
X-Google-Smtp-Source: APXvYqwjyPaHA773c2VUFVGYPa5REgr1zOLKI+SnkrCi5OvNSeKthl4bSSsD31mS1wQGNzj6T1mR1w==
X-Received: by 2002:a1c:d7:: with SMTP id 206mr17976344wma.69.1556531563666;
        Mon, 29 Apr 2019 02:52:43 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x20sm11241535wrg.29.2019.04.29.02.52.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 02:52:42 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 2/6] tools: bpftool: add --log-all option to print all possible log info
Date:   Mon, 29 Apr 2019 10:52:23 +0100
Message-Id: <20190429095227.9745-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429095227.9745-1-quentin.monnet@netronome.com>
References: <20190429095227.9745-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The --log-all option is a shortcut for "--log-libbpf warn,info,debug".
It tells bpftool to print all possible logs from libbpf, and may be
extended in the future to set other log levels from other components as
well.

This option has a short name: "-l".

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/Documentation/bpftool-prog.rst | 4 ++++
 tools/bpf/bpftool/bash-completion/bpftool        | 3 ++-
 tools/bpf/bpftool/main.c                         | 7 ++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 77d9570488d1..0525275f79f1 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -180,6 +180,10 @@ OPTIONS
 		  levels of information to print, which can be **warn**,
 		  **info** or **debug**. The default is **warn,info**.
 
+	-l, --log-all
+		  Print all possible log information. This is a shortcut for
+		  **--log-libbpf warn,info,debug**.
+
 EXAMPLES
 ========
 **# bpftool prog show**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index a232da1b158d..f4ad75c6b243 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -209,7 +209,8 @@ _bpftool()
 
     # Deal with options
     if [[ ${words[cword]} == -* ]]; then
-        local c='--version --json --pretty --bpffs --mapcompat --log-libbpf'
+        local c='--version --json --pretty --bpffs --mapcompat \
+            --log-libbpf --log-all'
         COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
         return 0
     fi
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 6318be6feb5c..417cff76c7a1 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -360,6 +360,7 @@ int main(int argc, char **argv)
 		{ "mapcompat",	no_argument,		NULL,	'm' },
 		{ "nomount",	no_argument,		NULL,	'n' },
 		{ "log-libbpf",	required_argument,	NULL,	'd' },
+		{ "log-all",	no_argument,		NULL,	'l' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -375,7 +376,7 @@ int main(int argc, char **argv)
 	hash_init(map_table.table);
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "Vhpjfmn",
+	while ((opt = getopt_long(argc, argv, "Vhpjfmnl",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -409,6 +410,10 @@ int main(int argc, char **argv)
 			if (set_libbpf_loglevel(optarg))
 				return -1;
 			break;
+		case 'l':
+			if (set_libbpf_loglevel("warn,info,debug"))
+				return -1;
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
-- 
2.17.1

