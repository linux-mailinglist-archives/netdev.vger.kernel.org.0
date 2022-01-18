Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F724924F4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240805AbiARLc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbiARLcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 06:32:10 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F46BC061753;
        Tue, 18 Jan 2022 03:32:10 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id C6A711F43ECC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642505529;
        bh=ZgAzpMGfSGdCPLE/fHhKIS82NhtSqBUPZr7WBPwkwXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx7JWdnsWkWk4grE31vvXpfCXjD8o1vsdwy0POm/s1KLrNoeRG1+DUE2oajaFDksE
         YzadKDKOZi3qe1WBwuczTjfvKccLBARXGJAwasHXtyF9UpiCC85q2oa5Ss1697xmGJ
         3Wxf3mO2riFUnVuBWnuf3yAkPKkfWSbDxk95cI68f3bVuonhtAsYBWBab2s1FWXs9r
         CXijweMt91uQIgihdL4CTkPE2z6sIJQ559xU62dh+RofzTFBMAMy9LWj8AmtlW3T5U
         UC6S3dV6zkyvblf5Nf9oc7RGTxDVpPFdf/ikPDX4fcvu4VGQtk5J7EZLDZcyeH2IRE
         QMWeGlcXUFUSg==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-security-module@vger.kernel.org (open list:LANDLOCK SECURITY
        MODULE), netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 10/10] selftests: vm: remove dependecy from internal kernel macros
Date:   Tue, 18 Jan 2022 16:29:09 +0500
Message-Id: <20220118112909.1885705-11-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118112909.1885705-1-usama.anjum@collabora.com>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The defination of swap() is used from kernel's internal header when this
test is built in source tree. The build fails when this test is built
out of source tree as defination of swap() isn't found. Selftests
shouldn't depend on kernel's internal header files. They can only depend
on uapi header files. Add the defination of swap() to fix the build
error:

	gcc -Wall  -I/linux_mainline2/build/usr/include -no-pie    userfaultfd.c -lrt -lpthread -o /linux_mainline2/build/kselftest/vm/userfaultfd
	userfaultfd.c: In function ‘userfaultfd_stress’:
	userfaultfd.c:1530:3: warning: implicit declaration of function ‘swap’; did you mean ‘swab’? [-Wimplicit-function-declaration]
	 1530 |   swap(area_src, area_dst);
	      |   ^~~~
	      |   swab
	/usr/bin/ld: /tmp/cclUUH7V.o: in function `userfaultfd_stress':
	userfaultfd.c:(.text+0x4d64): undefined reference to `swap'
	/usr/bin/ld: userfaultfd.c:(.text+0x4d82): undefined reference to `swap'
	collect2: error: ld returned 1 exit status

Fixes: 2c769ed7137a ("tools/testing/selftests/vm/userfaultfd.c: use swap() to make code cleaner")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/vm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index d3fd24f9fae8..d2480ab93037 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -119,6 +119,9 @@ struct uffd_stats {
 				 ~(unsigned long)(sizeof(unsigned long long) \
 						  -  1)))
 
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
-- 
2.30.2

