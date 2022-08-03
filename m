Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C725890AA
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiHCQlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbiHCQlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:41:02 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1B2419A4;
        Wed,  3 Aug 2022 09:41:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id m2so10131453pls.4;
        Wed, 03 Aug 2022 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=N/rPzwoWr6Zc1e93NbM+cbX9lSQe1RNnSYb8iWk3eWk=;
        b=o+lTMiKx0Gue014beeGYcDnSccRx/4eks7J9zz8ooHfZIW19tYPFiWli6M0osJiCiI
         ROkeUnxshUmapbBrs3AGRk+/ozAd1+AF67dioQUUt4G8V1Au78TRNHJPF5SijTJvFzK5
         hXmgbP3J9Pn+SITFtHeOr/tRCN2cPi4ThnDkYxEClw75snwkF/LshywKREvzR6UplvYg
         maos4sRG2i9ZIks1LWw59JYxNORrbpX2jbytDWZVGoTpqBtITyU1QGnGWfBIzDVqeYem
         HEOTL282X02PQ9xWhGXprLBgcK/peJdLGkk9rRPUG5YiQZALamg56hZlm+TzwzL7464P
         0s1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=N/rPzwoWr6Zc1e93NbM+cbX9lSQe1RNnSYb8iWk3eWk=;
        b=V7rUEEUA/FMz4uPyMfd8tOhqvU97QRpTI+2CEG5Us2dNEM4pAlEn19/KwGwXCmE/14
         e0PcpQoJgqsoGaY8NiUTfIReqtP9+Ku5EbyDJcNzm9dRu4f+F0W4Tj6VGGOPr2FzITih
         sQ6XywvkOVY9g18S4HCCidw8ybt+/XsG3Z9OA9k0YcJL+2iqwateKHu1wLyJUJYwnJdU
         oouhAwzt9JGhoTxGYg9O2jjH/AnXzgUpP4L68mexcY+tH/ixgSooPUWLOeLFOB2WeX4K
         l/QzHr9USPuIr0Ac2RdPowCqYslfFEYUI1vchpixJIkqcrFrb+2nxtvI1IAih2W9zrio
         wWfg==
X-Gm-Message-State: ACgBeo3UqErbLwhWTxFdoyX9jEnDhVT1Nypd9AiNAisPqNAGBFw35G1e
        HG4AcNuxP9lxNhyt6Y9HtgE=
X-Google-Smtp-Source: AA6agR6yHYlpMC/xBHbmBdKuLb0MbltplHd0GrmqtX2fRTO+b7RCl0vs4wtFkugwO1Bja2+SNLrFWQ==
X-Received: by 2002:a17:903:1ce:b0:16e:f510:6666 with SMTP id e14-20020a17090301ce00b0016ef5106666mr13165632plh.158.1659544860368;
        Wed, 03 Aug 2022 09:41:00 -0700 (PDT)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9-20020a170903230900b0016f057b88c9sm2259030plh.26.2022.08.03.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:40:59 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC net-next 5/6] net: Add flow counters and Tx processing error counter
Date:   Wed,  3 Aug 2022 09:40:44 -0700
Message-Id: <20220803164045.3585187-6-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803164045.3585187-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220803164045.3585187-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added flow counters. Total flow counter is accumulative, the current shows the
number of flows currently in flight, the error counters is accumulating the
number of errors during Tx processing.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
---
 include/net/netns/mib.h   |  3 +++
 include/net/quic.h        | 10 +++++++++
 include/net/snmp.h        |  6 +++++
 include/uapi/linux/snmp.h | 11 ++++++++++
 net/quic/Makefile         |  2 +-
 net/quic/quic_main.c      | 46 +++++++++++++++++++++++++++++++++++++++
 net/quic/quic_proc.c      | 45 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/quic_proc.c

