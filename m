Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728615E831B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiIWUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiIWUNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:13:41 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC561231F1
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so581346wmb.0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=TTM1N0pozEi1ZwuAicctDY4Ebesq3/EO1cjWgF0hb64=;
        b=RnzT0Q7TkscYSlvFVdAWu8PBgXur9H2vUGnz8Z8reN9ce7c7suX8HKnrSCj6Bb03y/
         bxlyQ0/bFCAysCsKx27B50wlmQcAAEaXNiAzflLHpOwpze04Udn0s6Hofwl4k9Hh6rYh
         KScquBsR4QWyef1Es2n6h3J6Wtj3kZPm9q3exXzlcpTjEzJDzUwOZc38HGyNWiGV2d+f
         0ItrhKONnzr7l/SJN73nJRsGOKiwUgkU0+OpOiRPAnuuwMShb4g2kISB6tAA+rY5SFmQ
         2HVQzLv9odLxW0I66olfTy3RaKOoG7iV7JbAVURrhCPxdy8L/ptzX5i9ieVDSs3ZRguy
         OOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TTM1N0pozEi1ZwuAicctDY4Ebesq3/EO1cjWgF0hb64=;
        b=SwGpULsgKW8MuH/Mah2iduggiIX3naOkVY+XK31MiGVgq7DtzLydXc3woZoetMGUtp
         bCJJU8sItHQn0Qxyx5m9NXGgcmLtTOhsB8KfphiZIdPYF/N3jSWBK/dSfKLMm06kW/2u
         l1Z8oy069x7Ezm9wMIofk0loOFo4QpxQwW5IzMMw3rpC7kK/zZTslU0EZRdgXClvf7dc
         dqIVnq8VOSkbz0A70o7Zu8MHL1cI/XeVVD3AC4bL1ESFXUzFo/sNdC6rnLt42P5kHvZG
         TiNnMdvbGz9/TuFadmUGIMcDoj9/iLqxbeMc6vm2c0RknhhsUDPArbna8lKVC5CrqoTa
         pI1A==
X-Gm-Message-State: ACrzQf1+yDt2FOlGEVvGdXXC76eUdBZ9caW1G79lvAtoivm9guBitWRu
        4JGUMabIbn7daXnZ/5jMCods2w==
X-Google-Smtp-Source: AMsMyM6GvdFlL3++VPMASaJsWm9+q8XwptrBopQlHl6OWjuYgV6rbqyC6X4f8RLtdVko7boz/R7ETg==
X-Received: by 2002:a05:600c:444b:b0:3b4:fdbd:5965 with SMTP id v11-20020a05600c444b00b003b4fdbd5965mr7045273wmn.128.1663964017651;
        Fri, 23 Sep 2022 13:13:37 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:37 -0700 (PDT)
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
Subject: [PATCH v2 07/35] tcp: Add TCP-AO config and structures
Date:   Fri, 23 Sep 2022 21:12:51 +0100
Message-Id: <20220923201319.493208-8-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

