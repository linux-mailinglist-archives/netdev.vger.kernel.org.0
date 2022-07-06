Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C00569683
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbiGFXnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbiGFXn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:43:26 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1A42D1CE;
        Wed,  6 Jul 2022 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657151000; x=1688687000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dZbdEudaqSAgySwZHwP+NdzQ1K6SO28Of0fID5u9j00=;
  b=KTtPl9e4bcMRFAtKPE1G1QN73dGyXaLF+letTw+f2WKieCosw6YJW9qz
   b6Zt2yiiV/9FYNQ8GZ0a+a5AQDDNvfuP5My3Wlzeu6SrWsFPAfXTjofR7
   w5CKIgrmAOSY3vVayaEQX11vR8k9sRfRcKj+8997DZsT/r85yk4ni0SSW
   k=;
X-IronPort-AV: E=Sophos;i="5.92,251,1650931200"; 
   d="scan'208";a="218850523"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 06 Jul 2022 23:43:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 0E6E3C0881;
        Wed,  6 Jul 2022 23:43:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 23:43:05 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 23:43:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH v2 net 10/12] cipso: Fix data-races around sysctl.
Date:   Wed, 6 Jul 2022 16:40:01 -0700
Message-ID: <20220706234003.66760-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706234003.66760-1-kuniyu@amazon.com>
References: <20220706234003.66760-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading cipso sysctl variables, they can be changed concurrently.
So, we need to add READ_ONCE() to avoid data-races.

Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Paul Moore <paul@paul-moore.com>
---
 Documentation/networking/ip-sysctl.rst |  2 +-
 net/ipv4/cipso_ipv4.c                  | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 9f41961d11d5..0e58001f8580 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1085,7 +1085,7 @@ cipso_cache_enable - BOOLEAN
 cipso_cache_bucket_size - INTEGER
 	The CIPSO label cache consists of a fixed size hash table with each
 	hash bucket containing a number of cache entries.  This variable limits
-	the number of entries in each hash bucket; the larger the value the
+	the number of entries in each hash bucket; the larger the value is, the
 	more CIPSO label mappings that can be cached.  When the number of
 	entries in a given hash bucket reaches this limit adding new entries
 	causes the oldest entry in the bucket to be removed to make room.
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 62d5f99760aa..6cd3b6c559f0 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -239,7 +239,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 	struct cipso_v4_map_cache_entry *prev_entry = NULL;
 	u32 hash;
 
-	if (!cipso_v4_cache_enabled)
+	if (!READ_ONCE(cipso_v4_cache_enabled))
 		return -ENOENT;
 
 	hash = cipso_v4_map_cache_hash(key, key_len);
@@ -296,13 +296,14 @@ static int cipso_v4_cache_check(const unsigned char *key,
 int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 		       const struct netlbl_lsm_secattr *secattr)
 {
+	int bkt_size = READ_ONCE(cipso_v4_cache_bucketsize);
 	int ret_val = -EPERM;
 	u32 bkt;
 	struct cipso_v4_map_cache_entry *entry = NULL;
 	struct cipso_v4_map_cache_entry *old_entry = NULL;
 	u32 cipso_ptr_len;
 
-	if (!cipso_v4_cache_enabled || cipso_v4_cache_bucketsize <= 0)
+	if (!READ_ONCE(cipso_v4_cache_enabled) || bkt_size <= 0)
 		return 0;
 
 	cipso_ptr_len = cipso_ptr[1];
@@ -322,7 +323,7 @@ int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 
 	bkt = entry->hash & (CIPSO_V4_CACHE_BUCKETS - 1);
 	spin_lock_bh(&cipso_v4_cache[bkt].lock);
-	if (cipso_v4_cache[bkt].size < cipso_v4_cache_bucketsize) {
+	if (cipso_v4_cache[bkt].size < bkt_size) {
 		list_add(&entry->list, &cipso_v4_cache[bkt].list);
 		cipso_v4_cache[bkt].size += 1;
 	} else {
@@ -1199,7 +1200,8 @@ static int cipso_v4_gentag_rbm(const struct cipso_v4_doi *doi_def,
 		/* This will send packets using the "optimized" format when
 		 * possible as specified in  section 3.4.2.6 of the
 		 * CIPSO draft. */
-		if (cipso_v4_rbm_optfmt && ret_val > 0 && ret_val <= 10)
+		if (READ_ONCE(cipso_v4_rbm_optfmt) && ret_val > 0 &&
+		    ret_val <= 10)
 			tag_len = 14;
 		else
 			tag_len = 4 + ret_val;
@@ -1603,7 +1605,7 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
 			 * all the CIPSO validations here but it doesn't
 			 * really specify _exactly_ what we need to validate
 			 * ... so, just make it a sysctl tunable. */
-			if (cipso_v4_rbm_strictvalid) {
+			if (READ_ONCE(cipso_v4_rbm_strictvalid)) {
 				if (cipso_v4_map_lvl_valid(doi_def,
 							   tag[3]) < 0) {
 					err_offset = opt_iter + 3;
-- 
2.30.2

