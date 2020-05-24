Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D63B1E00BE
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbgEXQvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387726AbgEXQvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:51:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED27FC061A0E;
        Sun, 24 May 2020 09:51:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e11so6887594pfn.3;
        Sun, 24 May 2020 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=djZbck+yBbWihA0B4R6+ByjUmJULJBdA1YBImrlU7zA=;
        b=nDbhXLl2US+I7Jy7eWm9Db8ItF0n0zo9B4C4V9/VwBvOlBC0Zc/5Jf6FJ75IhaaYhH
         aI1lEiqU34PzU4H4jz902ymn/iyZGFOl+L0cJjLRKHCpEKpqICGKix3ZYss01KTaG52y
         e5dbYjJdQaLg6TAUOYnopzWGD5tkvVIoVEe7p6yoNUSXpkiRz0l6sZWF66CHrZ8DZLx+
         /YKyWNP9AIfirVSv+5E7R4IAg1+Y63zSQYMQBkySg0WXS5rikceh3vdKwcDKECuH8CAk
         /3cv6aWn+3ySRXdwzalmRhbqb+63OeWee7H/QUdhixVojMtjdEJS/kkI9cWAVGzv+fSD
         Z2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=djZbck+yBbWihA0B4R6+ByjUmJULJBdA1YBImrlU7zA=;
        b=dSzO3XAQyCNUvUhJB+yObTnvMV8i+vkuveyVktCt4QahAS6CkXKxHYyIpOxo4jKFbX
         oqUO6H99j8r5owcL8vjTz6EAx81tyP8QPbtMJLyty4uwVJIriOhD4kKoMyFLB45M7ijz
         KoxM2qOWnDkbbnlS2INGFN8UGBchtRftFaP+uMIkq4yYCSCRTYV8cCFyIIMtJNtEploa
         keQxKtBmFYxcm60PC/bQW1R5hfpxm5RqrXzdRDOTROcv6q77EKHc3nteLeN0JkuK9iqQ
         MqXYQrl8sUR6xFAMmrr+hmqL9YBsmky42TRBqwfvzvbHEy5T9Z6E5OYJvjlZsTee+rM4
         C6oA==
X-Gm-Message-State: AOAM530O8zYC/UKFPZXx3QY4c/IDJO3kh6sj0nAImZ+3D0FeSq29Zepx
        E05b1Xm9hHghhhL18DXqDtE=
X-Google-Smtp-Source: ABdhPJxp2K9k9yr09CUmmAzNoN2Jqvqzj8wAhykGnp1Dxj3KinZFafT2485Utm5/x/AK9JbpwpvKAQ==
X-Received: by 2002:a65:4489:: with SMTP id l9mr23136345pgq.223.1590339090544;
        Sun, 24 May 2020 09:51:30 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 7sm11340697pfc.203.2020.05.24.09.51.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 09:51:29 -0700 (PDT)
Subject: [bpf-next PATCH v5 3/5] bpf, sk_msg: add get socket storage helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sun, 24 May 2020 09:51:15 -0700
Message-ID: <159033907577.12355.14740125020572756560.stgit@john-Precision-5820-Tower>
In-Reply-To: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
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
 include/uapi/linux/bpf.h       |    2 ++
 net/core/filter.c              |   15 +++++++++++++++
 tools/include/uapi/linux/bpf.h |    2 ++
 3 files changed, 19 insertions(+)

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

