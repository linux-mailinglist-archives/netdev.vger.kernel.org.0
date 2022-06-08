Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFEF54385C
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbiFHQEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245075AbiFHQEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875FB27CCF4
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:43 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id h1so18001506plf.11
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WhhA7d4SgDuLNJh5qxna0pplxrOZt4lEvQ8XEOxrYyM=;
        b=aTuuNO+SiJwBAaLU/ddUjM2dJuFvdLiQzGxiS1XhO6jYuSZcheTTTfe6XiWsO0d8QI
         ChXOv+ERhgu914Bw2MXDp4dnjzg+VRjhy8Y36a0Dsp6/BohPFNST/fFSJqvQBI0/hd6s
         pOfZoAyQFpwNGUYS6vyDiIWoBgJh1PDZ/OBbE4ibmrKtNcs2/rHIfrasdYt7P9R8dk+Z
         7t12kcPeyKTOxJYcRNuvhWcjbqviTKjgKzG0ylpsmuwewoA40iC+dG/wpMwfKLtLfsj6
         etksOlzi4wbgtzFEoNly4C+Ykg5NrgTLJK7jHu3gnw/YmhtUYbYeM/zRIZ1Qd/P3xS7m
         O2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WhhA7d4SgDuLNJh5qxna0pplxrOZt4lEvQ8XEOxrYyM=;
        b=vhJw2HRw8LWdBB9iY9yJfozaiXYGhJHtRPjEEjThkADNVm40KpyHfAUVWBheSdK/YC
         vfjIYr/h7yvXhUzaAEfWq8weZZGu2C0TRGT8rqLR5/c1cyPXtyVPwXFXtfLuGlnUIzh5
         FD/FWuoQgX54XwjVX+af806fJZG1JMmABBEHZsjGBGGWoI8TIc0ZEAVKVSGDohxunCB9
         2yp8mDttSiWI+8jmYBa70TANwKmJcEfSZHfOhc7MY+CmIILymXXDvYbtKqnBpPICalCM
         i3AEinUjTTExq7xm2Onbs9WyOOzpZ+UVEdz3fn6VHCpgen9ImthNK0DCLLWRZN8DYSv2
         cUdQ==
X-Gm-Message-State: AOAM532D5iYvF/qv+1lE+b0cEZItxGGM2OjaYVabo2ZJpaeZ04+htXva
        k97sup3y62egZZ3mrT3YgLE=
X-Google-Smtp-Source: ABdhPJzOxN9uQ0p2+RTKKWowm2yW8hh6MVqkWkpgk8SL+VQ8AHCVOYSJxN6qSTcHlo8ranSyyQPGbQ==
X-Received: by 2002:a17:90b:180e:b0:1e8:3023:eeb9 with SMTP id lw14-20020a17090b180e00b001e83023eeb9mr30821439pjb.55.1654704282609;
        Wed, 08 Jun 2022 09:04:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 1/8] net: use DEBUG_NET_WARN_ON_ONCE() in __release_sock()
Date:   Wed,  8 Jun 2022 09:04:31 -0700
Message-Id: <20220608160438.1342569-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Check against skb dst in socket backlog has never triggered
in past years.

Keep the check omly for CONFIG_DEBUG_NET=y builds.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 2ff40dd0a7a652029cca1743109286b50c2a17f3..f5062d9e122275a511efbc4d30de2ee501182498 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2844,7 +2844,7 @@ void __release_sock(struct sock *sk)
 		do {
 			next = skb->next;
 			prefetch(next);
-			WARN_ON_ONCE(skb_dst_is_noref(skb));
+			DEBUG_NET_WARN_ON_ONCE(skb_dst_is_noref(skb));
 			skb_mark_not_on_list(skb);
 			sk_backlog_rcv(sk, skb);
 
-- 
2.36.1.255.ge46751e96f-goog

