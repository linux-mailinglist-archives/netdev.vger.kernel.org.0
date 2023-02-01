Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B676686D44
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjBARn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjBARnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:43:49 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0144EA5DC
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:43:47 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4fee82718afso207224787b3.5
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 09:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=as/KFYcbQVX5Tub93SFUNSqZVlakPNUtP2+hNalMTTI=;
        b=ezamLb8Kq9KRixxzGnuEbkqi4YYc89HytMSWSruneRstwNl3qfwxmaWh095UKdOOrf
         l0KizB58obbDCARU7YYwMcQ15vcjgFe/XeVd9nw16sDJjHkZI8VRm58CJ8Cxp8wU/hSi
         u+8yKeLKshghIQclkkxIWdQbHzQgPzxV5wPoj2U/0KAPPEz3wH2bYJhBus1DolCP8AbJ
         3GzqHXY9kgJ0RGdgIFr79yEzDQAW5I6PdreIhvMEry/oliifYIlBJYfOtUclFQ73f3Yh
         PiSfucawdLLT9bEd8WzDmlG/zn5EHCC5dLQuUVnd3dSHUFwDXdFpMJ/hcBqFTvNLa83R
         pSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=as/KFYcbQVX5Tub93SFUNSqZVlakPNUtP2+hNalMTTI=;
        b=gMUs69zTL3XgW/WR7O8FTm5HH7eDrAfi4M0ZMJtEtDCWfGYi11//NRvsuL2m+eiuvT
         Un1nBcQiNqjcQ5mErotnCwMbQMx/MqS8qxpeUO1SS/WBW1OwmxRlLTmwpJ/flaJw7SPF
         X+gXIlUwCf3ttRuhQnRIj/00OluDpQhNYRZbGbWIymechXOlzZs8+3A4rzjZo3f7cQrt
         /Y4o9HPX/KMOxQUROy7J+yJgNcuEj+pFKb+EPSJDJKDhipu6dmhY171zSddKn72Vqt7u
         Q+TOSNCEYRBaJWRUQsrn78grS3Vi9mi9cFDLl1Hm2dfziVjYAXzG7KIeXScr8oOaMJ12
         co7w==
X-Gm-Message-State: AO0yUKV4DBpfQV1mWlCZ31SOWoQHLLuVNZWjBfoIFgqO+VALNfOxEUX3
        H3FkbrXh++7h1vC0fFuplGwemtHawyvahw==
X-Google-Smtp-Source: AK7set97BH/cFR7JQRmiMp/ksiI40u10t9LSIH0eYK8cZ6D/eXP9rlpzAG6N4g/gKaWuohN5U+xN2JTWyRUdFg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:cfcb:0:b0:827:8002:1dba with SMTP id
 f194-20020a25cfcb000000b0082780021dbamr405812ybg.229.1675273427298; Wed, 01
 Feb 2023 09:43:47 -0800 (PST)
Date:   Wed,  1 Feb 2023 17:43:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201174345.2708943-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: add TCP_MINTTL drop reason
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the unlikely case incoming packets are dropped because
of IP_MINTTL / IPV6_MINHOPCOUNT contraints...

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h | 6 ++++++
 net/ipv4/tcp_ipv4.c      | 1 +
 net/ipv6/tcp_ipv6.c      | 3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 70539288f9958716f9164cac3435cce34bd21f51..94bc3d5d880305a8c968a1801dabef83d995c567 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -71,6 +71,7 @@
 	FN(DUP_FRAG)			\
 	FN(FRAG_REASM_TIMEOUT)		\
 	FN(FRAG_TOO_FAR)		\
+	FN(TCP_MINTTL)			\
 	FNe(MAX)
 
 /**
@@ -312,6 +313,11 @@ enum skb_drop_reason {
 	 * (/proc/sys/net/ipv4/ipfrag_max_dist)
 	 */
 	SKB_DROP_REASON_FRAG_TOO_FAR,
+	/**
+	 * @SKB_DROP_REASON_TCP_MINTTL: ipv4 ttl or ipv6 hoplimit below
+	 * the threshold (IP_MINTTL or IPV6_MINHOPCOUNT).
+	 */
+	SKB_DROP_REASON_TCP_MINTTL,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8320d0ecb13ae1e3e259f3c13a4c2797fbd984a5..ea370afa70ed979266dbeea474b034e833b15db4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2102,6 +2102,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		/* min_ttl can be changed concurrently from do_ip_setsockopt() */
 		if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
 			__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
+			drop_reason = SKB_DROP_REASON_TCP_MINTTL;
 			goto discard_and_relse;
 		}
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7e46c8f521d5cfef74be5ae9deee0..543ee216772080d61800436a3eb31fa8d43d16c0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1708,8 +1708,9 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 
 	if (static_branch_unlikely(&ip6_min_hopcount)) {
 		/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
-		if (hdr->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
+		if (unlikely(hdr->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount))) {
 			__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
+			drop_reason = SKB_DROP_REASON_TCP_MINTTL;
 			goto discard_and_relse;
 		}
 	}
-- 
2.39.1.456.gfc5497dd1b-goog

