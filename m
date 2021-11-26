Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C302145F60F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbhKZUsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhKZUqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:46:54 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6583FC0613FE;
        Fri, 26 Nov 2021 12:41:13 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id i9so15973595qki.3;
        Fri, 26 Nov 2021 12:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HNz3Duqca+HlLoVbIohH9bsymmp0UBoU7O3wxp6FWTc=;
        b=qLkPySkLuhaBpRl6cbqyMiEjOMcORxCs8lmYoVHL3zOktNz7uxXz5M0Ey01TvY8a/i
         0Q+2Mx6NBMVRF4UqrmrhtQwyCQ9XU6Ed0WXVyu9tbo3ga5pE5U1lE4P1FHTF8lz7sJvS
         5xz7+FvibkcBLdQ1QjKAP9Gi4S0sUxvWNgl/NWlYOujbVtJKKD3oTWHj+HC/QBvJnH9j
         t9t9sLcD8czCHoVJzptoFfRrcIjbyDT9a/yF+/WpCUR17CwMDkL5WeTv/RZWxitQorPK
         0ij7bECPo3Ur/c3CxsOCjyp5AGioMc+6U4fsV4mJ2wjFeJhhB3MypNWtg7bHYTrCcGAC
         Bsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HNz3Duqca+HlLoVbIohH9bsymmp0UBoU7O3wxp6FWTc=;
        b=n7qIGzlP7sFrR65BigmihES2YKm8+qZAz1InEYfQoWF1tbSJw5KJBhUQXe54BTQG6N
         T3R+M903JapkUhJkvuRc/Ye6aO1u6ADfzJOZPsfAnpiT9ICRLBW2YcZS6GIauF0aCF1X
         TxLJNsmQdUEIfPCO9TuP8aEWIxbopAjC81BDMLDNXtwOXCzoAr+gRGg88TdMaq0ght+c
         Rd7rBnEEEj7We278zL4+g+zLANyz188LeiK1LNfQPq1FpY5p1OuyxwHWhJE/5yyvJgCu
         8lAR7hXukb2BhDFZ+noueP3fldcvwVFJRkVmizV85tgxaFM6n8E004jc+btxFgn+pwke
         Y0zA==
X-Gm-Message-State: AOAM531xl5ANGljw2TOgjlbtFxNkTP/MmK3ltubI1QHg1QCVLQI+iCm7
        N+KpEyhLjqWLwXV+YSp8KCnvYJI9c6M=
X-Google-Smtp-Source: ABdhPJxAOm9aVpJZaK6e4MyIWbYMdoYb4tPmazjB76XigeV8UTYeqpx4Hsh87ZnnqviPA+i1Jr7ydg==
X-Received: by 2002:a05:620a:2447:: with SMTP id h7mr23937005qkn.75.1637959272386;
        Fri, 26 Nov 2021 12:41:12 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4fa:e845:6c9f:cd5b])
        by smtp.gmail.com with ESMTPSA id u188sm3675024qkh.30.2021.11.26.12.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 12:41:12 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
Date:   Fri, 26 Nov 2021 12:41:08 -0800
Message-Id: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When BPF_SK_SKB_VERDICT was introduced, I forgot to add
a section mapping for it in libbpf.

Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 tools/lib/bpf/libbpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7c74342bb668..92fbebb12591 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8346,6 +8346,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("sockops",		SOCK_OPS, BPF_CGROUP_SOCK_OPS, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_skb/stream_parser",	SK_SKB, BPF_SK_SKB_STREAM_PARSER, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_skb/stream_verdict",SK_SKB, BPF_SK_SKB_STREAM_VERDICT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
+	SEC_DEF("sk_skb/skb_verdict",	SK_SKB, BPF_SK_SKB_VERDICT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_skb",		SK_SKB, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("sk_msg",		SK_MSG, BPF_SK_MSG_VERDICT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("lirc_mode2",		LIRC_MODE2, BPF_LIRC_MODE2, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
-- 
2.30.2

