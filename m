Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305CE698361
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBOSeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBOSdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:33:55 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8BC3A862
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:48 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso2281658wmp.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9pks7/AIVF620Cp0OiOwRGXcuPgKxA3s+/9rsq6ezA=;
        b=BYwUZEH9SkgOKulUPV2icH/2v6TruPfxPoFvMNm4CtyUZdcyvWLLTK2ADMchVLgatB
         3tGFdRMceJi2GWFTOzIumlau/HdtmHjqOPmU9NHZY3kQK1lP/jBsE88pDzdz6bmh9dbx
         Bvw24VxIzKo8dK8hUHq6NsTP8CRmOSUxImjNaizeV4NeXWRKGJUqZEQDHMmREdfEs15o
         mI0WoqtqDQngRBWTfig1X1zh3Q5KiKYMDCp7n5oIOBMCRlphBwzGJXiyXrOK0FwZS6Jl
         v75cWDFUwlFMj/h1Wz9rlStwOXkCPcK0BOes1SnpygPhBIZ6VIJ1ESrRDjFekc1dFcmA
         dllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9pks7/AIVF620Cp0OiOwRGXcuPgKxA3s+/9rsq6ezA=;
        b=LHdYYmP75OzwE0KPzLD/hd4CZwEkCApnmbxdKuEVEQMAeE2XgR15S4eBGNh4akPZEI
         ZrhhEJwpmJ4lxkQ7PUHRTcyUbWaNXRECpzbd8+AqfNWi6H1jKnXv6w3XOZdfKh6WfUN7
         swekb10NdFntjKBGOCMYlQ/czIIHwEfqFpTVJXmrIhhuuLE907XLdYWr7d9Hh+Az3y4f
         Ce4o0JHY8iygWq6u2Fk1Jrjeza2sPiKXAwaWdZSTjBBJ058+vfbuXlSfrRjrUbzdsuhX
         Tg1WKz405PKX6Zt9kFXS0RYePeGLAUWuiGVWKKEUMuQT2hBHe3I3KwFu84yk9L3+7JHO
         KqdA==
X-Gm-Message-State: AO0yUKUXyfQE3Ldfta3yZ7BzU2Okqs6ktAaCVaItVYu+BLXjl71qAeaa
        x7yUzfOaP52TLPYZA8RrQBr6Hw==
X-Google-Smtp-Source: AK7set+GOMPZuE9rYYHkw5Tb9XLVrFCAJmby8fKm8q6SC8EYUxqD9eBq1JGsnAr237bg+RQFAGSiXg==
X-Received: by 2002:a05:600c:444b:b0:3dd:1c46:b92 with SMTP id v11-20020a05600c444b00b003dd1c460b92mr2871329wmn.16.1676486027071;
        Wed, 15 Feb 2023 10:33:47 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:33:46 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v4 02/21] tcp: Add TCP-AO config and structures
Date:   Wed, 15 Feb 2023 18:33:16 +0000
Message-Id: <20230215183335.800122-3-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new kernel config option and common structures as well as
helpers to be used by TCP-AO code.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/tcp.h      |  9 +++-
 include/net/tcp.h        |  8 +---
 include/net/tcp_ao.h     | 90 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tcp.h |  2 +
 net/ipv4/Kconfig         | 13 ++++++
 5 files changed, 114 insertions(+), 8 deletions(-)
 create mode 100644 include/net/tcp_ao.h

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index ca7f05a130d2..ac742427bb39 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -435,13 +435,18 @@ struct tcp_sock {
 	bool	syn_smc;	/* SYN includes SMC */
 #endif
 
-#ifdef CONFIG_TCP_MD5SIG
-/* TCP AF-Specific parts; only used by MD5 Signature support so far */
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+/* TCP AF-Specific parts; only used by TCP-AO/MD5 Signature support so far */
 	const struct tcp_sock_af_ops	*af_specific;
 
+#ifdef CONFIG_TCP_MD5SIG
 /* TCP MD5 Signature Option information */
 	struct tcp_md5sig_info	__rcu *md5sig_info;
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info	__rcu *ao_info;
+#endif
+#endif
 
 /* TCP fastopen related information */
 	struct tcp_fastopen_request *fastopen_req;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e77080003800..2d9ca039edc7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -37,6 +37,7 @@
 #include <net/snmp.h>
 #include <net/ip.h>
 #include <net/tcp_states.h>
+#include <net/tcp_ao.h>
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
@@ -1615,12 +1616,7 @@ static inline void tcp_clear_all_retrans_hints(struct tcp_sock *tp)
 	tp->retransmit_skb_hint = NULL;
 }
 
