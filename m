Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78DF2B4127
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgKPKam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:30:42 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39709 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbgKPKam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:30:42 -0500
Received: by mail-ed1-f66.google.com with SMTP id e18so18174775edy.6;
        Mon, 16 Nov 2020 02:30:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=lB0bxldVJKg0VtkpxPKNbE5m+VtMP8jCWWtwfQ+qzEI=;
        b=oZ1lpcmxFTJf2/C3f0vItWK+E+MYFflzagnXE90X5mV84p3BWlDI5HWr22jRY+tqFa
         ZduLVdLOcKW6RZ+f+DoyWtK70EC83Tu3S7zeohGW9z0lgQTBuiC5iskCrz4B+kgZ0UWL
         +QCdANyuExUVrJiPHQLEMBa1CJLBG3Ey8nZwcmrA2qSRVC29eEQtTD6V3hZoyyfZZjyY
         GH2g5BxRu7T8tQFVYvddCbq1WjraZV02ltQdi9bYZD2uPZzYn+d7R97qIvuVoB+UJEkp
         Sv4Gpy3hbneH6PPG4+2z/6UNixWAKgHOL7BwnMT1ZmCzCVybdZB5UYnx9ZRwmm9etqhP
         eBRA==
X-Gm-Message-State: AOAM530r3bD1ODa8HgsUISx9ypUZUTwbeP+PgR4g28wQYeOq2Tj2VvYI
        Mccei1W/1HP3DfnzolYX/dE=
X-Google-Smtp-Source: ABdhPJwF8PihJCO8UWjfS3lH9NuSFO89pQ+2JQ+DTZaxYvJ+deHx3AjI1C1Y2x1WFnjyyXkDW7IqqQ==
X-Received: by 2002:aa7:d14a:: with SMTP id r10mr14714068edo.225.1605522640010;
        Mon, 16 Nov 2020 02:30:40 -0800 (PST)
Received: from santucci.pierpaolo ([2.236.81.180])
        by smtp.gmail.com with ESMTPSA id lc1sm10285588ejb.57.2020.11.16.02.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 02:30:39 -0800 (PST)
Date:   Mon, 16 Nov 2020 11:30:37 +0100
From:   Santucci Pierpaolo <santucci@epigenesys.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2] selftest/bpf: fix IPV6FR handling in flow dissector
Message-ID: <X7JUzUj34ceE2wBm@santucci.pierpaolo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From second fragment on, IPV6FR program must stop the dissection of IPV6
fragmented packet. This is the same approach used for IPV4 fragmentation.
This fixes the flow keys calculation for the upper-layer protocols.
Note that according to RFC8200, the first fragment packet must include
the upper-layer header.

Signed-off-by: Santucci Pierpaolo <santucci@epigenesys.com>
---
v2: extend the commit message, as suggested by John Fastabend
    <john.fastabend@gmail.com>

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
2.17.5

