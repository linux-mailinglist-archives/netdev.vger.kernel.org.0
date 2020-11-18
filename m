Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EEE2B735D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgKRAra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRAr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:47:29 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EF4C061A48;
        Tue, 17 Nov 2020 16:47:28 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y22so50138plr.6;
        Tue, 17 Nov 2020 16:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VVUDsIQSbxm2kV6TXkpMyNop6FcshPxk4X8Om/Gvsg=;
        b=C3jo8906JKjYOkkYJIW9j2p4HK2VlJk9cY+Vbx1gNpN+dBsDkZctcOkWnY77EyQaf8
         XAPkUoRy3Ua8vQVyH/L1njUgvRdyXxmhf1mr9XPhTafx21sLi1cxtBIJDS1X6cOJq6yc
         /9zs5N5oFfEmj9bPRp/Lnx/WJK3CXP0lTgZSRPDX/9PmyAIRUfIPOJj9FhDaAn2PliYZ
         XHwujUqfseA7CctUHuorAMx6hnfbCPuou6Tx82IGxtCXd1ijUoNHTEvujKgISTT1h9Ds
         13PB6xRp8+apXZm4ZLdxUTvIkkB/EaChfr4RbrCxYfUEHcv0+SX1PsJyYCgQgIEwRMNl
         vJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VVUDsIQSbxm2kV6TXkpMyNop6FcshPxk4X8Om/Gvsg=;
        b=WtlKi3m4ZPT3PpyHX2HaahKPyNfD172QWmbxiKKiIvGxuoedbWgFHqCZDRiOLZCC3A
         GCQN/n+eyDA9KcxLLNrQRWhGh9JSrDvoigY3hXmkwfOPrW1Z2y2pLsIAkr/P76Hgyp7F
         pVYR01EtpRiBkkg0TNF6r6+yO+QX3SAyhOisFtcX3BDIpnPlvoDwkKnO/1rjbtDTYfWM
         NqESgLc1m63CC5FPBZ04veMIa/vxJfjOHV3+ZQtVj3zCHJMTWpp1GRYKDqRK4zggEmZi
         uUFbgkcwGiwGQ+MeRjK4/EQXMgtoShedRjIUuyXpJELlHwpuZqv05Z8Xqq/lOGax5ZA9
         b9IA==
X-Gm-Message-State: AOAM533Q03/MOyP8ax3Jol4YkfmpQ/cG7gRiNlmeJPo21ZTv+BT7i+JE
        8ukNGrt5UOvnp3rfy4/EmScic81pkcpnvQ==
X-Google-Smtp-Source: ABdhPJy5UWxuFtmpm7KypkH7TEKSVPcZs2RVxxqutxJLsY9riHHM0IT5Bvga844ocE2sOv79zwISoA==
X-Received: by 2002:a17:90a:5217:: with SMTP id v23mr1581575pjh.160.1605660447897;
        Tue, 17 Nov 2020 16:47:27 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id y124sm22355993pfy.28.2020.11.17.16.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 16:47:27 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 3/3] net: add support for sending RFC8335 PROBE
Date:   Tue, 17 Nov 2020 16:47:26 -0800
Message-Id: <9b256be32638926353a24c5600a689e7b339d595.1605659597.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
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

Changes since v3:
 - Reorder patches add defines first 
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

