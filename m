Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAEF4514A0
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345562AbhKOULO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345787AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403F5C0BC9A8
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:10 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n8so15272879plf.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LzvJ3uZpmPz8KIpiyyH1ezS3hd212SefPfGNUcXRiNk=;
        b=Q3O3+ksxvz6f897rrzvHxgsdFeQFejtLsiJgpoxOBH70UdsVZJvUnl5e87dTzr+92J
         TRbHV1UjwUiWQMgZ0nydGf+tHjuZ0oajrXKMHHv0GFmKJYqd17lzb8BUoBI7GSp1CsIA
         mMuI6naU1n1Iexz7Dd9JfzapKGXXYIkJxVBe2DosAnS2o67+RqgFetTjv8WIR9oxc3XD
         KxamAhAzCApv5Gk3WugdBtQfHqjBsgWp6P2yoOHk13w54Itl+JokaQugyf11j3VsHC+L
         6RWbAZGnh+wrktu1VwjtyM0tHBdSYItkipq4m+w36IP0/2ae/PSninrHGNZNxd0/P9oA
         k4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LzvJ3uZpmPz8KIpiyyH1ezS3hd212SefPfGNUcXRiNk=;
        b=DarwoXd00GlZs2qa1jRT1h/fI+Mp7ECnACuCwsqU4TWb3+WUJNwRNQKF9soCukHC0L
         eab1HBvM2xNyXC0i+CyIHTC2ltmK0cD0J3FArlY5pAgdkuLxGMtjE9Fk2rQFu9/F+l35
         otQo5wUCYXA90tNrtFZ8rAjmewpV48uhR1wnQxsb6MLRijbk6I0D3a0nho08KoWy6Aky
         pld6gukQyrKc17LbIL4PhDty1PyQ3uSN4vFJqRxvebkkgndqmEyK35hNshbP4NhnvUCw
         Ijx0XZAYlPbSsoI86jtM50zbDnqe8cx9+8xYtomLF1aNI1Fy5I5uWznH6Sl5fJLdURxw
         vjyA==
X-Gm-Message-State: AOAM533BIQ2toWfsdKYmezAhwQ5l3PTcntq12RMCzCd6gVxzvXockYys
        rTSInq925FqTC8WkuoKFdmU=
X-Google-Smtp-Source: ABdhPJxq7/Mds7YWj+KBiMh2d/YhxAXKrQHrQlZe4d+9bqgkjnzQUH//96cXgzWlH/X9LsmGuKRAMQ==
X-Received: by 2002:a17:90b:4a50:: with SMTP id lb16mr68287271pjb.37.1637002989824;
        Mon, 15 Nov 2021 11:03:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 07/20] ipv6: shrink struct ipcm6_cookie
Date:   Mon, 15 Nov 2021 11:02:36 -0800
Message-Id: <20211115190249.3936899-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

gso_size can be moved after tclass, to use an existing hole.
(8 bytes saved on 64bit arches)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c19bf51ded1d026e795a3f9ae0ff3be766fc174e..53ac7707ca70af513aef32389afd681bff3082f3 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -345,9 +345,9 @@ struct ipcm6_cookie {
 	struct sockcm_cookie sockc;
 	__s16 hlimit;
 	__s16 tclass;
-	__s8  dontfrag;
-	struct ipv6_txoptions *opt;
 	__u16 gso_size;
+	__s8  dontfrag;
+	struct ipv6_txoptions *opt;
 };
 
 static inline void ipcm6_init(struct ipcm6_cookie *ipc6)
-- 
2.34.0.rc1.387.gb447b232ab-goog