diff --git a/include/net/netns/mib.h b/include/net/netns/mib.h
index 7e373664b1e7..dcbba3d1ceec 100644
--- a/include/net/netns/mib.h
+++ b/include/net/netns/mib.h
@@ -24,6 +24,9 @@ struct netns_mib {
 #if IS_ENABLED(CONFIG_TLS)
 	DEFINE_SNMP_STAT(struct linux_tls_mib, tls_statistics);
 #endif
+#if IS_ENABLED(CONFIG_QUIC)
+	DEFINE_SNMP_STAT(struct linux_quic_mib, quic_statistics);
+#endif
 #ifdef CONFIG_MPTCP
 	DEFINE_SNMP_STAT(struct mptcp_mib, mptcp_statistics);
 #endif
diff --git a/include/net/quic.h b/include/net/quic.h
index 15e04ea08c53..b6327f3b7632 100644
--- a/include/net/quic.h
+++ b/include/net/quic.h
@@ -25,6 +25,16 @@
 #define QUIC_MAX_PLAIN_PAGES		16
 #define QUIC_MAX_CIPHER_PAGES_ORDER	4
 
+#define __QUIC_INC_STATS(net, field)				\
+	__SNMP_INC_STATS((net)->mib.quic_statistics, field)
+#define QUIC_INC_STATS(net, field)				\
+	SNMP_INC_STATS((net)->mib.quic_statistics, field)
+#define QUIC_DEC_STATS(net, field)				\
+	SNMP_DEC_STATS((net)->mib.quic_statistics, field)
+
+int __net_init quic_proc_init(struct net *net);
+void __net_exit quic_proc_fini(struct net *net);
+
 struct quic_internal_crypto_context {
 	struct quic_connection_info	conn_info;
 	struct crypto_skcipher		*header_tfm;
diff --git a/include/net/snmp.h b/include/net/snmp.h
index 468a67836e2f..f94680a3e9e8 100644
--- a/include/net/snmp.h
+++ b/include/net/snmp.h
@@ -117,6 +117,12 @@ struct linux_tls_mib {
 	unsigned long	mibs[LINUX_MIB_TLSMAX];
 };
 
+/* Linux QUIC */
+#define LINUX_MIB_QUICMAX	__LINUX_MIB_QUICMAX
+struct linux_quic_mib {
+	unsigned long	mibs[LINUX_MIB_QUICMAX];
+};
+
 #define DEFINE_SNMP_STAT(type, name)	\
 	__typeof__(type) __percpu *name
 #define DEFINE_SNMP_STAT_ATOMIC(type, name)	\
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..708f62e28c9d 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -347,4 +347,15 @@ enum
 	__LINUX_MIB_TLSMAX
 };
 
+/* linux QUIC mib definitions */
+enum
+{
+	LINUX_MIB_QUICNUM = 0,
+	LINUX_MIB_QUICCURRTXSW,			/* QuicCurrTxSw */
+	LINUX_MIB_QUICTXSW,			/* QuicTxSw */
+	LINUX_MIB_QUICTXSWERROR,		/* QuicTxSwError */
+	__LINUX_MIB_QUICMAX
+};
+
+
 #endif	/* _LINUX_SNMP_H */
diff --git a/net/quic/Makefile b/net/quic/Makefile
index 928239c4d08c..a885cd8bc4e0 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_QUIC) += quic.o
 
-quic-y := quic_main.o
+quic-y := quic_main.o quic_proc.o
diff --git a/net/quic/quic_main.c b/net/quic/quic_main.c
index e738c8130a4f..eb0fdeabd3c4 100644
--- a/net/quic/quic_main.c
+++ b/net/quic/quic_main.c
@@ -362,6 +362,8 @@ static int do_quic_conn_add_tx(struct sock *sk, sockptr_t optval,
 	if (rc < 0)
 		goto err_free_ciphers;
 
+	QUIC_INC_STATS(sock_net(sk), LINUX_MIB_QUICCURRTXSW);
+	QUIC_INC_STATS(sock_net(sk), LINUX_MIB_QUICTXSW);
 	return 0;
 
 err_free_ciphers:
@@ -411,6 +413,7 @@ static int do_quic_conn_del_tx(struct sock *sk, sockptr_t optval,
 	crypto_free_aead(crypto_ctx->packet_aead);
 	memzero_explicit(crypto_ctx, sizeof(*crypto_ctx));
 	kfree(connhash);
+	QUIC_DEC_STATS(sock_net(sk), LINUX_MIB_QUICCURRTXSW);
 
 	return 0;
 }
@@ -436,6 +439,9 @@ static int do_quic_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		break;
 	}
 
