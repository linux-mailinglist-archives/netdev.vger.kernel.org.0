Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B411DD162
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbgEUPXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730109AbgEUPXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F815C061A0E;
        Thu, 21 May 2020 08:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=V3sFdWlGraEdlC3I/bIfjhE1S8jpT74WDIoCxf3hPhY=; b=o+3+sQwxPcLlavSAzP5Wb5mlV7
        4pJUfozGOBi+EIdePhgfn8R7BXuK2VW+obVElYBj27JQHb2XZMxDpZqD4cKu6yd1Wxi3zmUey9w4G
        cSMuw9ovKiqDPDFdMm4g3jRhW2zBbAiBjNndhVDynW8RLwzBEOxtIhEfjSSbDZtt7iOT+FE8Lp/X1
        4zpZKlYtOXAtDNdzckmlEGshqtiEiBMF4FjH5cFnTCrwuLlhqu1mhJVCN+7oH3wmcyjYZDegy6Ic7
        B6VUnU34PLKnYbmSvgeCI+h00IT3Tyahd8vT8OxgqcmtSYXZH/bYgX5Ix8xedieOXDC7SKeM/T4f0
        k/gEciKw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2m-0004RB-Pa; Thu, 21 May 2020 15:23:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/23] bpf: factor out a bpf_trace_copy_string helper
Date:   Thu, 21 May 2020 17:22:49 +0200
Message-Id: <20200521152301.2587579-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521152301.2587579-1-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out a helper to do the fault free access to the string pointer
to get it out of a crazy indentation level.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/trace/bpf_trace.c | 42 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f5231ffea85b9..9d4080590f711 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -321,6 +321,28 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 	return &bpf_probe_write_user_proto;
 }
 
+static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
+		size_t bufsz)
+{
+	void __user *user_ptr = (__force void __user *)unsafe_ptr;
+
+	buf[0] = 0;
+
+	switch (fmt_ptype) {
+	case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
+		break;
+#endif
+	case 'k':
+		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
+		break;
+	case 'u':
+		strncpy_from_user_nofault(buf, user_ptr, bufsz);
+		break;
+	}
+}
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
  * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
@@ -403,24 +425,8 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 				break;
 			}
 
-			buf[0] = 0;
-			switch (fmt_ptype) {
-			case 's':
-#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-				strncpy_from_unsafe(buf, unsafe_ptr,
-						    sizeof(buf));
-				break;
-#endif
-			case 'k':
-				strncpy_from_kernel_nofault(buf, unsafe_ptr,
-							   sizeof(buf));
-				break;
-			case 'u':
-				strncpy_from_user_nofault(buf,
-					(__force void __user *)unsafe_ptr,
-							 sizeof(buf));
-				break;
-			}
+			bpf_trace_copy_string(buf, unsafe_ptr, fmt_ptype,
+					sizeof(buf));
 			goto fmt_next;
 		}
 
-- 
2.26.2

