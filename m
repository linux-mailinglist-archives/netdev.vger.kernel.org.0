Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7210B1D2862
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 09:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgENHCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 03:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgENHCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 03:02:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EC0C061A0C;
        Thu, 14 May 2020 00:02:22 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s20so821693plp.6;
        Thu, 14 May 2020 00:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=exf19t930SX+cfRNGe3IOO9qF0esqQVEBJnT+ceqQ/8=;
        b=UiSjcqLv1eEZMcvmQdBlNM5ZyA8GwZxaoMw9FDpacqki9xA2V/XiBs03oWn0+JpTvr
         U2lS4lW8M7veY9L3habkuCeBuEk2nK3kwVsZ2K5f/NAIS7dErrdJg12dVvgXn4tX/Run
         s2j2m4+t1Rh54mWaYSuiNGIeC11p/VWoJMHkXVOvCT5haLvCbopVP8BhFhduvokHT8pS
         bTTJq2j8+5IE4NkpAd+8+g8dbxcTr02nwfVX4BhJb+cmJfx6lu3KcA74lvOAZuKO3pOh
         k5zmgkmUMvINjGYMgwgk5wI5U+0MLBBbXTz/B9oMoucy6h6nFOdB5VgIU6fF/vzGejOP
         qnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=exf19t930SX+cfRNGe3IOO9qF0esqQVEBJnT+ceqQ/8=;
        b=ZDqb0XzS+H7jHLGw8muXs7x5+MkmxDvBnVSGXW/ygtl4MASFJe6DImsbskANYw7n9V
         lGLENLlVq8cdQSvuLp0FLhO436pW/sy9xnodB+4QMXhbOU/STgKBQ35UzZkU95FbslX5
         NYyjhbUqxo51GPIKCX4cWsNTPvR0rBCmbxaUeKXy7igRKizPNZF+ZMKe8/2nsjXO+6I1
         rZ7yeoNet4FKk1B0jqdMPgZWg3WVW5HERmboA9wngoWywUR4zjLELgLH4CMZ44dwFT0C
         mH6paAEKy/d5Koy//rL+M0Bheqgm91VJeDwJQ12OY0EE9KvLmNjfTu4Sfsq+KKBs3jRI
         XDag==
X-Gm-Message-State: AOAM5325qP4kW7BVA3P0/xUxCAhVFPzmjBpXz2Qx31xa7+xyMr7hjZbw
        8nFt2k5hT2+Q6BlNVIZplg==
X-Google-Smtp-Source: ABdhPJxCYR2LmEz5QYdvaLfhTkPuGVvRQAIsEbKTvtGgBIEY6YC9lI6Y4UDTOB9L9yVvyTO172nIAQ==
X-Received: by 2002:a17:902:8c8f:: with SMTP id t15mr2735774plo.183.1589439741756;
        Thu, 14 May 2020 00:02:21 -0700 (PDT)
Received: from localhost.localdomain ([2409:4071:5b5:d53:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id i128sm1446807pfc.149.2020.05.14.00.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 00:02:20 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, frextrite@gmail.com, joel@joelfernandes.org,
        paulmck@kernel.org, cai@lca.pw,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH net] ipv6: Fix suspicious RCU usage warning in ip6mr
Date:   Thu, 14 May 2020 12:32:04 +0530
Message-Id: <20200514070204.3108-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

This patch fixes the following warning:

=============================
WARNING: suspicious RCU usage
5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
-----------------------------
net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!

ipmr_new_table() returns an existing table, but there is no table at
init. Therefore the condition: either holding rtnl or the list is empty
is used.

Fixes: d13fee049f ("Default enable RCU list lockdep debugging with .."): WARNING: suspicious RCU usage
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/ipv6/ip6mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 65a54d74acc1..fbe282bb8036 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -98,7 +98,7 @@ static void ipmr_expire_process(struct timer_list *t);
 #ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
 #define ip6mr_for_each_table(mrt, net) \
 	list_for_each_entry_rcu(mrt, &net->ipv6.mr6_tables, list, \
-				lockdep_rtnl_is_held())
+				lockdep_rtnl_is_held() ||  list_empty(&net->ipv6.mr6_tables))
 
 static struct mr_table *ip6mr_mr_table_iter(struct net *net,
 					    struct mr_table *mrt)
-- 
2.17.1

