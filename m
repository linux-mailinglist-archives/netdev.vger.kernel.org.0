Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5D21D5C0D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgEOWGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOWGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:06:11 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0C7C061A0C;
        Fri, 15 May 2020 15:06:11 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q10so4128367ile.0;
        Fri, 15 May 2020 15:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=c0BG3kaZ50Dcd+OGVnp2ZcPP0p+RiidJl2L8uBk24fI=;
        b=rFuERQ4rSSIe5IVcO1biP7F/LEcOX76pk/lgNPgSV8FuO9EbHDqFGCCKPhbrIkngVj
         owlkdupaDkO84Bb9Y3o0KBdh1TYjyR09YFDBNSUXQVIORmv/upmWw7vBS+yhQqEHsl9v
         cB7F6y5Quq6HrFQLUnRd+F4XHi9PGmAMjyf0ByfjDLlDTLD9aSqrAFM7TpR6BuDIdqAm
         t3hb2QUT1YVvGhXbV3uEK9QHLOzYZYr79P7rgm1RGJH1mRmFFvGIoeziyUMMwzStlQM8
         N+tmKbhhcGjtkSUaH6I8q8hTYwB3eIkWjaUeZ0kmxxbIK//UUn65xMshI0KLPKugLDBo
         92Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=c0BG3kaZ50Dcd+OGVnp2ZcPP0p+RiidJl2L8uBk24fI=;
        b=rz76RBgdCgv2M/9cuWEYqRdtsKAF3CKyCqiVfa7BhCL1JkA6zYMplUq15b7MuSwePB
         Pz/qgX7mV4icXaixNPYXa60muCSOXS5d77/MmScivxlaE5M1d3ADi4nqJL6sHrHb87qn
         zKrDERoDdxIqKEKHzDRto/wgL/41A+HYb7m1oCLP6lstAvwQey0Lepu/A71MhgWd6LCR
         9KssP37+XPbt9Su8JI7157dEWDoU4VHqeQImISPYq95Ah/sForNqmFDyseb3nuz7RMZQ
         u1r8Pe+lEHoIq3mTuOv+cujbFLTUolGVDT5lrH72s4OFkR0gg5o00UVpgCVU751aOyj1
         2ZnQ==
X-Gm-Message-State: AOAM531VSkB9e/foJEq8sFtm7zgPx0cM2DrVepkcGT8R/uiPFYKMWaXN
        sVhvXPiOo3r/ncKOSGCXM90=
X-Google-Smtp-Source: ABdhPJwXBqFJlCMCIWH5MM45uzHva0n0oF5xuuz75wO+Y2DO+QyLry53sNupAjqPWhYiyubuM/AdPA==
X-Received: by 2002:a92:40ca:: with SMTP id d71mr5615680ill.200.1589580371196;
        Fri, 15 May 2020 15:06:11 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u17sm1372861ilb.86.2020.05.15.15.06.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 15:06:10 -0700 (PDT)
Subject: [bpf-next PATCH v2 1/5] bpf: sk_msg add some generic helpers that
 may be useful from sk_msg
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Fri, 15 May 2020 15:05:57 -0700
Message-ID: <158958035716.12532.11872908481088096292.stgit@john-Precision-5820-Tower>
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
 net/core/filter.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index f8a3c7e..7dac2b6 100644
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

