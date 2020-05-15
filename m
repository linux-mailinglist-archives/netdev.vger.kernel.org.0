Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B191D5C11
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEOWGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOWGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:06:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378BBC061A0C;
        Fri, 15 May 2020 15:06:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e18so4329221iog.9;
        Fri, 15 May 2020 15:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=l0fi4reCxer9j8s9eFCBgAkvySexoWyfcL59EJukikY=;
        b=LxhqcWhPLBEftR47C+v6nBU3ILpjsHwv6xxYgpO/OkYWyxQUDrJEfWCjJZd805E3eD
         88eWenEKf+nxNimKv9DVrDjnZpAIoVWMJyyAIECOjNr4CKuNgfyUJsbpM0Rfz5DZstMj
         ogN/M6fi5WV6hBZ3a5KPICK8/Zfs8PsmYwBoOI+jGqvdtfWvXxcPiOwWkDSXeyYB+Ck4
         zf1288dBawZ8L905oBwPUyu85akyBfXHUuTpgDEYI+hOJyt3qUTUMYwr/r3ehcI12qyn
         n8v+4qHLGLCpRcfBxw1met1+ciJ7OWION0HdKjlaM2xNrW/bzqKY1tTS+UqH4aCrG3fN
         NR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=l0fi4reCxer9j8s9eFCBgAkvySexoWyfcL59EJukikY=;
        b=DiAUELLLhV+8tnU42dkDFj3CL9lavRMTtUU8lNWmuGsxA8JTsmUnxGZhxvBAHML75G
         geYKlvWpsqE/3a3+/BU4dbj6RM5RX5x0+WIHDFeX+r4MMuQ3jBGAMV88n4tLqWy9Avoj
         ZAd/HlJ2LvbjpKQyKm2U3P9brwypnqCj9NL/Jd+FVVaZlp+u0wZ+q0Q0GRKXKWkdUMMx
         wC9DsfTExqFvEMM8c3iBuoPIuIysS6mtW99NnoBlwMZdKLpx+NLccGJV4TCJYUu+u81C
         ZKhgSzDGiZJMw5YtUQIda81yuQ50jrUvb+NVnMCzYi6QCVdERlq90DWxHsF8a6pPp3bK
         S1Jw==
X-Gm-Message-State: AOAM530ov3whhtDKAAZhYBSvhtPOinVbBcPsOqn3MR7v0Hlt3/EviQso
        7aS4Wmqq2ALlKxn7c7aMNfk=
X-Google-Smtp-Source: ABdhPJwi6DDOdiXnSQYep45RnkdFsuJQ6R3I2yS02NhcBhJr9wLujcLmJiKoM7ctuzGhAruffSfanw==
X-Received: by 2002:a5d:8ad8:: with SMTP id e24mr4797036iot.41.1589580412674;
        Fri, 15 May 2020 15:06:52 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e19sm1148301iob.1.2020.05.15.15.06.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 15:06:52 -0700 (PDT)
Subject: [bpf-next PATCH v2 3/5] bpf: sk_msg add get socket storage helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Fri, 15 May 2020 15:06:38 -0700
Message-ID: <158958039839.12532.8701091377815048145.stgit@john-Precision-5820-Tower>
In-Reply-To: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
References: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
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
---
 include/uapi/linux/bpf.h |    2 ++
 net/core/filter.c        |   15 +++++++++++++++
 2 files changed, 17 insertions(+)

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
index 7dac2b6..5769753 100644
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

