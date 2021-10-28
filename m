Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9083543D871
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhJ1BOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhJ1BOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 21:14:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EF4C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 18:12:08 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r28so4797824pga.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 18:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ud/dZhHuJLxTDMGDJYTdpyn6NwlqIlqtVhG1AGwNj3k=;
        b=FAHCSIyyZ+oH/jYBs3YnFDDn7+Cx5SmA7LUNTbX43Xdqmht/f809m6yTdEX0uY0xJY
         Euatn8R1SGmMGt9ElaiPuvG3Iah/F4y7scY65i+wGxxriDyLHEY9zNWA5Rqm2uzd6FjX
         MCcv7MZiIdjDgKtnF0nYwvmHJ4JSKyWVGNPND0Jsip+eWBUEB9aoCeekQpVIS1qp37PL
         DAArLxqi4J19/RAuJ3vV9DZ4JvqSekU2JjUOjzPhIzq0/GFw27K1nit4zUaWrYV2LOni
         ra0VOpHpnvb8xr/56UCteGVlgdkbOHY3DfVZe6o34H2L3HNhYVcR5RoFErb7+njHvTu2
         /sGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ud/dZhHuJLxTDMGDJYTdpyn6NwlqIlqtVhG1AGwNj3k=;
        b=ZejJqGQPAD/flFTFQu+NvOj+JKOV7MRE2hIMg5EgSa1q1V1sC59T8fVVkPvQDoYyO1
         K5KHhSKNYx+8ulD1hbJX0mVM61Ir/x59MJH0q/2eSmoN8KZ4M92mRFQ+HrtnxlRcpyV4
         cPmE+BttaD/SG/MgzWEO5Xnumhf9zgT8fACj/mNVW+nC0H1AcFKDl2NZCl+IbxPIgbKe
         CItRC8MJ+ElSePjN9rDmuIvZ+pxRr3gTGm7j6X/U4TCBaXPedj2ZxorbkviFhxr5A5/T
         /3gdzpxLlTDWcCMiHCnur2715YdoRv/BIgJSQv1398MMAVWpvXWsCkQPjBsrM2gZYKig
         q0ng==
X-Gm-Message-State: AOAM531+kFVkxqjWg1DsBlaJWCQ5OE+D6c6zdqA2leB6+Zt8cqIckYT5
        zpaa5vgcLoviaVStXl2fwwM=
X-Google-Smtp-Source: ABdhPJzpd79SfMWoXYd4uW7l8/KDCizLDF4fLZCw66UlFoTz6DCtoNm+Tyv8MIeIelwsoyfxMeo5TQ==
X-Received: by 2002:a62:7f4a:0:b0:44d:292f:cc24 with SMTP id a71-20020a627f4a000000b0044d292fcc24mr1157120pfd.58.1635383528505;
        Wed, 27 Oct 2021 18:12:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id k73sm163072pgc.63.2021.10.27.18.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 18:12:08 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: cleanup __sk_stream_memory_free()
Date:   Wed, 27 Oct 2021 18:12:05 -0700
Message-Id: <20211028011205.151804-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We now have INDIRECT_CALL_INET_1() macro, no need to use #ifdef CONFIG_INET

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ff4e62aa62e51a68d086e9e2b8429cba5731be00..36d6321a587781fc1e058bae69eee27bc94a7b20 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1299,15 +1299,9 @@ static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 	if (READ_ONCE(sk->sk_wmem_queued) >= READ_ONCE(sk->sk_sndbuf))
 		return false;
 
-#ifdef CONFIG_INET
 	return sk->sk_prot->stream_memory_free ?
-		INDIRECT_CALL_1(sk->sk_prot->stream_memory_free,
-			        tcp_stream_memory_free,
-				sk, wake) : true;
-#else
-	return sk->sk_prot->stream_memory_free ?
-		sk->sk_prot->stream_memory_free(sk, wake) : true;
-#endif
+		INDIRECT_CALL_INET_1(sk->sk_prot->stream_memory_free,
+				     tcp_stream_memory_free, sk, wake) : true;
 }
 
 static inline bool sk_stream_memory_free(const struct sock *sk)
-- 
2.33.0.1079.g6e70778dc9-goog

