Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F06A3556
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 13:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfH3LAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 07:00:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46604 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfH3LAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 07:00:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id h7so5192347wrt.13
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 04:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oHkWOIUKneM96Wyt7o1Cc9RvWciYrEm0JcdszF+su8k=;
        b=wNpGCBFSgHwPPyZqz/ha0sptmoyhxwuxQd6ZaM8KQiSBCv4LwgV3w17X0/E9JHeBgU
         CZVnD4CB3HcraJT7o8v89LEUgGUXmecbazqXsiExShF5vGp3JJ5Dsodg0pkbzqiZvtVD
         uMCIDBIvhoEtGSAbVpxKNtk0SLUABEcBTcjQ/jmRwo5CkPIjvQy4EvMMC46rhCDkgrFl
         J/j+4IeTRvYLU7Vb3bWg5Q7g1KQu+t3zBulhkma4XTPDUkpILOjgGi6rg88N3HAhqosA
         7ETj6mkk42sT94iGqTTVEkoe6BIACbjaVM5iy6d2WvYtA26gIF+rCATBceEUDNTVEOvp
         B4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oHkWOIUKneM96Wyt7o1Cc9RvWciYrEm0JcdszF+su8k=;
        b=QX0yBWtZq7d8pWRQ/mMfG4Onsgbh6jqur7VkLPnTrbNKbTMviFlKRSA2K4Tu8WuOAv
         qYEDlLg/mYM+Hm1H9jiwo95Gskjxh41JhwRNWM3qzKhK7nZaXeffniSKe5B2ges/SneV
         o6WzekpDMReOQw1gduaPj89EKpL1IlJ83RtMEqRTLlZzQCrFiK0zFvt9nkqmuZcLSvrJ
         +/hG8xnDe+mhZcW4KX4rbrEECx5BOvjWG38+qLO3TbSBXyyRkAEP7ap/aRr4NyJxCHjf
         lGs76JLnjJcjOKj92iN27RuvgayOGBP6YPRvd54eWdFwlHUtMFbNFwkQffCeMngMd++g
         l7xA==
X-Gm-Message-State: APjAAAXP1/rIgQdt+bFCMHoTzTZf+YvyWDzyYumIHixSu+fddKBfvoQo
        T88y8+jsUm6v7R2kQK+nwCbLVw==
X-Google-Smtp-Source: APXvYqzQaKljQj1oVj+cwHiLS/PzbI7pmdiGYRHhTn1lCvZsh/587HgXPW/pDBFc9a91Kjn2uprYgA==
X-Received: by 2002:a5d:4582:: with SMTP id p2mr5524924wrq.305.1567162852657;
        Fri, 30 Aug 2019 04:00:52 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t198sm7848083wmt.39.2019.08.30.04.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 04:00:51 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next v2 2/4] tools: bpftool: improve and check builds for different make invocations
Date:   Fri, 30 Aug 2019 12:00:38 +0100
Message-Id: <20190830110040.31257-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830110040.31257-1-quentin.monnet@netronome.com>
References: <20190830110040.31257-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a number of alternative "make" invocations that can be used to
compile bpftool. The following invocations are expected to work:

  - through the kbuild system, from the top of the repository
    (make tools/bpf)
  - by telling make to change to the bpftool directory
    (make -C tools/bpf/bpftool)
  - by building the BPF tools from tools/
    (cd tools && make bpf)
  - by running make from bpftool directory
    (cd tools/bpf/bpftool && make)

Additionally, setting the O or OUTPUT variables should tell the build
system to use a custom output path, for each of these alternatives.

The following patch fixes the following invocations:

  $ make tools/bpf
  $ make tools/bpf O=<dir>
  $ make -C tools/bpf/bpftool OUTPUT=<dir>
  $ make -C tools/bpf/bpftool O=<dir>
  $ cd tools/ && make bpf O=<dir>
  $ cd tools/bpf/bpftool && make OUTPUT=<dir>
  $ cd tools/bpf/bpftool && make O=<dir>

After this commit, the build still fails for two variants when passing
the OUTPUT variable:

  $ make tools/bpf OUTPUT=<dir>
  $ cd tools/ && make bpf OUTPUT=<dir>

In order to remember and check what make invocations are supposed to
work, and to document the ones which do not, a new script is added to
the BPF selftests. Note that some invocations require the kernel to be
configured, so the script skips them if no .config file is found.

v2:
- In make_and_clean(), set $ERROR to 1 when "make" returns non-zero,
  even if the binary was produced.
- Run "make clean" from the correct directory (bpf/ instead of bpftool/,
  when relevant).

Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/Makefile                    |  12 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/test_bpftool_build.sh       | 143 ++++++++++++++++++
 3 files changed, 152 insertions(+), 6 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_build.sh

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index cd0fc05464e7..3fc82ff9b52c 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -17,21 +17,23 @@ endif
 BPF_DIR = $(srctree)/tools/lib/bpf/
 
 ifneq ($(OUTPUT),)
-  BPF_PATH = $(OUTPUT)
+  LIBBPF_OUTPUT = $(OUTPUT)/libbpf/
+  LIBBPF_PATH = $(LIBBPF_OUTPUT)
 else
-  BPF_PATH = $(BPF_DIR)
+  LIBBPF_PATH = $(BPF_DIR)
 endif
 
-LIBBPF = $(BPF_PATH)libbpf.a
+LIBBPF = $(LIBBPF_PATH)libbpf.a
 
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
 
 $(LIBBPF): FORCE
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) $(OUTPUT)libbpf.a
+	$(if $(LIBBPF_OUTPUT),@mkdir -p $(LIBBPF_OUTPUT))
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) $(LIBBPF_OUTPUT)libbpf.a
 
 $(LIBBPF)-clean:
 	$(call QUIET_CLEAN, libbpf)
