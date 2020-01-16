Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0813DB80
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAPNWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:22:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729052AbgAPNWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:22:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579180954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xYGxxZgSLFtlH8jcI3Nu4qoKg9CPPVXnWephfx6aPc4=;
        b=Stt8e65Q5XtwCiuINBhMnysaTKnKXhJV5CgkdySzD7uWhw/dZoQ64+oKr8BQVvIgN5ZcRB
        wI7cnoU6S/CARt779faXH/1aGArthe9Py6IfAuWtInsaeL7tuFXv01LrYODYoNVAdH+h4h
        OeA4YgSaC2dBa/cnpsanCW8QF4/xkcY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-Jz8gZXz1M-GAFkA87zBMbQ-1; Thu, 16 Jan 2020 08:22:28 -0500
X-MC-Unique: Jz8gZXz1M-GAFkA87zBMbQ-1
Received: by mail-lj1-f200.google.com with SMTP id a19so5153655ljp.15
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:22:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xYGxxZgSLFtlH8jcI3Nu4qoKg9CPPVXnWephfx6aPc4=;
        b=GmpEtjBw63Wc9t6+hGSEVgPjqZxksGikQxKS9GhulIXS+dqzCo6MC1rVCOjL2f29l4
         cPXk+a+O67VvP1o6YkU3fHFeNmGNBW4Wq+0R83RwJaDtC0X1koMc5agaefrNR6arZ01/
         dg5wh2YtHVbXzwPNDVnN02M34AZJn+ll/BNTZLch13JxYJIwnQF4utSgRI+jXYIvj6ly
         6OJ2DIxnihQCPLMwhgHgZZWCkLFHnwfGjVXMcWiJjxxSHZp6cPMXEQ2+MJDRaAEjA9VM
         waPQV2Mw6QBN4iaaE41ea2mRPSyHrSZaOQf57HujkwyfK7IM3QNri2oCxXD3nPZ3TfNo
         vMSA==
X-Gm-Message-State: APjAAAXUOn7Qu5Oq/Q5HKQ/YSpiMeO26OrmmnjcBR1B6UtBXzzqTqDlf
        u53jKBXO0z68/4KS5mp39HKoZarMKWIXFnr5UAHO4KdNPF0OPWTRw7/Ac5SNCcVMuNvoju9kZTW
        Hs+U2R77pdOQhZc2v
X-Received: by 2002:a2e:b52b:: with SMTP id z11mr2348640ljm.155.1579180947071;
        Thu, 16 Jan 2020 05:22:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxfmdIbBJX76Kqg7+Yyy3+Jb6vlAiz8KLU+B3P9UXhqphkNxoSBonQsyrf+47I652QC3NESmg==
X-Received: by 2002:a2e:b52b:: with SMTP id z11mr2348613ljm.155.1579180946842;
        Thu, 16 Jan 2020 05:22:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s22sm10945565ljm.41.2020.01.16.05.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:22:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 19EEE1808D8; Thu, 16 Jan 2020 14:22:24 +0100 (CET)
Subject: [PATCH bpf-next v3 11/11] libbpf: Fix include of bpf_helpers.h when
 libbpf is installed on system
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
Date:   Thu, 16 Jan 2020 14:22:24 +0100
Message-ID: <157918094400.1357254.5646603555325507261.stgit@toke.dk>
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

The change to use angled includes for bpf_helper_defs.h breaks compilation
against libbpf when it is installed in the include path, since the file is
installed in the bpf/ subdirectory of $INCLUDE_PATH. Since we've now fixed
the selftest Makefile to not require this anymore, revert back to
double-quoted include so bpf_helpers.h works regardless of include path.

Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken from selftests dir")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/bpf_helpers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 050bb7bf5be6..f69cc208778a 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -2,7 +2,7 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__
 
-#include <bpf_helper_defs.h>
+#include "bpf_helper_defs.h"
 
 #define __uint(name, val) int (*name)[val]
 #define __type(name, val) typeof(val) *name

