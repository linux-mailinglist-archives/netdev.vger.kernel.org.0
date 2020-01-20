Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3355D142BB2
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgATNHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:07:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45714 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgATNGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579525608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MkLSYm3mzAZXDQgD2SVlnhnv45Ao3CBk7NzaRvQfH7U=;
        b=h6N1aw1ubvrOW7G/ysDHROfT28oEufwwPWGsJlAh84H+szBE/QZp2vaYy3MgJtFDPzapAx
        p26sOUz2hIzznXG3QbFzfehKKEFkYg74WSn4Gw2v/+tPy4Y4h6+yWLbTRdjZ2bad+cD8/Y
        Yd65urD5zM7fvSl8FoxX0bPVQIrKBOo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-pg7KG5P1NdyAHJInNyOD3w-1; Mon, 20 Jan 2020 08:06:47 -0500
X-MC-Unique: pg7KG5P1NdyAHJInNyOD3w-1
Received: by mail-lf1-f71.google.com with SMTP id x23so6222384lfc.5
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MkLSYm3mzAZXDQgD2SVlnhnv45Ao3CBk7NzaRvQfH7U=;
        b=LahG/4dHNLCq7mD48lac71/Twvu7zKXaD5Pc6+yzY5caCRlb3Y8HaGKJJn7HEk0Ize
         OM+SnafRjY2fyqRMPCWKypDlYroHWhrMCtONTtursXjWE/GV9urSuHarr4uL2K9mrxgO
         5Ev4SxCFuuMESmWW5Yj2SojJtM3662YUr6sbLqVHAoAP2cMlySrVcRT/ezMHI3N+jmS0
         hPRrykE3aWHsgkUaCq0ALxNDNh+eQy6wTokm/4oHMlVRDS8ICxb192a94e5BM7p54hR0
         EMiuzmwzFEUvZB/voNTVQ5V3HtWBvLAjunOHnhjtdjdmgeRoJsf4xTwy2IoO4xnFNHD7
         csAQ==
X-Gm-Message-State: APjAAAWt8Wt8a7npRKcIWOiwaTSYEbekV5T6iEry/iMaQiHCGlzgX4Sg
        Pzs7Vvt7hVIryhdZUcbKHorMaq568K7dg+7hlYz3rCM8wdc/6E8dPIOyRHk5x9KAXhhlAFTW7ac
        hFTwUdGTcFELXVmHu
X-Received: by 2002:ac2:5e2e:: with SMTP id o14mr7404720lfg.198.1579525605661;
        Mon, 20 Jan 2020 05:06:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxFiThs7woU8NNE+Z3Xi+dI52IZDR8cAEXZMjePibrZkF51mtKKwxYoZzZkPgd0sMDCRYfMg==
X-Received: by 2002:ac2:5e2e:: with SMTP id o14mr7404688lfg.198.1579525605362;
        Mon, 20 Jan 2020 05:06:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b22sm20503583lji.99.2020.01.20.05.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:06:44 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 89C7B1804D7; Mon, 20 Jan 2020 14:06:43 +0100 (CET)
Subject: [PATCH bpf-next v5 03/11] selftests: Pass VMLINUX_BTF to runqslower
 Makefile
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Mon, 20 Jan 2020 14:06:43 +0100
Message-ID: <157952560344.1683545.2723631988771664417.stgit@toke.dk>
In-Reply-To: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Add a VMLINUX_BTF variable with the locally-built path when calling the
runqslower Makefile from selftests. This makes sure a simple 'make'
invocation in the selftests dir works even when there is no BTF information
for the running kernel. Do a wildcard expansion and include the same paths
for BTF for the running kernel as in the runqslower Makefile, to make it
possible to build selftests without having a vmlinux in the local tree.

Also fix the make invocation to use $(OUTPUT)/tools as the destination
directory instead of $(CURDIR)/tools.

Fixes: 3a0d3092a4ed ("selftests/bpf: Build runqslower from selftests")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/Makefile |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 246d09ffb296..8240282aef7f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -124,10 +124,14 @@ $(OUTPUT)/test_stub.o: test_stub.c
 	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
+VMLINUX_BTF_PATHS := $(abspath ../../../../vmlinux)			\
+			       /sys/kernel/btf/vmlinux			\
+			       /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF:= $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))
 .PHONY: $(OUTPUT)/runqslower
 $(OUTPUT)/runqslower: force
-	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	      \
-		    OUTPUT=$(CURDIR)/tools/
+	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
+		    OUTPUT=$(OUTPUT)/tools/ VMLINUX_BTF=$(VMLINUX_BTF)
 
 BPFOBJ := $(OUTPUT)/libbpf.a
 

