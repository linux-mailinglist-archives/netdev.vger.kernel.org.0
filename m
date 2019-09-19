Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07DBAB7FC2
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 19:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391900AbfISRMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 13:12:41 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33814 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389131AbfISRMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 13:12:40 -0400
Received: by mail-pf1-f202.google.com with SMTP id v6so2710785pfm.1
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 10:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TCM31xL05D5MPLOhROrHFn7g2ZwBYnE1gbAFNXaD7CY=;
        b=Lyt001Ch7xSwZTB46oMp6pbHEL+iYBpJoJ8akQPa0U6+rA7D0gDv/wLoiDtg0eur0q
         YivIMljmfHNmibwsepvBuYwBovujRNRoOoC4pwqTbHWmi5hhWHryGRRvYWru8uaPeKFE
         ZgZTWpMP7pBNxMd7FdVerrdJqpd1BHqxQ7521gEZv2T56UMoT8IPZlWOccFQwGtxmHEb
         N/6/98CUiGSR5PhQ/fhDFZBS1GIcrA0K2nW6XKQCq2f0MQbq2KDo6kY/e3CTaxBsqhvy
         8kZUWTDU9Mt17haRdEdFm/AE4DNZfj47vz8G6bAhkCUIu4qNUmwzRLV0QfCfquRMdycW
         ORkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TCM31xL05D5MPLOhROrHFn7g2ZwBYnE1gbAFNXaD7CY=;
        b=ZaD4l1PVODh4/byiG88wtYeb3l/8FbuABWZBNJ/arv0XOL1JmWPzDV/qnRyGRae9qI
         LB+GXEVIHLNPxfWldv0y78r7TDSUDu/WtgydzkP9MI0S1sRp33CJcaOnqWn4o0HmVnnp
         Liv+jOxONMGbVpRPvs4RoPUgi4xZ5u80Izj/qx6SBhle3lbU+hJHmMRqA2VJNeRSoTzU
         8Xx1pjJ8rklsTyQM/MflGbnwSK6Ky5S0BSXPhLPvkpFNoftjMKynf1hogTKMdGXmj3Jk
         n0R6YaUOTilOYlUbNo9ECLQxEDbYqxfdHGizX7KJe6rXVaPjF2vDcD7Qel8rIiJFL+wV
         d2Ig==
X-Gm-Message-State: APjAAAWejB22EK2huGN8YqBiOnlsu03KGPk3t3CTLxDbOiaAKtHCwrLN
        LQpshnmWRcaq/ZuyWvS8JYBdEryddKEYTQ==
X-Google-Smtp-Source: APXvYqxC1ogp5ymarS23o7Y/qNEBm1VgExZMuoYAiVSg3two4S/SZfEUgGainukDUYqL5VgRE6RC3+WAy7ivRA==
X-Received: by 2002:a63:304:: with SMTP id 4mr10135000pgd.13.1568913159779;
 Thu, 19 Sep 2019 10:12:39 -0700 (PDT)
Date:   Thu, 19 Sep 2019 10:12:36 -0700
Message-Id: <20190919171236.111294-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH net] ipv6: fix a typo in fib6_rule_lookup()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wei Wang <weiwan@google.com>, Yi Ren <c4tren@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yi Ren reported an issue discovered by syzkaller, and bisected
to the cited commit.

Many thanks to Yi, this trivial patch does not reflect the patient
work that has been done.

Fixes: d64a1f574a29 ("ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Wei Wang <weiwan@google.com>
Bisected-and-Reported-by: Yi Ren <c4tren@gmail.com>
---
 net/ipv6/ip6_fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 87f47bc55c5e3f5e5f522d153fad69d6d82e6332..6e2af411cd9cc4131c5d457e6d48f177fc6d4428 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -318,7 +318,7 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 	if (rt->dst.error == -EAGAIN) {
 		ip6_rt_put_flags(rt, flags);
 		rt = net->ipv6.ip6_null_entry;
-		if (!(flags | RT6_LOOKUP_F_DST_NOREF))
+		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
 			dst_hold(&rt->dst);
 	}
 
-- 
2.23.0.237.gc6a4ce50a0-goog

