Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C812B30D1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgKNU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 15:56:13 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0ACC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:13 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id j19so2813028pgg.5
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/q0fXt+FVXhTYsCnuA0Q58p8WBaZGG366BanZYoQ8k=;
        b=DIH8j0hX5AuilDWb8R2NVRHuYsHN+9a8+CONjwRsEqESR16WFDpw50oiL5TKSmNCrt
         yKOLZYO3eMP9Q2h3BcU92e8UzOuiXoZvHoave2arHdSiryAugM8aDd5vgk5f1M9c8dHj
         EjBrYO5pj8a7wkLJ7AheYCW/zUlaY47WqWN4V8RUcaF19uxhPb4uIyDmyHReLl05PzMM
         b7srEc88k/nOCFVVueaMrD5lKJ7ejFSOympdYfW2NiMLY52it8sPcAHO57sHtaz1sbPL
         X7no7m9SM0vleWePTv91Wr6MvZlqToJCIij30Qd6QYFWrr8BmZUGg4HV7vwh9nCjFzFC
         sTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/q0fXt+FVXhTYsCnuA0Q58p8WBaZGG366BanZYoQ8k=;
        b=DK29uYRt8vm+fS1FW+IhXdgh16aIHDVvpZ8f3BGfshzrjT0lSuPs68XzU69j9RPrgX
         WOarhsyiNQJDmiKG1i37csbqc1Tuu3OVcvMcXLvL/5Kug3TjnypCTen9Rs3v7O7s0p7S
         p0fiFVZbIkaJSSwVsOu9pUaawxaZIOy2WWyPf/MBwe1G276kKDuYgguDcPWuIbwFXVbp
         924yUbIUc3dqMJ70baHEqDISA/ytE8MZdtkk3Ne4FR/Xx8nOpT/KKDCOx2Gb20z/sxD1
         EAdw3N5kAAKQoFkfpcIwGs0ViK9u3UQBbAxCEAHyRBarleJGuoHnO4W6ma+tVIzCCLBh
         Pbgg==
X-Gm-Message-State: AOAM531yBEK7nsjFaB3q59HNsKirZN1WKbfVSFUOodS3qE+bSVQecafX
        29eu6I9MHl7f5hrIBXAwN8o=
X-Google-Smtp-Source: ABdhPJy6gKLt8IFgBlQ3pS9vHd7NRhauCKUJ+9EyGKaDhoiglocoKTF8NT4GzNiZS+AfJI4VvU/4fg==
X-Received: by 2002:a62:1b0e:0:b029:164:228b:f063 with SMTP id b14-20020a621b0e0000b0290164228bf063mr7526141pfb.75.1605387373045;
        Sat, 14 Nov 2020 12:56:13 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id 92sm15996783pjv.32.2020.11.14.12.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 12:56:12 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 1/3] net: add support for sending RFC8335 PROBE
Date:   Sat, 14 Nov 2020 12:56:11 -0800
Message-Id: <d038c95149a0497e4fda40f856e1a1179065da9b.1605386600.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
References: <cover.1605386600.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modifying the ping_supported function to support probe message types
allows the user to send probe requests through the existing framework
for sending ping requests.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes since v1:
 - Switch to correct base tree

Changes since v2:
 - Switch to net-next tree 67c70b5eb2bf7d0496fcb62d308dc3096bc11553
---
 net/ipv4/ping.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 248856b301c4..39bdcb2bfc92 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -453,7 +453,9 @@ EXPORT_SYMBOL_GPL(ping_bind);
 static inline int ping_supported(int family, int type, int code)
 {
 	return (family == AF_INET && type == ICMP_ECHO && code == 0) ||
-	       (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST && code == 0);
+	       (family == AF_INET && type == ICMP_EXT_ECHO && code == 0) ||
+	       (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST && code == 0) ||
+	       (family == AF_INET6 && type == ICMPV6_EXT_ECHO_REQUEST && code == 0);
 }
 
 /*
-- 
2.29.2

