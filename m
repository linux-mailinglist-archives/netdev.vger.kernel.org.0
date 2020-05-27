Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9981E3B40
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgE0ILW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgE0ILV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:11:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98094C061A0F;
        Wed, 27 May 2020 01:11:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q9so1183185pjm.2;
        Wed, 27 May 2020 01:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HqOS3b0kz9buhGMAwpM1e//tKnAWm9QINLirTrl38pg=;
        b=S36TXPD+KUZ9H8z+UDfCNsckNt2wGNaZtWoxpON/qzpyfONRP3RXBhjAv6r1vaD6VM
         dZEpV09dFNbqdc1a0hwG6ffffnMqutBwx+7sFXtzlOlT3RGZ8+nabhTEpAE3DzpValbZ
         SMLiJwVINacNSXmxnzvL/MItftqm4oEBkphZyOEZTVWqsZKoSh6EWfCEp6APirf+imvu
         T23OdXZJWGzGjymlrSA6hzjKGNJ5W0sLoBjZjFaFbPJukBGESiorAy7MxkWchzXhudaO
         HCNPCL3sVKvdyxYgUzeeVy8KTTW2NBvy6nC900yhwstIsArEcb+w2fuw71bS12fgJYu5
         +Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HqOS3b0kz9buhGMAwpM1e//tKnAWm9QINLirTrl38pg=;
        b=Z2Z8s0XKz5Cyj52iCZxeo7iWouYceqvCOEzyT/n2usN2sqixJzckW6znCBDURHEUES
         eoeNrKCJUvZP2qVK/WLnZrMoMRkeTqGVS7beslChq0ZHEMYi8/1lLrj26aERNMLoQ5aN
         6LzCIWxC0xfJOavCkwmrUmLrxTFCKxrFhQv9Gsi9X4HRwXq9i88OPd1Ockqg6UEQ6Kob
         X3DagU4x3n6hXvPLpQ+pKMPD5xEuj/l8tlcfa5hMujAS0Y65waxKbM8lHEmKI+vormtG
         iXGSlnPR/0E0QCIeFbmoAzCD1i+2Sug5D/lJCFRILskPHeg90R1VC2c/bn4w2ysQNJbH
         2kjA==
X-Gm-Message-State: AOAM531ehmpQ5TDjdQjVQKuOUNzkrH4w9dnyvq5iuyYbybnQIczP1mfm
        IxGKXhM/OP6pEp7Ve94Iv58=
X-Google-Smtp-Source: ABdhPJy19Y2TTdpBtx5Eq7lIRF3QDNKWjyEXuKGwJyCfDu3atCCpqNXEB6EYMRIiFklvx7jbAgyf5Q==
X-Received: by 2002:a17:90a:7bcb:: with SMTP id d11mr3663001pjl.209.1590567080839;
        Wed, 27 May 2020 01:11:20 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id v127sm1449496pfv.99.2020.05.27.01.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 01:11:20 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net] netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update
Date:   Wed, 27 May 2020 01:10:39 -0700
Message-Id: <20200527081038.3506095-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

net/netfilter/nf_conntrack_core.c:2068:21: warning: variable 'ctinfo' is
uninitialized when used here [-Wuninitialized]
        nf_ct_set(skb, ct, ctinfo);
                           ^~~~~~
net/netfilter/nf_conntrack_core.c:2024:2: note: variable 'ctinfo' is
declared here
        enum ip_conntrack_info ctinfo;
        ^
1 warning generated.

nf_conntrack_update was split up into nf_conntrack_update and
__nf_conntrack_update, where the assignment of ctifno is in
nf_conntrack_update but it is used in __nf_conntrack_update.

Pass the value of ctinfo from nf_conntrack_update to
__nf_conntrack_update so that uninitialized memory is not used
and everything works properly.

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Link: https://github.com/ClangBuiltLinux/linux/issues/1039
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 08e0c19f6b39..e3b054a2f796 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2017,11 +2017,11 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 }
 
 static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
-				 struct nf_conn *ct)
+				 struct nf_conn *ct,
+				 enum ip_conntrack_info ctinfo)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	enum ip_conntrack_info ctinfo;
 	struct nf_nat_hook *nat_hook;
 	unsigned int status;
 	int dataoff;
@@ -2146,7 +2146,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 		return 0;
 
 	if (!nf_ct_is_confirmed(ct)) {
-		err = __nf_conntrack_update(net, skb, ct);
+		err = __nf_conntrack_update(net, skb, ct, ctinfo);
 		if (err < 0)
 			return err;
 	}

base-commit: a4976a3ef844c510ae9120290b23e9f3f47d6bce
-- 
2.27.0.rc0

