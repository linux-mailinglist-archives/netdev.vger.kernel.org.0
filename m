Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3BECC66C
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbfJDXTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:19:50 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38394 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731461AbfJDXTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:19:49 -0400
Received: by mail-qk1-f193.google.com with SMTP id u186so7394531qkc.5
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 16:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CXfifb6bYDRxcf0uxkKHuRVZMD6qU6qHFLXrnM88Gns=;
        b=gHXh13QzhO+dM6vSktks9wt0ZzfveH91LsEAVgKVCkOvpEuhp80J7kth1kjz/0pasg
         xIaNaA9kQ3v7z8qb1aohmoNLhgBGb9QB4J0QPPykDS4dL2+MrE2vlMwWqbNoI/R1JwkR
         n24cqy0XU5Zuh7Ha1CO5dS0G/IA2dq/P2UGC1Fagtdk87qkIn30e5MBP5Dq6T9OgsG/X
         Qc3Q0O68H7DODmV1DN8MF0zPr7j55dCb9cH0/NWaNFot8yhZNTkrgqJOpPi+Jgvr89MD
         KCu3hDTjiXdfGP/t90mQu8/Rd7upvemvKg1+mJ/IFRqLfzNqKSo0bjO4ijSMR7FqD0OZ
         /k0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CXfifb6bYDRxcf0uxkKHuRVZMD6qU6qHFLXrnM88Gns=;
        b=MdQHuyNmNwL9RKFh2NG54DrA/POmO7xhTPatWTzhHjit28gi/skgg8fWLCWpwEW+t+
         VKw1dHpYY1X/9fLdOm6EI5X59A3B+LChqw9ptduYd099OEnXUHca1IdSzGDp5TSRaeMJ
         2t0iQGM/0V+4T0LnBdvafSBpFJ/l0pRfUwosCP27IsqLTHSZPczr6NU518PeilApSNKV
         aB0cGThqQGAmbOBJfTyWTbVIg12B0Y79fUnQVsevAtDQxM9UgQKu5wr2A/U9rUG+kdG7
         bjHK5fwZ9pvszwRn98c4IIGq028SOTFzQinHpdl4e7zXnYc6KL8hTVpQz4EDXzwE1/9X
         RM5A==
X-Gm-Message-State: APjAAAURAIFtxt+/2JMFqmmz4iia+W7M/ZnOndXrqs24RCC4miSRTZqQ
        U/Nm9jYucpbZ2NkVNfukvK61sdUxYnU=
X-Google-Smtp-Source: APXvYqx6uF2TD1p+oHWhIAmYR7yIHlvvxxLyfH+6occcurERM0vN8KkQVOLRntcoWz4HKUQCW+jraQ==
X-Received: by 2002:ae9:dd42:: with SMTP id r63mr12758067qkf.394.1570231188906;
        Fri, 04 Oct 2019 16:19:48 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z46sm4653398qth.62.2019.10.04.16.19.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 16:19:48 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 4/6] net/tls: add statistics for installed sessions
Date:   Fri,  4 Oct 2019 16:19:25 -0700
Message-Id: <20191004231927.21134-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191004231927.21134-1-jakub.kicinski@netronome.com>
References: <20191004231927.21134-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add SNMP stats for number of sockets with successfully
installed sessions.  Break them down to software and
hardware ones.  Note that if hardware offload fails
stack uses software implementation, and counts the
session appropriately.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/tls.rst | 14 ++++++++++++++
 include/uapi/linux/snmp.h        |  8 ++++++++
 net/tls/tls_main.c               | 23 +++++++++++++++++++----
 net/tls/tls_proc.c               |  8 ++++++++
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/tls.rst b/Documentation/networking/tls.rst
index a6ee595630ed..cfba587af5c9 100644
--- a/Documentation/networking/tls.rst
+++ b/Documentation/networking/tls.rst
@@ -219,3 +219,17 @@ Statistics
 
 TLS implementation exposes the following per-namespace statistics
 (``/proc/net/tls_stat``):
