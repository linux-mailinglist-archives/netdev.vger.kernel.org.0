Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A2E9FB89
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfH1HXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:23:12 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:37641 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfH1HXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:23:07 -0400
Received: by mail-lf1-f48.google.com with SMTP id w67so1242885lff.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ChrDtz59PnCX+6+r9UCdXvbVLOtObm7QD6/Fb8mBLd8=;
        b=Pq2QeT0JSwflfDyfGw+IpbCkdMftwlMx9FkXMud1cXD7nUTTk/UhYnXygF7reAPVqz
         RP6OBw+CaT2DDQkpnxoA4pySZjW4BGJAZpQVm1NGz1MMablRgnl1CJ1Z5N+xslqqBi0W
         Yrqgk+snPp0iqhvVo05cYTtH4GYqtLal5Olfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ChrDtz59PnCX+6+r9UCdXvbVLOtObm7QD6/Fb8mBLd8=;
        b=b6XdGbfyJdMRm21Pav8+iHNqn1I7SXmQRizOHtLQiMS79PVIJ9p8+uyekLKVjMt0oD
         tmTvZzm1YQjSTDThXjyJAJTUemwzGqjVi8XoDG4I7MfIiFY1+bNDVeYO7vip5OR2A1rS
         +KELbNykEN2Y0pt9srvp3iQ3bAbRE1exnh/+FzNG6orGa2tWeesD4rcDe/cBtD4IN+IX
         YOmsGw594XRMyIFGcMNTuTNWchizdcdRMHPFI03b2u5n84Y5/EyAmrjbvWqvwJMMRP0z
         zpCHeI4Oam+oh4OtsYPHzgyq0bcbtMs2fbQuuEr+CnCzG3lvqWaI7MBbrHYbv0rm0jpD
         v18g==
X-Gm-Message-State: APjAAAUnQ4SdV75Shr48rh6yS4Pfqi3uIlBC1K9BAcUw95JIGNtJqScE
        VfM3Ao+x5RDuil0ONMwrBNHhUQ==
X-Google-Smtp-Source: APXvYqzxJ3Mhwm/IPq1UDw4LsLtnUR8CKfKfH4WkwC8YVqnuos4IDuKZE0JITkZea8gPXZHVeep7/A==
X-Received: by 2002:a19:6b09:: with SMTP id d9mr1653999lfa.8.1566976985078;
        Wed, 28 Aug 2019 00:23:05 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w26sm590039lfk.57.2019.08.28.00.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:23:04 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 07/12] inet6: Run inet_lookup bpf program on socket lookup
Date:   Wed, 28 Aug 2019 09:22:45 +0200
Message-Id: <20190828072250.29828-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the ipv4 changes, run a BPF program attached to netns in context
of which we're doing the socket lookup so that it can redirect the skb to a
socket of its choice. The program runs before the listening socket lookup.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet6_hashtables.h | 19 +++++++++++++++++++
 net/ipv6/inet6_hashtables.c    |  5 +++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index fe96bf247aac..c2393d148d8d 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -104,6 +104,25 @@ struct sock *inet6_lookup(struct net *net, struct inet_hashinfo *hashinfo,
 			  const int dif);
 
 int inet6_hash(struct sock *sk);
+
+static inline struct sock *inet6_lookup_run_bpf(struct net *net, u8 proto,
+						const struct in6_addr *saddr,
+						__be16 sport,
+						const struct in6_addr *daddr,
+						unsigned short hnum)
+{
+	struct bpf_inet_lookup_kern ctx = {
+		.family		= AF_INET6,
+		.protocol	= proto,
+		.saddr6		= *saddr,
+		.sport		= sport,
+		.daddr6		= *daddr,
+		.hnum		= hnum,
+	};
+
+	return __inet_lookup_run_bpf(net, &ctx);
+}
+
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
 #define INET6_MATCH(__sk, __net, __saddr, __daddr, __ports, __dif, __sdif) \
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index cf60fae9533b..40dd0a3d80ed 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -157,6 +157,11 @@ struct sock *inet6_lookup_listener(struct net *net,
 	struct sock *result = NULL;
 	unsigned int hash2;
 
+	result = inet6_lookup_run_bpf(net, hashinfo->protocol,
+				      saddr, sport, daddr, hnum);
+	if (result)
+		goto done;
+
 	hash2 = ipv6_portaddr_hash(net, daddr, hnum);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
-- 
2.20.1

