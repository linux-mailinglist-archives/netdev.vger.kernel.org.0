Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3157C52C52E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242885AbiERU7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242856AbiERU7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7240230229
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652907580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tG6J7OXecG2aHQWxhTipqfUbGWLrMU/iiBvmaxNqXfU=;
        b=WR7iRY+v/grf/Ls26RP5B765Pj0RSwV/CzTlqrfDUAQLLsgkSeMZxc2b0afCrnci6OV1Kc
        ABXxPZMwrzpkNN5+fVEhEnMQKxsa5b1XZl6hYatd18QoeKV1t6w07BcTdQ6SpvBHzsAoE/
        P/3MbopjwflI54DKA/JkOYfd1EWo8aw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-40hpmLLpPA-9qBBY7Stp_g-1; Wed, 18 May 2022 16:59:35 -0400
X-MC-Unique: 40hpmLLpPA-9qBBY7Stp_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9A27101AA44;
        Wed, 18 May 2022 20:59:34 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 633502166B25;
        Wed, 18 May 2022 20:59:31 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v5 01/17] bpf/btf: also allow kfunc in tracing and syscall programs
Date:   Wed, 18 May 2022 22:59:08 +0200
Message-Id: <20220518205924.399291-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tracing and syscall BPF program types are very convenient to add BPF
capabilities to subsystem otherwise not BPF capable.
When we add kfuncs capabilities to those program types, we can add
BPF features to subsystems without having to touch BPF core.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v5:
- also add syscalls

new in v4:
- I think this is where I need to add my new kfuncs, though
  in the end I need to be able to change the incoming data, so
  maybe only fmod_ret is the one we need to be able to be RW.
---
 kernel/bpf/btf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2f0b0440131c..7bccaa4646e5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -202,6 +202,8 @@ enum btf_kfunc_hook {
 	BTF_KFUNC_HOOK_XDP,
 	BTF_KFUNC_HOOK_TC,
 	BTF_KFUNC_HOOK_STRUCT_OPS,
+	BTF_KFUNC_HOOK_TRACING,
+	BTF_KFUNC_HOOK_SYSCALL,
 	BTF_KFUNC_HOOK_MAX,
 };
 
@@ -7110,6 +7112,10 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
 		return BTF_KFUNC_HOOK_TC;
 	case BPF_PROG_TYPE_STRUCT_OPS:
 		return BTF_KFUNC_HOOK_STRUCT_OPS;
+	case BPF_PROG_TYPE_TRACING:
+		return BTF_KFUNC_HOOK_TRACING;
+	case BPF_PROG_TYPE_SYSCALL:
+		return BTF_KFUNC_HOOK_SYSCALL;
 	default:
 		return BTF_KFUNC_HOOK_MAX;
 	}
-- 
2.36.1

