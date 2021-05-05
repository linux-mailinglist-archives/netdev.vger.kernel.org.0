Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037D33746E4
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhEERcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbhEERbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:31:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8935CC049545
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 09:58:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e2so1427727plh.8
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 09:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qtQrR5pj/ogcL3/YBIIjQKtTJ2qDM4voCRxl7aNUJ9k=;
        b=tmjpxzPhQtGLs56o87bIdbDI2+st2rR/L8dgwgDPUTCaSjAVpmx+7+FZ6+JHsaGLVp
         r3QS4C+FK1RlzgeFtljR+I+sYkqM5Jk/vW/dF6WCMozKvqgvO27RfF2wqR1iFiWPOv6T
         rldHpWXsfWSJ/eR1LcHZgg7DoInYIwtX3pDik7axmMKrXwlQ4fHpzgTMsBJ7z08cBcRn
         n1Vk00N6AOzKNRfGmy3rUDoDFFYQjwKaQ0rooVBlelqfr/3XEw8aF5Lh7+3c0DMfjSd2
         GCeGcSzn0E/QYvTcWCbMaLPhfaRGOtsTrkwPyzQZu0GgZn/1uZnnXT8D8Gq5KFhgNQ/2
         C/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qtQrR5pj/ogcL3/YBIIjQKtTJ2qDM4voCRxl7aNUJ9k=;
        b=lwXQPXXcGlgVN8OPJKaS96O3HcyfN8xdDGJfhl+mz5bhj4q0LgV6t7GXsGT4Q5XbjM
         UeIb64XihgRcJNb3AOuRbxCIJ7RcuHHxNE2uVwG4wQqvnBvGTh5tDUK+VA84wChuNLiu
         0jSyEVhWjLAKscYGnPd7RDjlAFgD/6XwZhP9+4As2d5kpx3W74/VtJgNdjHANwvNlT4Y
         /XYi9RtQAmoGvlq6THjYRpSHYCT/IDzcejJRP7S9xLmeIoutM5Y/6kKE+FyztZWSvhF6
         1ll7YlsXiMQv0KN7HJKMaQ1ZrrYSPXlXlywimDdzF6IL/n1kigZ//vJbmxLz2Ye1XOA8
         RJWA==
X-Gm-Message-State: AOAM531cFYuIdG6aIQIXBlYqaBzl934DxXMUe+q998vyav3delCDSYfS
        TG51kXpLzvKW0VJcdDct+5c=
X-Google-Smtp-Source: ABdhPJyvRrkli6d9svfQtfLEAfd+DTu8PR0guPnREa/0BQg3MValPCLdgihy6GtFvM5NFBv/4aafRw==
X-Received: by 2002:a17:90b:b05:: with SMTP id bf5mr36384995pjb.123.1620233921037;
        Wed, 05 May 2021 09:58:41 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:3fb8:c336:5d98:38cb])
        by smtp.gmail.com with ESMTPSA id n18sm6504720pgj.71.2021.05.05.09.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 09:58:40 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Nucca Chen <nuccachen@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH] net: fix nla_strcmp to handle more then one trailing null character
Date:   Wed,  5 May 2021 09:58:31 -0700
Message-Id: <20210505165831.875497-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Android userspace has been using TCA_KIND with a char[IFNAMESIZ]
many-null-terminated buffer containing the string 'bpf'.

This works on 4.19 and ceases to work on 5.10.

I'm not entirely sure what fixes tag to use, but I think the issue
was likely introduced in the below mentioned 5.4 commit.

Reported-by: Nucca Chen <nuccachen@google.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
Change-Id: I66dc281f165a2858fc29a44869a270a2d698a82b
---
 lib/nlattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 5b6116e81f9f..1d051ef66afe 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -828,7 +828,7 @@ int nla_strcmp(const struct nlattr *nla, const char *str)
 	int attrlen = nla_len(nla);
 	int d;
 
-	if (attrlen > 0 && buf[attrlen - 1] == '\0')
+	while (attrlen > 0 && buf[attrlen - 1] == '\0')
 		attrlen--;
 
 	d = attrlen - len;
-- 
2.31.1.527.g47e6f16901-goog

