Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6263B1DD166
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgEUPXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbgEUPXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9938FC061A0E;
        Thu, 21 May 2020 08:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fI4BRYe9whyI1lE6Uh0NEnF4iP7fYZaJTzPrp5Za6uo=; b=Rc9O/LwXdxzubF/e2bxMkK9d4f
        UhDXZm1zKBeKIKj9/Jz1Y/K5qnzv0S8NKWwxSg5bKdgdANSeHGV7KRYVGMH9+l0QVqmZvSCZmnGX9
        qYxlc+F8UryHEcpA7FKBhBekDVxkG7T+4hX9klro7vBfN6bG/qV31zyNMAv1CeRwz+w7RTdwsr/Yu
        HmzRsi5rg7lZwATK3Hm8ID1GMejSC4+E/Ul4LxzW1cgDD7SvARSgrJrDJ+fA4s6kSVr/CwZnIhpCe
        j3S1EHwmmy/IwapVI6M3pg0CMB8ohnyHLd0jPrsbxI8JXy8OYSnnVv4r00AznrYv4pY0YRANLFzMi
        vZOZqSXA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2p-0004TG-H2; Thu, 21 May 2020 15:23:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/23] bpf: handle the compat string in bpf_trace_copy_string better
Date:   Thu, 21 May 2020 17:22:50 +0200
Message-Id: <20200521152301.2587579-13-hch@lst.de>
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

User the proper helper for kernel or userspace addresses based on
TASK_SIZE instead of the dangerous strncpy_from_unsafe function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/trace/bpf_trace.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9d4080590f711..737d739230a6b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -331,8 +331,11 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
 	switch (fmt_ptype) {
 	case 's':
 #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
-		strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
-		break;
+		if ((unsigned long)unsafe_ptr < TASK_SIZE) {
+			strncpy_from_user_nofault(buf, user_ptr, bufsz);
+			break;
+		}
+		fallthrough;
 #endif
 	case 'k':
 		strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
-- 
2.26.2

