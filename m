Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B79934D632
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhC2RlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhC2Rky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 13:40:54 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C293C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 10:40:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h3so10315554pfr.12
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 10:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3J09YicP+rllSqz6vRUYD/u7JbB9ohoPmhpxpekykg=;
        b=fr4/i6q4YCwhamcnMuLP58ohzEY/MoUfiWxmH1BlajFOtfCWxOHdSZXhbQnAhQ3hQY
         nhDayNy2vROzSxkC+dCQMkN4aDf1lLdzzQylSIbj4NfwujWlliA5Tm6/AlLEp1JfOCX+
         023pxJYcsT9M4VDh6pcc56O/CgGcOnbLhS84iYFKymrWfaKP310L4n7PPWM6lFurd69e
         e+bTSSVUuyjJJFz3h7pmpYmnrmOGFWV8yRVCfydSn8SpeLmnQ0U9j2P33G+pvn8ci9dr
         AVjRp0NxHkbpOBjbVzDF+uaUTmeUC8gU6S0Rlxas1ryBoK/5pg6kQOsoHS6fDO8V5VWz
         FRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3J09YicP+rllSqz6vRUYD/u7JbB9ohoPmhpxpekykg=;
        b=hB1ehXhQKOtPRI5M+fPXssE1piIf+MH54ltRlmZAovmA/OMEKA9Aq9/s//6pSBnL7f
         Kfw2YBQ/sD/OwB9AyYuINCGJhnb5JUvGHWhYg77ixhuyj8dFneDWMKtHPg+sjMoUf2HX
         /oj7FhRQlYYv9at3f2IGnN2Yf+mKyIMA2M+6/R8hoGs1JaYzrEaVtEqFMDa2FcI9BJcs
         z1IJ9T3Vl18jKdKfKoEsgo4jLh2zNHi2lpyAfqjPWICxZDBfWqL5mVji/6Zpv74AXDLL
         VMYeKUPb2hAI6ypNRKT0GmNBVvyxdTos76LJAnTmIq7qGIi4Pd2psiuCNHCfphhvyBDZ
         dONw==
X-Gm-Message-State: AOAM532gP7h3Mxw7eOtG3LhQVZDpeoO1WucmCfZC1oa1DxzWRMrbUiTa
        EtyYCYeHpfJyV8zRTU7RkUM=
X-Google-Smtp-Source: ABdhPJyRZsKpKAnjwd+Jy0s4EglDmaG5XLZ0t6o0awf7mS8mW1REdSswOXPXleu2YODu1HmztLDqog==
X-Received: by 2002:a62:fc90:0:b029:213:be9a:7048 with SMTP id e138-20020a62fc900000b0290213be9a7048mr26463812pfh.4.1617039654034;
        Mon, 29 Mar 2021 10:40:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:78a0:7565:129d:828c])
        by smtp.gmail.com with ESMTPSA id c16sm17114304pfc.112.2021.03.29.10.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 10:40:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: fix tcp_min_tso_segs sysctl
Date:   Mon, 29 Mar 2021 10:40:49 -0700
Message-Id: <20210329174049.4085756-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_min_tso_segs is now stored in u8, so max value is 255.

255 limit is enforced by proc_dou8vec_minmax().

We can therefore remove the gso_max_segs variable.

Fixes: 47996b489bdc ("tcp: convert elligible sysctls to u8")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/sysctl_net_ipv4.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 442ff4be1bde236563b6cfea67179de4f30856bf..3a7e5cf5d6cc7e0ca911decac1b4bcf9d71b36c8 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -31,7 +31,6 @@
 static int two = 2;
 static int four = 4;
 static int thousand = 1000;
-static int gso_max_segs = GSO_MAX_SEGS;
 static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
@@ -1245,7 +1244,6 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ONE,
-		.extra2		= &gso_max_segs,
 	},
 	{
 		.procname	= "tcp_min_rtt_wlen",
-- 
2.31.0.291.g576ba9dcdaf-goog

