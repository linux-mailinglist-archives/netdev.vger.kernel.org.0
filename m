Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA921A3DF3
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 04:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDJCGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 22:06:22 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33859 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgDJCGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 22:06:22 -0400
Received: by mail-pj1-f67.google.com with SMTP id q16so1446534pje.1;
        Thu, 09 Apr 2020 19:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CMpVmJ+cnQy/gzLhnplIw7thRivCqLL3yG7fXq8V54U=;
        b=AEJQnWZzg53rTfF1TQcWQxy3bwOMKV8uEPRH/XA+Gj76xdqzcDNsZacbQ8kTiQlu0Y
         k1dVSSD9oRjCNg8Sc25Vu13qTVmilXn/1iJ7vqv9BIGRGCviyqrxN+2EIphX09pLRelS
         W6IB/q8nl2Br1j9VsDYckCeNy5WcE2hUZnsOkMjqeigg3qXwxcqpoNMkqcvYDHCCRjqo
         pxgO24zdqRknsUYlHbvABTOTEnMeC+PrusALvS5lvyWC+8mWN0Xr+bhw1I4dM/QU9nTM
         olijG44/acRgbe8HrflqcLYVsTK13G2h6/SK+VpMU/h7vdWzbDDpy/LIE3Rp+tbLumZM
         qksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CMpVmJ+cnQy/gzLhnplIw7thRivCqLL3yG7fXq8V54U=;
        b=ZiXB6juKdSW1FRETMcm4GyoCMU7NJrEal81pa0R6ul0hmXRe4Zg4lanUg1L2O7Z60M
         6E+CCLaQDQz1U3MNKKcGk/UpXDFTIWhsO2plxa4NZmB8GvQsu2nXvTBGSnEwrvAmxa/0
         Ge27rSJZ3R6KulzhvtVZaOQCYrJm7Gs1a4r1tD1Nb9HASFTrVd0OiZtnmhajV7hDJUXJ
         MzG7W+GZ9XRXrvMsSQQHPPCrfK7U3DDfmCIOHL7P9W+YsqvftuUDS12mnGZpxg8ZjeRO
         ZuZJCTkpBjnbiIfqMxJ67Wqr3JLG7SIZnY11tKUbV9INwLu+aak8Tn5qePtKhZpIWW5B
         fKvg==
X-Gm-Message-State: AGi0PuZum6R8DbYPRgRcXhzuOrJtW11fjxKoV6Asc1Yoor5VujHMZ343
        NEB4Llltjcdy0yhjVSHwQA==
X-Google-Smtp-Source: APiQypLYxiQSyFcjg3L0pvugfHdSNkykRc+083UGrL0Fl9G/lJem44Arh0ZO70nrUgN20QYTzaD5Lw==
X-Received: by 2002:a17:90a:3acc:: with SMTP id b70mr2634059pjc.179.1586484380281;
        Thu, 09 Apr 2020 19:06:20 -0700 (PDT)
Received: from localhost.localdomain ([49.142.73.162])
        by smtp.gmail.com with ESMTPSA id s9sm405504pjr.5.2020.04.09.19.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 19:06:19 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH] tools: bpftool: fix struct_ops command invalid pointer free
Date:   Fri, 10 Apr 2020 11:06:12 +0900
Message-Id: <20200410020612.2930667-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit 65c93628599d ("bpftool: Add struct_ops support"),
a new type of command struct_ops has been added.

This command requires kernel CONFIG_DEBUG_INFO_BTF=y, and for retrieving
btf info, get_btf_vmlinux() is used.

When running this command on kernel without BTF debug info, this will
lead to 'btf_vmlinux' variable contains invalid(error) pointer. And by
this, btf_free() causes a segfault when executing 'bpftool struct_ops'.

This commit adds pointer validation with IS_ERR not to free invalid
pointer, and this will fix the segfault issue.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/struct_ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index 2a7befbd11ad..0fe0d584c57e 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -591,6 +591,8 @@ int do_struct_ops(int argc, char **argv)
 
 	err = cmd_select(cmds, argc, argv, do_help);
 
-	btf__free(btf_vmlinux);
+	if (!IS_ERR(btf_vmlinux))
+		btf__free(btf_vmlinux);
+
 	return err;
 }
-- 
2.26.0

