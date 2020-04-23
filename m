Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08231B5626
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgDWHlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:41:39 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:33701 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgDWHlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:41:37 -0400
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 03N7dV9P000368;
        Thu, 23 Apr 2020 16:39:36 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 03N7dV9P000368
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1587627577;
        bh=mNS7qQakks7vv7rluiZ6sy2TT3u/Yp/y0uXOfjW+ff0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgX24GzV3a5gSzU8pqBzK0uUPmBoq73gXEZoV5t08/+yMcChrq6uP7MLHhdRwGGPc
         UWKvR0/hvVQCXVFtYvZMmDoPZQ/cwJ9mDXpvEU300Nv0iI9sU5civP4dV2/hkMVLAd
         FK3BuYRHjhBFQa1B+oUmnNtjb8ARPuZe15DK2bHR9pfUVqUOIyrDpfQwSS0YaEk3Us
         q6/fi3DlDwocFmaIOowfh119DbojAG/bzBarEoAk6yIvb/41VnjUiic1yir+KsK4p0
         yG0QRj3cc7yMSM3LycQICnWyH8UcXZJq1ixs6BeZA2jNqtJYewteyupK7yviIoCJZc
         GujOc7Bj6SMyA==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kbuild@vger.kernel.org
Cc:     bpf@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/16] net: bpfilter: use 'userprogs' syntax to build bpfilter_umh
Date:   Thu, 23 Apr 2020 16:39:17 +0900
Message-Id: <20200423073929.127521-5-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423073929.127521-1-masahiroy@kernel.org>
References: <20200423073929.127521-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user mode helper should be compiled for the same architecture as
the kernel.

This Makefile reuses the 'hostprogs' syntax by overriding HOSTCC with CC.

Now that Kbuild provides the syntax 'userprogs', use it to fix the
Makefile mess.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/bpfilter/Makefile | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 36580301da70..6ee650c6badb 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -3,17 +3,14 @@
 # Makefile for the Linux BPFILTER layer.
 #
 
-hostprogs := bpfilter_umh
+userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o
-KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
-HOSTCC := $(CC)
+user-ccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
-ifeq ($(CONFIG_BPFILTER_UMH), y)
-# builtin bpfilter_umh should be compiled with -static
+# builtin bpfilter_umh should be linked with -static
 # since rootfs isn't mounted at the time of __init
 # function is called and do_execv won't find elf interpreter
-KBUILD_HOSTLDFLAGS += -static
-endif
+bpfilter_umh-ldflags += -static
 
 $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
 
-- 
2.25.1

