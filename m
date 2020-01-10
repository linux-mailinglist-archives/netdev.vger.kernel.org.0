Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB9E1368EB
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgAJI0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:26:05 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:39312 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgAJI0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:26:04 -0500
Received: by mail-pf1-f176.google.com with SMTP id q10so773235pfs.6
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/MIGwsjD/KcHPQE9iFDm9NScPYyt5CTNfPeUOVRR0U=;
        b=MxPnV6GzhDKbENWsw35mbIAOGx8AZh7+IpdLXQ4jsZiih0lc3qO1HgW/I3d2Uhifzu
         qkWjmekO/fRiPNc0Hppf6NZv4TTpJbsKtW5gKvcIs2Vj+4Ris10asgpJQpi+wvD/RHRy
         dzE4/5N0T2a0GW0xlZmrpT+PFRXzVu7Vl8kAKJbEDwK2uUaA2zkhakXrV5uzBbpJmhl7
         th1NhtTFUZ9M9ah2ghzzZflglKxRCVn3Xm5JY95U88Q4cz55IL3NZDV7aBqWFAuHENpM
         6mAFrBhuYbs56G5o//5NqPSg4WZPx/qeeiBPCfyyNCtEamjKWhVnyYmcZ094mpOrL1AO
         pWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/MIGwsjD/KcHPQE9iFDm9NScPYyt5CTNfPeUOVRR0U=;
        b=tJwOKFTxPimYs9ZLxYeSrQmv+7R3iZQJN6vy2egaoU3JlQKhSaTkeUJkTdRUoVpL7v
         E80iA+nDtb14GjL+qGquuSfe8zY8Oisp8QcqaoCOLXXHQbQ4f4JCjqjVSlhyun5WF6WG
         BsHS1zL1TVF1vZZemCuQN0yeGEBRSeohgZaNDVwWHkZ9fi8PkDhvpTlocvbeIcP7BAR6
         MmmmmT+GcUh/7+Up9TrRsEtbzlRcCMfDeSBqbgekSlzILGgfL5kStWi9JnNpO650fzg6
         S/f/XUem0sGltzi+86szMUTqzXVu6NpK4LVraSErFK3Tu7bBBLPKqLHlaxAYcCGkouPh
         qdDQ==
X-Gm-Message-State: APjAAAWjAlYQZXO3hiCb8mxGID8KL+lhhesS5jZX3IUQKaAwZLcMPl+n
        7RYZ1aQl/GDdeNXA/RjR7pcka8s1j08=
X-Google-Smtp-Source: APXvYqywN5rmdwkIbvAAhZ35DQ9HhUNvHHIFXkr+ABbO/9/Zt9PKxZpPCUqLQzElj6IWOHgXqfIDWA==
X-Received: by 2002:a63:d66:: with SMTP id 38mr2831761pgn.233.1578644763837;
        Fri, 10 Jan 2020 00:26:03 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k23sm1533759pgg.7.2020.01.10.00.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:26:03 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] net/route: remove ip route rtm_src_len, rtm_dst_len valid check
Date:   Fri, 10 Jan 2020 16:24:56 +0800
Message-Id: <20200110082456.7288-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In patch set e266afa9c7af ("Merge branch
'net-use-strict-checks-in-doit-handlers'") we added a check for
rtm_src_len, rtm_dst_len, which will cause cmds like
"ip route get 192.0.2.0/24" failed.

There is no sense to restrict rtm_src_len, rtm_dst_len to 32 for IPv4,
or 128 for IPv6. Remove this check.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: d0440029831b ("net: ipv4: ipmr: perform strict checks also for doit handlers")
Fixes: a00302b60777 ("net: ipv4: route: perform strict checks also for doit handlers")
Fixes: 0eff0a274104 ("net: ipv6: route: perform strict checks also for doit handlers")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ipmr.c  | 10 +---------
 net/ipv4/route.c | 10 +---------
 net/ipv6/route.c | 10 +---------
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6e68def66822..293a0189ff4e 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2500,9 +2500,7 @@ static int ipmr_rtm_valid_getroute_req(struct sk_buff *skb,
 					      rtm_ipv4_policy, extack);
 
 	rtm = nlmsg_data(nlh);
-	if ((rtm->rtm_src_len && rtm->rtm_src_len != 32) ||
-	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 32) ||
-	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
+	if (rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
 	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
 		NL_SET_ERR_MSG(extack, "ipv4: Invalid values in header for multicast route get request");
 		return -EINVAL;
@@ -2513,12 +2511,6 @@ static int ipmr_rtm_valid_getroute_req(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
-	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
-		NL_SET_ERR_MSG(extack, "ipv4: rtm_src_len and rtm_dst_len must be 32 for IPv4");
-		return -EINVAL;
-	}
-
 	for (i = 0; i <= RTA_MAX; i++) {
 		if (!tb[i])
 			continue;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 87e979f2b74a..fb36780ee415 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3063,9 +3063,7 @@ static int inet_rtm_valid_getroute_req(struct sk_buff *skb,
 					      rtm_ipv4_policy, extack);
 
 	rtm = nlmsg_data(nlh);
-	if ((rtm->rtm_src_len && rtm->rtm_src_len != 32) ||
-	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 32) ||
-	    rtm->rtm_table || rtm->rtm_protocol ||
+	if (rtm->rtm_table || rtm->rtm_protocol ||
 	    rtm->rtm_scope || rtm->rtm_type) {
 		NL_SET_ERR_MSG(extack, "ipv4: Invalid values in header for route get request");
 		return -EINVAL;
@@ -3083,12 +3081,6 @@ static int inet_rtm_valid_getroute_req(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
-	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
-		NL_SET_ERR_MSG(extack, "ipv4: rtm_src_len and rtm_dst_len must be 32 for IPv4");
-		return -EINVAL;
-	}
-
 	for (i = 0; i <= RTA_MAX; i++) {
 		if (!tb[i])
 			continue;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index affb51c11a25..4e82d4fd1b53 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5714,9 +5714,7 @@ static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
 					      rtm_ipv6_policy, extack);
 
 	rtm = nlmsg_data(nlh);
-	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
-	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
-	    rtm->rtm_table || rtm->rtm_protocol || rtm->rtm_scope ||
+	if (rtm->rtm_table || rtm->rtm_protocol || rtm->rtm_scope ||
 	    rtm->rtm_type) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid values in header for get route request");
 		return -EINVAL;
@@ -5732,12 +5730,6 @@ static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
-	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
-		NL_SET_ERR_MSG_MOD(extack, "rtm_src_len and rtm_dst_len must be 128 for IPv6");
-		return -EINVAL;
-	}
-
 	for (i = 0; i <= RTA_MAX; i++) {
 		if (!tb[i])
 			continue;
-- 
2.19.2

