Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D9F6D57C1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbjDDEva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjDDEvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:51:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35F8211D;
        Mon,  3 Apr 2023 21:51:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j13so29356380pjd.1;
        Mon, 03 Apr 2023 21:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583866; x=1683175866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEByK7ayQymGUwHV+hLag/ZuQOh0jiZxz8ClMc7Oq0s=;
        b=h13w4QJTAs/h80A3maG01T4HzM0Oayq3vx6kP/y7mq2laVMhDs1zovqc9ixeey2rBb
         M1AZV20HQ2EnwpY55NYgUSMYwmLEpIPH1EQCxkruh6Qz0Gsb/33lz7grTunmewXTveui
         1zxvWqJ/15oWU0SzIlo8Q/MEKFQVeKWkdB2h4wCooepUxiScO9dWoqCeSOb0TFknL7Y3
         5yR9cQ+pRvaQM7w2ErIF9HL1x04MbEOuF9xM5ecDChivCy8rqKYwqBYtmymSRSbYJqhP
         2Hyd2BUpsWrhD+AiaSf8BrS9QgT5X889W65iTEVxDkIQZTj1f0PKOJIxxymCOFrbEwJO
         wjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583866; x=1683175866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEByK7ayQymGUwHV+hLag/ZuQOh0jiZxz8ClMc7Oq0s=;
        b=wm/1iErxwIz6FVQO2F/jBIkt/BW1ZtQHtmBKhL2RycMTl+8qiq1Sz/Tl1MsVCLuwvZ
         cMSembTLYcwWE36UzHFkR1CV+socL3SV62OAh5xxRaMm8t+iX990OEEvtBa/uGAOc1+v
         zX7O0vEmCrWYK9rGIDC/9Fz92YRZSK4QI7wAcu4/MGCuSq/rs5YUFpBxD4c4UrcoQzUB
         YVb9XvfpSsen4xpMI9zSELNAXnpKTVfiwSf1Q4Wyx0Eb2lKJfHpuvQnkjYUneg7zVAEH
         wmbVuNodCW65CgOk/yEUfaZ4anrLiJgD4utGjE+CvW5etZLI6BfUx5ycyuwgSpVYprUE
         4yrg==
X-Gm-Message-State: AAQBX9f+elnSzJR4qcLoCQtCOpq63eHMqdne3KccDbPbUlqoa0jvkhVf
        Wy2eJzDOhofr/IIdj6r04hc=
X-Google-Smtp-Source: AKy350ZbKhIUGP0wn/uUtuKFfD20cUFAmYRLGUb0OTVGidgCmS5Jv1lMvw3ob2YZrWvc0+BpE1vjyA==
X-Received: by 2002:a17:90b:3a91:b0:237:461c:b31a with SMTP id om17-20020a17090b3a9100b00237461cb31amr1380141pjb.32.1680583866150;
        Mon, 03 Apr 2023 21:51:06 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090ac24400b002407750c3c3sm6902998pjx.37.2023.04.03.21.51.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:51:05 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 8/8] selftests/bpf: Add tracing tests for walking skb and req.
Date:   Mon,  3 Apr 2023 21:50:29 -0700
Message-Id: <20230404045029.82870-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add tracing tests for walking skb->sk and req->sk.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../bpf/progs/test_sk_storage_tracing.c          | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
index 6dc1f28fc4b6..02e718f06e0f 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
@@ -92,4 +92,20 @@ int BPF_PROG(inet_csk_accept, struct sock *sk, int flags, int *err, bool kern,
 	return 0;
 }
 
+SEC("tp_btf/tcp_retransmit_synack")
+int BPF_PROG(tcp_retransmit_synack, struct sock* sk, struct request_sock* req)
+{
+	/* load only test */
+	bpf_sk_storage_get(&sk_stg_map, sk, 0, 0);
+	bpf_sk_storage_get(&sk_stg_map, req->sk, 0, 0);
+	return 0;
+}
+
+SEC("tp_btf/tcp_bad_csum")
+int BPF_PROG(tcp_bad_csum, struct sk_buff* skb)
+{
+	bpf_sk_storage_get(&sk_stg_map, skb->sk, 0, 0);
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.34.1

