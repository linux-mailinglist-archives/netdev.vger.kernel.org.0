Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84D7610361
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbiJ0Uvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbiJ0UvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:51:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E5750FB9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l14-20020a05600c1d0e00b003c6ecc94285so4501937wms.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8i/gl7wAgw3adUScG+83KXrsRY+kJ2aoxLCf0MMJXM=;
        b=Xam3LaxAeiTB1zvHvzhans3VEgoaEcognLyeZZUJYqWSgbnPd4ExdVXjvAkwyBz5yO
         rKmW9Pc/0jQhqIgfdQ9QuHfCm6yS2P197cjG5MVsQBBO1zm33UJaDK6dXIjLTkLQM4Ua
         vL1e8IKfw8SifzkEmV7KRqmlUlgTyuid1Qhr1+VqPSxEneC+RxBXQCwfQkkdHVRhvtGf
         1DdpxtuWTMIxgYX1iWIJ8NFBfgRrXRY+HV5l37c5Ee6OVROsuXO85rrGx8O+W4sCiqbi
         euGSH+iww3mHEPmyubwlrq827rfLlWpeZU8Ro/yFuqGcgx4X9xwkwxpdXaOlE9NDHPAI
         hjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8i/gl7wAgw3adUScG+83KXrsRY+kJ2aoxLCf0MMJXM=;
        b=kK5pOT+jdxcfVPYQnhQaMcJkeQmdU+OngpN4kUMTuyMvEaDS1vG8IzCmZS9NBp7wix
         iLMzxP97fWNvuIzFqmwaNURt4MUXKnJR3RwOdf54o8c4cc6hLsRp3+TLAKwSm3g8HURm
         Tqnr0J16e6f04kvBlJXtHmTbTi4FzTGISlOsAzG/VJG+4wtxbBPpk5Thv4t7QW1dLAeF
         9By6HKg+TVRqCDjqOTsAYXsi1XmNk9jaC4XpQFSFKSmJttQDwao+66hfZ1xjYe3CTSOe
         WbZS1x2xTDAFtQyKchjY7IlgJwZ3uOeRjTomq755MDwu2V0V6SoMfrHDhKCYbiB1yBP1
         v3wQ==
X-Gm-Message-State: ACrzQf1UirQF3nkLItGZu+isPEOr6KFESpD/3FVSNI1z/CetuLcAn9aD
        n43jmqOd5BCl/iGn05LIusVi/A==
X-Google-Smtp-Source: AMsMyM4YHmm8g7cbjtPxeWmHmHYTUdfHDi0MtcWyV5hSvf3PxdBYYnCOxEEF8w5Pkder3UfJUWGXAA==
X-Received: by 2002:a7b:cbce:0:b0:3c6:fb29:6084 with SMTP id n14-20020a7bcbce000000b003c6fb296084mr7290569wmi.131.1666903471567;
        Thu, 27 Oct 2022 13:44:31 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:31 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 24/36] net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)
Date:   Thu, 27 Oct 2022 21:43:35 +0100
Message-Id: <20221027204347.529913-25-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete becomes very, very fast - almost free, but after setsockopt()
syscall returns, the key is still alive until next RCU grace period.
Which is fine for listen sockets as userspace needs to be aware of
setsockopt(TCP_AO) and accept() race and resolve it with verification
by getsockopt() after TCP connection was accepted.

The benchmark results (on non-loaded box, worse with more RCU work pending):
> ok 33    Worst case delete    16384 keys: min=5ms max=10ms mean=6.93904ms stddev=0.263421
> ok 34        Add a new key    16384 keys: min=1ms max=4ms mean=2.17751ms stddev=0.147564
> ok 35 Remove random-search    16384 keys: min=5ms max=10ms mean=6.50243ms stddev=0.254999
> ok 36         Remove async    16384 keys: min=0ms max=0ms mean=0.0296107ms stddev=0.0172078

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/uapi/linux/tcp.h |  3 +++
 net/ipv4/tcp_ao.c        | 17 ++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 453187d21da8..42850ae6e99d 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -353,6 +353,9 @@ struct tcp_diag_md5sig {
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
 #define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
+#define TCP_AO_CMDF_DEL_ASYNC	(1 << 3)	/* Asynchronious delete, valid
+						 * only for listen sockets
+						 */
 
 #define TCP_AO_GET_CURR		TCP_AO_CMDF_CURR
 #define TCP_AO_GET_NEXT		TCP_AO_CMDF_NEXT
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index a29c5bb8586b..46df1d455889 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1503,7 +1503,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_DEL_ASYNC)
 #define TCP_AO_GETF_VALID						\
 	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
 
@@ -1629,11 +1629,26 @@ static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_key *key,
 
 	hlist_del_rcu(&key->node);
 
+	/* Support for async delete on listening sockets: as they don't
+	 * need current_key/rnext_key maintaining, we don't need to check
+	 * them and we can just free all resources in RCU fashion.
+	 */
+	if (cmd->tcpa_flags & TCP_AO_CMDF_DEL_ASYNC) {
+		if (sk->sk_state != TCP_LISTEN)
+			return -EINVAL;
+		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+		return 0;
+	}
+
 	/* At this moment another CPU could have looked this key up
 	 * while it was unlinked from the list. Wait for RCU grace period,
 	 * after which the key is off-list and can't be looked up again;
 	 * the rx path [just before RCU came] might have used it and set it
 	 * as current_key (very unlikely).
+	 * Free the key with next RCU grace period (in case it was
+	 * current_key before tcp_ao_current_rnext() might have
+	 * changed it in forced-delete).
 	 */
 	synchronize_rcu();
 	err = tcp_ao_current_rnext(sk, cmd->tcpa_flags,
-- 
2.38.1

