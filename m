Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3184728DD6B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgJNJYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:24:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730705AbgJNJUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 05:20:23 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 61CEF4C78C70AFF484C9;
        Wed, 14 Oct 2020 17:19:59 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 14 Oct 2020
 17:19:52 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <andrii@kernel.org>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <masahiroy@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
Date:   Wed, 14 Oct 2020 17:17:49 +0800
Message-ID: <20201014091749.25488-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IF CONFIG_BPFILTER_UMH is set, building fails:

In file included from /usr/include/sys/socket.h:33:0,
                 from net/bpfilter/main.c:6:
/usr/include/bits/socket.h:390:10: fatal error: asm/socket.h: No such file or directory
 #include <asm/socket.h>
          ^~~~~~~~~~~~~~
compilation terminated.
scripts/Makefile.userprogs:43: recipe for target 'net/bpfilter/main.o' failed
make[2]: *** [net/bpfilter/main.o] Error 1

Add missing include path to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/bpfilter/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index cdac82b8c53a..389ea76ccc0b 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -5,7 +5,7 @@
 
 userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o
-userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
+userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi -I usr/include/
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
 # builtin bpfilter_umh should be linked with -static
-- 
2.17.1

