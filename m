Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39144FF542
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiDMKyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbiDMKys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:54:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB46B59A4A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg10so3125944ejb.4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+d6Rov8cjDp4XASxWMxnkxwuD5Gq2aFtJ+v6sDjNGk=;
        b=E2vRYdVkMpOuOmuBfP6Oq6xxQ8AygCk0IigcDxqCSJmZqps/Xbyf6XW0O12cT1Oax4
         FiCB528iHFY03d7tXKx1d7N2lWiDg084eNkY9gq7shM2MIKG9UF5/64tnrZ3mpv2OI6e
         mV12s6jeyA6T8qTdawpgBxEpaf9xzc4JN48EHsKpzIF3Puf1xfFHkxbwqDOBfCUKcufz
         72d5o/qUEMspTt1BacW//JMc0IKjZixQER9i2DrxZEZHW1da2hBX9DWVs/SXN4DCMKMj
         t4gR2S79+YxQGdmMRFJdJ5nY175E47oT+YLWlr/jgqTtIN17mxndg0U/ui3nDbEhX3z9
         Zgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+d6Rov8cjDp4XASxWMxnkxwuD5Gq2aFtJ+v6sDjNGk=;
        b=aNFhOVagYQgerGw+XFxwVvGcmit3j84d5pDDyw8JRZdOR0xj9NGA1NKDY8iUTK0rEN
         osS6WRey9mPwy2k8q3iaUNv+Y7BT3SFdu4IaIeIfIjVwCBJwJBxGoMoJxc2jpOP06yCe
         rFVJbM0OXjiOSq5ruV+ZfGHFndb9d8ZUK86aHcVceCwmRXAH9rNAHEN4V0d1+gckYDJV
         efshKbfmKSoAo7emDotYxl8BVezW0ePXPtDrYpnwv6QxgIuMW1aDE/A5wutWZgkXDrm2
         qx9Rhg/3qQoR86DT5iVXYVLT+qAb3h/BVKVxzlYWruX58kNXSzSG07yuT3eUqL/qkzXG
         5ayQ==
X-Gm-Message-State: AOAM533PlgTknxBMTGHLuj0Oi17UB6wqVsMchfL1bAS2Hri5SrTLKdPB
        ZRAp/wAEiisYe6oX0cSAyiA4VL0bp6BtPv1L
X-Google-Smtp-Source: ABdhPJzHstTpmBQgNCZQOeZWES1aAH90boWyFAjDx2nJhi9OSbcCrVvB3z3PKcnCHhXapqWq8d+UHw==
X-Received: by 2002:a17:906:3ad3:b0:6cd:382b:86e5 with SMTP id z19-20020a1709063ad300b006cd382b86e5mr36598097ejd.145.1649847146154;
        Wed, 13 Apr 2022 03:52:26 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709063bc800b006e898cfd926sm2960952ejf.134.2022.04.13.03.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:52:25 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4 05/12] net: rtnetlink: add bulk delete support flag
Date:   Wed, 13 Apr 2022 13:51:55 +0300
Message-Id: <20220413105202.2616106-6-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413105202.2616106-1-razor@blackwall.org>
References: <20220413105202.2616106-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new rtnl flag (RTNL_FLAG_BULK_DEL_SUPPORTED) which is used to
verify that the delete operation allows bulk object deletion. Also emit
a warning if anyone tries to set it for non-delete kind.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v4: new patch

 include/net/rtnetlink.h | 3 ++-
 net/core/rtnetlink.c    | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 0bf622409aaa..bf8bb3357825 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -10,7 +10,8 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *,
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 
 enum rtnl_link_flags {
-	RTNL_FLAG_DOIT_UNLOCKED = BIT(0),
+	RTNL_FLAG_DOIT_UNLOCKED		= BIT(0),
+	RTNL_FLAG_BULK_DEL_SUPPORTED	= BIT(1),
 };
 
 enum rtnl_kinds {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index beda4a7da062..63c7df52a667 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -249,6 +249,8 @@ static int rtnl_register_internal(struct module *owner,
 	if (dumpit)
 		link->dumpit = dumpit;
 
+	WARN_ON(rtnl_msgtype_kind(msgtype) != RTNL_KIND_DEL &&
+		(flags & RTNL_FLAG_BULK_DEL_SUPPORTED));
 	link->flags |= flags;
 
 	/* publish protocol:msgtype */
@@ -6009,6 +6011,12 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	flags = link->flags;
+	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
+	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
+		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
+		goto err_unlock;
+	}
+
 	if (flags & RTNL_FLAG_DOIT_UNLOCKED) {
 		doit = link->doit;
 		rcu_read_unlock();
-- 
2.35.1