-	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(OUTPUT) clean >/dev/null
+	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_OUTPUT) clean >/dev/null
 
 prefix ?= /usr/local
 bash_compdir ?= /usr/share/bash-completion/completions
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1faad0c3c3c9..c7595b4ed55d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -63,7 +63,8 @@ TEST_PROGS := test_kmod.sh \
 	test_tcp_check_syncookie.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
-	test_xdping.sh
+	test_xdping.sh \
+	test_bpftool_build.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
new file mode 100755
index 000000000000..4ba5a34bff56
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -0,0 +1,143 @@
+#!/bin/bash
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+ERROR=0
+TMPDIR=
+
+# If one build fails, continue but return non-0 on exit.
+return_value() {
+	if [ -d "$TMPDIR" ] ; then
+		rm -rf -- $TMPDIR
+	fi
+	exit $ERROR
+}
+trap return_value EXIT
+
+case $1 in
+	-h|--help)
+		echo -e "$0 [-j <n>]"
+		echo -e "\tTest the different ways of building bpftool."
+		echo -e ""
+		echo -e "\tOptions:"
+		echo -e "\t\t-j <n>:\tPass -j flag to 'make'."
+		exit
+		;;
+esac
+
+J=$*
+
+# Assume script is located under tools/testing/selftests/bpf/. We want to start
+# build attempts from the top of kernel repository.
+SCRIPT_REL_PATH=$(realpath --relative-to=$PWD $0)
+SCRIPT_REL_DIR=$(dirname $SCRIPT_REL_PATH)
+KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
+cd $KDIR_ROOT_DIR
+
+check() {
+	local dir=$(realpath $1)
+
+	echo -n "binary:  "
+	# Returns non-null if file is found (and "false" is run)
+	find $dir -type f -executable -name bpftool -print -exec false {} + && \
+		ERROR=1 && printf "FAILURE: Did not find bpftool\n"
+}
+
+make_and_clean() {
+	echo -e "\$PWD:    $PWD"
+	echo -e "command: make -s $* >/dev/null"
+	make $J -s $* >/dev/null
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+	if [ $# -ge 1 ] ; then
+		check ${@: -1}
+	else
+		check .
+	fi
+	(
+		if [ $# -ge 1 ] ; then
+			cd ${@: -1}
+		fi
+		make -s clean
+	)
+	echo
+}
+
+make_with_tmpdir() {
+	local ARGS
+
+	TMPDIR=$(mktemp -d)
+	if [ $# -ge 2 ] ; then
+		ARGS=${@:1:(($# - 1))}
+	fi
+	echo -e "\$PWD:    $PWD"
+	echo -e "command: make -s $ARGS ${@: -1}=$TMPDIR/ >/dev/null"
+	make $J -s $ARGS ${@: -1}=$TMPDIR/ >/dev/null
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+	check $TMPDIR
+	rm -rf -- $TMPDIR
+	echo
+}
+
+echo "Trying to build bpftool"
+echo -e "... through kbuild\n"
+
+if [ -f ".config" ] ; then
+	make_and_clean tools/bpf
+
+	## $OUTPUT is overwritten in kbuild Makefile, and thus cannot be passed
+	## down from toplevel Makefile to bpftool's Makefile.
+
+	# make_with_tmpdir tools/bpf OUTPUT
+	echo -e "skip:    make tools/bpf OUTPUT=<dir> (not supported)\n"
+
+	make_with_tmpdir tools/bpf O
+else
+	echo -e "skip:    make tools/bpf (no .config found)\n"
+	echo -e "skip:    make tools/bpf OUTPUT=<dir> (not supported)\n"
+	echo -e "skip:    make tools/bpf O=<dir> (no .config found)\n"
+fi
+
+echo -e "... from kernel source tree\n"
+
+make_and_clean -C tools/bpf/bpftool
+
+make_with_tmpdir -C tools/bpf/bpftool OUTPUT
+
+make_with_tmpdir -C tools/bpf/bpftool O
+
+echo -e "... from tools/\n"
+cd tools/
+
+make_and_clean bpf
+
+## In tools/bpf/Makefile, function "descend" is called and passes $(O) and
+## $(OUTPUT). We would like $(OUTPUT) to have "bpf/bpftool/" appended before
+## calling bpftool's Makefile, but this is not the case as the "descend"
+## function focuses on $(O)/$(subdir). However, in the present case, updating
+## $(O) to have $(OUTPUT) recomputed from it in bpftool's Makefile does not
+## work, because $(O) is not defined from command line and $(OUTPUT) is not
+## updated in tools/scripts/Makefile.include.
+##
+## Workarounds would require to a) edit "descend" or use an alternative way to
+## call bpftool's Makefile, b) modify the conditions to update $(OUTPUT) and
+## other variables in tools/scripts/Makefile.include (at the risk of breaking
+## the build of other tools), or c) append manually the "bpf/bpftool" suffix to
+## $(OUTPUT) in bpf's Makefile, which may break if targets for other directories
+## use "descend" in the future.
+
+# make_with_tmpdir bpf OUTPUT
+echo -e "skip:    make bpf OUTPUT=<dir> (not supported)\n"
+
+make_with_tmpdir bpf O
+
+echo -e "... from bpftool's dir\n"
+cd bpf/bpftool
+
+make_and_clean
+
+make_with_tmpdir OUTPUT
+
+make_with_tmpdir O
-- 
2.17.1

