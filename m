Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43381E00B9
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgEXQut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgEXQut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:50:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF365C061A0E;
        Sun, 24 May 2020 09:50:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id n15so7550380pjt.4;
        Sun, 24 May 2020 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WpksQQuSOYFEg+wnTmw3DB7QF9n6IUD+5AgSrpySUcw=;
        b=ox+SI+agzx0LUxSfygqJcC19eZre69dkL4ro+kGLJa3FAE4MtZ0cyH715F6mtjhyzg
         ddOORZthVKOkgoxWMyQprnF+d8moJRKw8kqgL54cYOlyGpdjZ71q/EFry5ArW6UHJWkN
         gShiWrm4qrpsDV2lRjqawHnZ58JIMm5HZMS7byFIRhgXwvWfQoR3vB3qMtVTxc8kcpeI
         a3GfCiExuziJGiRrUBBmTJOfgnx2PPJmCpf1tpLuOVr1FRjeleL0UlCThA2UEFeET5bT
         VMb0w2dPEZP1OpPGCfmWm6YAVLtOTSKB+WPAxdpTdQDuJoIkJ48ro9oxM3q/l4KbuxhF
         gotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WpksQQuSOYFEg+wnTmw3DB7QF9n6IUD+5AgSrpySUcw=;
        b=mj+1/5JZFMTwj1Shd8pd6/LttGjZ1J5Z2mOSPNzY64+PSVF2yDkLuqxjmH/Fhk1Ike
         0FuYdrltSXUfQ3TU3wPxLYEkDLh7kZRBlNV1ex3O0K6iGE7QYT3UWQy+a4MvPng0fMjp
         cHH9G3bJe8WhE/gRi30MbiS2F8IgNgOiGQoIGeGRKk2cr+pUeMB8IZgfvpugUL1qlLZv
         8re595uK9wn6i7mtCRpmA3uANgOu3ZF9klFS+6+zbtNyIeFHSWWwu0jHkDVHZ73XJQ9e
         nR+Zoryr8ZzF+oK7yMMyBwxBR9gGwni/9e65Fd0MJ1SDEXzmkPlCxgsJxeC5lOaTfiUj
         YPMA==
X-Gm-Message-State: AOAM5329QZPCWqSm2p0cQLcgR0HaMqGlzmI9hOfB4KqlHGAt4j0FNzHN
        Y0OJuFY3XokOYjTQ99WIVIk=
X-Google-Smtp-Source: ABdhPJy4Texe7B4aO8c8PKq7ElbNCvZPxSLHYKZ4AdyaP/tmeF0LcdJLQvnovN2LlUYzE0WMHF+2Mg==
X-Received: by 2002:a17:90a:dc83:: with SMTP id j3mr15910999pjv.59.1590339048563;
        Sun, 24 May 2020 09:50:48 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z20sm10119643pgv.52.2020.05.24.09.50.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 09:50:47 -0700 (PDT)
Subject: [bpf-next PATCH v5 1/5] bpf,
 sk_msg: add some generic helpers that may be useful from sk_msg
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sun, 24 May 2020 09:50:33 -0700
Message-ID: <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
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

