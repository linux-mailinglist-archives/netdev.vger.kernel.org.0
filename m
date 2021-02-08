Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CE2313BC2
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhBHR5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbhBHRzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:55:17 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976D8C06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:54:33 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t25so10727821pga.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+O9RXy20nOZtVAzRE1KIvZyJl0+VVqbkieHFl0m9tt8=;
        b=J3LkI/d8QAQD/m5ow6FBchDU0eUkvzzcUlMGf6Th2bpVPVQ1yPlhwIEspnYGDvsUZF
         XUehCVxhBRSF82Wky081gIuiu4zAePwaVS5Hl6xtCR5lJD7qnba6+MwLqruA/7oZzL1G
         Q80Dx0UfWlO6dhCOKXfklB24M1wqVy8uFaa1OFAUK6dRf1hyc/g63LBMVr3XFXLGFekp
         0D4nBuT1XVnpNGavcZ5iw1N9t3g7pKhS8yjxLWSujB+fXqamDptTTvAlP2hrGHXTaZZv
         4ykfZi9lNd/8ZyjOfRDzOJmYl0wE4PzGEJZ+BuendXlRXsXCKZqL7jkd2nbVzOgp6BQb
         I+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+O9RXy20nOZtVAzRE1KIvZyJl0+VVqbkieHFl0m9tt8=;
        b=WIlpEVUyqjuwNhxBlm9LUcKfsnKA5uCxOt38Qi7LHpM1PEESobDucEI4zAn/L5F59d
         qhYIJah0sVR3THTp46oJ28BwtGzE2s4mfClvLLQvlmqmrQNOGpFydpFkpmqHX9UfvnyW
         4AcDlWjtOEdWdZqtd+RYgPKhXXeoCqPz1OIIglLNBOqvUny7PkUCkf19tnTnhJhhl12A
         aHrRHCoxgLKnkTdz+c9Ydx8wCw4Fl+lNYePioJz7uPFNZ09su1FaAnBrQEZMRk2CnKMU
         XVLCqWi3l+d+e5FR4GxjJCPb+jFQ9yYAmJo3EkEToC753B+337mEI6LyoV0kbhlGfpy6
         g6JA==
X-Gm-Message-State: AOAM533iawjt467FVxaODnC1/3z0oIKfI4cm1eII36MNl3mkZ1l4SkeT
        g6Ppx3YDBXImDUm1EpyKc/4=
X-Google-Smtp-Source: ABdhPJx0aIZyYD6BlXmuxU6f6tKbCf6KyweLQ2H5TyhZKSqwWeg7AiQAUhILSq3zvv/0ZfRNgIyGWw==
X-Received: by 2002:a63:4e63:: with SMTP id o35mr17696933pgl.291.1612806873213;
        Mon, 08 Feb 2021 09:54:33 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 123sm20433941pge.88.2021.02.08.09.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:54:32 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 3/8] mld: use mca_{get | put} instead of refcount_{dec | inc}
Date:   Mon,  8 Feb 2021 17:54:21 +0000
Message-Id: <20210208175421.5126-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mca_{get | put} are wrapper function of refcount_{dec | inc}.
And using only wrapper functions is more readable.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/mcast.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 9c4dc4c2ff01..45a983ed091e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -723,7 +723,7 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 
 	spin_lock_bh(&mc->mca_lock);
 	if (del_timer(&mc->mca_timer))
-		refcount_dec(&mc->mca_refcnt);
+		mca_put(mc);
 	spin_unlock_bh(&mc->mca_lock);
 }
 
@@ -1089,7 +1089,7 @@ static void igmp6_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 		return;
 
 	if (del_timer(&mc->mca_timer)) {
-		refcount_dec(&mc->mca_refcnt);
+		mca_put(mc);
 		delay = mc->mca_timer.expires - jiffies;
 	}
 
@@ -1098,7 +1098,7 @@ static void igmp6_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 
 	mc->mca_timer.expires = jiffies + delay;
 	if (!mod_timer(&mc->mca_timer, jiffies + delay))
-		refcount_inc(&mc->mca_refcnt);
+		mca_get(mc);
 	mc->mca_flags |= MAF_TIMER_RUNNING;
 }
 
@@ -1493,7 +1493,7 @@ int igmp6_event_report(struct sk_buff *skb)
 		if (ipv6_addr_equal(&mc->mca_addr, &mld->mld_mca)) {
 			spin_lock(&mc->mca_lock);
 			if (del_timer(&mc->mca_timer))
-				refcount_dec(&mc->mca_refcnt);
+				mca_put(mc);
 			mc->mca_flags &= ~(MAF_LAST_REPORTER | MAF_TIMER_RUNNING);
 			spin_unlock(&mc->mca_lock);
 			break;
@@ -2446,12 +2446,12 @@ static void igmp6_join_group(struct ifmcaddr6 *mc)
 
 	spin_lock_bh(&mc->mca_lock);
 	if (del_timer(&mc->mca_timer)) {
-		refcount_dec(&mc->mca_refcnt);
+		mca_put(mc);
 		delay = mc->mca_timer.expires - jiffies;
 	}
 
 	if (!mod_timer(&mc->mca_timer, jiffies + delay))
-		refcount_inc(&mc->mca_refcnt);
+		mca_get(mc);
 	mc->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
 	spin_unlock_bh(&mc->mca_lock);
 }
-- 
2.17.1

