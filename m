Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829F3570EE0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiGLAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiGLAUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:20:24 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992359FDD;
        Mon, 11 Jul 2022 17:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585172; x=1689121172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BOTxwiHCCh1rQfYT4NGOUHqaICGEEVt97Tp5vc03HcI=;
  b=ea0OtVySj0tVHOaYoqAcxUTrkokA3S9pWfmaVXlaCE/2czAQE/wJoWDk
   2x5HEGQn0ScQyPNq4lVBrB0F02ECFRU+9tFDn5IZy0z1GKs6mVm/8DrEc
   HmRgOuonQA9V9mlkSgD9MkvgrXgTkGyljh8F9MhmcMyX9gHQN28TtkbKg
   E=;
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 12 Jul 2022 00:19:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id D5BCC4C003F;
        Tue, 12 Jul 2022 00:19:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:19:28 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:19:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Manning <mmanning@vyatta.att-mail.com>
Subject: [PATCH v1 net 11/15] raw: Fix a data-race around sysctl_raw_l3mdev_accept.
Date:   Mon, 11 Jul 2022 17:15:29 -0700
Message-ID: <20220712001533.89927-12-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712001533.89927-1-kuniyu@amazon.com>
References: <20220712001533.89927-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.185]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_raw_l3mdev_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 6897445fb194 ("net: provide a sysctl raw_l3mdev_accept for raw socket lookup with VRFs")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Mike Manning <mmanning@vyatta.att-mail.com>
---
 include/net/raw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 8ad8df594853..c51a635671a7 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -75,7 +75,7 @@ static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_raw_l3mdev_accept,
+	return inet_bound_dev_eq(READ_ONCE(net->ipv4.sysctl_raw_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
-- 
2.30.2

