Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDA3505D6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhCaRxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhCaRw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00336C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:25 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v23so8296333ple.9
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q4TBqce8mY6AR+OZQk4qDXOtNAhlIQrUCVWXl872Sls=;
        b=gm0nOM7Yj+OvFRgkqor3Dm9ylksZJAggFbABomC0kw5GWEqytBNmSrSLWAYdBH8oSG
         +yIC/cBU6r8zNLkTR/W5llgoBjGdraEiz9zcfEyoiJaWWl++McEK/Dmj+KwdhEMHn01p
         zcdvieFkXMGHWRVD8bZd6qEq4BWHKDm2qU9dzi2LpqA1dVAswdzBrs5Pul14ifuikpgQ
         Ysea/KQSI78dOXr7+dgqMU1zDEHaJ3OOt0B44Vp0FXBsz7PW+dp044trLHB3SXlLWNIu
         HmgZbeWtO/zHM6R064vt79DiBpM0Wc8e8C5TJKXIz5+sFF6rpvlVibAj+bAU2Cy/g7xS
         xwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q4TBqce8mY6AR+OZQk4qDXOtNAhlIQrUCVWXl872Sls=;
        b=Jf43FoyCx72TVf1RUSKU79v5nwd2oGOK2oU5rRuQJN0hSZyC+Z79bk2ugIpLnPteEZ
         1Yksn2OytEiGibnnCP8XXtq7la9CFt7lUErnfE32w1MoOufqCGHQOAL3FBTmIeiztK4x
         ZPFySmhpyZadbxxL18sLjw7yb2+RLIDofBHdx03HswPawYZKb1GBnk/DqQN+p4+wpJEE
         Te5weEp8LvWsn6wD0uutqCFLkPp3EPfqKo/ERRSR4NYCooSwTnVhdTBPK7H/p+epclHh
         rgykGIupiwrLUmGElZhJXXOzc9DzjkknenjhMk1btgUv98h1PmTldiIjj1cIbl9nq1Rw
         s37w==
X-Gm-Message-State: AOAM531qTyGOEJbFpumQ+SU0Lz4mOsrufs+7CPMe/xJe43KE7ag5nPeh
        ULp2vqXAYh/xPdNm3ZKLFI+nbAWJJIw=
X-Google-Smtp-Source: ABdhPJzHAdNnjAbzmF708o83TpjQpA9AQUtbjAkH7Ft0v6t1ilvk6jlDcEyRHP9xNq7aj3sIgBmolQ==
X-Received: by 2002:a17:90a:ad87:: with SMTP id s7mr4735739pjq.20.1617213145596;
        Wed, 31 Mar 2021 10:52:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 6/9] ipv4: convert igmp_link_local_mcast_reports sysctl to u8
Date:   Wed, 31 Mar 2021 10:52:10 -0700
Message-Id: <20210331175213.691460-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This sysctl is a bool, can use less storage.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index eb6ca07d3b0f5a3e0e90eee3e3049c0a0cc31d3d..fafcedf643832d80ebbd3d1c7c0fd8ac0866b99a 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -197,9 +197,9 @@ struct netns_ipv4 {
 	u8 sysctl_udp_l3mdev_accept;
 #endif
 
+	u8 sysctl_igmp_llm_reports;
 	int sysctl_igmp_max_memberships;
 	int sysctl_igmp_max_msf;
-	int sysctl_igmp_llm_reports;
 	int sysctl_igmp_qrv;
 
 	struct ping_group_range ping_group_range;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ad75d6bb2df7f60afda5c4a4f6524885a8b982c2..fd2b35065bb21195f65b80d7a815221320f08eb3 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -848,9 +848,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "igmp_link_local_mcast_reports",
 		.data		= &init_net.ipv4.sysctl_igmp_llm_reports,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "igmp_max_memberships",
-- 
2.31.0.291.g576ba9dcdaf-goog

