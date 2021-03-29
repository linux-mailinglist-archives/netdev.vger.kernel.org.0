Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A8F34DC64
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhC2XZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhC2XZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 19:25:09 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E83C061764
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 16:25:09 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso9281704wmi.3
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 16:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gvWBHRQ4dmNlAUqlBpgyV+LGIhnFLsa/5M1EOOKR94E=;
        b=Nr3ds1bAUpbG9U6miXNRzbQ1LRVbDehZ2ZuwSnSWHLI0LjXKeSTA18tddSNKKFuQws
         iM8kBFmUNkz6xlUiVSQbAWMRYjs43oz3GCq1aeVSseKsBxsMiL+36Yf69vUAcsFgfuX/
         jj8NWlcJbXAjqGxxzjwb12AvuCc19SsnNS0P/eAvmn0Zi5kwXV/te0gJzBSwOnD2B8C4
         qSt0Ry2OkDbVMTWI79Dmc++kJFJlyXck6I4Q8IiIK8GE4/zB9Vrq8YY0JwuJ1hLvaH2K
         51wyqMQElQUsxEvh49eIC42NCj2AEEgtDehY4jyaLKlc42TM26M5klHRxxyeMQcOQDVP
         noQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gvWBHRQ4dmNlAUqlBpgyV+LGIhnFLsa/5M1EOOKR94E=;
        b=tGWaVfL8pxdpVDAOwk7nWwNu8vCS5E9Z9L2HTjv4kgweEnmWpNQFw/SaAM6b9Z1sOe
         YIziD9JUoR0ry4SVPVZsZ140RJQhw9rg0f3K5Sy4ImlMQvwVF0YlOT5DyNCINkCOtrED
         9VtissHEYA4u7pukh0AFQ20PuYpQ0xu6MJkGxfFDAREkYERXgTh7zSl2gyYPUVe8fbeV
         MJHGj0lW3oy8fNjd7Y1KRL6J4ulXXr6M8PChcx/CS3di85jdcA/QCFVrzkPK1EeE3zTC
         yvRk7W/K2M8InVvcdSoo7NQQ967br4F+qf+rsnlHnWl1swKQeQD2Veibu2FVvV/6Vnd7
         C32A==
X-Gm-Message-State: AOAM530PpEvaQs8WLNRbCzyhmF61Ua5QhikVSWi5QpAM4hIbf3y5tlrE
        AGBPrJpuyLCKpg5qactv3ucIaQ==
X-Google-Smtp-Source: ABdhPJwME6tVWZ3CgqlQk2+a7FRLosmhGeD6rmBASHnofcgCCKN4B/5z2HMtQmTyBEX9I3nszitmew==
X-Received: by 2002:a7b:c4d1:: with SMTP id g17mr1129751wmk.101.1617060307675;
        Mon, 29 Mar 2021 16:25:07 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id m17sm32759518wrx.92.2021.03.29.16.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 16:25:07 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] xfrm/compat: Cleanup WARN()s that can be user-triggered
Date:   Tue, 30 Mar 2021 00:25:06 +0100
Message-Id: <20210329232506.232142-1-dima@arista.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace WARN_ONCE() that can be triggered from userspace with
pr_warn_once(). Those still give user a hint what's the issue.

I've left WARN()s that are not possible to trigger with current
code-base and that would mean that the code has issues:
- relying on current compat_msg_min[type] <= xfrm_msg_min[type]
- expected 4-byte padding size difference between
  compat_msg_min[type] and xfrm_msg_min[type]
- compat_policy[type].len <= xfrma_policy[type].len
(for every type)

Reported-by: syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com
Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/xfrm/xfrm_compat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index d8e8a11ca845..a20aec9d7393 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -216,7 +216,7 @@ static struct nlmsghdr *xfrm_nlmsg_put_compat(struct sk_buff *skb,
 	case XFRM_MSG_GETSADINFO:
 	case XFRM_MSG_GETSPDINFO:
 	default:
-		WARN_ONCE(1, "unsupported nlmsg_type %d", nlh_src->nlmsg_type);
+		pr_warn_once("unsupported nlmsg_type %d\n", nlh_src->nlmsg_type);
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
@@ -277,7 +277,7 @@ static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
 		return xfrm_nla_cpy(dst, src, nla_len(src));
 	default:
 		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
-		WARN_ONCE(1, "unsupported nla_type %d", src->nla_type);
+		pr_warn_once("unsupported nla_type %d\n", src->nla_type);
 		return -EOPNOTSUPP;
 	}
 }
@@ -315,8 +315,10 @@ static int xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src
 	struct sk_buff *new = NULL;
 	int err;
 
-	if (WARN_ON_ONCE(type >= ARRAY_SIZE(xfrm_msg_min)))
+	if (type >= ARRAY_SIZE(xfrm_msg_min)) {
+		pr_warn_once("unsupported nlmsg_type %d\n", nlh_src->nlmsg_type);
 		return -EOPNOTSUPP;
+	}
 
 	if (skb_shinfo(skb)->frag_list == NULL) {
 		new = alloc_skb(skb->len + skb_tailroom(skb), GFP_ATOMIC);
@@ -378,6 +380,10 @@ static int xfrm_attr_cpy32(void *dst, size_t *pos, const struct nlattr *src,
 	struct nlmsghdr *nlmsg = dst;
 	struct nlattr *nla;
 
+	/* xfrm_user_rcv_msg_compat() relies on fact that 32-bit messages
+	 * have the same len or shorted than 64-bit ones.
+	 * 32-bit translation that is bigger than 64-bit original is unexpected.
+	 */
 	if (WARN_ON_ONCE(copy_len > payload))
 		copy_len = payload;
 
-- 
2.31.0

