Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E189A21081F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgGAJ33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 05:29:29 -0400
Received: from conuserg-12.nifty.com ([210.131.2.79]:46839 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgGAJ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 05:29:28 -0400
X-Greylist: delayed 97089 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2020 05:29:27 EDT
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id 0619QqhQ002765;
        Wed, 1 Jul 2020 18:26:53 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com 0619QqhQ002765
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1593595614;
        bh=5we+5c718gKlOfNkIYOvekscGTKtWBtNSwI5Fr+6doc=;
        h=From:To:Cc:Subject:Date:From;
        b=GZN+JENCwEH5hIIAA5OAA6SiwDSbWFSaHKX9f4TdgmuZDiYDeGmIadJKSPba3wD4T
         ybgOM8V3CHbP2S48ZrQkw8/RhIJNzN5ECtSKZ/tgc/8k+JTmsO6E/e96fzcn9l/pd7
         BmU0+lSIOJCigxHBdsG9WTlo0hiani9w65gI9r9anD4wPx8DfkHtDfwBBjQSYeQm+8
         y5T6NDLZCXLgS5Sx9ZxX8dx+Myww98wU5bELOBFrSDC8AJRNQLP+Muu+CdRuQErEh4
         Zs7ibFUXfzrXiPD6CeCeEhNJQi6/LxgwxXl/lS94IfZcCiUvuIQcp1ZgKfJOKsQxDZ
         CLApO9/M/F5wg==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kbuild@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Song Liu <songliubraving@fb.com>,
        =?UTF-8?q?Valdis=20Kl=20=C4=93=20tnieks?= <valdis.kletnieks@vt.edu>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH] bpfilter: allow to build bpfilter_umh as a module without static library
Date:   Wed,  1 Jul 2020 18:26:44 +0900
Message-Id: <20200701092644.762234-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally, bpfilter_umh was linked with -static only when
CONFIG_BPFILTER_UMH=y.

Commit 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build
bpfilter_umh") silently, accidentally dropped the CONFIG_BPFILTER_UMH=y
test in the Makefile. Revive it in order to link it dynamically when
CONFIG_BPFILTER_UMH=m.

Since commit b1183b6dca3e ("bpfilter: check if $(CC) can link static
libc in Kconfig"), the compiler must be capable of static linking to
enable CONFIG_BPFILTER_UMH, but it requires more than needed.

To loosen the compiler requirement, I changed the dependency as follows:

    depends on CC_CAN_LINK
    depends on m || CC_CAN_LINK_STATIC

If CONFIG_CC_CAN_LINK_STATIC in unset, CONFIG_BPFILTER_UMH is restricted
to 'm' or 'n'.

In theory, CONFIG_CC_CAN_LINK is not required for CONFIG_BPFILTER_UMH=y,
but I did not come up with a good way to describe it.

Fixes: 8a2cc0505cc4 ("bpfilter: use 'userprogs' syntax to build bpfilter_umh")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/bpfilter/Kconfig  | 10 ++++++----
 net/bpfilter/Makefile |  2 ++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
index 84015ef3ee27..73d0b12789f1 100644
--- a/net/bpfilter/Kconfig
+++ b/net/bpfilter/Kconfig
@@ -9,12 +9,14 @@ menuconfig BPFILTER
 if BPFILTER
 config BPFILTER_UMH
 	tristate "bpfilter kernel module with user mode helper"
-	depends on CC_CAN_LINK_STATIC
+	depends on CC_CAN_LINK
+	depends on m || CC_CAN_LINK_STATIC
 	default m
 	help
 	  This builds bpfilter kernel module with embedded user mode helper
 
-	  Note: your toolchain must support building static binaries, since
-	  rootfs isn't mounted at the time when __init functions are called
-	  and do_execv won't be able to find the elf interpreter.
+	  Note: To compile this as built-in, your toolchain must support
+	  building static binaries, since rootfs isn't mounted at the time
+	  when __init functions are called and do_execv won't be able to find
+	  the elf interpreter.
 endif
diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index f23b53294fba..cdac82b8c53a 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -7,10 +7,12 @@ userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
+ifeq ($(CONFIG_BPFILTER_UMH), y)
 # builtin bpfilter_umh should be linked with -static
 # since rootfs isn't mounted at the time of __init
 # function is called and do_execv won't find elf interpreter
 userldflags += -static
+endif
 
 $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
 
-- 
2.25.1

