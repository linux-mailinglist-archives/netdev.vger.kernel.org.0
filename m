Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653F35765DF
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiGORTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiGORTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:19:16 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EE8252A1
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657905554; x=1689441554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aD8uFS4p48k7H7Lb9Fcxivh87PcCKzGmmweY7dkmP6o=;
  b=shM5xMSFZFGX9t6oypZsBtM/4RdvMHpPdiTf9YbgRSkXiSLEpKeciCT6
   Al9wg4xS2LweYDGx7dZ0cEGnAGw6QYuMkoEr7M9ljK108db2VRrc6YWbt
   duTUBNgADdzQJI711p4aCwssn7IXagtQr41PzRrUqCuZOKmHX7+pB66ct
   Q=;
X-IronPort-AV: E=Sophos;i="5.92,274,1650931200"; 
   d="scan'208";a="218895607"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 15 Jul 2022 17:19:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-7d84505d.us-west-2.amazon.com (Postfix) with ESMTPS id 28E659A2F0;
        Fri, 15 Jul 2022 17:19:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 15 Jul 2022 17:18:58 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 15 Jul 2022 17:18:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 03/15] igmp: Fix data-races around sysctl_igmp_max_msf.
Date:   Fri, 15 Jul 2022 10:17:43 -0700
Message-ID: <20220715171755.38497-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
References: <20220715171755.38497-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.124]
X-ClientProxiedBy: EX13D31UWA003.ant.amazon.com (10.43.160.130) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_igmp_max_msf, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/igmp.c        | 2 +-
 net/ipv4/ip_sockglue.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 792ea1b56b9e..cd7839db34da 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2384,7 +2384,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 	}
 	/* else, add a new source to the filter */
 
-	if (psl && psl->sl_count >= net->ipv4.sysctl_igmp_max_msf) {
+	if (psl && psl->sl_count >= READ_ONCE(net->ipv4.sysctl_igmp_max_msf)) {
 		err = -ENOBUFS;
 		goto done;
 	}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index d497d525dea3..a8a323ecbb54 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -782,7 +782,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
 	if (gsf->gf_numsrc >= 0x1ffffff ||
-	    gsf->gf_numsrc > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+	    gsf->gf_numsrc > READ_ONCE(sock_net(sk)->ipv4.sysctl_igmp_max_msf))
 		goto out_free_gsf;
 
 	err = -EINVAL;
@@ -832,7 +832,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
-	if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+	if (n > READ_ONCE(sock_net(sk)->ipv4.sysctl_igmp_max_msf))
 		goto out_free_gsf;
 	err = set_mcast_msfilter(sk, gf32->gf_interface, n, gf32->gf_fmode,
 				 &gf32->gf_group, gf32->gf_slist_flex);
@@ -1244,7 +1244,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		}
 		/* numsrc >= (1G-4) overflow in 32 bits */
 		if (msf->imsf_numsrc >= 0x3ffffffcU ||
-		    msf->imsf_numsrc > net->ipv4.sysctl_igmp_max_msf) {
+		    msf->imsf_numsrc > READ_ONCE(net->ipv4.sysctl_igmp_max_msf)) {
 			kfree(msf);
 			err = -ENOBUFS;
 			break;
-- 
2.30.2

