Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1923E140B06
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgAQNhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:37:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45408 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727026AbgAQNgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579268204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VosVvChz478iuqQd8mY3MBbU9kJ6mOJCPMFLJtpQS9A=;
        b=JapctdLYmJlndbiifzMGssPVyMmyshuZw7pl0eza5u6eyiHXO6aBm3Z+tBZ6ulbQCgKv0l
        cDj/Oh6LbD4R0y0WK3G7wDe86dUNiAXgrsTxk06+2m5uoYiLqBbq37nFUwYrVGIUWF250Q
        415rtzoT2WizfDu7Q978WXdsdndLQyc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-wnD0PvZMNWqLmEH_xigpvw-1; Fri, 17 Jan 2020 08:36:43 -0500
X-MC-Unique: wnD0PvZMNWqLmEH_xigpvw-1
Received: by mail-lf1-f70.google.com with SMTP id i29so4355682lfc.18
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 05:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VosVvChz478iuqQd8mY3MBbU9kJ6mOJCPMFLJtpQS9A=;
        b=KFqoKyzcTpxkYm5gn8P4cqkZOw9CnHHA9OjCRB++SzwJzqjDzPrA01rsxi6DfviujD
         EdJUKdBgYc1xjFA0cDzOnzvzNH3RfQ51HPXbVr1HQogLgGmC1ZOyk1swAO5PbZBIqoD6
         k9J8JBbfJ4jVkEnQyHwI/e03ZCmKCvXCewxtabtaLl3Zc2Z5rdxWNPRB11fpZzC/UEVY
         N9IzP0vgx8BikK/YoM3EKaJmoGhgr5RFdJw8//8oJ1beKtGNgE1laGm3frAuvosMQm0/
         HtWUN7QywLylG+6JIqmbOdiswejXYj8KJfqU4br1QxjBxLVjKm0SorLsCYLNdMdgiLcu
         QLnw==
X-Gm-Message-State: APjAAAWDniPPZbtF3OAa9CdtxcLJYFS2m59gDtLeivNBKolyszqH8vBG
        J7+dZ8DovJkxiN0GgG5USqtvs6p+MAhzEqcNVbwsWPszPcvihP2dA3uwIhTH08GXp+ErhisSM5S
        IY7laYdIAIdVfypJK
X-Received: by 2002:a2e:7a07:: with SMTP id v7mr5832267ljc.271.1579268201644;
        Fri, 17 Jan 2020 05:36:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDzc22CsFKb/cLaKxHhC/rP5bXs/6Q5mMm+BqErB5PbFxN/F3ojSRACUfTIl5DJKT9rUlTrA==
X-Received: by 2002:a2e:7a07:: with SMTP id v7mr5832239ljc.271.1579268201264;
        Fri, 17 Jan 2020 05:36:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s1sm12420064ljc.3.2020.01.17.05.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:36:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3EFB41804D8; Fri, 17 Jan 2020 14:36:39 +0100 (CET)
Subject: [PATCH bpf-next v4 02/10] tools/bpf/runqslower: Fix override option
 for VMLINUX_BTF
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
Date:   Fri, 17 Jan 2020 14:36:39 +0100
Message-ID: <157926819920.1555735.13051810516683828343.stgit@toke.dk>
In-Reply-To: <157926819690.1555735.10756593211671752826.stgit@toke.dk>
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The runqslower tool refuses to build without a file to read vmlinux BTF
from. The build fails with an error message to override the location by
setting the VMLINUX_BTF variable if autodetection fails. However, the
Makefile doesn't actually work with that override - the error message is
still emitted.

Fix this by including the value of VMLINUX_BTF in the expansion, and only
emitting the error message if the *result* is empty. Also permit running
'make clean' even though no VMLINUX_BTF is set.

Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/runqslower/Makefile |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index cff2fbcd29a8..b62fc9646c39 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -10,13 +10,9 @@ CFLAGS := -g -Wall
 
 # Try to detect best kernel BTF source
 KERNEL_REL := $(shell uname -r)
-ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
-VMLINUX_BTF := /sys/kernel/btf/vmlinux
-else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
-VMLINUX_BTF := /boot/vmlinux-$(KERNEL_REL)
-else
-$(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explicitly")
-endif
+VMLINUX_BTF_PATHS := /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_REL)
+VMLINUX_BTF_PATH := $(abspath $(or $(VMLINUX_BTF),$(firstword \
+	$(wildcard $(VMLINUX_BTF_PATHS)))))
 
 abs_out := $(abspath $(OUTPUT))
 ifeq ($(V),1)
@@ -67,9 +63,13 @@ $(OUTPUT):
 	$(call msg,MKDIR,$@)
 	$(Q)mkdir -p $(OUTPUT)
 
-$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF) | $(OUTPUT) $(BPFTOOL)
+$(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
 	$(call msg,GEN,$@)
-	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+	@if [ ! -e "$(VMLINUX_BTF_PATH)" ] ; then \
+		echo "Couldn't find kernel BTF; set VMLINUX_BTF to specify its location."; \
+		exit 1;\
+	fi
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
 
 $(OUTPUT)/libbpf.a: | $(OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)			       \

