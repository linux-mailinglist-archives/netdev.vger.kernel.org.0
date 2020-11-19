Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAEF2B8BF5
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 08:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgKSHEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 02:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKSHEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 02:04:35 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E74C0613CF;
        Wed, 18 Nov 2020 23:04:35 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id i8so3546457pfk.10;
        Wed, 18 Nov 2020 23:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D/5rJiqikCUZu65kYjth7Bjoaz6kJ6lLHKRwdYxROB0=;
        b=EQmcXkLh6Rn7MJyv347o1y+dw4771R932U+aAcOvUhQSu/PV2Z3YMBenw+leJvHVx4
         bg/V9WPj3yKkzQhH7UPPm9vnvI1jX7MGOb16DG+qOEs2XkjWSdCiXHx1qMuVWUTl+0jn
         xtSpbp01B5fMxo0CL6XEolJVw8r8sgC/LwhIx8MADcgQ3A3yznO4QR1HQWE8my+WaEa5
         fpJcLScMMMTMcfLDaXkV3wpkKdpElA9moF+EQp4RAPremKCBuf9JdY2TqB/s0LD3vx2a
         vzPb9nqxmckd7u63MyQWMQFwUoDw79X9MC5qaPju+r8213cR+4v//N/HIy2+V6/bKHif
         ZOig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D/5rJiqikCUZu65kYjth7Bjoaz6kJ6lLHKRwdYxROB0=;
        b=JcgL8bu/O+j4xtqT6/2bcZ6fOFbj/Wp/Z43zMSJx/T/r2arxAfEUal4gr2QoBvNmr/
         Eh9TJ23I2BRfbQd92ei7mCbxgOtzUS/PT9Ywg4/yRWceHwCB60NZoiRR/MjsNcFj9n5g
         LdYAVZJdbq7fXFAnYtNLai3p3q8tcM7euKNu3GaCcwVKpc2xJVGpKB4IMCQZHRBNKTTQ
         DJgY+MYl1d0G9IoStJkxNUnTlpxxiPcA30Bgs3pTvdf+BvHspqPSVmeRKxsoscQpsTMW
         /oGE89LX6v0lytZUnCw3Q+9oxoFga3z04JRHPiiZ6HhAA8NcdTvvEJLbiQamLIHKMMpJ
         wlEA==
X-Gm-Message-State: AOAM532amCXZfdM6mUrWPQQXifBCDpvepqfo4eRpNi3Bk8GDrLfZE/eB
        IgsatG75D1EPIkr/fnIVpg==
X-Google-Smtp-Source: ABdhPJx20v3M8X5/o/3g4bLOnf/UG5SbANbD3ln/Rj1y6VGJ9JHDWmxqmb2wDOZ9J1JLU4RjydTecw==
X-Received: by 2002:a17:90b:ed0:: with SMTP id gz16mr3087192pjb.23.1605769474631;
        Wed, 18 Nov 2020 23:04:34 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 23sm27805498pfx.210.2020.11.18.23.04.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2020 23:04:33 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] bpf: Check the return value of dev_get_by_index_rcu()
Date:   Thu, 19 Nov 2020 15:04:28 +0800
Message-Id: <1605769468-2078-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The return value of dev_get_by_index_rcu() can be NULL, so here it
is need to check the return value and return error code if it is NULL.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..1263fe07170a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5573,6 +5573,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 		struct net_device *dev;
 
 		dev = dev_get_by_index_rcu(net, params->ifindex);
+		if (unlikely(!dev))
+			return -EINVAL;
 		if (!is_skb_forwardable(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
 	}
-- 
2.20.0

