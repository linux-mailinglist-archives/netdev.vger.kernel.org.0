Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7688B2ADCA7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgKJRMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:12:24 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39246 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKJRMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:12:23 -0500
Received: by mail-ed1-f67.google.com with SMTP id e18so13568293edy.6;
        Tue, 10 Nov 2020 09:12:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=gMWumldJ9UU3kZd8oowtYDvR++TdiU3XisALKrh8u1Q=;
        b=qlaN3sJ3HuuRQ4pq6Ldv/9wyaxABMdXVKQ4KoxzVXjNmu4mK118kSAv/yGF6+7tYkZ
         9i5weBBbi58wzPDASuu/RV0pHmUr6aDaKWuR4xZQxYJUSmTR0Vs8livsemMCQOglJy9h
         sMkUBtPXtT7NqaAN4TIjmn5HbJC+0tm1YfE3yY3VQCd+FUwepzrWLENMllF/3qSd7z9Y
         696tidGPz1y4KfP+YwNewAbWztPvrGQnYpoz3NNo/YIb4w/t/DZs3YOJUCCiLts2xHOL
         dZOsQHl+YjDCEQE7FD9C3j3aqGkwiiUkWQZXFwrenJhV5FtKIGV4tV99GbZjY77vFKPT
         ZvlQ==
X-Gm-Message-State: AOAM532U0U7YWQhph8t20QS1Nlc1ZGiUJZgOH20AFfFtDfPIxRYkyshR
        wmpriygZDKg+TCYHZAXa0rc=
X-Google-Smtp-Source: ABdhPJwUfCydgBcV/x31hFTnMPaO0/zDn4iSGzkrYe3JlaFzj7WBDsPVr+igD6PMgiywYYW0RxqxLQ==
X-Received: by 2002:a50:f0d4:: with SMTP id a20mr326268edm.303.1605028336215;
        Tue, 10 Nov 2020 09:12:16 -0800 (PST)
Received: from santucci.pierpaolo ([2.236.81.180])
        by smtp.gmail.com with ESMTPSA id h9sm10648713ejk.118.2020.11.10.09.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 09:12:15 -0800 (PST)
Date:   Tue, 10 Nov 2020 18:12:13 +0100
From:   Santucci Pierpaolo <santucci@epigenesys.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
Message-ID: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From second fragment on, IPV6FR program must stop the dissection of IPV6
fragmented packet. This is the same approach used for IPV4 fragmentation.

Signed-off-by: Santucci Pierpaolo <santucci@epigenesys.com>
---
 tools/testing/selftests/bpf/progs/bpf_flow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 5a65f6b51377..95a5a0778ed7 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -368,6 +368,8 @@ PROG(IPV6FR)(struct __sk_buff *skb)
 		 */
 		if (!(keys->flags & BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
 			return export_flow_keys(keys, BPF_OK);
+	} else {
+		return export_flow_keys(keys, BPF_OK);
 	}
 
 	return parse_ipv6_proto(skb, fragh->nexthdr);
-- 
2.29.2

