Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF25455497
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 07:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243258AbhKRGNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 01:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241659AbhKRGNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 01:13:51 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE3CC061570;
        Wed, 17 Nov 2021 22:10:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b11so4305868pld.12;
        Wed, 17 Nov 2021 22:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dTmsY3/eaoFrMF9sZ5Mn2qk9OUF9m4XlagiWzfBrDG0=;
        b=TKrUfo+bi/NdDux2W/jW45nfMJhMt0L/JKTyFXCQ/CM6SxzaPpGLQuYlKwzYI78K3D
         MWE5tevNvUIKjBgPPLoyU1AU2408sUHGTmiPmtjhVn6m8/Gphi5aGfJ76p1lp56tuUuZ
         2MyOHJC8XVDQ57ys6Hq4UJlRgxkXhFuVu7dJ7RG+BXnXgNTaBWVa6rR5ljJ9Whq9UsG5
         /AhilvGJQodwSNwI0W6ed5ll3RXyvddMHwbj1ejqsn3qZvQ7Bm4h894/suBWw+kAb8zI
         ECXh/jDUWB/qMmmpc6QDbFxw+EOVFYtxCVE1EivR6EjI6paJRSy8RsqracIBwrrqg5Yd
         3yfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dTmsY3/eaoFrMF9sZ5Mn2qk9OUF9m4XlagiWzfBrDG0=;
        b=YZQMIEniF09w3CKoWBSJhDAtvO9iTVknyUn75O5dUYLHqAXFTk11izaJpb8iJiS/eN
         CNlvH5ktQE8Nq/rDsOEUAzL6Kgbd8FxSOZckqFmfxR8gerVRhBtSzXnyAa2/PGgnVeFK
         phIlN8WdRY726YZsdoZpXAYfHUpvOjcMeh26MRzqcGUSOQkPmH8e42S0gO2AJxaZtR8e
         yyfCppxCumOYPpRuFIOqIuPbjDqMovW5nWvFBm6kVcEF/fMNoMjugtTjDvhAo+H7jUsa
         XdA6UAtIPeKwiHZ01JY/jfW5i6a5+mRwmm7NPC3Z3+/FFaeidOFxGwMiEYlqrsM6Pl30
         1qpA==
X-Gm-Message-State: AOAM532AZ6ek9GVX80+qFnPisbiNq8c0l93bV9jcdL4gwKckiOr7DPYf
        gwYR5Za3O02jxWKrz3SzxnIVmG/ec34=
X-Google-Smtp-Source: ABdhPJwYTm2kxX2YIpfb1kNNOuQz0U3sRh0CpxW3B/WvkBea5LOgNCeZNXh90PLCQEy0dKy2HALByA==
X-Received: by 2002:a17:90b:1e0c:: with SMTP id pg12mr7459698pjb.135.1637215851553;
        Wed, 17 Nov 2021 22:10:51 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s7sm1733102pfu.139.2021.11.17.22.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 22:10:51 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yao.jing2@zte.com.cn, zealci@zte.com.cn
Subject: [PATCH] ipv6: ah6: use swap() to make code cleaner
Date:   Thu, 18 Nov 2021 06:10:18 +0000
Message-Id: <20211118061018.163920-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yao Jing <yao.jing2@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yao Jing <yao.jing2@zte.com.cn>
---
 net/ipv6/ah6.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 828e62514260..b5995c1f4d7a 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -175,7 +175,6 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 			 * See 11.3.2 of RFC 3775 for details.
 			 */
 			if (opt[off] == IPV6_TLV_HAO) {
-				struct in6_addr final_addr;
 				struct ipv6_destopt_hao *hao;
 
 				hao = (struct ipv6_destopt_hao *)&opt[off];
@@ -184,9 +183,7 @@ static void ipv6_rearrange_destopt(struct ipv6hdr *iph, struct ipv6_opt_hdr *des
 							     hao->length);
 					goto bad;
 				}
-				final_addr = hao->addr;
-				hao->addr = iph->saddr;
-				iph->saddr = final_addr;
+				swap(hao->addr, iph->saddr);
 			}
 			break;
 		}
-- 
2.25.1

