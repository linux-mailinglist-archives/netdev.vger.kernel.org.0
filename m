Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7D31DED3
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhBQSJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhBQSI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:08:58 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C6C061788
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:18 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id m2so8982680pgq.5
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cCET9WBqWjygW6XCStVpWhmRU/4x/+TmAJlTpAVop6s=;
        b=p+IaIuWFFkmokc3g4KwFW6xT4Tn0Q5L7nmb+PFWe4DDAek9JQxTI7OaObBWnEk4iBN
         cCQLMT32L8JdRRD9SLR0yiCq6t75mVo7E5cxblodQutlJPGfRLXEdW67SoOV/0UVpx+F
         tezdyTB+JclEV7CsS7UrkWNJ3liO0FkYfOrQzzovepfur5fD5xAA0vwcDsg9QXODrTiX
         BvgNIMbAPNcd8JHqewK5O7q4aqNAGWUHzUzijIDTwYCmy4rE4HKGvIAksz04amobnMT0
         FrkCHgf2eFD4HceY0VDaRVaEH294g7+x280SjKCeq3zbyawW6XwyPclarWAbuk21kiMf
         eyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCET9WBqWjygW6XCStVpWhmRU/4x/+TmAJlTpAVop6s=;
        b=M6H+g7Zz6X2tW0hl9/ccppF1zjnWnss5Jmhhh0rNrw1QrCkWtUXA4qwTPTSna67pci
         oABXn3nHKhadxmpJpcstA7qnW6c+foZN9CwZCoAkZdVBtfz+qT9GA2ll2nINe4Nb2G6Z
         d0kuVfNEz1OXoiGcgxGv6g9qepJ8BipHsohQl7KVYy79W4pBRlWtsIsdINsdQc55B5Y8
         pu0zuiMivlJUqzGBRZEGw8NujCBpM2coBJkN5VVA36Dp/NA3q7jSVJnjEuyn3ix11R1d
         5yoFAtIOQLprqtxgssAxWaI4l22NOBbQOl2A0MfvPu40azMb8eacuoBqEFfJ1zf6/dZ7
         afIQ==
X-Gm-Message-State: AOAM5310HabAv1J2lYnpmafO4N9we75BxlSRtiDkv9njTG8fDYujerLV
        KlGIFYNrYpKZDejb95ISjIo=
X-Google-Smtp-Source: ABdhPJwO7YJsdZRY2QF410cH7sMhkTu2z5r+XEn6NbmaAn07Kwl8WN+GXYAlKUshCRoTd0fdaQJaDA==
X-Received: by 2002:a63:2254:: with SMTP id t20mr537205pgm.230.1613585298158;
        Wed, 17 Feb 2021 10:08:18 -0800 (PST)
Received: from localhost.localdomain (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id s7sm3218558pgb.89.2021.02.17.10.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:08:17 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V3 net-next 4/5] net: add support for sending RFC 8335 PROBE messages
Date:   Wed, 17 Feb 2021 10:08:16 -0800
Message-Id: <4b9b6324310cfea00e8f8a0c0dea2c35134ee2e0.1613583620.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the ping_supported function to support PROBE message types. This
allows tools such as the ping command in the iputils package to be
modified to send PROBE requests through the existing framework for
sending ping requests.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/ping.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 8b943f85fff9..1c9f71a37258 100644
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
2.25.1

