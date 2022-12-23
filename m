Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E0B655308
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 18:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiLWREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 12:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiLWREO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 12:04:14 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164E3175A0
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 09:04:09 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4NdtnL0mH8z9sZ5;
        Fri, 23 Dec 2022 18:04:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1671815046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KPF4PBkDk0yEQRrOj8ZnL4djX27cE1yMYgoXEb+b/gM=;
        b=cqZsGry4+UgOCxEzm3VA0LCZ8JSdLj5i1RP7moZld7QiXNoDxmFq9E7RRAD/P4hvUCOuwR
        c9hdmC/2xnjiCgFFgqejpgjR+gnEjzlMHd1n/XgieynaxItPtu3vaMu9pej5YNY5mp7a8R
        buaxVEbO55qKFvp0yQUeLVJSOEEax7PsMQxzeugn4ZeNIsYXNdZLWVt3Kza6FsFI9K+VSL
        daiNuNxS1ci1ZkPOnLlb6zQ67yqXsBD0nI9bi8I2xjADeFzI1VzTruzycy5ZAaBvxVfsV7
        hN12J51rSYxiTAIZ48SaEo5lqufFyNLZXQAxUFrIRR25+dGnKEj5M1dLtfcMng==
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     netdev@vger.kernel.org
Cc:     heiko.thiery@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH iproute2 v2] configure: Remove include <sys/stat.h>
Date:   Fri, 23 Dec 2022 18:03:45 +0100
Message-Id: <20221223170345.3785809-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4NdtnL0mH8z9sZ5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check_name_to_handle_at() function in the configure script is
including sys/stat.h. This include fails with glibc 2.36 like this:
````
In file included from /linux-5.15.84/include/uapi/linux/stat.h:5,
                 from /toolchain-x86_64_gcc-12.2.0_glibc/include/bits/statx.h:31,
                 from /toolchain-x86_64_gcc-12.2.0_glibc/include/sys/stat.h:465,
                 from config.YExfMc/name_to_handle_at_test.c:3:
/linux-5.15.84/include/uapi/linux/types.h:10:2: warning: #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders" [-Wcpp]
   10 | #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders"
      |  ^~~~~~~
In file included from /linux-5.15.84/include/uapi/linux/posix_types.h:5,
                 from /linux-5.15.84/include/uapi/linux/types.h:14:
/linux-5.15.84/include/uapi/linux/stddef.h:5:10: fatal error: linux/compiler_types.h: No such file or directory
    5 | #include <linux/compiler_types.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
````

Just removing the include works, the manpage of name_to_handle_at() says
only fcntl.h is needed.

Fixes: c5b72cc56bf8 ("lib/fs: fix issue when {name,open}_to_handle_at() is not implemented")
Tested-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 configure | 1 -
 1 file changed, 1 deletion(-)

diff --git a/configure b/configure
index c02753bb..18be5a03 100755
--- a/configure
+++ b/configure
@@ -214,7 +214,6 @@ check_name_to_handle_at()
     cat >$TMPDIR/name_to_handle_at_test.c <<EOF
 #define _GNU_SOURCE
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <fcntl.h>
 int main(int argc, char **argv)
 {
-- 
2.35.1

