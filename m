Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71DA1BEF88
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgD3FCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3FCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:02:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA93C035495
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:02:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so1807221plo.7
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=amsR6fKfRr2MWIQ/OWsdu5esmwGJH8U8a3u3xAw5fqo=;
        b=cada2NaGDLB0cDt+l+/BM0sLwJkJTr9FMICp0pZn8kxnaesTMJ3PbgBZ7V9uJVHVuq
         dfXXSBabCZvf5g0+YN9RsJUUur7sNpiokvuqRINgIz6jUYaXlnaT+bdZzo/wnNhPQgR6
         wNim2pGqWZKtoPQ6pgiUBy+YJp/kxax8wndidEeY8MVgAwJCXHwO3pcFus7RWfuHEYGH
         tvfCC6NCP+HmqJjmx/oUfte43/+v5jR295AA9Ya9x6mLJRb3bDI6ikQm7d2KLNEW3lFK
         ZG0rp/N2khAetS/m/Dx1bk9rggco4SMbrisNXSVNh1A/J4/zVLxxaYWNu33vk1Lnhh4o
         MR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=amsR6fKfRr2MWIQ/OWsdu5esmwGJH8U8a3u3xAw5fqo=;
        b=VgzDm0gQlKGQ71l5Pz+OU0D4ZaPIM1AmwiHwY1Ov1Ly398w/wRH8vNw3FBc707ypc5
         CscipB+kNZPOJa6pD2p59N0HPZroG+7RJi/MpdVZ47RdcXsFg/Xa/8x2LnD5veTjdkXg
         CW1KXdxOdKTQbrNGBeiT+xv+ZH5tWeNXIMytCS7z+vqf8c/PreE3wk83rohXr46BJj+T
         SS6DI9nVbe4pOSby//JkBdS8Mczx0rzonJOzp+jZ3zGm2y/aLxndexNkllnwSo11TSPq
         kwUbbulL0EGYhI5pcsjJsnsqNRzJceau65nQDI4MsyHE79EkW6cGayX2zRXCDvfy12EC
         rbAA==
X-Gm-Message-State: AGi0PuaBmKWbEFSIyJmev1pdYmlzd0p5lqu5XzQCP9mTBaA6asNoTyi0
        pe3REkDTqWMgAVQEH+RHjzcDSzwWCUw=
X-Google-Smtp-Source: APiQypKdkRtAZy/nSgsW1YQ2Afy186QEQE0hftz2AxYlZkqTjqac1124OK7R9hqLByZm5Y+HsSlmFQ==
X-Received: by 2002:a17:902:e989:: with SMTP id f9mr1971813plb.321.1588222958126;
        Wed, 29 Apr 2020 22:02:38 -0700 (PDT)
Received: from localhost.localdomain (fp98a56d27.tkyc502.ap.nuro.jp. [152.165.109.39])
        by smtp.gmail.com with ESMTPSA id 79sm2169931pgd.62.2020.04.29.22.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 22:02:37 -0700 (PDT)
From:   Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
To:     pablo@netfilter.org
Cc:     netdev@vger.kernel.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org,
        Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
Subject: [PATCH net] gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()
Date:   Thu, 30 Apr 2020 14:01:36 +0900
Message-Id: <20200430050136.1837-1-ahochauwaaaaa@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In drivers/net/gtp.c, gtp_genl_dump_pdp() should set NLM_F_MULTI
flag since it returns multipart message.
This patch adds a new arg "flags" in gtp_genl_fill_info() so that
flags can be set by the callers.

Signed-off-by: Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
---
 drivers/net/gtp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 672cd2caf2fb..21640a035d7d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1169,11 +1169,11 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 static struct genl_family gtp_genl_family;
 
 static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
-			      u32 type, struct pdp_ctx *pctx)
+			      int flags, u32 type, struct pdp_ctx *pctx)
 {
 	void *genlh;
 
-	genlh = genlmsg_put(skb, snd_portid, snd_seq, &gtp_genl_family, 0,
+	genlh = genlmsg_put(skb, snd_portid, snd_seq, &gtp_genl_family, flags,
 			    type);
 	if (genlh == NULL)
 		goto nlmsg_failure;
@@ -1227,8 +1227,8 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock;
 	}
 
-	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid,
-				 info->snd_seq, info->nlhdr->nlmsg_type, pctx);
+	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
+				 0, info->nlhdr->nlmsg_type, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -1271,6 +1271,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 				    gtp_genl_fill_info(skb,
 					    NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
+					    NLM_F_MULTI,
 					    cb->nlh->nlmsg_type, pctx)) {
 					cb->args[0] = i;
 					cb->args[1] = j;
-- 
2.17.1

