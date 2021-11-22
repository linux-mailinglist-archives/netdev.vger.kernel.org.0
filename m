Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53845902A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhKVO2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:28:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239619AbhKVO2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:28:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA74360C4B;
        Mon, 22 Nov 2021 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637591099;
        bh=FGv94gFy4WBdvHEzA6cpyqj2itz57Y1s1entzgLv0lc=;
        h=From:To:Cc:Subject:Date:From;
        b=T8e+gx08Is9wWwskzcBH2IYiZTinWtXE/7L2pDSTB7+vYfvZWxLjCrIUI5Ofp6Hz1
         KA3zhy6cfMVSD1kGXtniQI19wFtYSYFwQ+DOv5Ed6HDc7+Dbwlt26qXglVNuMYgdE2
         T59cCN/yc+viidG1XdNqOwJnNOPnkOFlcel8L2OTSuWuc7nJpkOhWAmNf57sP3CEEc
         mIAmGEYqI7HjdpwnTer407fYonclDdPtVJhhCPpfSDivtvQg3b9ZlBZTduBvFnx20Z
         8oqXQwUjJe/+3gqVfYXCKJQyfpKywq1LiY7EtUvBbC+rJWWnxoNq8TH7Rr5JwQ2swq
         AZ/lX7O//TdUQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, jonathon.reinhart@gmail.com,
        tglx@linutronix.de, peterz@infradead.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH net-next v2] sections: global data can be in .bss
Date:   Mon, 22 Nov 2021 15:24:56 +0100
Message-Id: <20211122142456.181724-1-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When checking an address is located in a global data section also check
for the .bss section as global variables initialized to 0 can be in
there (-fzero-initialized-in-bss).

This was found when looking at ensure_safe_net_sysctl which was failing
to detect non-init sysctl pointing to a global data section when the
data was in the .bss section.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

A few remarks:

- This still targets net-next but I added Arnd if he prefers to take it
  through the 'asm-generic' tree, now that is_kernel_core_data is in
  include/asm-generic/.

- I kept the Acked-by tag as the change is the same really, the
  difference is the core_kernel_data function was renamed to
  is_kernel_core_data and moved since then.

- @Jonathon: with your analysis and suggestion I think you should be
  listed as a co-developer. If that's fine please say so, and reply
  with both a Co-developed-by and a Signed-off-by tags.

Since v1:
  - Grouped the .data and .bss checks in the same function.

v1 was https://lore.kernel.org/all/20211020083854.1101670-1-atenart@kernel.org/T/

Thanks!
Antoine

 include/asm-generic/sections.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 1dfadb2e878d..76a0f16e56cf 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -130,18 +130,24 @@ static inline bool init_section_intersects(void *virt, size_t size)
 
 /**
  * is_kernel_core_data - checks if the pointer address is located in the
- *			 .data section
+ *			 .data or .bss section
  *
  * @addr: address to check
  *
- * Returns: true if the address is located in .data, false otherwise.
+ * Returns: true if the address is located in .data or .bss, false otherwise.
  * Note: On some archs it may return true for core RODATA, and false
  *       for others. But will always be true for core RW data.
  */
 static inline bool is_kernel_core_data(unsigned long addr)
 {
-	return addr >= (unsigned long)_sdata &&
-	       addr < (unsigned long)_edata;
+	if (addr >= (unsigned long)_sdata && addr < (unsigned long)_edata)
+		return true;
+
+	if (addr >= (unsigned long)__bss_start &&
+	    addr < (unsigned long)__bss_stop)
+		return true;
+
+	return false;
 }
 
 /**
-- 
2.33.1

