Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA43C645E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 21:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhGLT7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 15:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbhGLT7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 15:59:06 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F3AC0613DD;
        Mon, 12 Jul 2021 12:56:17 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id o8so10031418ilf.4;
        Mon, 12 Jul 2021 12:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A+PcvZFpIdycnLsj6soRgU5MzyOWEpr7KT3V/KooJ6o=;
        b=nxV4HxKQq5Z7Bwj4ef26X9sp3iR0xAo0Q8y9mhx4CvNu7hz6MpnX0R2XRjSrJTQEqG
         ppmC+cW6rc8IdYGDMyvJt5TU/2KxDdoA7+z9E9Cj5BAm8ytW4IMuV15VCw4/3Y/pgZlb
         eOyvmTSHcPquvvcPejpuxfrMEk8Bq/oXRys8RqjTfpU/lLmILLOvL6E/VmzLvS/2LMoJ
         3HhDqcFmHFW47JTLXefOUxNVd4Gu+lwwt6PD9rjiHhsiy39DdN9gtK4fDIaoLxL9kd+2
         VhlLeEi9y7ezBBgnN4hgRhPFvhaJOeyJBHOr3TnI2ec5YmPKvs9vWSYhDsIa9O4wZ9NQ
         4XuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A+PcvZFpIdycnLsj6soRgU5MzyOWEpr7KT3V/KooJ6o=;
        b=q5H2gORANDp9fLuMXOiLL/Y+wJkaN2letzPPWJ+VhqYZz0lSrc3gf+hB8CloRMdqLJ
         1M5cFN80g/s4KraRwsw5E8hi0NjMEvu3bUeqpvNxqmhDdLKUORtJIH8SEia0Qh7cA+dU
         kh6D0Wa5014olPGRbVSUWwWOWBpqOVfcpvXYiOw3xCEBPDytnWVQTg3QdCyELsiNZDXf
         EqQI0HeJqodOTJE555+SVp3Cw0BO/lGoiMogbDmox4dHlhULz8gmXDdJUqpwJjv6FxE0
         Hxtl852THN68wLrEnUir2Qu06abXe8ie59RCvkpbtvv4xCzCggkj+mXs/8quQc3z31Gm
         5Wdw==
X-Gm-Message-State: AOAM532+v9/ELwS+TCi/2akQgsf04fa+9WM7C+Wlp6fiSawD217q5R4Z
        CwW91HmMuG+3ibu4CKhvDac=
X-Google-Smtp-Source: ABdhPJw6qQ4+a4FCn958FQpKKid/Hq4o0QHRVYmlmPgl/rwnfl547DZmLtZgpNnKl7bf8DUla8FAWA==
X-Received: by 2002:a92:d9c6:: with SMTP id n6mr388331ilq.142.1626119776627;
        Mon, 12 Jul 2021 12:56:16 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l5sm8389210ion.44.2021.07.12.12.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 12:56:16 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, jakub@cloudflare.com, daniel@iogearbox.net,
        andriin@fb.com, xiyou.wangcong@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v4 2/2] bpf, sockmap: sk_prot needs inuse_idx set for proc stats
Date:   Mon, 12 Jul 2021 12:55:46 -0700
Message-Id: <20210712195546.423990-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712195546.423990-1-john.fastabend@gmail.com>
References: <20210712195546.423990-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
We currently do not set this correctly from sockmap side. The result is
reading sock stats '/proc/net/sockstat' gives incorrect values. The
socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

To get the correct inuse_idx value move the core_initcall that initializes
the tcp/udp proto handlers to late_initcall. This way it is initialized
after TCP/UDP has the chance to assign the inuse_idx value from the
register protocol handler.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f26916a62f25..d3e9386b493e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -503,7 +503,7 @@ static int __init tcp_bpf_v4_build_proto(void)
 	tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
 	return 0;
 }
-core_initcall(tcp_bpf_v4_build_proto);
+late_initcall(tcp_bpf_v4_build_proto);
 
 static int tcp_bpf_assert_proto_ops(struct proto *ops)
 {
-- 
2.25.1