-union tcp_md5_addr {
-	struct in_addr  a4;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct in6_addr	a6;
-#endif
-};
+#define tcp_md5_addr tcp_ao_addr
 
 /* - key database */
 struct tcp_md5sig_key {
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
new file mode 100644
index 000000000000..27d8b4abef22
--- /dev/null
+++ b/include/net/tcp_ao.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _TCP_AO_H
+#define _TCP_AO_H
+
+#define TCP_AO_MAX_HASH_SIZE	64
+#define TCP_AO_KEY_ALIGN	1
+#define __tcp_ao_key_align __aligned(TCP_AO_KEY_ALIGN)
+
+union tcp_ao_addr {
+	struct in_addr  a4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr	a6;
+#endif
+};
+
+struct tcp_ao_hdr {
+	u8	kind;
+	u8	length;
+	u8	keyid;
+	u8	rnext_keyid;
+};
+
+struct tcp_ao_key {
+	struct hlist_node	node;
+	union tcp_ao_addr	addr;
+	u8			key[TCP_AO_MAXKEYLEN] __tcp_ao_key_align;
+	unsigned int		tcp_sigpool_id;
+	u16			port;
+	u8			prefixlen;
+	u8			family;
+	u8			keylen;
+	u8			keyflags;
+	u8			sndid;
+	u8			rcvid;
+	u8			maclen;
+	u8			digest_size;
+	struct rcu_head		rcu;
+	u8			traffic_keys[];
+};
+
+static inline u8 *rcv_other_key(struct tcp_ao_key *key)
+{
+	return key->traffic_keys;
+}
+
+static inline u8 *snd_other_key(struct tcp_ao_key *key)
+{
+	return key->traffic_keys + key->digest_size;
+}
+
+static inline int tcp_ao_maclen(const struct tcp_ao_key *key)
+{
+	return key->maclen;
+}
+
+static inline int tcp_ao_sizeof_key(const struct tcp_ao_key *key)
+{
+	return sizeof(struct tcp_ao_key) + (TCP_AO_MAX_HASH_SIZE << 1);
+}
+
+static inline int tcp_ao_len(const struct tcp_ao_key *key)
+{
+	return tcp_ao_maclen(key) + sizeof(struct tcp_ao_hdr);
+}
+
+static inline unsigned int tcp_ao_digest_size(struct tcp_ao_key *key)
+{
+	return key->digest_size;
+}
+
+struct tcp_ao_info {
+	struct hlist_head	head;
+	struct rcu_head		rcu;
+	/* current_key and rnext_key aren't maintained on listen sockets.
+	 * Their purpose is to cache keys on established connections,
+	 * saving needless lookups. Never dereference any of them from
+	 * listen sockets.
+	 */
+	struct tcp_ao_key	*volatile current_key;
+	struct tcp_ao_key	*rnext_key;
+	u8			ao_flags;
+	__be32			lisn;
+	__be32			risn;
+	u32			snd_sne;
+	u32			snd_sne_seq;
+	u32			rcv_sne;
+	u32			rcv_sne_seq;
+};
+
+#endif /* _TCP_AO_H */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 879eeb0a084b..5655bfe28b8d 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -348,6 +348,8 @@ struct tcp_diag_md5sig {
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+#define TCP_AO_MAXKEYLEN	80
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 89e2ab023272..2bcda91462c8 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -744,6 +744,19 @@ config DEFAULT_TCP_CONG
 config TCP_SIGPOOL
 	tristate
 
+config TCP_AO
+	bool "TCP: Authentication Option (RFC5925)"
+	select CRYPTO
+	select TCP_SIGPOOL
+	depends on 64BIT # seq-number extension needs WRITE_ONCE(u64)
+	help
+	  TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
+	  protects against replays for long-lived TCP connections, and
+	  provides more details on the association of security with TCP
+	  connections than TCP MD5 (See RFC5925)
+
+	  If unsure, say N.
+
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO
-- 
2.39.1

