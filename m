Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D083505D2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhCaRw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbhCaRwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E85C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m11so15077688pfc.11
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M542lfMcaoG0xPmGsnq9ggsaGj5JrxyHQu8s+vU2Zis=;
        b=eSN9uxaDH74vEVvqV9+7jcShXJS7Yk7VqUS8MwPsXG2MoF2VrDInOqK8722PmTwSa/
         mFW/kPKzJKeDDMn8phTOk7S88uf96nndxs+sS1ysJI1GD82eUSevC/gNyvIrt4FXZqeO
         tP3MkMawK+zkTE2jjFxHDoZOYyIkzhPq0Rvgf4KyjRWZi9+DeE4eRg4JkT5bQHRDTy8R
         wZq4XUwes87w+kDBzI5LbGShCeleH0nySNQGzaNPranDc2w3Qwsyng2yPPX3fsvTwjmk
         CoQdTyEJYw02uWnuysT5vWdchAHuerl709j1E1S8lKqGZL8JCUt3HlMpAFdfRYTEjuAy
         oFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M542lfMcaoG0xPmGsnq9ggsaGj5JrxyHQu8s+vU2Zis=;
        b=Fva9YvE0/EO/KbRvZIOv/8DRmI9aSqtOppRlrkYo89QmXpS1z+454Rc31ZfY3l5nm0
         gAJhRwK2/H4DiXxWQl1s7d/8MU3Hx/ecLHNqfJE/6RT85d2Y9wOrn0haVZPMMG8sbu07
         yXNcchDKdZMLcA6ErpssRERIEmnworiUX4yNwDtKvymKwQ9ze6LLGLzFYAeS6LrWLTXX
         UBGp3AQqkrbPxfPQfEAIiZCxTLKVtgTpMoVxACR5xPQFa2Qu3c/uJiQifwEz+JPQ+C/d
         TN35KdXfiVpnpcGcsTbmFGxpDMjDT3J+ePRBBILY0U0D1cfEIxLxRAdJKrraiBStmHoQ
         ArtQ==
X-Gm-Message-State: AOAM532mrAyVKw51ParYbZmDHkwNMrVIX6UySynjWP2Xpq5E5hEQKRJG
        deCdCQSGuI5B6ODDX0OprpI=
X-Google-Smtp-Source: ABdhPJykndZ2sY5iRCJwwNz/Rg4SjT5YolI9Lo9q2GiEgFZ2CnQilao2fQyhgXOZwyVN4u6zKIlbUA==
X-Received: by 2002:a63:6f8a:: with SMTP id k132mr4405472pgc.59.1617213141433;
        Wed, 31 Mar 2021 10:52:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/9] ipv4: convert fib_notify_on_flag_change sysctl to u8
Date:   Wed, 31 Mar 2021 10:52:07 -0700
Message-Id: <20210331175213.691460-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Reduce footprint of sysctls.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 538ed69919dc4d51acfd43c7d6d1fca611fcb003..b187ac597b8ce33376070bcd42c8c935b9c287eb 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -191,7 +191,7 @@ struct netns_ipv4 {
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
 
-	int sysctl_fib_notify_on_flag_change;
+	u8 sysctl_fib_notify_on_flag_change;
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_udp_l3mdev_accept;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9199f507a005efc3f57ca0225d3898bfa5d01c53..a2352d8d88cc9956ac0ddcaf351cbc996fa10add 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1364,9 +1364,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "fib_notify_on_flag_change",
 		.data		= &init_net.ipv4.sysctl_fib_notify_on_flag_change,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
-- 
2.31.0.291.g576ba9dcdaf-goog

