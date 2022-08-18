Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B775989AA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345274AbiHRRBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345350AbiHRRAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:32 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DE2BFEAE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k9so2453202wri.0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=TTM1N0pozEi1ZwuAicctDY4Ebesq3/EO1cjWgF0hb64=;
        b=fOo3VI1g9BmPPgN7rpnPW1lV2d3KC1BwBi5fU8pOlu6RdoUYKuCo0aE+lbpHzCMnSl
         zuliEMyU7akY6nN8Qbgwu5pYNHu4/S1ka9vxrr866PUnfGe6iRAz//I7V2gi0Jo5q6tA
         Ewe4e4MQs+3XeGZZjnthnQI8/W3ckjY05miknqoVGod6S50gp2QZnY93XOjmfNRo83UP
         ueBK3mW0DuB74cU0fhC+9y6scMaVbnEB1W2Z6TFV2QUERh/i36VZkIHH5NKDyjyRgk4n
         0zsgbQZOPZ7woDCrclDYj6J2uOk64Nb+zBKx968J3azSNrgEgJyk8zvSGGjXIRF9ZKp8
         44ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=TTM1N0pozEi1ZwuAicctDY4Ebesq3/EO1cjWgF0hb64=;
        b=lJp7+7bjYXmdglHd2bjev2smnQXi0GjW1KEDL6u5mamNp3+a9FElePWpqFWlhIxUTz
         MRTVa3HT3ORkhE0kkdDEpaUZmNAnvZTrmpXZaav7cxdNGeSfdljVdbsT1uypPlkZ6MoD
         5KoLU/Q9Y6gINs6fgruj7sWbTQ2Al/1mNDPldSvonkmgtvPRM5GnP2sXpTC4j8BBIays
         PRSUDntgGSWKNozDEeWshVDq9JWlJddTzLCGjFEdK67i5TtdCp0x+ld+bfoX0bLT59lw
         kMYaMP59rQFKK7yOPmgsQ7o6FXDOt2/fmhPaYb9lMxE0cxc+FOIgSOwD2x1kKAOmsd2J
         a0dg==
X-Gm-Message-State: ACgBeo3isERXV0T9r2M3clylR6zF4O5D4giIpfkoa5jgtwmCPmfOy/ts
        QR7ge4B+i1PycpQ0llKMmSicmw==
X-Google-Smtp-Source: AA6agR4Bi9FWueEdfgfnGm3vffmOECSbA/4skiRs1lc76RzCakmLtMT7McffTq5GWOmP9g5CS6QkFA==
X-Received: by 2002:a05:6000:11c8:b0:225:3316:6957 with SMTP id i8-20020a05600011c800b0022533166957mr998191wrx.218.1660842023450;
        Thu, 18 Aug 2022 10:00:23 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:23 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 07/31] tcp: Add TCP-AO config and structures
Date:   Thu, 18 Aug 2022 17:59:41 +0100
Message-Id: <20220818170005.747015-8-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/tcp.h      |  3 ++
 include/net/tcp.h        |  8 +---
 include/net/tcp_ao.h     | 90 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tcp.h |  2 +
 net/ipv4/Kconfig         | 13 ++++++
 5 files changed, 110 insertions(+), 6 deletions(-)
 create mode 100644 include/net/tcp_ao.h

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22732c3..c8a8aaaf725b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -435,6 +435,9 @@ struct tcp_sock {
 /* TCP MD5 Signature Option information */
 	struct tcp_md5sig_info	__rcu *md5sig_info;
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info	__rcu *ao_info;
+#endif
 
 /* TCP fastopen related information */
 	struct tcp_fastopen_request *fastopen_req;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 75bb817928c1..b4b009094bf6 100644
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
@@ -1605,12 +1606,7 @@ static inline void tcp_clear_all_retrans_hints(struct tcp_sock *tp)
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
index 000000000000..39b3fc31e5a1
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
+	unsigned int		crypto_pool_id;
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
index 8fc09e8638b3..849bbf2d3c38 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -342,6 +342,8 @@ struct tcp_diag_md5sig {
 	__u8	tcpm_key[TCP_MD5SIG_MAXKEYLEN];
 };
 
+#define TCP_AO_MAXKEYLEN	80
+
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index c341864e4398..89bd0e9d97fe 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -731,6 +731,19 @@ config DEFAULT_TCP_CONG
 	default "bbr" if DEFAULT_BBR
 	default "cubic"
 
+config TCP_AO
+	bool "TCP: Authentication Option (rfc5925)"
+	select CRYPTO
+	select CRYPTO_POOL
+	select TCP_MD5SIG
+	depends on 64BIT # seq-number extension needs WRITE_ONCE(u64)
+	default y
+	help
+	  TCP-AO specifies the use of stronger Message Authentication Codes (MACs),
+	  protects against replays for long-lived TCP connections, and
+	  provides more details on the association of security with TCP
+	  connections than TCP MD5 (See RFC5925)
+
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO_POOL
-- 
2.37.2

