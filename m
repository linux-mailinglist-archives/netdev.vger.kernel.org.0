Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B038E33B025
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhCOKlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhCOKlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 06:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615804883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eL9tEew2nB/94zgHqbxKyc5ffnMfEtirNBABqKcrRhE=;
        b=C+eYpTJAEUPCMOzWII47qusL9YmZWREJcTX8nQ56b5BYYapPXlVk9v5q7UL3FAu5fDqlPh
        uGjMeC0k9RnqXP05v/YbOy3IOueaIMJojsuHB3c7JtDstRb7lvZpHOKwPiCkA5tZL7uWo4
        ipzeWzKte/VTBi+KyUi3u14VJ3aoJeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-xD7qBpzJM-mIj0uloV1y8Q-1; Mon, 15 Mar 2021 06:41:22 -0400
X-MC-Unique: xD7qBpzJM-mIj0uloV1y8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E758DF8A4;
        Mon, 15 Mar 2021 10:41:20 +0000 (UTC)
Received: from computer-6.station (unknown [10.40.194.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28D755D736;
        Mon, 15 Mar 2021 10:41:18 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net] mptcp: fix ADD_ADDR HMAC in case port is specified
Date:   Mon, 15 Mar 2021 11:41:16 +0100
Message-Id: <5e8d22caae531185d0ec7407508250d9351f029a.1615798075.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, Linux computes the HMAC contained in ADD_ADDR sub-option using
the Address Id and the IP Address, and hardcodes a destination port equal
to zero. This is not ok for ADD_ADDR with port: ensure to account for the
endpoint port when computing the HMAC, in compliance with RFC8684 §3.4.1.

Fixes: 22fb85ffaefb ("mptcp: add port support for ADD_ADDR suboption writing")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/options.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 5fabf3e9a38d..2b7eec93c9f5 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -571,15 +571,15 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 }
 
 static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
-				  struct in_addr *addr)
+				  struct in_addr *addr, u16 port)
 {
 	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[7];
 
 	msg[0] = addr_id;
 	memcpy(&msg[1], &addr->s_addr, 4);
-	msg[5] = 0;
-	msg[6] = 0;
+	msg[5] = port >> 8;
+	msg[6] = port & 0xFF;
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 7, hmac);
 
@@ -588,15 +588,15 @@ static u64 add_addr_generate_hmac(u64 key1, u64 key2, u8 addr_id,
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 static u64 add_addr6_generate_hmac(u64 key1, u64 key2, u8 addr_id,
-				   struct in6_addr *addr)
+				   struct in6_addr *addr, u16 port)
 {
 	u8 hmac[SHA256_DIGEST_SIZE];
 	u8 msg[19];
 
 	msg[0] = addr_id;
 	memcpy(&msg[1], &addr->s6_addr, 16);
-	msg[17] = 0;
-	msg[18] = 0;
+	msg[17] = port >> 8;
+	msg[18] = port & 0xFF;
 
 	mptcp_crypto_hmac_sha(key1, key2, msg, 19, hmac);
 
@@ -650,7 +650,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 			opts->ahmac = add_addr_generate_hmac(msk->local_key,
 							     msk->remote_key,
 							     opts->addr_id,
-							     &opts->addr);
+							     &opts->addr,
+							     opts->port);
 		}
 	}
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -661,7 +662,8 @@ static bool mptcp_established_options_add_addr(struct sock *sk, struct sk_buff *
 			opts->ahmac = add_addr6_generate_hmac(msk->local_key,
 							      msk->remote_key,
 							      opts->addr_id,
-							      &opts->addr6);
+							      &opts->addr6,
+							      opts->port);
 		}
 	}
 #endif
@@ -971,12 +973,14 @@ static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 	if (mp_opt->family == MPTCP_ADDR_IPVERSION_4)
 		hmac = add_addr_generate_hmac(msk->remote_key,
 					      msk->local_key,
-					      mp_opt->addr_id, &mp_opt->addr);
+					      mp_opt->addr_id, &mp_opt->addr,
+					      mp_opt->port);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	else
 		hmac = add_addr6_generate_hmac(msk->remote_key,
 					       msk->local_key,
-					       mp_opt->addr_id, &mp_opt->addr6);
+					       mp_opt->addr_id, &mp_opt->addr6,
+					       mp_opt->port);
 #endif
 
 	pr_debug("msk=%p, ahmac=%llu, mp_opt->ahmac=%llu\n",
-- 
2.29.2

