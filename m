Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00288F3CDC
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfKHA1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:54 -0500
Received: from mail-vk1-f202.google.com ([209.85.221.202]:36123 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfKHA1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:54 -0500
Received: by mail-vk1-f202.google.com with SMTP id z23so1939986vkb.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2/Czssji6LbE+N9OQqzsijnWWygjaYbKrNbxhPtNyl8=;
        b=pMEktJgforMUwDvgGu3IFy0UDiE3BBe6hiVN7Tjkq6tf3hjCCkaYYDz+zsqtHshy4x
         tMM6ee6woCNYQC5D2f7DS7Uv2KqbE7JUy04ZbyaXzGLHD0nGVG2//c+IHWqshsLn78o6
         Pf6q0V2jdhZLrqYyOUn6MparVX3rXJWb9dw9Y2vHH0VznLzASMIjZOXszEAhep3E4Wc4
         pXYuHCXKEf5U5qkM84Ky+QSXEAbfeAOqmIw0d2uidJfV64EimvVYEoJMOa11OrK+8f6W
         sE5ko6PsrP0UaD18C0ZW2poLWE8zGOMwNTgXFUPipf/5M4XsERwwN7dKT6hGTJwEAcH2
         OhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2/Czssji6LbE+N9OQqzsijnWWygjaYbKrNbxhPtNyl8=;
        b=noZ2kxxz4JnZJW1NGFQakUd61RF5T+DqOcsvRALMWWFGP/TdrWb07vWGlrA3yO4dLB
         v93GK/D+oN5KD6ukaSujlTjSfJPSBkqPKOLrgR0brIkj45X5Sk44vJuaEHLTapmA6KKM
         117yXsJhqhqgQLdJx/9uWFLDmzczk1AqfXWCKgbRS4NLkYN05jCniLRkefmvFAKy0DIe
         j+jGx1JWX2QpVgQCDlShjpKGPFn/oR3Z94rsbrU3BQIBw0vvNNk3n5xvqg+Gsh5Z0js5
         SAzCVW3Dj+IUnwsCtrMk44opGxT8hqju86TSMtmowYNQtUiz7y5ndm2X0+I2C2aZObP9
         ZEGA==
X-Gm-Message-State: APjAAAVmbIVaBGvTK7d0xcMsa5htvvj60q0WVjJW717llvRuc648aM3p
        FhD6NKhyy176IJnPp6xShvlrmb7rNJwEYg==
X-Google-Smtp-Source: APXvYqxUooU9GnlpP1oF76yT37JTcxw6sLJdET5yyrcWcJ9HjiRfkAb7Jh50e+iZiqqFG9XfiTYcdRFYU2joBw==
X-Received: by 2002:a05:6122:147:: with SMTP id r7mr5128337vko.97.1573172872059;
 Thu, 07 Nov 2019 16:27:52 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:20 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-8-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 7/9] u64_stats: provide u64_stats_t type
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 64bit arches, struct u64_stats_sync is empty and provides
no help against load/store tearing.

Using READ_ONCE()/WRITE_ONCE() would be needed.

But the update side would be slightly more expensive.

local64_t was defined so that we could use regular adds
in a manner which is atomic wrt IRQs.

However the u64_stats infra means we do not have to use
local64_t on 32bit arches since the syncp provides the needed
protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/u64_stats_sync.h | 51 +++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index a27604f99ed044d3492395c0328f41538234d7dc..9de5c10293f593fac6f64458d78f413c3c9fe26c 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -40,8 +40,8 @@
  *   spin_lock_bh(...) or other synchronization to get exclusive access
  *   ...
  *   u64_stats_update_begin(&stats->syncp);
- *   stats->bytes64 += len; // non atomic operation
- *   stats->packets64++;    // non atomic operation
+ *   u64_stats_add(&stats->bytes64, len); // non atomic operation
+ *   u64_stats_inc(&stats->packets64);    // non atomic operation
  *   u64_stats_update_end(&stats->syncp);
  *
  * While a consumer (reader) should use following template to get consistent
@@ -52,8 +52,8 @@
  *
  * do {
  *         start = u64_stats_fetch_begin(&stats->syncp);
- *         tbytes = stats->bytes64; // non atomic operation
- *         tpackets = stats->packets64; // non atomic operation
+ *         tbytes = u64_stats_read(&stats->bytes64); // non atomic operation
+ *         tpackets = u64_stats_read(&stats->packets64); // non atomic operation
  * } while (u64_stats_fetch_retry(&stats->syncp, start));
  *
  *
@@ -68,6 +68,49 @@ struct u64_stats_sync {
 #endif
 };
 
+#if BITS_PER_LONG == 64
+#include <asm/local64.h>
+
+typedef struct {
+	local64_t	v;
+} u64_stats_t ;
+
+static inline u64 u64_stats_read(const u64_stats_t *p)
+{
+	return local64_read(&p->v);
+}
+
+static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
+{
+	local64_add(val, &p->v);
+}
+
+static inline void u64_stats_inc(u64_stats_t *p)
+{
+	local64_inc(&p->v);
+}
+
+#else
+
+typedef struct {
+	u64		v;
+} u64_stats_t;
+
+static inline u64 u64_stats_read(const u64_stats_t *p)
+{
+	return p->v;
+}
+
+static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
+{
+	p->v += val;
+}
+
+static inline void u64_stats_inc(u64_stats_t *p)
+{
+	p->v++;
+}
+#endif
 
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
 {
-- 
2.24.0.432.g9d3f5f5b63-goog

