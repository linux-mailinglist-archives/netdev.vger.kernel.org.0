Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A92E1DD009
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgEUOfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgEUOfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:35:51 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB2AC061A0E;
        Thu, 21 May 2020 07:35:51 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n11so3248837pgl.9;
        Thu, 21 May 2020 07:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=djZbck+yBbWihA0B4R6+ByjUmJULJBdA1YBImrlU7zA=;
        b=dhzTNDTReu8aSKrCsAu11pj9PjXQlMbK1478ADFibV/P/8uKf1lyyC+urY13GsPspG
         o1TIaCaXVKNdPQL57IJEpGq4VbGJX0Lt76cDO84vWvznU7qabxmG9e3OrhQTZQL9iIuw
         bcYRiXgYJLWwDlzJBEe+9wQ83O51VqBM2IPKn/VK7wkLdH8Yr8y+CUGfqe8g/mQcWTA2
         2ZGUv4YmHBsQYRdD5izTe/v7y+RFAhbRQzkkYusbkyq3xffYL/eW8yqxD4kfAONaSuew
         4FS4calAUcUju8ClMC61Zz9E42WadHO5p0dO2m6fKVOXwk43AoAXogDblmWnVCJEM2fY
         VNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=djZbck+yBbWihA0B4R6+ByjUmJULJBdA1YBImrlU7zA=;
        b=IETzVTY/MmoA2E7NX+9lwjE4uy5F79rxsAMELq+utjQBstWc6MZygzDZod8J+1uyrt
         9dk5PIIx3pnOYwtlh/us9ja+RyL9Vhf01B4xMqor91B/UqcYY6UIe9YV0GIyZCHxt0Ej
         DIumiONcc+9d9VWkahbAesMqVZ6jHICIju6vNdByvhy5XzmUOa2g7Aw/ZLJBkMWZCcoo
         q+Df33mPTxeDF00qN43hWsZ8Uo+U1Tx1pkjdW+zoLXZwNi7KlGK1+ewW0X4qIMzdKKYt
         z0sfzjljlbiIt2XFIddV/naxVJ+brBECvltT5+E3GwXB3jVRrbC6E+0iCHlknnstHweb
         Nv9w==
X-Gm-Message-State: AOAM5300XZIGqfldyJFTBu7LtvVf7c1fNBfI0PSBpvQf4iaBrgRXcgbZ
        vCbtNLB5jeHd7rinVda6nkY=
X-Google-Smtp-Source: ABdhPJyLzlpVlUi/2GBMAgBg/vyGhhM84Af3V164XmjFhOalQ8aMM/2HUiOww28544kayx7NAhtQ0w==
X-Received: by 2002:a62:79c2:: with SMTP id u185mr9882284pfc.159.1590071751303;
        Thu, 21 May 2020 07:35:51 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p4sm4552683pff.159.2020.05.21.07.35.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 07:35:50 -0700 (PDT)
Subject: [bpf-next PATCH v3 3/5] bpf: sk_msg add get socket storage helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Thu, 21 May 2020 07:35:36 -0700
Message-ID: <159007173608.10695.10412818793074834651.stgit@john-Precision-5820-Tower>
In-Reply-To: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
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

