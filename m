Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047FB156A90
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 14:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBINPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 08:15:38 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35590 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbgBINPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 08:15:38 -0500
Received: by mail-pj1-f66.google.com with SMTP id q39so3002718pjc.0
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 05:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CaytYSX1hzpIKo99sN/1ZkNQvBK92/+TQBcuHH2kT1Y=;
        b=JuImFePwjSoeo6o56vFTMmzUoJVSkgREKl939KRSbsak3wYaY8dVRW1v/2fZA54fJq
         O1JOG5l2BqxGOsBh+T7AHyTK3XQN+jskn57xXAqEXNWLJmZa4a53Yg0mgyGMuRlUZEng
         Anfon8oZFzAwAR2NTTZ485eDQifxrLvKHyQOF123+LIO69UHzCjP3CAuEXexS5HCK1rj
         7gei+xf5m9d+lvYk6InxIr4+Qo7gWcNNETS/LKfZ6MC41DcJ5o6k+eRwUN569sAnyPEo
         EDtp3OQQYi41URKaHMHYQrh3Uw47AMYi3ee69SQ0eifDyc089LgKkoN20Lzvl6vG4mSE
         Vl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CaytYSX1hzpIKo99sN/1ZkNQvBK92/+TQBcuHH2kT1Y=;
        b=KNZq9Ik+W3ARNySelUp6xGnRgEGBHuN6EB7+BN4LZhMWmQIKCEq26KUwb1Z9X7js4B
         vJcKP57nwpJSUZE14fqaECzdFdI9uDOPbJfIv7khBAnnXl/HwL91nDb+dQ5IrFIKPJHv
         n/Ea5DBbwHXg+wYdvb2/4Uq7C0OaBQOcZ5Yfcm4RbNL7CvzEgKtS6u0PIfgqvI7t3XEI
         wPJCxRYgWqrZNOJBH4zXAtYxPfEwX+txQz4coZEgw+V4J6e0+cVeqA/ThVRa1CMqcJEJ
         ehTDJ+6b6wmm5NUMLqnT3fCFvwpMbCS/7EfZtAWGLglTReO5W3tu8SN0eFJ+QFzQ3IjV
         oDwQ==
X-Gm-Message-State: APjAAAVfF0E6Wi/hzBNI+DMrspAINouwJRD/3VQm08hd0rvEbvL8/jvp
        FnXOmx5Fge/8RiNaiiOo7f/Eg/f+5Gw=
X-Google-Smtp-Source: APXvYqyoWc41mIxl+D/VDKz5SXZXJ6Mm48FnV7TJ5L6cDT2nsZjObrvlv3rvA/jpe1+1Qz97oD4fvw==
X-Received: by 2002:a17:902:a58a:: with SMTP id az10mr8098378plb.20.1581254137593;
        Sun, 09 Feb 2020 05:15:37 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y10sm9425623pfq.110.2020.02.09.05.15.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Feb 2020 05:15:36 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Trent Jaeger <tjaeger@cse.psu.edu>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: fix uctx len check in verify_sec_ctx_len
Date:   Sun,  9 Feb 2020 21:15:29 +0800
Message-Id: <afee25abdf818c7a7374773a6f347cf5c719038e.1581254129.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not sufficient to do 'uctx->len != (sizeof(struct xfrm_user_sec_ctx) +
uctx->ctx_len)' check only, as uctx->len may be greater than nla_len(rt),
in which case it will cause slab-out-of-bounds when accessing uctx->ctx_str
later.

This patch is to fix it by return -EINVAL when uctx->len > nla_len(rt).

Fixes: df71837d5024 ("[LSM-IPSec]: Security association restriction.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b88ba45..38ff02d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -110,7 +110,8 @@ static inline int verify_sec_ctx_len(struct nlattr **attrs)
 		return 0;
 
 	uctx = nla_data(rt);
-	if (uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len))
+	if (uctx->len > nla_len(rt) ||
+	    uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len))
 		return -EINVAL;
 
 	return 0;
-- 
2.1.0

