Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8AB36876A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238770AbhDVTs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVTs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:48:27 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D675C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:52 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id j3so22657945qvs.1
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 12:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BS4wMwOPy/+FHjBI5zqFwcN+ZsoK7V+Tg4hNVIYePko=;
        b=bVdYBzlCTCPh2RPU1AwFeo6nFmXpYrGgvQn164/liqW9Rw+cr1m7NWmBvrllzOm7Fl
         dvTXupIpxNlojbW5Bip3G4RNaNsn2/hn1fnA5nCl68TCPz4OlBmac7An/IyuAxSm++kV
         5rAaWMweAoONZkbM8XbbvKUzpNJHxccURIsQVxLUm3eg4L5MqO6gbRpGA+7OJRlbWbnn
         Vg68Gw1tbrIhHBh24oS9VEPi3QPf9S270MqxlV1d+WROuw/BZvx3WKeQlBAVb8qq/UB1
         RaPo3aqk5pPPJIqgUV2xIUV2BAU8n9uCpD/hQEHWzjxR9CmGcMIpwIpmogeRBT2zdIGf
         sGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BS4wMwOPy/+FHjBI5zqFwcN+ZsoK7V+Tg4hNVIYePko=;
        b=kLl2HF8T0E4020w1Uw8mpMe2o5GgXtMMveewKXE3/RuK684d3nN6B1E/CPOf8pGo2J
         9xE1aY5y1mpdlRaK7R6fplXtO+6xI4LNtEFA1k0giAleggNv25rJe3TWK/TCPdBNAq6J
         YkOAHFjbX4Qrt+wkk0PeAw9jlm5qrb8FL1ePezuQ9exbxC62js5mPBa0fiAy934IUjPv
         srYbgxytcucOD2dLjOGKfiPwPs14NZbk2tgXSzHY50JqlkvLVKnsvfc65FMbJkPuJxk4
         Kp1UL0dnsq8y7fd7OxdCiBOxY+kke5qO8nJODsYH4R26WJ0min+EXkpbaMl7diz4likZ
         hSEw==
X-Gm-Message-State: AOAM5326YmBDITc82gB4GNSFq7u9/8zc3b1EtZlQ7UkPBLNpvXPtdVfg
        0p5b4vCGy4CjAqlBKBXEkh3clAOTzo4=
X-Google-Smtp-Source: ABdhPJwIrKwrU1Ig5eGcFlLijh9jc7JwHmpA2YBtD+06MDMKAbeobUwd9uN3JPFBhaJ/jHZ6oM955w==
X-Received: by 2002:a0c:da13:: with SMTP id x19mr522653qvj.53.1619120871601;
        Thu, 22 Apr 2021 12:47:51 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:e069:ac66:9dd7:6f76])
        by smtp.gmail.com with ESMTPSA id a4sm2821781qta.19.2021.04.22.12.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:47:51 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: [PATCH net-next 1/3] once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
Date:   Thu, 22 Apr 2021 15:47:36 -0400
Message-Id: <20210422194738.2175542-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
References: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Certain uses of "do once" functionality (such as many occurrences of
static bool __section(".data.once")) reside outside of fast path, and
thus do not require jump label patching via static keys.

Implement DO_ONCE_LITE, which offers this "do once" functionality
without using static keys.

Implement DO_ONCE_LITE_IF, which offers the same functionality but
gated by a condition test. This is common in current uses of static
bool __section(".data.once").

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 include/linux/once.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/once.h b/include/linux/once.h
index 9225ee6d96c7..a92bb213f817 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -52,6 +52,22 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 		___ret;							     \
 	})
 
+/* Call a function once. Similar to DO_ONCE(), but does not use jump label
+ * patching via static keys.
+ */
+#define DO_ONCE_LITE(func, ...)						     \
+	DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
+#define DO_ONCE_LITE_IF(condition, func, ...)				     \
+	({								     \
+		static bool __section(".data.once") __already_done;	     \
+		bool __ret_do_once = !!(condition);			     \
+									     \
+		if (unlikely(__ret_do_once && !__already_done)) {	     \
+			__already_done = true;				     \
+			func(__VA_ARGS__);				     \
+		}							     \
+		unlikely(__ret_do_once);				     \
+	})
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 #define get_random_once_wait(buf, nbytes)                                    \
-- 
2.31.1.498.g6c1eba8ee3d-goog

