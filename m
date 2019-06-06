Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB437516
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfFFNYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:24:21 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46391 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFNYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:24:19 -0400
Received: by mail-ed1-f67.google.com with SMTP id h10so3276311edi.13
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 06:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dHmzSWbk8IMgndPg0jHwJtFtzdcw4xzx7gncTOu/cp4=;
        b=tL/2WqD/0fK7SA7BTPly4XAbHwxRjMAO7VEty0N39SSpIUnUOPOZ9W8VMRnys2XoFn
         D81npUb4bJ+6ObhkIS+nRRi3FIdJv0bFMEbibYYcw0JuEc0V+hYuHPAziTKcCIR+MgbT
         02qfOGyl6lIZf0MI+91iWQP9mxwLq94e4x9VQUUoXDwdcLVSTCiReZIm/rJjeQU8Pav7
         kgCCH6az1m2N6gwpLcOw/jLKLxNgEOaa7Zl1eysDBGL4cV5RSDAmJz5m+pkH+O9OeDKa
         4TVVmyvFdYN5f04WGa7alD3DtqYxetLda6oZQXwPuXz0oSV5VWPB3i7d/3LPN/imUtqg
         bB2Q==
X-Gm-Message-State: APjAAAUtVK0wKLcRbtjaw5fNiVEx4mGaeu9JDMV0qKj1AXnp10KuaAow
        0WorwHUfOEVJvlVdEKcETpBgsA==
X-Google-Smtp-Source: APXvYqxq2uei1O/9BHDuysR629JKxKOEYaNDy2SeXwZlGslmKJpJsR0nWrbJ9BL/GGOvhAJT+fMJ5w==
X-Received: by 2002:a17:906:a94c:: with SMTP id hh12mr42400773ejb.143.1559827457799;
        Thu, 06 Jun 2019 06:24:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id l19sm452565edc.84.2019.06.06.06.24.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:24:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A2F1A181CC2; Thu,  6 Jun 2019 15:24:14 +0200 (CEST)
Subject: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Date:   Thu, 06 Jun 2019 15:24:14 +0200
Message-ID: <155982745460.30088.2745998912845128889.stgit@alrua-x1>
In-Reply-To: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The bpf_redirect_map() helper used by XDP programs doesn't return any
indication of whether it can successfully redirect to the map index it was
given. Instead, BPF programs have to track this themselves, leading to
programs using duplicate maps to track which entries are populated in the
devmap.

This patch adds a flag to the XDP version of the bpf_redirect_map() helper,
which makes the helper do a lookup in the map when called, and return
XDP_PASS if there is no value at the provided index.

With this, a BPF program can check the return code from the helper call and
react if it is XDP_PASS (by, for instance, substituting a different
redirect). This works for any type of map used for redirect.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h |    8 ++++++++
 net/core/filter.c        |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7c6aef253173..d57df4f0b837 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3098,6 +3098,14 @@ enum xdp_action {
 	XDP_REDIRECT,
 };
 
+/* Flags for bpf_xdp_redirect_map helper */
+
+/* If set, the help will check if the entry exists in the map and return
+ * XDP_PASS if it doesn't.
+ */
+#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
+#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
+
 /* user accessible metadata for XDP packet hook
  * new fields must be added to the end of this structure
  */
diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..2e532a9b2605 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
 		return XDP_ABORTED;
 
+	if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
+		void *val;
+
+		val = __xdp_map_lookup_elem(map, ifindex);
+		if (unlikely(!val))
+			return XDP_PASS;
+	}
+
 	ri->ifindex = ifindex;
 	ri->flags = flags;
 	WRITE_ONCE(ri->map, map);

