Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435E142A8E4
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhJLP5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234892AbhJLP5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68B7B60F3A;
        Tue, 12 Oct 2021 15:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054146;
        bh=mGg5pdn9UC0b6WN6sZKlvpjSE6lVd9slWpJt7h/B9TE=;
        h=From:To:Cc:Subject:Date:From;
        b=HpyaRFjb0ZzPiXoHE7jUGmas3r9Pv4/X+6Jrp/1a6XjA5YoiO3yaNtTaNYx6wsKyR
         Fc1fcYbKOcYZt2SJzzltnQjgA+Ru+c2FW50gXJI7G//8t1Zp09zR0aN2P2D58p7i9f
         OiQ/GaPjvSD57YNL54kdTA2zC38xugiwUicy9PLvRqb8yn2hdd5lm6zTbqWpcmoFG9
         1lH3c0ttphcDrt84RGA9McYSK9ocL5b4/+wzDQO/bI6RVTaf2M4lOaN+CX7R1TBYOf
         dpuKWjEG3ktISA9HU8MNrAgz6Bfhm11F7kmOPegBU9eZ6rcfVPFvHdFuLjs65HUQAU
         9ZQ6nPAcsxEHA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, jonathon.reinhart@gmail.com,
        netdev@vger.kernel.org
Subject: [RFC net-next] net: sysctl data could be in .bss
Date:   Tue, 12 Oct 2021 17:55:42 +0200
Message-Id: <20211012155542.827631-1-atenart@kernel.org>
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
---

Hello,

This is sent as an RFC as I'd like a fix[1] to be merged before to
avoid introducing a new warning. But this can be reviewed in the
meantime.

I'm not sending this as a fix to avoid possible new warnings in stable
kernels. (The actual fixes of sysctl files should go).

I think this can go through the net-next tree as kernel/extable.c
doesn't seem to be under any subsystem and a conflict is unlikely to
happen.

Thanks!
Antoine

[1] https://lore.kernel.org/all/20211012145437.754391-1-atenart@kernel.org/T/

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

