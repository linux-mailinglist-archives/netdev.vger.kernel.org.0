Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E0E49D6D5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiA0Agu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiA0Ago (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:44 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4188C06161C;
        Wed, 26 Jan 2022 16:36:43 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id me13so2041868ejb.12;
        Wed, 26 Jan 2022 16:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YcffHEbuuMh1GAJfl6EBV2ha6pRMQcnaQyLatKJI1BU=;
        b=NJewKiI1hoOJlwu68lbQdEmd/sffYw/XmfEjJ4VdhGOPyGDaFqBAWBu9wG4o7K47KP
         G/Wse3mP0M2NMYYBvQdwofMOkKKjGvPXWzekT6KVZ+JaRIKTcBbVBXH5/VvUWsjYr1DL
         qgt8YulxKlwjbsryMYckZVLV1U0fz66hr+NneHbt+iizcrIsdPzuPrXgPKxaTk5V7CLI
         +b4ge5ClmMpqGKLD6sX1DbgJfZoGZTPK83H1yKjrwu1RtEb1tY0IlhqGWwF0RfpagP8d
         TygiZ7jlGxFww0jy8tK2n0oA45KfczLOMHIX+JD7U54BpZj/EgWhcDTVZKKxY94Kjn8T
         6u8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YcffHEbuuMh1GAJfl6EBV2ha6pRMQcnaQyLatKJI1BU=;
        b=U1WMYrt9270U4lq+tMnv/EiiG+RVSlU7BNtAlGjCDtFHcz8QoACbwrE0CxIY6Wjijb
         HbCKs9bHVLLf9IbdnoiCf/NW52H7Edv7hRPrsWeJ5bISADr+F4EhYk/GUjvRLFEhyrPu
         jSI3xJMvieP9p2XGlBMCp/M8jEcSyuoi4nnwQUy+D/94qZjqNKzGnYnUlPJ3wAKii6pB
         PHX1H2ZMbM19/6Cc8w3RIsIEN6bHn+JozEHeK6TLEYWLlE1B8sZpLqmVftPc5a48NmR6
         eJdCGcKXgCfFFkgubEUGmETERKBs3OhR9bcyns6Uby0xG1xTbp+PnvGSgxR5yv6Uvb1F
         E8fw==
X-Gm-Message-State: AOAM530B2XArin2CeizoxkpLKjN37BhRzqmx8DO5bCmmmzXxRr6vM9Gm
        q1iNc5iaAgCGBD4hWzPQ+GQRvLvSSI4=
X-Google-Smtp-Source: ABdhPJx9TKtR0SROmZRu0f30+P9TVzjqvb48KlZozpjt5DoHtYKk+aw+FII5MXHsrcbnsHbkCDEGTw==
X-Received: by 2002:a17:906:1b0b:: with SMTP id o11mr1054429ejg.109.1643243801828;
        Wed, 26 Jan 2022 16:36:41 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 05/10] ipv6: don't zero inet_cork_full::fl after use
Date:   Thu, 27 Jan 2022 00:36:26 +0000
Message-Id: <120aefd3d8bc4392f98edec3148779db39ef1454.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It doesn't appear there is any reason for ip6_cork_release() to zero
cork->fl, it'll be fully filled on next initialisation. This 88 bytes
memset accounts to 0.3-0.5% of total CPU cycles.
It's also needed in following patches and allows to remove an extar flow
copy in udp_v6_push_pending_frames().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c |  1 -
 net/ipv6/udp.c        | 10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 88349e49717a..b8fdda9ac797 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1831,7 +1831,6 @@ static void ip6_cork_release(struct inet_cork_full *cork,
 		cork->base.dst = NULL;
 		cork->base.flags &= ~IPCORK_ALLFRAG;
 	}
-	memset(&cork->fl, 0, sizeof(cork->fl));
 }
 
 struct sk_buff *__ip6_make_skb(struct sock *sk,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e221a6957b1f..3af1eea739a8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1266,23 +1266,17 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 {
 	struct sk_buff *skb;
 	struct udp_sock  *up = udp_sk(sk);
-	struct flowi6 fl6;
 	int err = 0;
 
 	if (up->pending == AF_INET)
 		return udp_push_pending_frames(sk);
 
-	/* ip6_finish_skb will release the cork, so make a copy of
-	 * fl6 here.
-	 */
-	fl6 = inet_sk(sk)->cork.fl.u.ip6;
-
 	skb = ip6_finish_skb(sk);
 	if (!skb)
 		goto out;
 
-	err = udp_v6_send_skb(skb, &fl6, &inet_sk(sk)->cork.base);
-
+	err = udp_v6_send_skb(skb, &inet_sk(sk)->cork.fl.u.ip6,
+			      &inet_sk(sk)->cork.base);
 out:
 	up->len = 0;
 	up->pending = 0;
-- 
2.34.1

