Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131C31D1F0A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390608AbgEMTZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:25:13 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45A8C061A0C;
        Wed, 13 May 2020 12:25:13 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l20so830802ilj.10;
        Wed, 13 May 2020 12:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ODQhDoD/RNKHs+K+pBLPAhhfok/39J8rg2Y2+wl2aD0=;
        b=UC3jc0bmdOQbrjh4LMP7ngEByr5STo/GX7kvhf20ir01eFIiMLHDBpwyapXN9JNMap
         +fywfZGL42qE0FpBn6wn6swxBIE4ESlkQbpHqybiSczL2YJY9kC19de2iItLY2r7qmgm
         zEa40Id7CLpgSh9ewUWuTyUwQCihsAtwsrM4JMbr8dQ34Fzh05LR+5NIsO57hYEHxfgb
         75+9MPOUrHXVTUehGqRcKDrNtXmEv4++z9cBtqKnlBLaVjLBnvdJLbypvu6WPISY0g5W
         Q5qV0LTPwnFpQBGDqisgJR0h7L8MnjlCLM8zmrI/t8yCi+74ufZFvwY31K8peSzOngxS
         KXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ODQhDoD/RNKHs+K+pBLPAhhfok/39J8rg2Y2+wl2aD0=;
        b=A6eA1O6Stj7xXYr++lYOHkGxHjdBbRDJHFlymW5A5maRLXuLp1ybfcF0tx6o3I9CSi
         H5ueFbWSCUPn7XQ/lnFi5o6nWpwcKqor6QMwUuVshGl3t7NTzM3nPi5n+ILIHNYYlura
         MiaLxpkhhl5e6G/XcBqwycJPXhVBNBjeWbKNjRzXhvQPdqIcFLXzZSLYL100zjAOsFac
         0QqGxgEl5ZmLhfLY5hb+snf+Xttnw52Fm+F1/8z5eZet8edI+idC3wPJe4vmUF0wZddx
         Sn07hZMwS1qsfnovnIb8wg0iz4hzqH6fELCuZjNKi+e+aLA6GcT6QQ7i6kZpfO908DFn
         pvkA==
X-Gm-Message-State: AOAM532dGLTpDI6D5SrLzuhV9+HrzhmQ2f15ZYc7pg/oi/eaYJ1VLWWt
        ZkmL9Tw+Mww8MQ39da2/yws=
X-Google-Smtp-Source: ABdhPJyBvGJh6Vntt5CMyTal0990zt9BKxLzNKwIEarWowr10YcyrhVhTN1i24AlIe880Yy4THKmJg==
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr1035577ilo.118.1589397913152;
        Wed, 13 May 2020 12:25:13 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p1sm206770ioh.38.2020.05.13.12.25.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:25:12 -0700 (PDT)
Subject: [bpf-next PATCH 3/3] bpf: sk_msg add get socket storage helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Wed, 13 May 2020 12:24:58 -0700
Message-ID: <158939789875.17281.10136938760299538348.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
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
index bfb31c1..3ca7cfd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3607,6 +3607,8 @@ struct sk_msg_md {
 	__u32 remote_port;	/* Stored in network byte order */
 	__u32 local_port;	/* stored in host byte order */
 	__u32 size;		/* Total size of sk_msg */
+
+	__bpf_md_ptr(struct bpf_sock *, sk); /* current socket */
 };
 
 struct sk_reuseport_md {
diff --git a/net/core/filter.c b/net/core/filter.c
index d1c4739..c42adc8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6395,6 +6395,10 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
@@ -7243,6 +7247,11 @@ static bool sk_msg_is_valid_access(int off, int size,
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
@@ -8577,6 +8586,12 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
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

