Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E13188B8B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgCQREz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:04:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38049 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCQREz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:04:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id t13so73236wmi.3
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 10:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g/lflDQ38qP2yrrUSeMTfBCWFbUPaWfHaTE5vNmEMN4=;
        b=aNSA4UTP+Gym+zPkFl4OslZfEZqEu0MYvF+eOMmgcXFTaZBlaCk2GvNU3CKUx6p2ES
         xhFnp7xgFnPIeCAi15U/alTXmkG8l7RSCodgniVAhkpaWhUIKciXgtu/tyWgie3k+jLQ
         8ALdx3JPlAbVsxRKwzsJSvg0xVtM1iZsGo2Sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g/lflDQ38qP2yrrUSeMTfBCWFbUPaWfHaTE5vNmEMN4=;
        b=inlODoQDZrJxr4P5TUxQZbNxKybztj3iWdqiHU9gkpkS3sPr6yWBsfsKlwxXBaA1kQ
         myoXYmxlqd1a6jwZTPvDwkUvxJS2FPHVD0ncDGS2sANxapUTTdY/P5AfIfQU+hPvFJxE
         kxHZyFoJubv9jho9p2q3djB4Al7TSo0RQpQ1iIwRxEkfIH4mlGZZap20AJr8oxpiYmHT
         ipGqVsf3NgOPkPN30hjVgqVFEYZpUCjdo48AfozkASk606HmsYZkMU5o1OwMsD9Dpp6P
         k8caCCDpmWinjbHQ5+JRqJzTAm1gfP4xftAakS32xuqeJOV/Cj2vpxECH7jYPYPzhbbm
         ouxw==
X-Gm-Message-State: ANhLgQ1rJ7iMRXKLoOqytqffYAOfexduuac2pUJK5zWYNppolyW3J9kI
        QcimgZZuvj50Dm44wLNrMUSTmyJmA7kvDw==
X-Google-Smtp-Source: ADFU+vvnOngflpDaXMYj9okkhCZcx4MIq+k+9rOFI2qZgaKafNJcE6MQMNeVtq7crvK7WJu7RYYK0w==
X-Received: by 2002:a1c:6745:: with SMTP id b66mr41377wmc.30.1584464692222;
        Tue, 17 Mar 2020 10:04:52 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id r28sm5561201wra.16.2020.03.17.10.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 10:04:49 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next 2/3] net/tls: Read sk_prot once when building tls proto ops
Date:   Tue, 17 Mar 2020 18:04:38 +0100
Message-Id: <20200317170439.873532-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317170439.873532-1-jakub@cloudflare.com>
References: <20200317170439.873532-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from being a "tremendous" win when it comes to generated machine
code (see bloat-o-meter output for x86-64 below) this mainly prepares
ground for annotating access to sk_prot with READ_ONCE, so that we don't
pepper the code with access annotations and needlessly repeat loads.

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-46 (-46)
Function                                     old     new   delta
tls_init                                     851     805     -46
Total: Before=21063, After=21017, chg -0.22%

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/tls/tls_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ff08b2ff7597..e7de0306a7df 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -628,24 +628,25 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 static void tls_build_proto(struct sock *sk)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
+	const struct proto *prot = sk->sk_prot;
 
 	/* Build IPv6 TLS whenever the address of tcpv6 _prot changes */
 	if (ip_ver == TLSV6 &&
-	    unlikely(sk->sk_prot != smp_load_acquire(&saved_tcpv6_prot))) {
+	    unlikely(prot != smp_load_acquire(&saved_tcpv6_prot))) {
 		mutex_lock(&tcpv6_prot_mutex);
-		if (likely(sk->sk_prot != saved_tcpv6_prot)) {
-			build_protos(tls_prots[TLSV6], sk->sk_prot);
-			smp_store_release(&saved_tcpv6_prot, sk->sk_prot);
+		if (likely(prot != saved_tcpv6_prot)) {
+			build_protos(tls_prots[TLSV6], prot);
+			smp_store_release(&saved_tcpv6_prot, prot);
 		}
 		mutex_unlock(&tcpv6_prot_mutex);
 	}
 
 	if (ip_ver == TLSV4 &&
-	    unlikely(sk->sk_prot != smp_load_acquire(&saved_tcpv4_prot))) {
+	    unlikely(prot != smp_load_acquire(&saved_tcpv4_prot))) {
 		mutex_lock(&tcpv4_prot_mutex);
-		if (likely(sk->sk_prot != saved_tcpv4_prot)) {
-			build_protos(tls_prots[TLSV4], sk->sk_prot);
-			smp_store_release(&saved_tcpv4_prot, sk->sk_prot);
+		if (likely(prot != saved_tcpv4_prot)) {
+			build_protos(tls_prots[TLSV4], prot);
+			smp_store_release(&saved_tcpv4_prot, prot);
 		}
 		mutex_unlock(&tcpv4_prot_mutex);
 	}
-- 
2.24.1

