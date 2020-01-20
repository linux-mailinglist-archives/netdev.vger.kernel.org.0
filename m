Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F2142BDC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 14:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgATNNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 08:13:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44732 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgATNNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 08:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579526002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7nX6gCvToHh/M+ufmuZNkVcVbY/LiP2p5Z5znXTQZT8=;
        b=aeamstEo4wluHA13W2AFtdyy9HpsLGYyQYOxpBi2dThqJu0PT7DPEUPDf+Yd9Lm0Yuwb7z
        YM0VfHAzA4lrOjh2aUtH50w8riwzTzfsxS4z9slQkhLkIdGqqsJ3XRmgGCDOGgA60vBJD7
        fwCu8Z0CmlMzS0iv8PSNN/NAYAeHff8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-bj2fEK11NmiM4szsIhiMhA-1; Mon, 20 Jan 2020 08:13:21 -0500
X-MC-Unique: bj2fEK11NmiM4szsIhiMhA-1
Received: by mail-ed1-f69.google.com with SMTP id ay24so18741354edb.0
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 05:13:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7nX6gCvToHh/M+ufmuZNkVcVbY/LiP2p5Z5znXTQZT8=;
        b=j7E+YjQSVjm4fA0Qf2McAPPBczghtDGs2FBjzQ+M1q64vLdMGk8SjF5MODTDQAP1Xs
         fh/jKt6kEo+tdQdmsg9a5r8pe0sEk7Ujcph1PPZYVY1XbCehvMVAph5kwv1eIqRBTgEm
         FRErPoRG2HaUnvZTA69+bC5Ls3BE3RDRj89LIBoBSz+Ou08ECUZXQQMMdLMSAKPdUd8T
         CAWFXGphlpjWGdzdiSkmdXlTJUC09UPbrVW+gC50dvw/D+q+Zm/CU1C0kPYjlxrnli0o
         eeZ7FQdkkAQgct7ZwftpMEk0XDPpvY388a7CpwR79CZVOVtSIAcHPH8TKlWjw3tAXBWw
         3r3A==
X-Gm-Message-State: APjAAAUayXC9PPfU0IWqHztk+QGsbIGcpnZg1lvEdVqEt1IbsHcVqr9C
        gYNrg0KuaH/+oA9mShH6uVZYWb59grAPhkjHX59jfrB+BaOsCuhE8S65GvKWe1s0x4s+pyezT1U
        XUuz2lvyPKrJs/eaj
X-Received: by 2002:a17:906:ce3c:: with SMTP id sd28mr20507828ejb.251.1579525999670;
        Mon, 20 Jan 2020 05:13:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0QP6IDZi2QN6qajrJveTlJj75I05ZuYUObj5tdnbOi4mrACFD11iCcZbt/l4zWfp+Ir1i2Q==
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr13842833ljq.109.1579525998002;
        Mon, 20 Jan 2020 05:13:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z3sm16867876ljh.83.2020.01.20.05.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:13:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 709ED1804D6; Mon, 20 Jan 2020 14:06:51 +0100 (CET)
Subject: [PATCH bpf-next v5 10/11] runsqslower: Support user-specified libbpf
 include and object paths
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
Date:   Mon, 20 Jan 2020 14:06:51 +0100
Message-ID: <157952561135.1683545.5660339645093141381.stgit@toke.dk>
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

This adds support for specifying the libbpf include and object paths as
arguments to the runqslower Makefile, to support reusing the libbpf version
built as part of the selftests.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/runqslower/Makefile |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index b90044caf270..faf5418609ea 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -6,7 +6,9 @@ LLVM_STRIP := llvm-strip
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 LIBBPF_SRC := $(abspath ../../lib/bpf)
-INCLUDES := -I$(OUTPUT) -I$(abspath ../../lib)
+BPFOBJ := $(OUTPUT)/libbpf.a
+BPF_INCLUDE := $(OUTPUT)
+INCLUDES := -I$(BPF_INCLUDE) -I$(OUTPUT) -I$(abspath ../../lib)
 CFLAGS := -g -Wall
 
 # Try to detect best kernel BTF source
@@ -37,7 +39,7 @@ clean:
 	$(call msg,CLEAN)
 	$(Q)rm -rf $(OUTPUT) runqslower
 
-$(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(OUTPUT)/libbpf.a
+$(OUTPUT)/runqslower: $(OUTPUT)/runqslower.o $(BPFOBJ)
 	$(call msg,BINARY,$@)
 	$(Q)$(CC) $(CFLAGS) -lelf -lz $^ -o $@
 
@@ -50,7 +52,7 @@ $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
 	$(call msg,GEN-SKEL,$@)
 	$(Q)$(BPFTOOL) gen skeleton $< > $@
 
-$(OUTPUT)/%.bpf.o: %.bpf.c $(OUTPUT)/libbpf.a | $(OUTPUT)
+$(OUTPUT)/%.bpf.o: %.bpf.c $(BPFOBJ) | $(OUTPUT)
 	$(call msg,BPF,$@)
 	$(Q)$(CLANG) -g -O2 -target bpf $(INCLUDES)			      \
 		 -c $(filter %.c,$^) -o $@ &&				      \
@@ -73,9 +75,9 @@ $(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
 	fi
 	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
 
-$(OUTPUT)/libbpf.a: | $(OUTPUT)
+$(BPFOBJ): | $(OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \
-		    OUTPUT=$(abs_out)/ $(abs_out)/libbpf.a
+		    OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
 $(DEFAULT_BPFTOOL):
 	$(Q)$(MAKE) $(submake_extras) -C ../bpftool			      \

