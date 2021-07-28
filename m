Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D0D3D9354
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhG1Qia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhG1Qi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:38:26 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7258C061757;
        Wed, 28 Jul 2021 09:38:23 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d18so5103804lfb.6;
        Wed, 28 Jul 2021 09:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=77K73dksEpmGlJUjpwNW6l4lVOW4JLj+w9GUtsUnAX4=;
        b=ulOuYdlbzRHWBrNH0SiwEqP8deil/czWYniaORknPDBTvPk11hYuAeN0x8UP0YckBc
         GVXuoXsWYEaeYiorylmqdg4F5RlJqzRqy1hI01VabcyhgpKh3mrexBWcF/z03gBkp9kX
         1IrKQeQdLk6yAFBhmJdafQev4hLboHLzwi20IpQQHfuUsXxLKjEEvb5IX4vXclSnGUBp
         Lc3XW2RwTudUoANoDbka9ITPNVDjtybn3eQF4cOXSS1uHEHJVMg2CWYD5z5WWnedKmM4
         yEJa4AF3yf0NSGrRFv1VyY0yccyB5NuRKROoLurvE4azjJwtNErrdjg9zKYepoxKlWv5
         lYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=77K73dksEpmGlJUjpwNW6l4lVOW4JLj+w9GUtsUnAX4=;
        b=Lr43/5fxRL2QpzgI0OUYBvjezXZmQZIjdSXk+NudLN7QE5z0pLOnkNiONSJFlkhey4
         sXqJvFSvCiCQi9sVuPyDL/ZP995JJkcUTUA7jKWyiu+Sapx4/l0Eanoj5uMnyUXk1mtE
         01GuAPog8RvHIS7iZpM0EPFZjZcQ4jF3xE1hlS0UEUshlhnKgcftHw/JBDFGW7Qt4i9A
         J2dkZRsmlBdPp9jpesnU7gxLNCCzzFBu5U9vIk7Bbc4xJCt1031UXtZ2rGINC3xE+WC5
         NInGeTTWa8LbUU6N4hYMXqWIhDm87JLb9cFNIeWoKkPKenwDAsWwNA+mENyBUNltuPDJ
         rwvA==
X-Gm-Message-State: AOAM531JwTrs7hDpWX6zCIkzt5mxiCjChGAtKy5s4SeHYYwKRoRf+OkI
        HOqhL9vJskgoc/yn6tg/hug=
X-Google-Smtp-Source: ABdhPJyej1AktIotkBnpEVyH6gJAn59DFYy2Ner1i6FFpNiG1r/Q+UQb3CcJBMUE2jbC1m9sg/Xu4Q==
X-Received: by 2002:a19:c758:: with SMTP id x85mr319786lff.609.1627490302133;
        Wed, 28 Jul 2021 09:38:22 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id w17sm43590lfu.304.2021.07.28.09.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:38:21 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com
Subject: [PATCH next] net: xfrm: fix shift-out-of-bounce
Date:   Wed, 28 Jul 2021 19:38:18 +0300
Message-Id: <20210728163818.10744-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to check up->dirmask to avoid shift-out-of-bounce bug,
since up->dirmask comes from userspace.

Also, added XFRM_USERPOLICY_DIRMASK_MAX constant to uapi to inform
user-space that up->dirmask has maximum possible value

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Reported-and-tested-by: syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 include/uapi/linux/xfrm.h | 1 +
 net/xfrm/xfrm_user.c      | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 6e8095106192..b96c1ea7166d 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -514,6 +514,7 @@ struct xfrm_user_offload {
 #define XFRM_OFFLOAD_INBOUND	2
 
 struct xfrm_userpolicy_default {
+#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
 	__u8				dirmask;
 	__u8				action;
 };
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index acc3a0dab331..03b66d154b2b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1966,9 +1966,14 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
-	u8 dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+	u8 dirmask;
 	u8 old_default = net->xfrm.policy_default;
 
+	if (up->dirmask >= XFRM_USERPOLICY_DIRMASK_MAX)
+		return -EINVAL;
+
+	dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+
 	net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
 				    | (up->action << up->dirmask);
 
-- 
2.32.0

