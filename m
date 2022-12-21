Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6F65390F
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 23:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiLUWxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 17:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLUWxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 17:53:36 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E54423E96
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 14:53:34 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4NcpdN4N6dz9sZ1;
        Wed, 21 Dec 2022 23:53:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1671663208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rA9YpxVrjoLJfN9Oaq6nu9p+cmJYsXCGzxW6F2NsZOU=;
        b=BoGTDkM3ZzimNGvHKgappqZHqB1/jsNsPmqRaw9RkrqD40FLseOZhRHIKTX5QKuPFNY69O
        dUx1Y54l6NbGlx2e2kKip8rz0H6EvFrHCFbVSlKdUD/K1Nbb109ygN6LHAnsHc5+3tK+A4
        ivjCzkVjNRpSbW+27dF7bzSdqWcX/YUugKr4Wkrj/1gd1a/xIKwYXXYckTiYvxyFDyM6Xj
        Xz1xzWEEVaWESRUZHQe2OgK7JvEHjXhwUjWpvSop877HOFSOj3Pcc8juF3d0a3502/7quZ
        SZdbxz8CIIbhG6IHPbKbWAk8QAbtDQQNmvakZ7CBwJ7ABRllcQV89KpdgHBUAQ==
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     netdev@vger.kernel.org
Cc:     heiko.thiery@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH iproute2] configure: Remove include <sys/stat.h>
Date:   Wed, 21 Dec 2022 23:53:04 +0100
Message-Id: <20221221225304.3477126-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4NcpdN4N6dz9sZ1
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

