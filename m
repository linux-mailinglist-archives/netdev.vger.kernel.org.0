Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E00537FA0
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfFFVck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:32:40 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:42191 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbfFFVck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:32:40 -0400
Received: by mail-qk1-f202.google.com with SMTP id l16so3209153qkk.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ddtb+6Yv4ye3BakH7YBJP3uOjhB9QhZnMRT9iBNguKk=;
        b=fGmY7thQWq7sb8UVOF/88VdgLfYp8JOBdNTejA8U+DjrM8pgBk30HYtsifFLkgr604
         F7Jd3+DsXTs8/fEBeMm1V6UNWoRvR/pBwVYwPpER4jdzmGZsR6/BbXIBAUlPnKLAMo2D
         LEo/MuuPEkiNy2G13yJTSswlYKLN8MmemyLhLohsefhKsdX+Xnqly4ZI8X2/ZLJ39lEH
         l4AjmLKMuB3mZWx2thPUfdGtYZNDV7WNTDVC0nViW/IGr+yos1Y66tD2BYrxVgToJ1h/
         CdWiintiTTW8u6R3mgmkQT/xxP5QcKfp6yNM9itMDhabXWI7+Q0RZNVshkuKtNYdKGeM
         ZrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ddtb+6Yv4ye3BakH7YBJP3uOjhB9QhZnMRT9iBNguKk=;
        b=qs0dY/oXZe0UMV+5iERyb3DHWkJGMxD13whpcSnW2BymWBiPorHrVszI0IdHwEKP0q
         N6TQ9Syf9pQbKBSGAyJ8Gq0M356HhMpfU2JB/jWPAefdU2KMFQaVAAqqkOYAis/ZeplP
         J1eqa4NrJwe2Xwb2pS6pb/X64qC/mTgd69sRt4UlkmPQpXTBlv6wJwMYvxCfeE9vDL4F
         1gM69YCGIZNGutbCIHWwtfharI2D/Kkj1GZOLvjtAqR6D1clH1XcZWJB3LaO3fm98d5K
         rz5yFZIhwjXXU0BvgdCSqtEBtwNBFibxadmZDLxn4jBdNLMI3ePPVaBqUNAVXUn3+vvC
         vmWw==
X-Gm-Message-State: APjAAAWIYNlN+TmSaIl33nEYQt1balu96GW6p7IUOJYcN2KMzYtAaagP
        BQEp/vBKXChs3HPp86gBhuXJUUlMmW2rGA==
X-Google-Smtp-Source: APXvYqxSAHUWr89ABIa5oITqUQ88XpgjfGdi7IZ3gnVExS4/WqUbFKhw/LP1ptPexOyEsdz8qF2T7eE/lEzeyw==
X-Received: by 2002:ad4:536b:: with SMTP id e11mr39616414qvv.163.1559856759154;
 Thu, 06 Jun 2019 14:32:39 -0700 (PDT)
Date:   Thu,  6 Jun 2019 14:32:34 -0700
Message-Id: <20190606213234.162732-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v2 net] ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before taking a refcount, make sure the object is not already
scheduled for deletion.

Same fix is needed in ipv6_flowlabel_opt()

Fixes: 18367681a10b ("ipv6 flowlabel: Convert np->ipv6_fl_list to RCU.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/ip6_flowlabel.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index be5f3d7ceb966d609121f89a6cc5dcc605834c89..f994f50e1516226c88101f901f71647514ad580b 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -254,9 +254,9 @@ struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk, __be32 label)
 	rcu_read_lock_bh();
 	for_each_sk_fl_rcu(np, sfl) {
 		struct ip6_flowlabel *fl = sfl->fl;
-		if (fl->label == label) {
+
+		if (fl->label == label && atomic_inc_not_zero(&fl->users)) {
 			fl->lastuse = jiffies;
-			atomic_inc(&fl->users);
 			rcu_read_unlock_bh();
 			return fl;
 		}
@@ -622,7 +622,8 @@ int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 						goto done;
 					}
 					fl1 = sfl->fl;
-					atomic_inc(&fl1->users);
+					if (!atomic_inc_not_zero(&fl1->users))
+						fl1 = NULL;
 					break;
 				}
 			}
-- 
2.22.0.rc1.311.g5d7573a151-goog

