Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4347B182C3
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfEHXq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:46:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33694 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfEHXq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:46:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id m32so553243qtf.0
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 16:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8R7qoCpNwQyIeKoCGehs7ejfngcdB2SGO6wjOhxrXzc=;
        b=Jc/y/fZ1OEaBi4y4S2gzMd9aP32QA9pNeiwtRdJu5F1RPWknC0nEorj8u4NQFlRxEw
         sZxcGeSQXca68ScZoGtx8r8PfuqUg49YEqYtJ++j8580FQ20CbpeYqASuuBrZL1HFVOq
         1zmFIopiSHPgU+istbJHHqzjMaFYbSpkMLrPQV+ufqm8pvOiEwugP2ZQLPJQ/iEbHacf
         UQcwwotDWbAST3Fsts/TltEU86ngo0POfSF4vXYZ5/G79o/Z+0nfnrd/M1I8KSuY34Ja
         XiCjdy6JKx7nP989sAe2kcQCqXCqYj3nHVDH6QC6nyuBDABRoJk4yA1TqnXOWjxu2HOU
         oMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8R7qoCpNwQyIeKoCGehs7ejfngcdB2SGO6wjOhxrXzc=;
        b=UcCeL014tbLppV3KR1tYiS6WvCvJGlLnjCOvFclrvOgnc/N96lv8tBi/z0vK9apftV
         QMh/qrpBq59zXNVUvdzcSoFpNYLCZHP+QguAeQsN14Ni0tnrPMqAS8713JSqZPSwiVS4
         72fhHq2hY+y/5RQxip4YJA6tg2UnpR5Ed+unkzuaI1yHLgRAgJ1RdcNjtAPzOBG4h7wk
         WXP9/l4DmodtwkjmCuBYuf3fGd0F35o5kgJfb+iyyM46S2NeZhCyRleh8WkbUxCbH0zr
         H6EwANYX1qAlRgwst34C3nCeZyeqhucWyg3QtU0vISvIQu8+yK7I0eUhF6dsSth59uil
         Fatw==
X-Gm-Message-State: APjAAAVC+QTsCSgIx0V2e8a9PMkTzk/hgyy7noylYSss8yY0o46eRrvX
        6haFag4k57Ze4nO6mieI0E/xug==
X-Google-Smtp-Source: APXvYqzKHjhOeZns8tiGT1BtBiNvY20kBqWyshEogzniCBCG+yDxufKaicQ+xHN16+AWr8K2KgC+mg==
X-Received: by 2002:a0c:878e:: with SMTP id 14mr874313qvj.103.1557359187866;
        Wed, 08 May 2019 16:46:27 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n66sm242562qkc.36.2019.05.08.16.46.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 16:46:27 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     oss-drivers@netronome.com, netdev@vger.kernel.org,
        edumazet@google.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] net/tcp: use deferred jump label for TCP acked data hook
Date:   Wed,  8 May 2019 16:46:14 -0700
Message-Id: <20190508234614.7751-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User space can flip the clean_acked_data_enabled static branch
on and off with TLS offload when CONFIG_TLS_DEVICE is enabled.
jump_label.h suggests we use the delayed version in this case.

Deferred branches now also don't take the branch mutex on
decrement, so we avoid potential locking issues.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/tcp.h    |  2 +-
 net/ipv4/tcp_input.c | 16 +++++++++++-----
 net/tls/tls_device.c |  1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7cf1181630a3..985aa5db570c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2198,7 +2198,7 @@ extern struct static_key_false tcp_have_smc;
 void clean_acked_data_enable(struct inet_connection_sock *icsk,
 			     void (*cad)(struct sock *sk, u32 ack_seq));
 void clean_acked_data_disable(struct inet_connection_sock *icsk);
-
+void clean_acked_data_flush(void);
 #endif
 
 #endif	/* _TCP_H */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 077d9abdfcf5..20f6fac5882e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -77,7 +77,7 @@
 #include <asm/unaligned.h>
 #include <linux/errqueue.h>
 #include <trace/events/tcp.h>
-#include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 #include <net/busy_poll.h>
 
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
@@ -113,22 +113,28 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define REXMIT_NEW	2 /* FRTO-style transmit of unsent/new packets */
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
-static DEFINE_STATIC_KEY_FALSE(clean_acked_data_enabled);
+static DEFINE_STATIC_KEY_DEFERRED_FALSE(clean_acked_data_enabled, HZ);
 
 void clean_acked_data_enable(struct inet_connection_sock *icsk,
 			     void (*cad)(struct sock *sk, u32 ack_seq))
 {
 	icsk->icsk_clean_acked = cad;
-	static_branch_inc(&clean_acked_data_enabled);
+	static_branch_inc(&clean_acked_data_enabled.key);
 }
 EXPORT_SYMBOL_GPL(clean_acked_data_enable);
 
 void clean_acked_data_disable(struct inet_connection_sock *icsk)
 {
-	static_branch_dec(&clean_acked_data_enabled);
+	static_branch_slow_dec_deferred(&clean_acked_data_enabled);
 	icsk->icsk_clean_acked = NULL;
 }
 EXPORT_SYMBOL_GPL(clean_acked_data_disable);
+
+void clean_acked_data_flush(void)
+{
+	static_key_deferred_flush(&clean_acked_data_enabled);
+}
+EXPORT_SYMBOL_GPL(clean_acked_data_flush);
 #endif
 
 static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
@@ -3598,7 +3604,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		icsk->icsk_retransmits = 0;
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
-		if (static_branch_unlikely(&clean_acked_data_enabled))
+		if (static_branch_unlikely(&clean_acked_data_enabled.key))
 			if (icsk->icsk_clean_acked)
 				icsk->icsk_clean_acked(sk, ack);
 #endif
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 7b2f40fe339f..5325607b5886 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1038,4 +1038,5 @@ void __exit tls_device_cleanup(void)
 {
 	unregister_netdevice_notifier(&tls_dev_notifier);
 	flush_work(&tls_device_gc_work);
+	clean_acked_data_flush();
 }
-- 
2.21.0

