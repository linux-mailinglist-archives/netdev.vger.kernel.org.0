Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C81255DE2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfFZBod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:44:33 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:38369 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFZBod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:44:33 -0400
Received: by mail-pl1-f176.google.com with SMTP id g4so446673plb.5
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 18:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V6OYgzaqYhr9egvv+LCV2yyF08Pv7oqdefJQ+ajQbqE=;
        b=saP+e6G3P3tQCGJFHxdTGmr4zaoCyVDqAo2xqCuWe7/+uvIjA40ccEyg8zWQL/PtlD
         2tQUr4LCnUrcy1xpnZcRx4tJ3g4xzlYZrN0/bIluckNHwC6EXJpwegKX3rkMesh/GDcI
         Od05VC/5g3bOkVUOHU3rdqzeOykc/dDDZnnJWgS4FzEhNEDaB2vLJ8xPT8pU2IrDglxv
         UWbwunEH8UhOW3YQWqvT0X/A/uiqZvotYtdY/s/xLf5PR8Yggxd6f7PT1JzkGk2LBaAW
         odqRg3lS6gH0GXXuEwGPY6SKDr3BAVRrmgud6mkGkVE5JtHGHusmvnrn+YYv2JzWzX78
         DDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6OYgzaqYhr9egvv+LCV2yyF08Pv7oqdefJQ+ajQbqE=;
        b=KsD/2N14nl4iu24PAVa5Z6MSDeFs5xJZcxiJeRmFyeMrywZjiHqqxSYP4aC1XE0u3N
         adalzgjRz1SOqrMnaPjk94p1xXjutGRFxN9G6HzEh53AcYk7NDBBswOwHj4ndQbexau8
         5xgmEZrOzjcOMJB6vz77czH5o1cGvdOp7R2EoUlOAPQ1UFHF0qUV5diXA7BniBDbHFGS
         uUO89IeEDMcj91EevGZtC0S/sCtcKvEdReR0++7IKiWLDjdG3DTQIEiDBAUclab/jmgN
         RlIW+7osvZktn6w0A9qX9ZdAl2sOcEx59LuqQrLfMJYo6kcOc33uAEkW8iknzcStYPy+
         GCEw==
X-Gm-Message-State: APjAAAUyIawzoZgK14StKX25ukkA3/aSGpqJnJD7b6D+/e2ViYmUjWCs
        LIIOOvA/yo2WDQXmlRukfBZ3PMttbqlq6Q==
X-Google-Smtp-Source: APXvYqyxtBb7tPUPAHzVvXYEWCHwOVvnxSup3qB6Gya2bUN1VfXNR828sYxcIBx0laPC+e/rF8hL9g==
X-Received: by 2002:a17:902:24a2:: with SMTP id w31mr2034084pla.324.1561513472460;
        Tue, 25 Jun 2019 18:44:32 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v138sm17590332pfc.15.2019.06.25.18.44.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 18:44:31 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Phil Sutter <phil@nwl.cc>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Andrea Claudi <aclaudi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2] ip/iptoken: fix dump error when ipv6 disabled
Date:   Wed, 26 Jun 2019 09:44:07 +0800
Message-Id: <20190626014407.19204-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625093550.7804-1-liuhangbin@gmail.com>
References: <20190625093550.7804-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we disable IPv6 from the start up (ipv6.disable=1), there will be
no IPv6 route info in the dump message. If we return -1 when
ifi->ifi_family != AF_INET6, we will get error like

$ ip token list
Dump terminated

which will make user feel confused. There is no need to return -1 if the
dump message not match. Return 0 is enough.

v2: do not combine all the conditions together.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 ip/iptoken.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/iptoken.c b/ip/iptoken.c
index f1194c3e..9f356890 100644
--- a/ip/iptoken.c
+++ b/ip/iptoken.c
@@ -60,9 +60,9 @@ static int print_token(struct nlmsghdr *n, void *arg)
 		return -1;
 
 	if (ifi->ifi_family != AF_INET6)
-		return -1;
+		return 0;
 	if (ifi->ifi_index == 0)
-		return -1;
+		return 0;
 	if (ifindex > 0 && ifi->ifi_index != ifindex)
 		return 0;
 	if (ifi->ifi_flags & (IFF_LOOPBACK | IFF_NOARP))
-- 
2.19.2

