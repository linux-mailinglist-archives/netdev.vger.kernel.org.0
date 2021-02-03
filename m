Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6A30E74B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhBCXZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbhBCXZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:25:30 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DC2C061788
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:24:50 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q131so843575pfq.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cCET9WBqWjygW6XCStVpWhmRU/4x/+TmAJlTpAVop6s=;
        b=SQ/NnBUFo4RBP+SZcYF6aJNvHN4+toqVo2pVayjfIhUfIqCO4/ub8KMpccTkFDAPjy
         qU7fpUkWRTpLrybjMc9/j2Rh1R2UPlnjFLZjGkXZPvfba4iFSVGFoWyqXjxLtb67VJco
         nn+6riadAfrhOM4NUPeEmvM/hDq5xwSbPbfGxsHXCwFgO74xOTnB+hkYl3lB4t5si4j9
         KSrDjBdP/ru/bK7s1eiToN9WyjQLrlyANF5RMPJhy4a0MPfTMrG+g1Q3ULoTFxEa2COd
         05ulfWynInJnp9JXAz/LK8qEJHNBqcirvuiC6LQPZPBJXblHl2YqYuHQxJdUpmi9JwNA
         revQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCET9WBqWjygW6XCStVpWhmRU/4x/+TmAJlTpAVop6s=;
        b=KhHY4/nJvo/LOUYu7OksXleiQ6xOX7GJqW1T+v1acGWPUqvz1mUsO6MCz5J/IRyeg7
         5PBGeUuKjAN13uiiuaLsRZRG/hg6L+94s/7E00Zl/gkmSlb0yRRDADUKqqsXzSrkn+Da
         qzNO3f4JpJuWWgr7e6Yf/EPxhJRHeR2Aa3F+0jp9NWs0ABGrcwoEegYc8bKk8h44L+4U
         L0mSKJNKnDYC2tuxbh8mx12YLl/QTcYAd5ccp7n6zIhn3Z8+i6bF/8wM1paz0tvtbsqr
         /f/rNYmCABdiPY/bgqYyyCzT2HtFCnoOvjdIPpgbPhor01Miv66PtT/waCNtgVqmLy0/
         40BQ==
X-Gm-Message-State: AOAM532WTRetv2qpfvwEbGMv1hzYkNxXiMTn8iB5F2fgUBP5CrIW4ALw
        RZrcVjfJo3xpd0+eL/W70A0=
X-Google-Smtp-Source: ABdhPJwkiwkIOyyrApbxYqByTNxmGCHnjOzNDccG44yimVVXxZzA8F+SDed9wXSVCL4qqzXnvyYd8Q==
X-Received: by 2002:a63:4443:: with SMTP id t3mr5992878pgk.297.1612394690067;
        Wed, 03 Feb 2021 15:24:50 -0800 (PST)
Received: from localhost.localdomain (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id a6sm2245179pfr.43.2021.02.03.15.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:24:49 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next 4/5] net: add support for sending RFC 8335 PROBE messages
Date:   Wed,  3 Feb 2021 15:24:48 -0800
Message-Id: <aa55b7a6a6113bccbf15108df219eef0c77ebf51.1612393368.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
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

