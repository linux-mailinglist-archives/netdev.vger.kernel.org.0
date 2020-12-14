Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4987D2D96B7
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 11:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407486AbgLNK6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 05:58:10 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54452 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407369AbgLNK5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 05:57:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=teawaterz@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UIa9lBF_1607943417;
Received: from localhost(mailfrom:teawaterz@linux.alibaba.com fp:SMTPD_---0UIa9lBF_1607943417)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Dec 2020 18:57:03 +0800
From:   Hui Zhu <teawater@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Hui Zhu <teawaterz@linux.alibaba.com>
Subject: [PATCH] samples/bpf/Makefile: Create tools/testing/selftests/bpf dir
Date:   Mon, 14 Dec 2020 18:56:54 +0800
Message-Id: <20201214105654.5048-1-teawater@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hui Zhu <teawaterz@linux.alibaba.com>

Got an error when I built samples/bpf in a separate directory:
make O=../bk/ defconfig
make -j64 bzImage
make headers_install
make V=1 M=samples/bpf
...
...
make -C /home/teawater/kernel/linux/samples/bpf/../..//tools/build
CFLAGS= LDFLAGS= fixdep
make -f
/home/teawater/kernel/linux/samples/bpf/../..//tools/build/Makefile.build
dir=. obj=fixdep
make all_cmd
Warning: Kernel ABI header at 'tools/include/uapi/linux/netlink.h'
differs from latest version at 'include/uapi/linux/netlink.h'
Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h'
differs from latest version at 'include/uapi/linux/if_link.h'
  gcc
-Wp,-MD,samples/bpf/../../tools/testing/selftests/bpf/.cgroup_helpers.o.d
-Wall -O2 -Wmissing-prototypes -Wstrict-prototypes -I./usr/include
-I/home/teawater/kernel/linux/tools/testing/selftests/bpf/
-I/home/teawater/kernel/linux/tools/lib/
-I/home/teawater/kernel/linux/tools/include
-I/home/teawater/kernel/linux/tools/perf -DHAVE_ATTR_TEST=0  -c -o
samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.o
/home/teawater/kernel/linux/samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c
/home/teawater/kernel/linux/samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:315:1:
fatal error: opening dependency file
samples/bpf/../../tools/testing/selftests/bpf/.cgroup_helpers.o.d: No
such file or directory

ls -al samples/bpf/../../tools/testing/selftests/bpf/
ls: cannot access 'samples/bpf/../../tools/testing/selftests/bpf/': No
such file or directory

There is no samples/bpf/../../tools/testing/selftests/bpf/ causing a
compilation error.

This commit add a "make -p" before build files in
samples/bpf/../../tools/testing/selftests/bpf/ to handle the issue.

Signed-off-by: Hui Zhu <teawaterz@linux.alibaba.com>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index aeebf5d12f32..5b940eedf2e8 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -262,6 +262,7 @@ clean:
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like
+	mkdir -p $(obj)/../../tools/testing/selftests/bpf/
 	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
 		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
-- 
2.17.1

