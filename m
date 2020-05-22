Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ED11DDEB3
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgEVEYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgEVEYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 00:24:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC7BC061A0E;
        Thu, 21 May 2020 21:24:17 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id e11so3660547pfn.3;
        Thu, 21 May 2020 21:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=u1qp5PchNEddK4QSFzztTTIBWt9k+XfZUqh5kbp3XfQ=;
        b=LOyfr5Lyr7PNM53h7bbIayHaa8BpM7uo47sSfYUPBEdnKhDyUYEhJHSgqH/WWlxkcz
         JFxQDI4qraQADDh5bg8KybnThnINa4KZtPw0qX78cKna5hibyMQsLmQaY3CprEQ4SO+C
         aPT/QaIbIHY4erY+b8rtGDaboNRRLIIkzv48X2aaklg8MCvSr1LFGC+UCP7XLp4apGMM
         9cJ5uiQ6G9py67BP0WSvVYN1oKAyM+Ovrf07Z9uoJlnCUOvJnppukOmC1uRo8Fdp2knW
         Ni47MWix3KFxSysNIjmbQsq5ihERwFGzUxBNT+F1GwEGG2BBAwoK7xRSj1ahsGqnkle0
         /SJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=u1qp5PchNEddK4QSFzztTTIBWt9k+XfZUqh5kbp3XfQ=;
        b=m79OgvqcJ93KR1iaJRLID226YsD2ccHmqTlCz+gjEjaioz0P88akF+Bi7K5FgWuToq
         Mg9QxYyo4OMu1Vt0zYyj4YJ/QJo5YrcjS8BhDMgTkQlQB5LeQjUOsbmCYa8XnYCdLBeR
         /DMyz2jYs3joQ3p8qwr50Znh/kAZocQef/2dwJmW0wLhjy8DNkszv3jNbMcmuGr+k3aX
         JdhFM+lNGSHnws1EPJLzbEahdnnQnRUWQ0T/OXQop/fsCi4KeFwwxPIYvdRAeod1JdG1
         02AYc9in6nZCbRbqhKlpjWuCbK3e6z+FdGPLUeSZoo65jnBsTiqZBsdaPUZ1bEWY7Rk0
         XObA==
X-Gm-Message-State: AOAM5317V9AWe68NBNG58w5gWY+GviSUNn3OUV54pVwPrxZ+cdFikIGS
        RQ20ouMUo0Pg+YPr2pq79ns=
X-Google-Smtp-Source: ABdhPJyt/AqxciaxKJLkktD1rvdmul/OXNAg1nHzTgFdXZOVNLZ9qfVWXkr9FZl02H7xISh+e7dPjQ==
X-Received: by 2002:a17:90a:21e5:: with SMTP id q92mr2015115pjc.63.1590121456783;
        Thu, 21 May 2020 21:24:16 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y75sm5710772pfb.212.2020.05.21.21.24.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 21:24:16 -0700 (PDT)
Subject: [bpf-next PATCH v4 1/5] bpf: sk_msg add some generic helpers that
 may be useful from sk_msg
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com, lmb@cloudflare.com
Date:   Thu, 21 May 2020 21:24:00 -0700
Message-ID: <159012144058.14791.5250915494357940883.stgit@john-Precision-5820-Tower>
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

Add these generic helpers that may be useful to use from sk_msg programs.
The helpers do not depend on ctx so we can simply add them here,

 BPF_FUNC_perf_event_output
 BPF_FUNC_get_current_uid_gid
 BPF_FUNC_get_current_pid_tgid
 BPF_FUNC_get_current_comm
 BPF_FUNC_get_current_cgroup_id
 BPF_FUNC_get_current_ancestor_cgroup_id
 BPF_FUNC_get_cgroup_classid

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 0 files changed

diff --git a/net/core/filter.c b/net/core/filter.c
index 822d662..a56046a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6443,6 +6443,22 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_msg_push_data_proto;
 	case BPF_FUNC_msg_pop_data:
 		return &bpf_msg_pop_data_proto;
+	case BPF_FUNC_perf_event_output:
+		return &bpf_event_output_data_proto;
+	case BPF_FUNC_get_current_uid_gid:
+		return &bpf_get_current_uid_gid_proto;
+	case BPF_FUNC_get_current_pid_tgid:
+		return &bpf_get_current_pid_tgid_proto;
+#ifdef CONFIG_CGROUPS
+	case BPF_FUNC_get_current_cgroup_id:
+		return &bpf_get_current_cgroup_id_proto;
+	case BPF_FUNC_get_current_ancestor_cgroup_id:
+		return &bpf_get_current_ancestor_cgroup_id_proto;
+#endif
+#ifdef CONFIG_CGROUP_NET_CLASSID
+	case BPF_FUNC_get_cgroup_classid:
+		return &bpf_get_cgroup_classid_curr_proto;
+#endif
 	default:
 		return bpf_base_func_proto(func_id);
 	}

