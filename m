Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D60257BBFA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiGTQwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGTQwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:52:19 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA5567CB4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658335939; x=1689871939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=edCjY/InqPkuG3zbN9ALe+3HNdUZR31XAW4n9HMDBI0=;
  b=oLIjJvBszmi2bWV7jDGeI2Aqf+Taib0ArPD1NtYiCXxCHug4hhKCrYkC
   MR6oDTOCjg1KGXzplXL4U90FFrUiDTYWbOkF8SSfTWnLj3YeHt58k6pB3
   N/IjjqvPDONpGGJHbD48ApvJ5IwuzVePhlGUum6J/b3f+9KUAuCEz0Hhq
   Y=;
X-IronPort-AV: E=Sophos;i="5.92,286,1650931200"; 
   d="scan'208";a="240384485"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 20 Jul 2022 16:52:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-41c1ef8b.us-east-1.amazon.com (Postfix) with ESMTPS id 9DC02160F6C;
        Wed, 20 Jul 2022 16:52:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 16:52:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 16:52:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Kevin Yang <yyd@google.com>
Subject: [PATCH v1 net 06/15] tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.
Date:   Wed, 20 Jul 2022 09:50:17 -0700
Message-ID: <20220720165026.59712-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720165026.59712-1-kuniyu@amazon.com>
References: <20220720165026.59712-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D10UWA004.ant.amazon.com (10.43.160.64) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_no_ssthresh_metrics_save, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 65e6d90168f3 ("net-tcp: Disable TCP ssthresh metrics cache by default")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Kevin(Yudong) Yang <yyd@google.com>
---
 net/ipv4/tcp_metrics.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 9dcc418a26f2..d58e672be31c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -385,7 +385,7 @@ void tcp_update_metrics(struct sock *sk)
 
 	if (tcp_in_initial_slowstart(tp)) {
 		/* Slow start still did not finish. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && (tcp_snd_cwnd(tp) >> 1) > val)
@@ -401,7 +401,7 @@ void tcp_update_metrics(struct sock *sk)
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
 		/* Cong. avoidance phase, cwnd is reliable. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
 				       max(tcp_snd_cwnd(tp) >> 1, tp->snd_ssthresh));
@@ -418,7 +418,7 @@ void tcp_update_metrics(struct sock *sk)
 			tcp_metric_set(tm, TCP_METRIC_CWND,
 				       (val + tp->snd_ssthresh) >> 1);
 		}
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && tp->snd_ssthresh > val)
@@ -463,7 +463,7 @@ void tcp_init_metrics(struct sock *sk)
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
 		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
 
-	val = net->ipv4.sysctl_tcp_no_ssthresh_metrics_save ?
+	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 	if (val) {
 		tp->snd_ssthresh = val;
-- 
2.30.2

