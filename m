Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AF834992E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCYSIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhCYSIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:08:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CC2C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:34 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v3so2624707pgq.2
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9k97SxtcsqdbWE2RKU4QV5QkFAR1v73dtlcSPWuvkhI=;
        b=fy+bWJhOledzvQS+brQBsr6Qq15YV3evTvera5Oio64BW6c2hJvDDfg+Q+0Ua89hgN
         5qViQoo6jOR2CKBToh29hRQlsNAg92EmBLo6k0ob05c6qy7SOVS108P7WkydHw6k+izR
         Cg1V0IZufql7rdysrjfQnMsX7dfaMe7Rb40Kunmysz0acuVOth/P/KAhkXAVlaLsqId1
         sjRejjpFoIGHXbZcRSTbwHh9JZN8H/jsqpT0n2FJWWGVtxv3VrrVbZfF9V5KS5+mHJSK
         +GqnoTdLfW0VFuaGyun/0IYW3sUry5FaQea5y7Xr3CIstrzzq7ArC3upfpltdQT8ereV
         rANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9k97SxtcsqdbWE2RKU4QV5QkFAR1v73dtlcSPWuvkhI=;
        b=ckTv9YiTmpWzWjVngnDOpYgIB6XB87KqVekLn1IMCQo0XyOP9aKhVO8P+Ws05hhG94
         uYZPSmYZynQwagwt+krEf8GNru3YR/cuW8u3gM9tBCHp4FkwJZcpDlVOmci8JqKCcj4a
         OChGmPWR/XI3OGb4WdXXYGorUW6h0RlBLTPRL2gdTOBFwm8UAfvay3Z7mUj7e0Od7qZR
         Fs+mg/M39/8SpT37dWoNihqXwDCaqJO0Hzqa7Hd4O4zWtGVD9LKGiJLhAOB9X3dwwdwE
         IjjsAi2xisKMlvMCbiazox4gmAXFXh1+axM6CEqZmgZG70aIax5OstlYcTo4Jko6+/0Y
         Olyw==
X-Gm-Message-State: AOAM533o/Rk/xezM1l3KyC8o9bVJvT7YHA9ktrJo1eIywfpQnSDP3MzC
        7Q1r1VVvrd8DOrsW73qsX3Y=
X-Google-Smtp-Source: ABdhPJzuiR4/GGdVFM2SqgB8K2aNCTmOuizFcLVvRtBTXUWnnLIEbgi8A5QJXr3e8jMBbGla004dOQ==
X-Received: by 2002:a65:538f:: with SMTP id x15mr8798555pgq.429.1616695714197;
        Thu, 25 Mar 2021 11:08:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id j20sm5968359pjn.27.2021.03.25.11.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:08:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/5] ipv4: convert ip_forward_update_priority sysctl to u8
Date:   Thu, 25 Mar 2021 11:08:15 -0700
Message-Id: <20210325180817.840042-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210325180817.840042-1-eric.dumazet@gmail.com>
References: <20210325180817.840042-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This sysctl uses ip_fwd_update_priority() helper,
so the conversion needs to change it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 7b572d468fde5ae104ecdf4bd5b8118290deb81d..d2c0a6592ff6c0a3e954c157d109bf22d7bb701b 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -98,7 +98,7 @@ struct netns_ipv4 {
 	u8 sysctl_ip_default_ttl;
 	u8 sysctl_ip_no_pmtu_disc;
 	u8 sysctl_ip_fwd_use_pmtu;
-	int sysctl_ip_fwd_update_priority;
+	u8 sysctl_ip_fwd_update_priority;
 	u8 sysctl_ip_nonlocal_bind;
 	u8 sysctl_ip_autobind_reuse;
 	/* Shall we try to damage output packets if routing dev changes? */
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e5ff17526603c274d50350bc1ebb21e20c598c9a..713e0c0c91e918274cb7cdf7212a6a3e5b8e140c 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -209,7 +209,7 @@ static int ipv4_fwd_update_priority(struct ctl_table *table, int write,
 
 	net = container_of(table->data, struct net,
 			   ipv4.sysctl_ip_fwd_update_priority);
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
 	if (write && ret == 0)
 		call_netevent_notifiers(NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE,
 					net);
@@ -743,7 +743,7 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_forward_update_priority",
 		.data		= &init_net.ipv4.sysctl_ip_fwd_update_priority,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler   = ipv4_fwd_update_priority,
 		.extra1		= SYSCTL_ZERO,
-- 
2.31.0.291.g576ba9dcdaf-goog

