Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32AFE78997
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbfG2K0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:26:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35920 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfG2K0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:26:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so27803597pfl.3;
        Mon, 29 Jul 2019 03:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VcI5Q2ZpLHcc17k5AiEkcskGfcvmAnlW8nbveIAcfMs=;
        b=Ig1uEQG2w/0mpeZQe+ESmJRXBhegqQnZD4UxuXyDRkCKi7daWitBiMoDqMoHExcmXd
         mTC/ub8DvvLIz2UCTl16BApIZXWPSnXcCMm4+TRdyHgGj1ZNZ3DukfhHNajVO1r7XAeg
         pGmN4M+7XB6liHUnSIRyI83yFWKRKWP0SghzBSnt3euDTs0J+8X5IBUM2uTB32xD7Lpe
         LfFvEbo0SgJRSPc54XEhFkF0g0Wy1MK8Wxh9AQ5LJzVszsgpNz2lteYsYSGypedVQvx4
         S2+K5NanZToi+1T/if4wpF8eGftCvZsTgjvxX3EvcnUIqeiAxia/uWbCzeQ/ZD79KCHA
         w4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VcI5Q2ZpLHcc17k5AiEkcskGfcvmAnlW8nbveIAcfMs=;
        b=LcO+2p+uAU7OTofTer4MN10BcNByJWWA9LOpXuEdQ7YK3iqcz6R2IoF54jcMa+Lncg
         7d0BUTyd5GYf8Ru1X1kvDK+V6oIKibhMOTrbv3zV8VOoNsHpFCMl+Su9N4MozL6PUPWi
         CwHIt/PYCNnSbXzKAWGy+wBmvHMYIfWG1/d+uLGUqCxMIeO8eLKdoV8zfN/EYMBr9yJf
         HRR4REXWlJ61TwrArZDDWzSqFYUMCEBW3pXbxSnK7xGXhSkMJIskufnbouFNWb8nkuwV
         FqYGb6X6h4Inw/u2RI8dsZZjREIR/+oEvzFP/V+nbi8zHyb3zDGSKBt4aswzzYoEjaeF
         kaQQ==
X-Gm-Message-State: APjAAAW3dwl+p4ZdeULJOTjYln7qakb3JlewLlDrAOTvFOq7Hwc0zRug
        3XDpaNHl7FcaJ2UG0AsXjDM=
X-Google-Smtp-Source: APXvYqz3xs6nPpq/kgFOfr3gnJ6RaJd9dm9GfIi8867z/pWOsGB+ekawfPGdjAES1m7qYTHTjVMebw==
X-Received: by 2002:a63:c1c:: with SMTP id b28mr71431117pgl.354.1564395984612;
        Mon, 29 Jul 2019 03:26:24 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id i137sm60421203pgc.4.2019.07.29.03.26.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:26:24 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net, sbrivio@redhat.com, sd@queasysnail.net,
        liuhangbin@gmail.com, jbenc@redhat.com, dsahern@gmail.com,
        natechancellor@gmail.com, tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: geneve: Fix a possible null-pointer dereference in geneve_link_config()
Date:   Mon, 29 Jul 2019 18:26:11 +0800
Message-Id: <20190729102611.2338-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In geneve_link_config(), there is an if statement on line 1524 to check
whether rt is NULL:
    if (rt && rt->dst.dev)

When rt is NULL, it is used on line 1526:
    ip6_rt_put(rt)
        dst_release(&rt->dst);

Thus, a possible null-pointer dereference may occur.

To fix this bug, ip6_rt_put(rt) is called when rt is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/geneve.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index cb2ea8facd8d..a47a1b31b166 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1521,9 +1521,10 @@ static void geneve_link_config(struct net_device *dev,
 		rt = rt6_lookup(geneve->net, &info->key.u.ipv6.dst, NULL, 0,
 				NULL, 0);
 
-		if (rt && rt->dst.dev)
+		if (rt && rt->dst.dev) {
 			ldev_mtu = rt->dst.dev->mtu - GENEVE_IPV6_HLEN;
-		ip6_rt_put(rt);
+			ip6_rt_put(rt);
+		}
 		break;
 	}
 #endif
-- 
2.17.0

