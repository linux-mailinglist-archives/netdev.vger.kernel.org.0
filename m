Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2C7434712
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhJTIlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhJTIlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5FD61130;
        Wed, 20 Oct 2021 08:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634719137;
        bh=05MhIJFdu/NteHCGIflTaLKzgykCZ8pLRwjkjDBxlBg=;
        h=From:To:Cc:Subject:Date:From;
        b=XgkItdVI8GMwGlnCbW3HoF7JYMirrRwi8bpEz2iLTK8UKqKhf4WC9ZL9i9fhyTAN2
         j/KB+ktQNh0g1wV6cq0YiEgwPY/SP87V4Nb/ioLZhLo8gk4dFxR5KMwNdEDk8wI13k
         P4nDOBWVUoIvEo7caAGXzc9Cws4vGyTeq+TfrN1tMiIbrNyscKyHnG3DmQhefTTWf4
         Ka8Tb3949cGScdgm0bfsA/sX8zuzDG3Aidmm9TeV9Y7P37l67QguBAwL27AvjJzs89
         oH5HPRZObmsfftHnTCp0lwgegA+IvdRMH4tn58xwjshClTMhw0iSOclkKk+60UlpSF
         DVFsIaKCV7LJw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, jonathon.reinhart@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: sysctl data could be in .bss
Date:   Wed, 20 Oct 2021 10:38:54 +0200
Message-Id: <20211020083854.1101670-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A check is made when registering non-init netns sysctl files to ensure
their data pointer does not point to a global data section. This works
well for modules as the check is made against the whole module address
space (is_module_address). But when built-in, the check is made against
the .data section. However global variables initialized to 0 can be in
.bss (-fzero-initialized-in-bss).

Add an extra check to make sure the sysctl data does not point to the
.bss section either.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
---

Hello,

This was previously sent as an RFC[1] waiting for a problematic sysctl
to be fixed. The fix was accepted and is now in the nf tree[2].

This is not sent as a fix to avoid possible new warnings in stable
kernels. (The actual fixes of sysctl files should go).

I think this can go through the net-next tree as kernel/extable.c
doesn't seem to be under any subsystem and a conflict is unlikely to
happen.

Thanks,
Antoine

[1] https://lore.kernel.org/all/20211012155542.827631-1-atenart@kernel.org/T/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=174c376278949c44aad89c514a6b5db6cee8db59

 include/linux/kernel.h | 1 +
 kernel/extable.c       | 8 ++++++++
 net/sysctl_net.c       | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2776423a587e..beb61d0ab220 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -231,6 +231,7 @@ extern char *next_arg(char *args, char **param, char **val);
 extern int core_kernel_text(unsigned long addr);
 extern int init_kernel_text(unsigned long addr);
 extern int core_kernel_data(unsigned long addr);
+extern int core_kernel_bss(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
diff --git a/kernel/extable.c b/kernel/extable.c
index b0ea5eb0c3b4..477a4b6c8f63 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -100,6 +100,14 @@ int core_kernel_data(unsigned long addr)
 	return 0;
 }
 
+int core_kernel_bss(unsigned long addr)
+{
+	if (addr >= (unsigned long)__bss_start &&
+	    addr < (unsigned long)__bss_stop)
+		return 1;
+	return 0;
+}
+
 int __kernel_text_address(unsigned long addr)
 {
 	if (kernel_text_address(addr))
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index f6cb0d4d114c..d883cf65029f 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -144,7 +144,7 @@ static void ensure_safe_net_sysctl(struct net *net, const char *path,
 		addr = (unsigned long)ent->data;
 		if (is_module_address(addr))
 			where = "module";
-		else if (core_kernel_data(addr))
+		else if (core_kernel_data(addr) || core_kernel_bss(addr))
 			where = "kernel";
 		else
 			continue;
-- 
2.31.1

