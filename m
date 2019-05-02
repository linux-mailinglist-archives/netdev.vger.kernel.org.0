Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7031311F9D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfEBP5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:57:08 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:39146 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726282AbfEBP5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:57:07 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 323CBC020C;
        Thu,  2 May 2019 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556812623; bh=RBOX3eQrC5rsRBXO9Yo4WNgviqeI5NSvve/zb+XLVxc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=Y9N0v0jbsVcHuNWEyS1eF82Jf4TrB1GjTxL4ay82AZzmkjfu9VriSg14I27lP0YdC
         fQEqLS2NlVx9dDvL4mFiu+c+/9kpgO72N6F/2v+ZtNs4AW0Xg84LLUq4P/MCC9N1DV
         rqsN7sYzVG0fDGI36mF3d6qChyQ4AfjURSYmMLyy5kj1/6Elmzy1g4MsrAQo1nZrHE
         AHslJ8cnBPiJjPWui/RyUJz/RDflxwpyS6i8MUfjgSg9svZpoTp/CvDojnVgBFMWxQ
         tuIE91wmOvITeiZo35AtcBJ/860RMj8IrTtpt6awXJ4Mz6XjwdhPq31e6lCA2cJseX
         NfdwXAyzG/1Zw==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id BEF7BA005D;
        Thu,  2 May 2019 15:57:04 +0000 (UTC)
Received: from IN01WEHTCB.internal.synopsys.com (10.144.199.106) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 May 2019 08:57:04 -0700
Received: from IN01WEHTCA.internal.synopsys.com (10.144.199.103) by
 IN01WEHTCB.internal.synopsys.com (10.144.199.105) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 May 2019 21:27:12 +0530
Received: from vineetg-Latitude-E7450.internal.synopsys.com (10.10.161.89) by
 IN01WEHTCA.internal.synopsys.com (10.144.199.243) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 May 2019 21:27:12 +0530
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, Wang Nan <wangnan0@huawei.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-snps-arc@lists.infradead.org>,
        <linux-perf-users@vger.kernel.org>, <arnaldo.melo@gmail.com>,
        Y Song <ys114321@gmail.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2] tools/bpf: fix perf build error with uClibc (seen on ARC)
Date:   Thu, 2 May 2019 08:56:50 -0700
Message-ID: <1556812610-27957-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <CAH3MdRVkUFfwKkgT-pi-RLBpcEf6n0bAwWZOu-=7+qctPTCpkw@mail.gmail.com>
References: <CAH3MdRVkUFfwKkgT-pi-RLBpcEf6n0bAwWZOu-=7+qctPTCpkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.10.161.89]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When build perf for ARC recently, there was a build failure due to lack
of __NR_bpf.

| Auto-detecting system features:
|
| ...                     get_cpuid: [ OFF ]
| ...                           bpf: [ on  ]
|
| #  error __NR_bpf not defined. libbpf does not support your arch.
    ^~~~~
| bpf.c: In function 'sys_bpf':
| bpf.c:66:17: error: '__NR_bpf' undeclared (first use in this function)
|  return syscall(__NR_bpf, cmd, attr, size);
|                 ^~~~~~~~
|                 sys_bpf

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
v1 -> v2
  - Only add syscall nr for ARC, as asm-generic won't work with arm/sh [Y Song]
---
 tools/lib/bpf/bpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 9cd015574e83..d82edadf7589 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -46,6 +46,8 @@
 #  define __NR_bpf 349
 # elif defined(__s390__)
 #  define __NR_bpf 351
+# elif defined(__arc__)
+#  define __NR_bpf 280
 # else
 #  error __NR_bpf not defined. libbpf does not support your arch.
 # endif
-- 
2.7.4

