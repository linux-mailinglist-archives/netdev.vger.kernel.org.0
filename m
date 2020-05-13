Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA341D1F02
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390615AbgEMTYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:24:31 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EABBC061A0C;
        Wed, 13 May 2020 12:24:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j2so864838ilr.5;
        Wed, 13 May 2020 12:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oyHM7TvRRRTe25Gl/u3VxiStdwZw33rB19WS0P/3OiA=;
        b=Yin8pd76CWbWIEseez/cjeYX3rdWlXrNanzFRMF7Y26rxHTlorfdxz9WqMNo4Z7leb
         Lz/rlmDjkJk/UBGqYfu1EZtZ3u0VoMGeWQGBkzw3dCgtW7j/3zrl4ra+lmgDHLo/V6/g
         SwyKU+po3dTV+uDLtFPp7sMB1sRQmcQ6jds98M7XwbFnhjjUQaCJUXHNbHrjcyjCNfAw
         yPbbKPXoAAPMKfU43MzNojPUrt/Z4uFB+he0D/5JKQoCl6kPJkh5z+7x/uIrvolz5ElC
         o5GvRYn3KhjjFFVe9Ft+HkOjlROMp4jahuvZ5NoP/J+MNv4F1dA+41zL1byq6ANTVHK4
         c03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oyHM7TvRRRTe25Gl/u3VxiStdwZw33rB19WS0P/3OiA=;
        b=XjAS6sEYGSKvYtmt7R4pwcn3LGtUb/HY5p7hSUAvF/CoRaY7M6kwCfWlXn4hbaZNED
         kRmIXO+f/18BTUtsdL6LHZsWic36HmkDEL1c6r8ffuVFYg21mt6HV5oUqw4ZFtEvn5uN
         i2SqHFqIMDyEpuXjP9i8nAkFd0aeIxmkVZP5MlOZpiLBnzum8cr10zB5ev9hkYJsV/OT
         eQde67GN4EAc06Vokpj+yqHEBZWXLINMW5c6W8yXMrlreZjmqYNfFqkzfhZ5T4bHfCEZ
         hPKYlcbhGNkedXqlvhhZ5fGcgcHk8Z0MRG0O8t9r8ArPS9dQPjychcf8nxYiu4M+jSMq
         KfEQ==
X-Gm-Message-State: AOAM531y1AfBlMqkEyVbyg5xkKYfbMve8f11YXiwz3XdYodFB6SutJec
        9sAirC7q+eSnnhfgbiRrNbc=
X-Google-Smtp-Source: ABdhPJzr2m/XSg2/puojGKGu85g9+YglT6hCmanxh9yGf7xNeTM6y1hpp8rlxY6dO80XF9GbxSOHeg==
X-Received: by 2002:a92:9ed0:: with SMTP id s77mr948204ilk.283.1589397870966;
        Wed, 13 May 2020 12:24:30 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r1sm163749ilg.61.2020.05.13.12.23.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:24:30 -0700 (PDT)
Subject: [bpf-next PATCH 1/3] bpf: sk_msg add some generic helpers that may
 be useful from sk_msg
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Wed, 13 May 2020 12:23:50 -0700
Message-ID: <158939783014.17281.11169741455617229373.stgit@john-Precision-5820-Tower>
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

Add these generic helpers that may be useful to use from sk_msg programs.
The helpers do not depend on ctx so we can simply add them here,

 BPF_FUNC_perf_event_output
 BPF_FUNC_get_current_uid_gid
 BPF_FUNC_get_current_pid_tgid
 BPF_FUNC_get_current_comm
 BPF_FUNC_get_current_cgroup_id
 BPF_FUNC_get_current_ancestor_cgroup_id
 BPF_FUNC_get_cgroup_classid

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index da06349..45b4a16 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6380,6 +6380,22 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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

