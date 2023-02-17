Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4282B69B38B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBQUJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBQUJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:09:44 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7E21C5B3
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676664583; x=1708200583;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3UDTz3wXgiJ1DFdcnJvvRHlE7Ve6hKdgY2YfU5pQM7c=;
  b=qiBIl/h3KiZZVQoI65TTdGaiwfBu7/fY6llu6dve3bTa1EmdrHiHXfCk
   CXN4M2qqKH6qZds2g9bZGa4qfZpNhkjCBUpHwtZizwrMN8OlE5Lwg5/3D
   fAT2L8qp9ljIrz2OPwP2eMbls8y69idlMoSbsbr3bYs57jeFjiobbRLQi
   g=;
X-IronPort-AV: E=Sophos;i="5.97,306,1669075200"; 
   d="scan'208";a="294026080"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 20:09:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id 1E6F8821DB;
        Fri, 17 Feb 2023 20:09:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 17 Feb 2023 20:09:33 +0000
Received: from 88665a182662.ant.amazon.com (10.135.203.214) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Fri, 17 Feb 2023 20:09:30 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next] net/ulp: Remove redundant ->clone() test in inet_clone_ulp().
Date:   Fri, 17 Feb 2023 12:09:20 -0800
Message-ID: <20230217200920.85306-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.135.203.214]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2c02d41d71f9 ("net/ulp: prevent ULP without clone op from entering
the LISTEN status") guarantees that all ULP listeners have clone() op, so
we no longer need to test it in inet_clone_ulp().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/inet_connection_sock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eedcf4146d29..65ad4251f6fd 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1122,8 +1122,7 @@ static void inet_clone_ulp(const struct request_sock *req, struct sock *newsk,
 	if (!icsk->icsk_ulp_ops)
 		return;
 
-	if (icsk->icsk_ulp_ops->clone)
-		icsk->icsk_ulp_ops->clone(req, newsk, priority);
+	icsk->icsk_ulp_ops->clone(req, newsk, priority);
 }
 
 /**
-- 
2.30.2

