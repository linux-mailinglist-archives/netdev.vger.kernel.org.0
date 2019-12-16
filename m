Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A225F11FFAD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLPI2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:28:41 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37968 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfLPI2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 03:28:41 -0500
Received: by mail-pg1-f196.google.com with SMTP id a33so3261897pgm.5;
        Mon, 16 Dec 2019 00:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n+yuMf5nWYBUrNRd22g5pPieaL+STd4Dztgr45WcMBg=;
        b=dAkDx/5s4OJ3C36pTvAa4LkNcAgnsq0iuNb07xc29PZddLGkmCXT3KsB7z9G4G8KDC
         y7m8Ehgq+raj7DfOGDpSTNGJOZtZ8EBKUbnGuMfIYLGfRRQuT24jw2V9BhKzJCw5DDTJ
         d9OJqZunQAsz7cd+uHEEZgHg3Sd2fM7wL8CdkGHUchaRsOqnYe0mIE2WlX6mNrhsPp5p
         TBWs3Ulg4lcSEgEnpoKKRAG5XXziDkk68W90y+AbixxiGNNVxVQ1YdrV+4G2yr4y7y6X
         l6kLSPTmSnUFWlv8XPm9GEWL+ZuOT2M6gN83JMkvg6wX94jNPz38EHM9iERrL3QBwXy9
         XSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n+yuMf5nWYBUrNRd22g5pPieaL+STd4Dztgr45WcMBg=;
        b=IUQGMv77WLeiDUP7fJlPS7RsY9KWoRGRYwdxY5cYfjXrHa7U1CguGx7aYBpar/d0E2
         8GlgT2TXEuTcMvibBZURmijuhQYKlJd4gF22ca0tu3CPle2c39M7x6sLqX7P/zA8lsAC
         6SNC4nb/7pdM60T+GFv8nCPU3RqH319dcj33jLom0awE0SoxQcnoAUJAclj7sPLdwnRr
         3bOo6/nMXtxxD696KLxWOI2q0AlbiQLLECq+YNhCMKLxggiOKp0f9L/MFO/d27s4Bh30
         p8ccqfXn5Qggy00hACXx5p2x8VJZskGDKnNiCoMlauTZjip3xqY2BI07CMJ6+Qj/w73R
         DV/Q==
X-Gm-Message-State: APjAAAW8lHn20XcGDVCEMbG19J6xF1NbLYiJGft+KGbCtIintUKRSj54
        NZ2u/w+h/UYi28W5z5nG7j0=
X-Google-Smtp-Source: APXvYqxS7IgzFZgzl5dLgqw/49FZ6wCwNpLieGppWqUw3ssbzktmK4RQzVEfU5VSmmMOoSxwCjS1mw==
X-Received: by 2002:a62:a515:: with SMTP id v21mr14769992pfm.128.1576484920803;
        Mon, 16 Dec 2019 00:28:40 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id v72sm18383861pjb.25.2019.12.16.00.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 00:28:40 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: fix build by renaming variables
Date:   Mon, 16 Dec 2019 17:27:38 +0900
Message-Id: <20191216082738.28421-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In btf__align_of() variable name 't' is shadowed by inner block
declaration of another variable with same name. Patch renames
variables in order to fix it.

  CC       sharedobjs/btf.o
btf.c: In function ‘btf__align_of’:
btf.c:303:21: error: declaration of ‘t’ shadows a previous local [-Werror=shadow]
  303 |   int i, align = 1, t;
      |                     ^
btf.c:283:25: note: shadowed declaration is here
  283 |  const struct btf_type *t = btf__type_by_id(btf, id);
      |

Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 tools/lib/bpf/btf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 520021939d81..5f04f56e1eb6 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -300,16 +300,16 @@ int btf__align_of(const struct btf *btf, __u32 id)
 	case BTF_KIND_UNION: {
 		const struct btf_member *m = btf_members(t);
 		__u16 vlen = btf_vlen(t);
-		int i, align = 1, t;
+		int i, max_align = 1, align;
 
 		for (i = 0; i < vlen; i++, m++) {
-			t = btf__align_of(btf, m->type);
-			if (t <= 0)
-				return t;
-			align = max(align, t);
+			align = btf__align_of(btf, m->type);
+			if (align <= 0)
+				return align;
+			max_align = max(max_align, align);
 		}
 
-		return align;
+		return max_align;
 	}
 	default:
 		pr_warn("unsupported BTF_KIND:%u\n", btf_kind(t));
-- 
2.21.0

