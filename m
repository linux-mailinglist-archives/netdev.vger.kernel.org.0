Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0F348044
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbhCXSS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbhCXSSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:18:10 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB67C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:10 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id 125-20020a4a1a830000b02901b6a144a417so6040396oof.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BzVco/Eg/onFpe1i6nNSzFOzajJSuv5MLzRUu8zpDpk=;
        b=ug0ww+4Ujt8NAMxgDUbsMQHavK1ILbGdSNkJ7JaQVT4ANw+VKRe2BBOye5IOLD3qoZ
         ymmgkBjzY75m9JuZhmh5yEQNJxTK5jcKDm1IZRTTHR98pj/1BMqX887eMpYRM6zJ2cgX
         QfJ1Mwf2ae6doIdFmXHFhx4Wl+VnmG73mNx+EncklPveUfe8hFOkEsP5x+IKSjWOHIVE
         exLJta/29UJ6ziuaXVKYJxSVtvdu6AeTLccLWEXz6Z7hNjeLvJg2dNCix792ak7poLR5
         lfec1RQI5bpodUF0ZQGau0sGMkn5Nu24LKnYApRbnk+Lrxef59aLdploURd4NJKK0DOx
         ITPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BzVco/Eg/onFpe1i6nNSzFOzajJSuv5MLzRUu8zpDpk=;
        b=anFJP5f228zT3oggdDopHfAw8QdVcVApFa7zF6/MA63KBSGy7uu3ngpjJLEdXXNwL9
         Odxx7Qnd0vWRLSbKih+2bi61IFmM9tkBUR8dqQRiAR3NiYGHFQ+QL6x11gs+RBGL1cF7
         wbeJxS69DKG+IoHeBU2rZRlb0b33FCUYJQ9VxruzbYghIyXikp4RnwXaUJGKLfF0G1iE
         O6Tfh7n+rbHm2e+lwf8nV95chlmRl/Sgr6JLUEk2U7TuO0VHxgzE58KF6sAe7q5Va5rA
         3kLhp9o9nTa2iYLZGoWqrzR6ikZ9Z7ZolrvHnOSyESSLDia4Pp25qN0a5rGc0hQKxYkk
         tfMw==
X-Gm-Message-State: AOAM532E8tJy7KCgs/uQTLY4aCCQEb9rkZPqDQSg0FV9CRAoFi3MK7j8
        NpUEigdR90LGdRpOAmrCQ2HizN720lc=
X-Google-Smtp-Source: ABdhPJx3DV8Q/57EZrzuQzDDG35i2v06ztmcO9ygjlKLpPWgR7IeY5jFGxh7Hrwf7gkHLMGnZPSb5A==
X-Received: by 2002:a4a:d24c:: with SMTP id e12mr3846458oos.73.1616609889831;
        Wed, 24 Mar 2021 11:18:09 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id n13sm701718otk.61.2021.03.24.11.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:18:09 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 4/6] net: add support for sending RFC 8335 PROBE messages
Date:   Wed, 24 Mar 2021 11:18:07 -0700
Message-Id: <34d0ca051b01f52f5bf80b7f170d5101548826dc.1616608328.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
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
2.17.1

