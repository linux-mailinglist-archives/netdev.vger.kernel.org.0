Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62220520C7C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiEJEBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiEJEBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:01:47 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A7F2AA2F1
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:57:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j6so13882686pfe.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/z4M3GBGw6/WGXULFKw/7yx8sXpcmNAe2LOaka9wT5k=;
        b=ZIIkLBC3K9ZjYWSA/wfSSK7i26EffRzRT8fhwgsuGqhxpJWxI4ar7jYATqhSZfz2JQ
         1YyJIHMek4Pkyn0vtdR0MDR/H9hrxalYEi/7/mBQyVKK6UqESDMN7AVxLzgWZVFHof1y
         u6vkrKULrFt78S7rU2m1G0MEY7JdA3Ac+HKaBj1IxkXK0Dp1IR0p4D8k6OCYzkgedk8R
         Ik5xBDhO3eRpypC3/ohnPsKte/PfVHaPu1jTZ2AhbW8MoLxZKRI+XC3nPOQrrnY+YrHG
         q+7+QJNLamjyfRKUAdE43M85oIAxo6PLazPoN/qpk7RJRImvq6NzFxSDjOM5EKA4GCzg
         iopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/z4M3GBGw6/WGXULFKw/7yx8sXpcmNAe2LOaka9wT5k=;
        b=VLRIfWzKHhOZDZ7PfV5ujmgNPZwJqFbXyglPfi8Fu0VqnaXsIn8uKAPcNqNJA3/xEG
         bZAk1e8c8dGwFSl9OtEUBczoezQJIuvoyTB1dISdx3pDcyyFAJg/0KA1mcHm7GvPwn+1
         CyCflKSrmHzZc57qUGECOpHYMBW9oB7Qs40JlN4cGUzOpMhxQdkGhUcKf+5x/GagLZQz
         CMukArm5GPt/bYdlcJj6Xep7xVQBlekz+pB+Bul7iDxTmnH0ST2TfD4w3FRD5lAsGQDx
         QA0E6Kgp4ry5/Yws+2MHcKE8vlcth7fXaDDeXMSPJozymsonnu8o1eyfJ9IZfe8CdRfU
         gE5Q==
X-Gm-Message-State: AOAM5314bXd+eU6WCe02stWLVOGqIPWCCZqIAObQQTXjyM0qryA2FF7Y
        dlfCi5t6UEhL1OaFjOLzauU=
X-Google-Smtp-Source: ABdhPJze6KYjhGoyIkPP/IZfsYfCWundReB9ewO5rEpEfSAfkwU3AOn4Zc/f3Diw0vNLcZGNq4RifA==
X-Received: by 2002:aa7:9110:0:b0:4fa:e388:af57 with SMTP id 16-20020aa79110000000b004fae388af57mr18669547pfh.1.1652155070887;
        Mon, 09 May 2022 20:57:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090ad3cc00b001d81a30c437sm568193pjw.50.2022.05.09.20.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:57:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 3/5] net: warn if transport header was not set
Date:   Mon,  9 May 2022 20:57:39 -0700
Message-Id: <20220510035741.2807829-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510035741.2807829-1-eric.dumazet@gmail.com>
References: <20220510035741.2807829-1-eric.dumazet@gmail.com>
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

Make sure skb_transport_header() and skb_transport_offset() uses
are not fooled if the transport header has not been set.

This change will likely expose existing bugs in linux networking stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d58669d6cb91aa30edc70d59a0a7e9d4e2298842..a1c73fccccc68641fe46066e6d1195b31483ca4c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -42,6 +42,7 @@
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_common.h>
 #endif
+#include <net/net_debug.h>
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -2804,6 +2805,7 @@ static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
 
 static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
 {
+	DEBUG_NET_WARN_ON_ONCE(!skb_transport_header_was_set(skb));
 	return skb->head + skb->transport_header;
 }
 
-- 
2.36.0.512.ge40c2bad7a-goog

