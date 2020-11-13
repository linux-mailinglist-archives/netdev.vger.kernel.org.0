Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2312B2B1E41
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgKMPIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMPIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:08:17 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B0BC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:08:17 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id g7so7866956pfc.2
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZFVWd/LOOt3S/uFBqVU9M39PkBZOlcIBTXV9AwJvqxw=;
        b=KV96KiM2K9korWXiIvG2dQHRMvanvp72V5299ncO1UqKLsmTQWc9l2KtsHnEpcboNj
         CaW0XtdtZaPnYrV5dpuHScga4/iu7q/9OtYbYkGDYoTbXX1KhJIYBrA2b/4WDrzuu02C
         sfFcocfpYlpTWp5kX0rDNRZZnug6GaFBAX/ZwMZL0IIhoxV0GyEmcqEY/wKoL/mqLjV4
         hNbxADPXmrowe/gsaNDA83jdBGryv4jeocXkmGz8R/wxU9+9YH20YiGnzXILbXcKQ8eI
         E8IDbkTVmQSemr2fIrYY6s8bldchle6fBYx2OcHHlnGMQgvJ9cUxtKjui69dDtuX/mMm
         +VdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZFVWd/LOOt3S/uFBqVU9M39PkBZOlcIBTXV9AwJvqxw=;
        b=olvqA45MWRXea95khjjP5bXFQSTCS+AczVMbk5RmLMBkbkxNS1IpzdvNYsMSWM9szL
         OvwI0jLfchyQ3eej7CcmVRq173psi3FBF8zRp5j7K7vbzHHsPJasPLXr5SdoFGXVh++d
         qa3KBosLFrMlBJ8rgaMOg1IqcUDtMjCoW1MrSZHTa7Ug0322aRPK5pF0Z6f6naFuBp5X
         ydp2SVPYR77eBfgq8jTfBbt8/nEHGAws2XJ/6HiEmAHj2yoT//6jkj38KNfjvg43Cmrs
         vfmHIP0H5sT33E6Qcpx5lvVnkhOWJUg5dRQ1ZWdppGbB4VeVVusRLP40SiU1Y/EXsu/1
         jwaQ==
X-Gm-Message-State: AOAM5321M1KYAl4J8YU936dbXIl0y5UmThfLECogj6OPf719lG35kWUl
        NCPsVMRvL9ct3B0euF21ZJc=
X-Google-Smtp-Source: ABdhPJy/FWua3tQMk8JAcoTWqb/h58IcJk+CX3B9r70oSNOERsJ4w9IzYPMQqBOf3nj7Ggtzy9jkrg==
X-Received: by 2002:a63:4648:: with SMTP id v8mr2471979pgk.248.1605280097237;
        Fri, 13 Nov 2020 07:08:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id k17sm12043834pji.50.2020.11.13.07.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 07:08:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] tcp: uninline tcp_stream_memory_free()
Date:   Fri, 13 Nov 2020 07:08:08 -0800
Message-Id: <20201113150809.3443527-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201113150809.3443527-1-eric.dumazet@gmail.com>
References: <20201113150809.3443527-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both IPv4 and IPv6 needs it via a function pointer.
Following patch will avoid the indirect call.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h   | 13 +------------
 net/ipv4/tcp_ipv4.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4aba0f069b05d68b2595ec9a3bf8da7786437fde..d643ee4e42495f0b28c87e79d6192c23f8cdba7f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1965,18 +1965,7 @@ static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 	return tp->notsent_lowat ?: net->ipv4.sysctl_tcp_notsent_lowat;
 }
 
-/* @wake is one when sk_stream_write_space() calls us.
- * This sends EPOLLOUT only if notsent_bytes is half the limit.
- * This mimics the strategy used in sock_def_write_space().
- */
-static inline bool tcp_stream_memory_free(const struct sock *sk, int wake)
-{
-	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 notsent_bytes = READ_ONCE(tp->write_seq) -
-			    READ_ONCE(tp->snd_nxt);
-
-	return (notsent_bytes << wake) < tcp_notsent_lowat(tp);
-}
+bool tcp_stream_memory_free(const struct sock *sk, int wake);
 
 #ifdef CONFIG_PROC_FS
 int tcp4_proc_init(void);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7352c097ae48f7df6caba1ae5b98dccfecd79d1a..c2d5132c523c8d4258e407c4cc5112840b07805e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2740,6 +2740,20 @@ void tcp4_proc_exit(void)
 }
 #endif /* CONFIG_PROC_FS */
 
+/* @wake is one when sk_stream_write_space() calls us.
+ * This sends EPOLLOUT only if notsent_bytes is half the limit.
+ * This mimics the strategy used in sock_def_write_space().
+ */
+bool tcp_stream_memory_free(const struct sock *sk, int wake)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	u32 notsent_bytes = READ_ONCE(tp->write_seq) -
+			    READ_ONCE(tp->snd_nxt);
+
+	return (notsent_bytes << wake) < tcp_notsent_lowat(tp);
+}
+EXPORT_SYMBOL(tcp_stream_memory_free);
+
 struct proto tcp_prot = {
 	.name			= "TCP",
 	.owner			= THIS_MODULE,
-- 
2.29.2.299.gdc1121823c-goog

