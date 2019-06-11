Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831193C805
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 12:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391273AbfFKKDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 06:03:32 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38551 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbfFKKDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 06:03:32 -0400
Received: by mail-lj1-f195.google.com with SMTP id o13so10982027lji.5
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 03:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1U2C9g+Bn7fkKn6QJKsmlU0kk4+d2eQYyM+C8yfSRs=;
        b=sSKqCYAW9cYne1BgtwQIccsCBxTMI1ws+LxwuzGTMzxOoez3TrFBOA83sqjp8tUred
         fjbue8+legI2MXiYWtb3zY0X/Hv8sdq4yjifCr7BKcCJQF7Ho1P+TNrB8imYB+Aubx4h
         YA5kjQ58ss2+8Ie8SNJ22wtKIBX0RQR0QkzXdFhu27YmuRcBXXRrFEpE8c5I/b1SBxbr
         fNbkN1EnzcoikW1zqdAE2FrZMwswk2lhhyhl0E6VdzsoZ7MCCQdUdWHdzhQ8YWNR/HMt
         l3wMbqyKnl2oNyncfD5wXyKwqWYryf3/+Woac2v7EGek5fa1TRahsXD2KEbBKXIsT7hJ
         pFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D1U2C9g+Bn7fkKn6QJKsmlU0kk4+d2eQYyM+C8yfSRs=;
        b=IsqMmbrv9NrItuZFZj7vmAFOj3c0haLjtdcXrH9T8qSvOL4zeSOPcsPyBTrXiaypvH
         OHQzQFbmiTOR3n1wsGaifI8v3rI6OYx3w48apJlR5J7pyMzPyECy07QGOYfZTpjp/QTi
         cJkHEOvcIrNLXg8Kil0xGvS1+lyA6+WnWofAen0TOmGcVQwM0VQpIaDcJvIJiiL/WHmQ
         ikTU7YotrO0Pdrm0ZTQAQ0ucmPyzzItPMm9bX+nAQ4OuKQWoqbwkP0f3PHqDC4YFbEcd
         jCds99Y2J3QwQyYbdT8tWoK5733L5yge0Z5yx5Ozt54Ii62G+/dvTE8DzYHPtdx3FQPk
         cvTg==
X-Gm-Message-State: APjAAAU5PW+Jj/RNOZek2rajbcEB1WFFf9rXNILTuvD3uB9jrJ4bBb23
        Ouo90OVZj95HaE+v74HSd1CURQ==
X-Google-Smtp-Source: APXvYqxvSxZxJ844lX9B8OhaWiKW5KxExfU5Kjz0dPieaKjSzc3z3mG2nPF0Pjc96WBjmcG1YlQQnw==
X-Received: by 2002:a2e:8591:: with SMTP id b17mr28946871lji.71.1560247410437;
        Tue, 11 Jun 2019 03:03:30 -0700 (PDT)
Received: from mimer.lan (h-29-16.A159.priv.bahnhof.se. [79.136.29.16])
        by smtp.gmail.com with ESMTPSA id e12sm2444755lfb.66.2019.06.11.03.03.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 03:03:29 -0700 (PDT)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jonas Bonn <jonas@norrbonn.se>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH 1/1] Address regression in inet6_validate_link_af
Date:   Tue, 11 Jun 2019 12:03:27 +0200
Message-Id: <20190611100327.16551-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 7dc2bccab0ee37ac28096b8fcdc390a679a15841 introduces a regression
with systemd 241.  In that revision, systemd-networkd fails to pass the
required flags early enough.  This appears to be addressed in later
versions of systemd, but for users of version 241 where systemd-networkd
nonetheless worked with earlier kernels, the strict check introduced by
the patch causes a regression in behaviour.

This patch converts the failure to supply the required flags from an
error into a warning.  With this, systemd-networkd version 241 once
again is able to bring up the link, albeit not quite as intended and
thereby with a warning in the kernel log.

CC: Maxim Mikityanskiy <maximmi@mellanox.com>
CC: David S. Miller <davem@davemloft.net>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 081bb517e40d..e2477bf92e12 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5696,7 +5696,8 @@ static int inet6_validate_link_af(const struct net_device *dev,
 		return err;
 
 	if (!tb[IFLA_INET6_TOKEN] && !tb[IFLA_INET6_ADDR_GEN_MODE])
-		return -EINVAL;
+		net_warn_ratelimited(
+			"required link flag omitted: TOKEN/ADDR_GEN_MODE\n");
 
 	if (tb[IFLA_INET6_ADDR_GEN_MODE]) {
 		u8 mode = nla_get_u8(tb[IFLA_INET6_ADDR_GEN_MODE]);
-- 
2.20.1

