Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114E933A6F6
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 17:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhCNQtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 12:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbhCNQsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 12:48:43 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904F8C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o10so1934723plg.11
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BzVco/Eg/onFpe1i6nNSzFOzajJSuv5MLzRUu8zpDpk=;
        b=TdOb8p4vzXEfDJiAPiX9eNFFI4iQOx8sk71JPvs6hTRwGVblfLFIzRlY+pfj7PIGiV
         mAhHdxdibT4OM9hyFB/7UAfQmAnsCnxYQ761En71Tz1vVYNshbDtMUOF2+TzRu+nybYk
         hubiSDkW+jAZJRkcfhnuW7gsWYWXghMYqdLCUlNC1H22DdDNJMl/++uU1ah0ztGRLuED
         PcpE8YibH++hepSa+rjgy373AiMv0ecHaC6hG6sNg9jgTtZN7/DczF3qRghVm/enDyjH
         88VWdzCDExtImcViWjdvfthcav/nGG4R15rH1BFOt5hTgd08G+dQEG2VHjCtBBgh+xwn
         b9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BzVco/Eg/onFpe1i6nNSzFOzajJSuv5MLzRUu8zpDpk=;
        b=Uu0WsU9Nm59vVwsW60GM3InuUtsgdKTjPpPtVp7jCd5LsqvQASydCzAc8YUzT0OF0p
         dYWoJV/KXPXHddjweUvmgN2kHaznnag/9zlxtdPB/PdSRKgPV2JS3Iv7gb77ietfwaov
         dMOYl3ILqNOdm5Q7hyRrGpmbmIntJT00CjM6LTWBf2VJ98YTGtPb5XwiSy80YGvnl/QX
         38BpCCtit8ASQeLN+XpDolpAAXNrJgDnYpskPnAGCdWBmEm0yzaOe1Y+4XMN+dOBJ7ex
         8SQVC8m+TCa/GCsknLbh10JwU5eUFEAxKJ83nj2A2GhSpzEztQjnCT0CV13ldC3qlz9i
         r0xA==
X-Gm-Message-State: AOAM532Di7zqHibk8fywr2MiY+iLmsriLBcuR3jTs0e8VbZbIBYUD+lj
        4iyOY3teaz6uQFDhIRcAKY4=
X-Google-Smtp-Source: ABdhPJxlPAksuRSJSCn1mhtEZLS5N9M+E7RpSmIV9IauRUeAjYhYzycG/ZLVlaT7/yEP1BPm0meh5Q==
X-Received: by 2002:a17:90a:1696:: with SMTP id o22mr8509872pja.0.1615740523202;
        Sun, 14 Mar 2021 09:48:43 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:ed7e:5608:ecd4:c342])
        by smtp.googlemail.com with ESMTPSA id bb24sm8095469pjb.5.2021.03.14.09.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 09:48:42 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH V4 net-next 4/5] net: add support for sending RFC 8335 PROBE messages
Date:   Sun, 14 Mar 2021 09:48:40 -0700
Message-Id: <4b2fb4075c9ebd607290667ae72cd20d388aeb73.1615738432.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
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

