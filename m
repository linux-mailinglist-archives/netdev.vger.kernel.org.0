Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9F210F66
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 00:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfEAWxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 18:53:51 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:58254 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726126AbfEAWxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 18:53:51 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2829AC0169;
        Wed,  1 May 2019 22:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1556751232; bh=MBk03IEPACXRS9nF/u/+JCyk6lPEN0xQOcBI/LToqls=;
        h=From:To:CC:Subject:Date:From;
        b=W0tsRNLMk9Zplp79naCLyBUECO+G1OCcPZpjnbHDQ0j4JJ21+GEc7qw+IUL4t4eRr
         1+yJGuMtYGdk/UfpAxSIB4E3abWSMgWhwO9Aph8PFCieVnhxfEj3gdJPjOP8Z2ZcXN
         8wJnI2j9ugEr/wzchzwc77NkVhRq2viN3muklkKavGwU4Kts6zN2vKzRqfsLh/OS+s
         6bOH+l2mhF6Wu608/zXnG2OgPEPxiRQ+3BDZX/SDvj64DDnUduGXik2ckguV2N35ZY
         zIqSKEjmUbxa0d8mI9A0GwJ6OEk5QM7aISq4zMtNCnqNOA2pqMHBVp1xhuWK0cBIqH
         H/kaQMXlAt33g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 03127A0071;
        Wed,  1 May 2019 22:53:50 +0000 (UTC)
Received: from IN01WEHTCA.internal.synopsys.com (10.144.199.104) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 1 May 2019 15:53:49 -0700
Received: from IN01WEHTCB.internal.synopsys.com (10.144.199.105) by
 IN01WEHTCA.internal.synopsys.com (10.144.199.103) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 May 2019 04:23:58 +0530
Received: from vineetg-Latitude-E7450.internal.synopsys.com (10.13.182.230) by
 IN01WEHTCB.internal.synopsys.com (10.144.199.243) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 May 2019 04:23:57 +0530
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, Wang Nan <wangnan0@huawei.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-snps-arc@lists.infradead.org>,
        <linux-perf-users@vger.kernel.org>, <arnaldo.melo@gmail.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] tools/bpf: fix perf build error with uClibc (seen on ARC)
Date:   Wed, 1 May 2019 15:53:29 -0700
Message-ID: <1556751209-4778-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.13.182.230]
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

The fix is to define a fallbak __NR_bpf.

The obvious fix with be __arc__ specific value, but i think a better fix
is to use the asm-generic uapi value applicable to ARC as well as any new
arch (hopefully we don't add an old existing arch here). Otherwise I can
just add __arc__

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 tools/lib/bpf/bpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 9cd015574e83..2c5eb7928400 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -47,7 +47,10 @@
 # elif defined(__s390__)
 #  define __NR_bpf 351
 # else
-#  error __NR_bpf not defined. libbpf does not support your arch.
+/*
+ * Any non listed arch (new) will have to asm-generic uapi complient
+ */
+#  define __NR_bpf 280
 # endif
 #endif
 
-- 
2.7.4

