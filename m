Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827C01DCFEC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgEUOfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729558AbgEUOfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:35:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DECC061A0E;
        Thu, 21 May 2020 07:35:08 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q9so3147266pjm.2;
        Thu, 21 May 2020 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WpksQQuSOYFEg+wnTmw3DB7QF9n6IUD+5AgSrpySUcw=;
        b=Sir33K5VyX4mIVVc8fDv/ETvdM5x7DhRtmZiz9HxaNlNdqfFRk9klDIrxMrCDz6jV+
         j7+2o+65QHSP9UeF2kSxpqnp+UF0oGdudfGsEbt05SrB1NKR1V1Hg2R9nKeqM5zpio7j
         XXDJ4GVs8IPjDSAGQRYzR9zuQ7vLBvNO/2CenwBdDo3KtFOrEMdQ2ZECa5nEZUmvfgDI
         RvcdR7SwIPJsSo/VfQ/B+JLioZ3fx9XzUOKeJclqfQZ2/TDazQT7r9MvoOdiACiQ+ZGP
         cgYhryn6CzaTSWkxoXn4UwH7YACEe7SVgPriPFOCSlweCtSH/67rOhRpbXtrKQNNVeFX
         hPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WpksQQuSOYFEg+wnTmw3DB7QF9n6IUD+5AgSrpySUcw=;
        b=aJL1nLew4Mlks7BpQAw35KhumH/FFQo/3oJslICLyJyv2scG14fTBg8axYFL97Q+lq
         KlQapDhp9FNGFn6Oqk0XIFfdTApSBfD2vXOSZMOde/eBP3sRKhm4ZDGl00sHPY9ZrdPo
         opmxPOlRBi3kk7DOHB5FLooVUX6KUt9RFIjczJZx+L0XRVNe7pak56fjv/0gkClVp5YS
         okKdJiznFArgrQ8xpY7O/1IYvBjmnSxAALX/7z6uZsokxAQ/5Vxza7ZXxnh2dv9BnWgd
         atXtQ5sINRw0BnNMc7hfsq0bTLl7sdTf8DVK5OUdYRKbasnRyZkk8Rty/sGDnDz+m8Ae
         Druw==
X-Gm-Message-State: AOAM533OH1tCM0ac19x+ZQPpGr7sxRiKQyN7gD9Qf5jROit43H7ri4Nc
        fvjgCI3xepHTl49U9+rV2qA=
X-Google-Smtp-Source: ABdhPJxQBl4jGtUjPZzqWxuxRlUkaX4vxMT3AHYC0klsfz94l29yqKjsF1MfcoIrjBkfXXtX9SRRFA==
X-Received: by 2002:a17:90a:9f92:: with SMTP id o18mr11823960pjp.180.1590071707750;
        Thu, 21 May 2020 07:35:07 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j16sm4543046pfa.179.2020.05.21.07.34.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 07:35:07 -0700 (PDT)
Subject: [bpf-next PATCH v3 1/5] bpf: sk_msg add some generic helpers that
 may be useful from sk_msg
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Thu, 21 May 2020 07:34:52 -0700
Message-ID: <159007169244.10695.7758980724441079287.stgit@john-Precision-5820-Tower>
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

