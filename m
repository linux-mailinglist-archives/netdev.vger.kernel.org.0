Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C436D3C6BA4
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhGMHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbhGMHqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 03:46:54 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0D6C0613E9
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:44:04 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id a18so28556690ljk.6
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFpyRO99ImWOuNCn8/HimLZ/mqydcab4g/ak3WshCTc=;
        b=khgdXV5a2NA61l6XXxz9m4PC/1GNAAsugPaeSdcMZUL79dv9FJMpE4l5dlCNKVDy5o
         E7ufI9zhtX95vIVXQ2LD0rjnfR8/DgcA07ygmXcXvlG7z6wG8LxAYq1GAEnpsgQ60w5i
         J2LNk+95e7dKPqCPyXC7livf+WlEwYNkMIGuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qFpyRO99ImWOuNCn8/HimLZ/mqydcab4g/ak3WshCTc=;
        b=hLu3cLNz76/agTAEj9OwIofW8x89qPQqRVE/n8bIAa4l1LVSFKtgs1WXgIDqav1eE5
         bFvPWm+cH1LdjmQwC+V/efNLARn4xePBeYK7xWD6+dmFgtCz0WjthDaVyF0cxFFqX0J1
         rvusTnAWXjTFgjA7eEvWkCw4f3Tzb6D6ENKv0xz0UQf6oD4v50Baw8JnI/jkCDte6kUK
         C0r5mncENP4T2LrfS7PoAu7m6CVXTujLq0lU3eU8+ckeDbIN/DLhXPg/htcuiTm7P9za
         8WNL1Riv65IQ0DVk/YeHai5TdaGeYQD2Bk0K0UGf2+IGO9CUBxqowB5m8vroQ1p2BiNt
         rniQ==
X-Gm-Message-State: AOAM532MUjWRxbQsamdoo+hWRF/bzdUxBmNy06aELq2tx353blot94VY
        7Hx/sgTBNC3Q9Xbk8vdoVyCbhg==
X-Google-Smtp-Source: ABdhPJwLnscA/GazgXVnd9ZedkkhutIuxZqTAlB1ciTtJ/1jQBbYkpmoz7G+LVEMNjVpqO2JVGQ29w==
X-Received: by 2002:a2e:8110:: with SMTP id d16mr3052375ljg.42.1626162242723;
        Tue, 13 Jul 2021 00:44:02 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id b14sm1392754lfb.132.2021.07.13.00.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 00:44:02 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats
Date:   Tue, 13 Jul 2021 09:44:01 +0200
Message-Id: <20210713074401.475209-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
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
the udp proto handlers to late_initcall. This way it is initialized after
UDP has the chance to assign the inuse_idx value from the register protocol
handler.

Fixes: 5e21bb4e8125 ("bpf, test: fix NULL pointer dereference on invalid expected_attach_type")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Missing bit from John's fix [1].

[1] https://lore.kernel.org/bpf/20210712195546.423990-1-john.fastabend@gmail.com/T/#mba9e0b6aa8dd0c01d7421a084c62ec93c9eea764


 net/ipv4/udp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 45b8782aec0c..9f5a5cdc38e6 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -134,7 +134,7 @@ static int __init udp_bpf_v4_build_proto(void)
 	udp_bpf_rebuild_protos(&udp_bpf_prots[UDP_BPF_IPV4], &udp_prot);
 	return 0;
 }
-core_initcall(udp_bpf_v4_build_proto);
+late_initcall(udp_bpf_v4_build_proto);
 
 int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
-- 
2.31.1

