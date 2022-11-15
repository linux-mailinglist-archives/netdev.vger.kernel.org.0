Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370B06293F0
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbiKOJL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiKOJLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:11 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C8121E30
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:09 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id de43-20020a05620a372b00b006fae7e5117fso13052571qkb.6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n0VLENMcyvxwA2BZU5YBTMVw3WKcpvSd2Zjv1qxjp44=;
        b=FtgMXTd0TUIY3ZD3cb6R+fm9VjWxuEThcuyIZHyMLZ9EFVWbeSXXXKM5iEFzhEdq7F
         qQ10umbnCxRMJQQMm7x7VEGNrLNnQeQwaw97hdiy/VqS2mgvPp8MsT/8QmwQFBTNmlr6
         b13mh44hDaq4D7F4UOmE4cq6etft5KSRmWsREhIPg5fqfLamowvZfZywmCBrmOsr0F07
         1HkjGnzfr9go3lyTzWAFLl9W4bRj/zZbmOuGcdrn0c/BL5J9x+QM+HEu5zb1aUfTSiUh
         469gzpdZWWjzo/xFx3XN8aHKSJWXy0umuItni1qKabgQ8r3ZpHePuPXD7zKVhTfEc5QL
         GhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n0VLENMcyvxwA2BZU5YBTMVw3WKcpvSd2Zjv1qxjp44=;
        b=QZPdS019L2ZtlH08Q5CBr37E9ClHR/jlG8dzs64ySUckPln35UgDLlV5P/OZTnkwwD
         RodRO2Dn9Z9QBjUfA7kA248ZO5uysg3xlJH1Bc42UQlpHvheVw35sVndmmgB4EGJypBK
         fjTss4IxnDsOei7A0qYqZIWnxK4gGPdSphHc9bPzYR7lL5CeRimz6Qfx2kBzpI4O07io
         22qKRCsy4J6lngwBnci/fSwQxsN0nTfKX1YG/bIo+K0++XcjXTrZSP+hrvCMAYdKBB6a
         gjyAd7Z4VxXrEMThPvnAYITsK6dE1pkvgRzIKnDF+1jj1i6BR4ZCMAM0p4E/gVlIgVwV
         8M7A==
X-Gm-Message-State: ANoB5pnE4n+sUdKR17hsJRgkZfAQzQ55dwSbIfksCVsqN9RSR34ek/fs
        PBJ8TgGFFVKLhnBGnKIr+vnE7FI+zpzQCw==
X-Google-Smtp-Source: AA0mqf4T6gvrIqro5KqII+Xa+IRxQXhYyaBp/uBardQUDLJHY6pfO7ur43XRaybvIUP9xiw5hKCJ4zrOQI7ybQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6214:598d:b0:4b1:97a2:405b with SMTP
 id ll13-20020a056214598d00b004b197a2405bmr16097598qvb.27.1668503469072; Tue,
 15 Nov 2022 01:11:09 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:10:58 +0000
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115091101.2234482-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-4-edumazet@google.com>
Subject: [PATCH net-next 3/6] net: net_{enable|disable}_timestamp() optimizations
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adopting atomic_try_cmpxchg() makes the code cleaner.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 117e830cabb0787ecd3da13bd88f8818fddaddc1..10b56648a9d4a0a709f8e23bb3e114854a4a1b69 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2073,13 +2073,10 @@ static DECLARE_WORK(netstamp_work, netstamp_clear);
 void net_enable_timestamp(void)
 {
 #ifdef CONFIG_JUMP_LABEL
-	int wanted;
+	int wanted = atomic_read(&netstamp_wanted);
 
-	while (1) {
-		wanted = atomic_read(&netstamp_wanted);
-		if (wanted <= 0)
-			break;
-		if (atomic_cmpxchg(&netstamp_wanted, wanted, wanted + 1) == wanted)
+	while (wanted > 0) {
+		if (atomic_try_cmpxchg(&netstamp_wanted, &wanted, wanted + 1))
 			return;
 	}
 	atomic_inc(&netstamp_needed_deferred);
@@ -2093,13 +2090,10 @@ EXPORT_SYMBOL(net_enable_timestamp);
 void net_disable_timestamp(void)
 {
 #ifdef CONFIG_JUMP_LABEL
-	int wanted;
+	int wanted = atomic_read(&netstamp_wanted);
 
-	while (1) {
-		wanted = atomic_read(&netstamp_wanted);
-		if (wanted <= 1)
-			break;
-		if (atomic_cmpxchg(&netstamp_wanted, wanted, wanted - 1) == wanted)
+	while (wanted > 1) {
+		if (atomic_try_cmpxchg(&netstamp_wanted, &wanted, wanted - 1))
 			return;
 	}
 	atomic_dec(&netstamp_needed_deferred);
-- 
2.38.1.431.g37b22c650d-goog