+
+- ``TlsCurrTxSw``, ``TlsCurrRxSw`` -
+  number of TX and RX sessions currently installed where host handles
+  cryptography
+
+- ``TlsCurrTxDevice``, ``TlsCurrRxDevice`` -
+  number of TX and RX sessions currently installed where NIC handles
+  cryptography
+
+- ``TlsTxSw``, ``TlsRxSw`` -
+  number of TX and RX sessions opened with host cryptography
+
+- ``TlsTxDevice``, ``TlsRxDevice`` -
+  number of TX and RX sessions opened with NIC cryptography
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 4abd57948ad4..1b4613b5af70 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -327,6 +327,14 @@ enum
 enum
 {
 	LINUX_MIB_TLSNUM = 0,
+	LINUX_MIB_TLSCURRTXSW,			/* TlsCurrTxSw */
+	LINUX_MIB_TLSCURRRXSW,			/* TlsCurrRxSw */
+	LINUX_MIB_TLSCURRTXDEVICE,		/* TlsCurrTxDevice */
+	LINUX_MIB_TLSCURRRXDEVICE,		/* TlsCurrRxDevice */
+	LINUX_MIB_TLSTXSW,			/* TlsTxSw */
+	LINUX_MIB_TLSRXSW,			/* TlsRxSw */
+	LINUX_MIB_TLSTXDEVICE,			/* TlsTxDevice */
+	LINUX_MIB_TLSRXDEVICE,			/* TlsRxDevice */
 	__LINUX_MIB_TLSMAX
 };
 
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 686eba0df590..f144b965704e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -286,14 +286,19 @@ static void tls_sk_proto_cleanup(struct sock *sk,
 		kfree(ctx->tx.rec_seq);
 		kfree(ctx->tx.iv);
 		tls_sw_release_resources_tx(sk);
+		TLS_DEC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXSW);
 	} else if (ctx->tx_conf == TLS_HW) {
 		tls_device_free_resources_tx(sk);
+		TLS_DEC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXDEVICE);
 	}
 
-	if (ctx->rx_conf == TLS_SW)
+	if (ctx->rx_conf == TLS_SW) {
 		tls_sw_release_resources_rx(sk);
-	else if (ctx->rx_conf == TLS_HW)
+		TLS_DEC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXSW);
+	} else if (ctx->rx_conf == TLS_HW) {
 		tls_device_offload_cleanup_rx(sk);
+		TLS_DEC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXDEVICE);
+	}
 }
 
 static void tls_sk_proto_close(struct sock *sk, long timeout)
@@ -534,19 +539,29 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 	if (tx) {
 		rc = tls_set_device_offload(sk, ctx);
 		conf = TLS_HW;
-		if (rc) {
+		if (!rc) {
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXDEVICE);
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXDEVICE);
+		} else {
 			rc = tls_set_sw_offload(sk, ctx, 1);
 			if (rc)
 				goto err_crypto_info;
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXSW);
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXSW);
 			conf = TLS_SW;
 		}
 	} else {
 		rc = tls_set_device_offload_rx(sk, ctx);
 		conf = TLS_HW;
-		if (rc) {
+		if (!rc) {
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICE);
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXDEVICE);
+		} else {
 			rc = tls_set_sw_offload(sk, ctx, 0);
 			if (rc)
 				goto err_crypto_info;
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXSW);
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRRXSW);
 			conf = TLS_SW;
 		}
 		tls_sw_strparser_arm(sk, ctx);
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 4ecc7c35d2f7..1b1f3783badc 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -7,6 +7,14 @@
 #include <net/tls.h>
 
 static const struct snmp_mib tls_mib_list[] = {
+	SNMP_MIB_ITEM("TlsCurrTxSw", LINUX_MIB_TLSCURRTXSW),
+	SNMP_MIB_ITEM("TlsCurrRxSw", LINUX_MIB_TLSCURRRXSW),
+	SNMP_MIB_ITEM("TlsCurrTxDevice", LINUX_MIB_TLSCURRTXDEVICE),
+	SNMP_MIB_ITEM("TlsCurrRxDevice", LINUX_MIB_TLSCURRRXDEVICE),
+	SNMP_MIB_ITEM("TlsTxSw", LINUX_MIB_TLSTXSW),
+	SNMP_MIB_ITEM("TlsRxSw", LINUX_MIB_TLSRXSW),
+	SNMP_MIB_ITEM("TlsTxDevice", LINUX_MIB_TLSTXDEVICE),
+	SNMP_MIB_ITEM("TlsRxDevice", LINUX_MIB_TLSRXDEVICE),
 	SNMP_MIB_SENTINEL
 };
 
-- 
2.21.0

