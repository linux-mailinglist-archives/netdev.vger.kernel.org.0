Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB9B1DDEC5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgEVEZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgEVEZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 00:25:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3192C061A0E;
        Thu, 21 May 2020 21:25:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d10so4430317pgn.4;
        Thu, 21 May 2020 21:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Vh2zpRK2ZIuLIbEE9foxk4If0+O89GKPhh1m2P7VrLg=;
        b=I6rK2jqIC9sJp5eJ3pZaIKDj3tZzaOowXSLvUNm/ucJvZlhgEfZfR6kgYmGmChX3fK
         5/UPMvHP3lHwWsK591g1dWKmx3oTjmtM3pUt43uJ4wa2kTLA86y+BzR+1jCcNisuAJ0Q
         vuEGMIa2yoXsM7SPdYtuOwzLPJ1qs+TeRYicb1a5kR6irtCjeypcVqIL7P5wtmQH3yx+
         6GzwWub0IVyuS2G9EIi2ZEzMHCiVPAV9drTerXkpS5ZcwuAuCGKtJW1JUFYj7pv8Zpw0
         9F26ZdtQZkBARQPSDnTXN3AqxkkFC0uIqFg9jiLW/W0Ov2wlEoNHuf+Q0bSZv6KqL5Lw
         Xm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Vh2zpRK2ZIuLIbEE9foxk4If0+O89GKPhh1m2P7VrLg=;
        b=YttZMOb///T9j/TEamiYbflmLF90XUQ0p2wwOzAa0HwDeOu0m+DDEDxuJt/daEBsiO
         q+8nsVrj+CVUICwVLhx+WWrLg9+PqCZdVq5qHz8pbNzQqwO2WheomKOmzzrneKIc1Gid
         ADl9DjBSp/F16rruC50wQFOCOyap8dPaen7axRa7brfvHCXI2+1NEtaiIvFAGmh3vo9o
         DXfm9I0yDFeQ1dL8rV2A21+vV9OHh2ltsEJMoLAcu5OeYPDZV7Mzo/1SCPl6U5TkuZ0w
         Db/3k0XVxLDVLU5GawaWj2T/sqcy7T7LfS38AkwlGV+S3rB+YeFbGvfGyzW3tD5Aw7yj
         xb2g==
X-Gm-Message-State: AOAM533yhVWw4JAynT3WYI60mZfrdGdn56UWlTb3hg8lURCb7i7XZlmZ
        KGuiWEP7z2S41mPi5rYXWqQ=
X-Google-Smtp-Source: ABdhPJz0MMkPfpfomcrsfiHOGpzjjMwZvzQgc5kipsv4dZ7eC5j5ZFwp5q7AAO59edufcKXYpAXYgw==
X-Received: by 2002:a62:6281:: with SMTP id w123mr2113263pfb.248.1590121500324;
        Thu, 21 May 2020 21:25:00 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l23sm5254581pgc.55.2020.05.21.21.24.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 21:24:59 -0700 (PDT)
Subject: [bpf-next PATCH v4 3/5] bpf: sk_msg add get socket storage helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com, lmb@cloudflare.com
Date:   Thu, 21 May 2020 21:24:45 -0700
Message-ID: <159012148558.14791.7400656242498343492.stgit@john-Precision-5820-Tower>
In-Reply-To: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
References: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to use local socket storage.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 0 files changed

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b9b8a0f..d394b09 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3641,6 +3641,8 @@ struct sk_msg_md {
 	__u32 remote_port;	/* Stored in network byte order */
 	__u32 local_port;	/* stored in host byte order */
 	__u32 size;		/* Total size of sk_msg */
+
+	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
 };
 
 struct sk_reuseport_md {
diff --git a/net/core/filter.c b/net/core/filter.c
index a56046a..48b499f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6449,6 +6449,10 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_current_uid_gid_proto;
 	case BPF_FUNC_get_current_pid_tgid:
 		return &bpf_get_current_pid_tgid_proto;
+	case BPF_FUNC_sk_storage_get:
+		return &bpf_sk_storage_get_proto;
+	case BPF_FUNC_sk_storage_delete:
+		return &bpf_sk_storage_delete_proto;
 #ifdef CONFIG_CGROUPS
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
@@ -7269,6 +7273,11 @@ static bool sk_msg_is_valid_access(int off, int size,
 		if (size != sizeof(__u64))
 			return false;
 		break;
+	case offsetof(struct sk_msg_md, sk):
+		if (size != sizeof(__u64))
+			return false;
+		info->reg_type = PTR_TO_SOCKET;
+		break;
 	case bpf_ctx_range(struct sk_msg_md, family):
 	case bpf_ctx_range(struct sk_msg_md, remote_ip4):
 	case bpf_ctx_range(struct sk_msg_md, local_ip4):
@@ -8605,6 +8614,12 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 				      si->dst_reg, si->src_reg,
 				      offsetof(struct sk_msg_sg, size));
 		break;
+
+	case offsetof(struct sk_msg_md, sk):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_msg, sk),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct sk_msg, sk));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 146c742..b95bb16 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3641,6 +3641,8 @@ struct sk_msg_md {
 	__u32 remote_port;	/* Stored in network byte order */
 	__u32 local_port;	/* stored in host byte order */
 	__u32 size;		/* Total size of sk_msg */
+
+	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
 };
 
 struct sk_reuseport_md {

