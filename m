Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3A1E2309
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391207AbfJWTC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:02:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43708 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391062AbfJWTCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 15:02:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id l24so7743183pgh.10;
        Wed, 23 Oct 2019 12:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2dJBs5JnLT0QkfOhCc/zQewN+hifLtS+KM37LQVFfeM=;
        b=EkL6rBa3/RG5R2XDFmKPQMLXjpYt3d4Y8nW2vgV2IVv8xf3uX5/4p6HUkv3kzof92t
         cAKf4JXZFDUozDFlyCIV7M6c2O7Q67ClpZNPu3wLashfUDnuzNx5qCrK5OgnO7VX8eOw
         R+5vIPrCBHUxpLUlIFCugtQRWjytyROzYKfIBkWFWswWu2IVZ09p3phSJC7evfCUJkXH
         HDmj2WaxexDTyPuKu+SI31dpBPRnrZKztP6xUnSdsiYaasKna8eFZHzzKAVqMzYxipuv
         BG8Nqw6pLXdBXp5kBwFWNkkxC/b0xctKb0dBzxlpFiBJ9gEwyD2fppf58chiPJ6+GgV8
         pyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2dJBs5JnLT0QkfOhCc/zQewN+hifLtS+KM37LQVFfeM=;
        b=J1TXiMfPmPISCDlrqi5qNAd9GvGMxVQN87ENQ3xpQN9glgosDeP5tJxKpGTIZf0LOx
         M8cgJmEK4sGvzYSofbl13ElacFkDB2L3QyW1+JyyESHa1oCx7RVNcmsE4xWUVRdSNa8X
         gPGRAPFACBMbZyq8gJwVu+572CXFkXKklTBv1ptVggy44LnJmzJCP3kSlaT/TMD+Qkzb
         sOL/BhEmsRvVapwCS8y8kdN6iwhJHwd8Uwy8DWqR24zcHBiR4dFZYqm0wbqgtwFoBf7q
         hfnb/yodgvIQUG4FQcrFbZdVGgBeqp8dL9IDSv78LJMGYzvgI0oMzziN0ug170fNjwey
         agVw==
X-Gm-Message-State: APjAAAXeXkEGKFg2wMO+Ozp84eeqHT+f8S9vsAK88v+szDkflC+1xb4M
        11gHHbUQ6RNefTZmXooUmrXFtayBAA==
X-Google-Smtp-Source: APXvYqyXGd+62q0F7xqIfuJ4RjjFlSw2983Vf3UuNHF0zXMIsB9CNaIXAj2XU1eG8Fx0hFzyLPDRVw==
X-Received: by 2002:a17:90a:bd0b:: with SMTP id y11mr1998608pjr.28.1571857344618;
        Wed, 23 Oct 2019 12:02:24 -0700 (PDT)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id m13sm22430901pgi.22.2019.10.23.12.02.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 12:02:24 -0700 (PDT)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        pablo@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: [PATCH] [netfilter]: Fix skb->csum calculation when netfilter manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Date:   Wed, 23 Oct 2019 12:02:22 -0700
Message-Id: <1571857342-8407-2-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571857342-8407-1-git-send-email-pchaudhary@linkedin.com>
References: <1571857342-8407-1-git-send-email-pchaudhary@linkedin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update skb->csum, when netfilter code updates IPV6 SRC\DST address in IPV6 HEADER due to iptable rule.

Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
Signed-off-by: Andy Stracner <astracner@linkedin.com>
---
 include/net/checksum.h       |  2 ++
 net/core/utils.c             | 13 +++++++++++++
 net/netfilter/nf_nat_proto.c |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 97bf488..d7d28b7 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -145,6 +145,8 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 			       const __be32 *from, const __be32 *to,
 			       bool pseudohdr);
+void inet_proto_skb_csum_replace16(struct sk_buff *skb,
+			       const __be32 *from, const __be32 *to);
 void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
 				     __wsum diff, bool pseudohdr);
 
diff --git a/net/core/utils.c b/net/core/utils.c
index 6b6e51d..ab3284b 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -458,6 +458,19 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace16);
 
+void inet_proto_skb_csum_replace16(struct sk_buff *skb,
+			       const __be32 *from, const __be32 *to)
+{
+	__be32 diff[] = {
+		~from[0], ~from[1], ~from[2], ~from[3],
+		to[0], to[1], to[2], to[3],
+	};
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = csum_partial(diff, sizeof(diff),
+				  skb->csum);
+}
+EXPORT_SYMBOL(inet_proto_skb_csum_replace16);
+
 void inet_proto_csum_replace_by_diff(__sum16 *sum, struct sk_buff *skb,
 				     __wsum diff, bool pseudohdr)
 {
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 0a59c14..de94590 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -467,6 +467,8 @@ static void nf_nat_ipv6_csum_update(struct sk_buff *skb,
 	}
 	inet_proto_csum_replace16(check, skb, oldip->s6_addr32,
 				  newip->s6_addr32, true);
+	inet_proto_skb_csum_replace16(skb, oldip->s6_addr32,
+				  newip->s6_addr32);
 #endif
 }
 
-- 
2.7.4

