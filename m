Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A754514AB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349075AbhKOULt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345804AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC4C06EDC0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 8so3948971pfo.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FooQCbUIJ+BdByiyKpi0sSy78LSDGfQV+hc2qyor+T8=;
        b=SGwyGH6qeokESF/Z7IQT6gReROC3o8xjNBCiMMEG+G4oVusmw0sm88sft568c9ifcN
         ERFZ9atwI45h8HtrSXLa1/F5Qy+2s3SLscwDlp9pOI0ix2G1Wj6VTu4TZiwmE0E13nWJ
         olJKj3BLeLB/hoJYYuH7vTbjnhz97GWz6X4jKIllGPN34ufgqbdMCdOrQRGVDc99oWxp
         XlXpwqjM/zAI/agfTa8x60gCoQtY/SWjuduC2i3BoG1PQmM9heDpv7DUpwcy3xOiPKsb
         vsIo2F4CNFm6EI5+xh6OPKlH01WC0OL+zNbPC5xER+d0CBQdQ4AUsyQ9VnnvkbTD4c0J
         YF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FooQCbUIJ+BdByiyKpi0sSy78LSDGfQV+hc2qyor+T8=;
        b=uWoOzJsUmVIzmmXO+mUnEVk/4iOytMXwtyoaTzTcgsdFqw9JMFtFSMmpqpFlsJHBZY
         Ghg9TbG0eALnE7j6CFBm48TTMKV5TuyL2f7UfvBbyX4aUuONDQQED+dzgai6v4y08wn1
         CQaOC9m6VDvLKVcguJxwKhkp2GYbAkUIH5Ep0XweUXyaK9S7VLohDsjLla8nAXTrrcVj
         MswYHkjuK2ZQ0nW1wX6vLZ3/G0X+QrUkd+qVvE70HPD/ud3p+hQYNc8mOfdj9gOLcqP8
         6e8/rV5PT6vTBQGYDyeU5mNQT/KRw/O8bbF7bkw1mAPyUVfT7xlfHZDkEfLoby2kGC4U
         sKjw==
X-Gm-Message-State: AOAM530w9I4tscf2oeOKel30bdCdXYBnjZz6V1HmA9OFFXsT4g5QCRzG
        P7b4RX1qmHZsG9/Gst4lyuE=
X-Google-Smtp-Source: ABdhPJzEJnWrdVzZl7jdiAPjDlSWwNwnMF62JKv5Y0Ng6YYG7BLqdLEJLudLNO2kd8H3mBO7Yzb6QQ==
X-Received: by 2002:a05:6a00:ac6:b029:374:a33b:a74 with SMTP id c6-20020a056a000ac6b0290374a33b0a74mr35437530pfl.51.1637002997725;
        Mon, 15 Nov 2021 11:03:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 13/20] tcp: annotate data-races on tp->segs_in and tp->data_segs_in
Date:   Mon, 15 Nov 2021 11:02:42 -0800
Message-Id: <20211115190249.3936899-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_segs_in() can be called from BH, while socket spinlock
is held but socket owned by user, eventually reading these
fields from tcp_get_info()

Found by code inspection, no need to backport this patch
to older kernels.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h | 8 ++++++--
 net/ipv4/tcp.c    | 6 ++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4da22b41bde688dec4a3741f510346dae0cf32e0..05c81677aaf782f23b8c63d6ed133df802b43064 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2172,9 +2172,13 @@ static inline void tcp_segs_in(struct tcp_sock *tp, const struct sk_buff *skb)
 	u16 segs_in;
 
 	segs_in = max_t(u16, 1, skb_shinfo(skb)->gso_segs);
-	tp->segs_in += segs_in;
+
+	/* We update these fields while other threads might
+	 * read them from tcp_get_info()
+	 */
+	WRITE_ONCE(tp->segs_in, tp->segs_in + segs_in);
 	if (skb->len > tcp_hdrlen(skb))
-		tp->data_segs_in += segs_in;
+		WRITE_ONCE(tp->data_segs_in, tp->data_segs_in + segs_in);
 }
 
 /*
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 24d77a32c9cbcdf0e4380ec6d9aa3e42d2cf8730..267b2b18f048c4df4cabd819433a99bf8b3f2678 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3769,10 +3769,12 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	tcp_get_info_chrono_stats(tp, info);
 
 	info->tcpi_segs_out = tp->segs_out;
-	info->tcpi_segs_in = tp->segs_in;
+
+	/* segs_in and data_segs_in can be updated from tcp_segs_in() from BH */
+	info->tcpi_segs_in = READ_ONCE(tp->segs_in);
+	info->tcpi_data_segs_in = READ_ONCE(tp->data_segs_in);
 
 	info->tcpi_min_rtt = tcp_min_rtt(tp);
-	info->tcpi_data_segs_in = tp->data_segs_in;
 	info->tcpi_data_segs_out = tp->data_segs_out;
 
 	info->tcpi_delivery_rate_app_limited = tp->rate_app_limited ? 1 : 0;
-- 
2.34.0.rc1.387.gb447b232ab-goog

