Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478E113DB95
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgAPNXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:23:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33689 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbgAPNWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579180941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JNaXEay+BfE39lyxyJ2PEP3ihhAoXZzq/eELhC4L1o=;
        b=ind/tjrp+hJc/rBV+uiLs1nkYyeJ0vpMywNrOWtzT/8qyI6cfzgYFlHjUO8IAsd+oe84X2
        N7m4qdC8kKpBKtTyA3ZwuAM0C3Q+bi+hnF6n6G2L6ASxdCRgvKrvWm/lgrfnzy96F1w5VY
        jDnmrcLSQTWHyDRqLZTcB3qqf5vsTX0=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-5PaoDT-JPIGOXjiKko5YWQ-1; Thu, 16 Jan 2020 08:22:20 -0500
X-MC-Unique: 5PaoDT-JPIGOXjiKko5YWQ-1
Received: by mail-lf1-f72.google.com with SMTP id f18so3820757lfm.2
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:22:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1JNaXEay+BfE39lyxyJ2PEP3ihhAoXZzq/eELhC4L1o=;
        b=n0CIiY8iIiq2to043Ck1otCpCTsfiKOZLm7gOqf1F1/RLpYDvH56XKHfecejHPROYR
         pYiIS07UYmJA8GMVPzueXR1Tl5etuO5lzmLm9CKsq1V4iPBdohV8VjGGmvUo40Ozwt7n
         bbrGGZ8EfGzlBBUCIosTjZD1m6PN3YIBntFzRq3ez3YpG11oSWJc6px/hBNuLG3QqawM
         Z16TZVvoJyr+1/MMG7fezgglJPmLZT3neHJYm4jaegzGugJms6B2jLiX0oazmeK3oTSk
         H5oycHwpAKX3waMpsZQseWeD92d2klR/iPDtv1ZPknLyD1WII20lFHqldOv2sDNUKfIg
         SmIQ==
X-Gm-Message-State: APjAAAWFAWumfQVNDfhGhK4XzN0E1Z1aVPNqjG/l3mElJnKihSYYryEa
        jCOD9mlMw2agkSKLrVDE+WKdsFNeLPC0/KVEclR1MgE0UdkePbtlW3J6IS2rxEuVFdvqb+j8pK7
        jihP+mPQlKqIWF2cJ
X-Received: by 2002:a2e:9b9a:: with SMTP id z26mr2097969lji.181.1579180937447;
        Thu, 16 Jan 2020 05:22:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxmjI3D3P1O0fXnsgjkFsT/4yKIO+PCfW2/djdyLIQ9ovy7b5zFtyo0PIRC1gQN0jlZQeucRw==
X-Received: by 2002:a2e:9b9a:: with SMTP id z26mr2097957lji.181.1579180937304;
        Thu, 16 Jan 2020 05:22:17 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v8sm10931631lji.16.2020.01.16.05.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:22:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2129A1804D6; Thu, 16 Jan 2020 14:22:15 +0100 (CET)
Subject: [PATCH bpf-next v3 03/11] selftests: Pass VMLINUX_BTF to runqslower
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
Date:   Thu, 16 Jan 2020 14:22:15 +0100
Message-ID: <157918093501.1357254.2594464485570114583.stgit@toke.dk>
In-Reply-To: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
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
for the running kernel. Because of the previous changes to the runqslower
Makefile, if no locally-built vmlinux file exists, the wildcard search will
fall back to the pre-defined paths (and error out if they don't exist).

Fixes: 3a0d3092a4ed ("selftests/bpf: Build runqslower from selftests")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 246d09ffb296..30d0e7a813d2 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -127,7 +127,7 @@ $(OUTPUT)/test_stub.o: test_stub.c
 .PHONY: $(OUTPUT)/runqslower
 $(OUTPUT)/runqslower: force
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	      \
-		    OUTPUT=$(CURDIR)/tools/
+		    OUTPUT=$(CURDIR)/tools/ VMLINUX_BTF=$(abspath ../../../../vmlinux)
 
 BPFOBJ := $(OUTPUT)/libbpf.a
 

