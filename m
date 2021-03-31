Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BA73505D1
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhCaRwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbhCaRwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4ADC061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y2so8291330plg.5
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8UO2Ozxm1SXKOD6S8TvYVA153uE4XwXKbER1KSQTCbM=;
        b=r6rBG+8YeWAzuMBEQDW9nxNelToIFlTtA8smGIROx9TXxCOu3qTcEjjMMY3x8nbhVu
         rhHbqsvozpQD59H3agUAozaHg+1vVKCuR1Ls8hSmAH/AcslKtyfrXsZ/KuZ9uqLqDTc1
         b2RJmToADVg4ybtLcZp6mWq1amwymG1CXYCDgCAOqDSPtQzaMpLqN9PPYmyfXakROWcC
         7lLdZS9PZQjgznDTNM49wSqdR3wnD1IyC/kiSKN+49c+PVizVtq23TxwwGyR4YkqLFV3
         UFNbW3OqMwtc8LpZN3kdg+Yk5mNjsO2XnomXJ9l/dq5S/3t0PooSedoA71VxmBtpUWGh
         lnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8UO2Ozxm1SXKOD6S8TvYVA153uE4XwXKbER1KSQTCbM=;
        b=WMDDgfFhzfE3eRXzMNMDb1dwcxrQSy9syrJ0/RMCajeRoAxAAmUZx4xLQXgl5qpozB
         lSb7jxsLuUqarOBfv1mwvntvuN/SQKAn0Wu/1MH8J3AWciovlZXXgqRrzTTORL10ZWL7
         Qcw2QFpk9IZNtIuLSuytxf+lRhF+Uq0ASuGLQ4I2fkLcTntvIHKYXuGsjo2ltEqTstvz
         LrUD8VrX4MFAn9XIIjQQzP0oFLvDSo7AizkFQgCP+ri7wSCnsEbsRi3zK973cQsoSQMb
         8EdSACEOrJeVoK/32xh8QeA1X/f/675hYJ+6JmQPHOPeS9QK7FHrRKR1v0Mz8TCF8H13
         S6Lg==
X-Gm-Message-State: AOAM5330vFBe2sRhYod3pqa2GJSE/iY4QeKtGKcrxm1BkXqyWZkqzxio
        2a7YMOWdWg7aEONKlMAQqUA=
X-Google-Smtp-Source: ABdhPJxptNEjIbqvQ71NnFYMm0lMLU5fBIXc7Xue+KhYkeO1Dq5l7tNrOQDf4Hm/EtcW9vIb+F3vhA==
X-Received: by 2002:a17:90a:bd09:: with SMTP id y9mr4501105pjr.179.1617213140074;
        Wed, 31 Mar 2021 10:52:20 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/9] inet: shrink netns_ipv4 by another cache line
Date:   Wed, 31 Mar 2021 10:52:06 -0700
Message-Id: <20210331175213.691460-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

By shuffling around some fields to remove 8 bytes of hole,
we can save one cache line.

pahole result before/after the patch :

/* size: 768, cachelines: 12, members: 139 */
/* sum members: 673, holes: 11, sum holes: 39 */
/* padding: 56 */
/* paddings: 2, sum paddings: 7 */
/* forced alignments: 1 */

->

/* size: 704, cachelines: 11, members: 139 */
/* sum members: 673, holes: 10, sum holes: 31 */
/* paddings: 2, sum paddings: 7 */
/* forced alignments: 1 */

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 1085ed4e0788d7cd432dfc7e5604ef3cd66dc337..538ed69919dc4d51acfd43c7d6d1fca611fcb003 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -57,17 +57,17 @@ struct netns_ipv4 {
 	struct mutex		ra_mutex;
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	struct fib_rules_ops	*rules_ops;
-	bool			fib_has_custom_rules;
-	unsigned int		fib_rules_require_fldissect;
 	struct fib_table __rcu	*fib_main;
 	struct fib_table __rcu	*fib_default;
+	unsigned int		fib_rules_require_fldissect;
+	bool			fib_has_custom_rules;
 #endif
 	bool			fib_has_custom_local_routes;
+	bool			fib_offload_disabled;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	int			fib_num_tclassid_users;
 #endif
 	struct hlist_head	*fib_table_hash;
-	bool			fib_offload_disabled;
 	struct sock		*fibnl;
 
 	struct sock  * __percpu	*icmp_sk;
-- 
2.31.0.291.g576ba9dcdaf-goog