+	if (rc)
+		QUIC_INC_STATS(sock_net(sk), LINUX_MIB_QUICTXSWERROR);
+
 	return rc;
 }
 
@@ -1242,6 +1248,9 @@ static int quic_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	quic_put_plain_user_pages(plain_pages, nr_plain_pages);
 
 out:
+	if (unlikely(ret < 0))
+		QUIC_INC_STATS(sock_net(sk), LINUX_MIB_QUICTXSWERROR);
+
 	return ret;
 }
 
@@ -1374,6 +1383,36 @@ static void quic_release(struct sock *sk)
 	release_sock(sk);
 }
 
+static int __net_init quic_init_net(struct net *net)
+{
+	int err;
+
+	net->mib.quic_statistics = alloc_percpu(struct linux_quic_mib);
+	if (!net->mib.quic_statistics)
+		return -ENOMEM;
+
+	err = quic_proc_init(net);
+	if (err)
+		goto err_free_stats;
+
+	return 0;
+
+err_free_stats:
+	free_percpu(net->mib.quic_statistics);
+	return err;
+}
+
+static void __net_exit quic_exit_net(struct net *net)
+{
+	quic_proc_fini(net);
+	free_percpu(net->mib.quic_statistics);
+}
+
+static struct pernet_operations quic_proc_ops = {
+	.init = quic_init_net,
+	.exit = quic_exit_net,
+};
+
 static struct udp_ulp_ops quic_ulp_ops __read_mostly = {
 	.name		= "quic-crypto",
 	.owner		= THIS_MODULE,
@@ -1383,6 +1422,12 @@ static struct udp_ulp_ops quic_ulp_ops __read_mostly = {
 
 static int __init quic_register(void)
 {
+	int err;
+
+	err = register_pernet_subsys(&quic_proc_ops);
+	if (err)
+		return err;
+
 	udp_register_ulp(&quic_ulp_ops);
 	return 0;
 }
@@ -1390,6 +1435,7 @@ static int __init quic_register(void)
 static void __exit quic_unregister(void)
 {
 	udp_unregister_ulp(&quic_ulp_ops);
+	unregister_pernet_subsys(&quic_proc_ops);
 }
 
 module_init(quic_register);
diff --git a/net/quic/quic_proc.c b/net/quic/quic_proc.c
new file mode 100644
index 000000000000..cb4fe7a589b5
--- /dev/null
+++ b/net/quic/quic_proc.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2019 Meta Platforms, Inc. */
+
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <net/snmp.h>
+#include <net/quic.h>
+
+#ifdef CONFIG_PROC_FS
+static const struct snmp_mib quic_mib_list[] = {
+	SNMP_MIB_ITEM("QuicCurrTxSw", LINUX_MIB_QUICCURRTXSW),
+	SNMP_MIB_ITEM("QuicTxSw", LINUX_MIB_QUICTXSW),
+	SNMP_MIB_ITEM("QuicTxSwError", LINUX_MIB_QUICTXSWERROR),
+	SNMP_MIB_SENTINEL
+};
+
+static int quic_statistics_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned long buf[LINUX_MIB_QUICMAX] = {};
+	struct net *net = seq->private;
+	int i;
+
+	snmp_get_cpu_field_batch(buf, quic_mib_list, net->mib.quic_statistics);
+	for (i = 0; quic_mib_list[i].name; i++)
+		seq_printf(seq, "%-32s\t%lu\n", quic_mib_list[i].name, buf[i]);
+
+	return 0;
+}
+#endif
+
+int __net_init quic_proc_init(struct net *net)
+{
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net_single("quic_stat", 0444, net->proc_net,
+				    quic_statistics_seq_show, NULL))
+		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
+
+	return 0;
+}
+
+void __net_exit quic_proc_fini(struct net *net)
+{
+	remove_proc_entry("quic_stat", net->proc_net);
+}
-- 
2.30.2

