Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8D912B5CB
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 17:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfL0QRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 11:17:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55263 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfL0QRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 11:17:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so8391616wmj.4;
        Fri, 27 Dec 2019 08:17:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=SG7nr9ICGnz7OFhLtGkWxeugBCCgStuFW1fApxIreNQ=;
        b=AgvVpyjDm8loZLo6+VCaFOMhnMTYCpy1QBINIh2InUpHnxTlZ+Cbnm/zCzRbYZryx0
         ER+0KtW1zlc50u/C5UQkaxsF7M+nZ3cM7afQ0jcUDxjBWg51aRKZLcRRkXjnDHGS1DhO
         DMvT64EGzawhNtJ43YJwX+Go7475w7HSgdituGVOeTqNs64FuPT7PtniLaK+uCMBvzVE
         yPm/ugil5gUh5trjLV0skGPDYpJmyo1m0+Z8ZvP6D2YtvThH2NDU2aCNtWa+MLZArH3M
         xgYm+TLKnksC5ZQWr5iANcPAQzvLPLfsFE+4+k4xRha90ASdr7ycIHZABT7ZhM2y8iaF
         yEyg==
X-Gm-Message-State: APjAAAUJplQw2ZIWj3lpTv9wqMnTrOvHPn5O8ENnhmrtBltT2HSNCTRv
        SBt+6+5MW7B5cTxEp1ocf5/mSC61wnU=
X-Google-Smtp-Source: APXvYqwOCSXkPlq/h42+G6nm5JcdbVPSDwMAAUSz+cYndNEyvgpZ9zzftenbWKl11ZiOJ1hDdyzCtg==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr20008536wmk.59.1577463419432;
        Fri, 27 Dec 2019 08:16:59 -0800 (PST)
Received: from Nover ([161.105.209.130])
        by smtp.gmail.com with ESMTPSA id 60sm36190353wrn.86.2019.12.27.08.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 08:16:59 -0800 (PST)
Date:   Fri, 27 Dec 2019 17:16:58 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpftool: allow match by name prefixes
Message-ID: <20191227161657.GA16029@Nover>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends bpftool to support lookup of programs and maps by
name prefixes (instead of full name only), as follows.

  $ ./bpftool prog show name tcp_
  19: kprobe  name tcp_cleanup_rbu  tag 639217cf5b184808  gpl
      [...]
  20: kprobe  name tcp_sendmsg  tag 6546b9784163ee69  gpl
      [...]

Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 tools/bpf/bpftool/Documentation/bpftool-map.rst  | 4 ++--
 tools/bpf/bpftool/Documentation/bpftool-prog.rst | 2 +-
 tools/bpf/bpftool/main.h                         | 4 ++--
 tools/bpf/bpftool/map.c                          | 2 +-
 tools/bpf/bpftool/prog.c                         | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index cdeae8ae90ba..bcc38ff9da65 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -39,9 +39,9 @@ MAP COMMANDS
 |	**bpftool** **map freeze**     *MAP*
 |	**bpftool** **map help**
 |
-|	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* | **name** *MAP_NAME* }
+|	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* | **name** *NAME_PREFIX* }
 |	*DATA* := { [**hex**] *BYTES* }
-|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *PROG_NAME* }
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *NAME_PREFIX* }
 |	*VALUE* := { *DATA* | *MAP* | *PROG* }
 |	*UPDATE_FLAGS* := { **any** | **exist** | **noexist** }
 |	*TYPE* := { **hash** | **array** | **prog_array** | **perf_event_array** | **percpu_hash**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 64ddf8a4c518..8e39ac362c16 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -33,7 +33,7 @@ PROG COMMANDS
 |	**bpftool** **prog help**
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
-|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *PROG_NAME* }
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* | **name** *NAME_PREFIX* }
 |	*TYPE* := {
 |		**socket** | **kprobe** | **kretprobe** | **classifier** | **action** |
 |		**tracepoint** | **raw_tracepoint** | **xdp** | **perf_event** | **cgroup/skb** |
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 4e75b58d3989..8e70617e55fb 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -42,12 +42,12 @@
 #define BPF_TAG_FMT	"%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx"
 
 #define HELP_SPEC_PROGRAM						\
-	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG | name PROG_NAME }"
+	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG | name NAME_PREFIX }"
 #define HELP_SPEC_OPTIONS						\
 	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-f|--bpffs} |\n"	\
 	"\t            {-m|--mapcompat} | {-n|--nomount} }"
 #define HELP_SPEC_MAP							\
-	"MAP := { id MAP_ID | pinned FILE | name MAP_NAME }"
+	"MAP := { id MAP_ID | pinned FILE | name NAME_PREFIX }"
 
 static const char * const prog_type_name[] = {
 	[BPF_PROG_TYPE_UNSPEC]			= "unspec",
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c01f76fa6876..79e0d72ffdd2 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -125,7 +125,7 @@ static int map_fd_by_name(char *name, int **fds)
 			goto err_close_fd;
 		}
 
-		if (strncmp(name, info.name, BPF_OBJ_NAME_LEN)) {
+		if (!is_prefix(name, info.name)) {
 			close(fd);
 			continue;
 		}
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 2221bae037f1..295509548c8b 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -117,7 +117,7 @@ static int prog_fd_by_nametag(void *nametag, int **fds, bool tag)
 		}
 
 		if ((tag && memcmp(nametag, info.tag, BPF_TAG_SIZE)) ||
-		    (!tag && strncmp(nametag, info.name, BPF_OBJ_NAME_LEN))) {
+		    (!tag && !is_prefix(nametag, info.name))) {
 			close(fd);
 			continue;
 		}
-- 
2.17.1

