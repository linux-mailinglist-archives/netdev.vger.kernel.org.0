Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F84F2F4E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389128AbfKGN21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:28:27 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36321 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389003AbfKGN2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:28:03 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15so2286330lja.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E+91P1B4I9nUdKLz0FwOjZwRdttTAkpiPZ4BDPYb2xA=;
        b=g5WpoUbS7tBcQdvpARR9AGtrAIvtk6MXU53yoZ8VIwHDb1Ya/JtCWE1CNjVHPMPlav
         ltgeX4wpZTM5XFSYSZn1DAfKp8WCSoRDGSj1qcnA86GHrcU0GJQP4uVr18ptoVzAhY+5
         KwQb8Sw+D9Pu5VkMKBgfSFf2Iqluzs6RfNO5LNQuq/l1/Ttwxexb2mY4Mg5wWyYjE9wQ
         0XSY/Q7ikoNUCAr5aH3PGRGrluOQ5dHF+WNTEgLkDWY112pEjzJ1mrYRkCmI0jVLCGTl
         wD8YlD01Ep2FJQmBGBAr6Mh6f4t/TWfMr+2TZyBk5D9JCEbIQ5eAPEl8+PMGp9nbwh0i
         m5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E+91P1B4I9nUdKLz0FwOjZwRdttTAkpiPZ4BDPYb2xA=;
        b=nLsvY9QMa5BVI0vCsWF6Ltke/znJQgm4RlaoUYiF4uIQYoWqQWZ7BcZPhfFe4gmMzB
         +dSJnxbl3aTRHbr982LD2Bo7PTMqdYe1ZKmTlGNheo4Nrv6RGY5ioUKnZVU03spIPXaS
         kgNZ1luc0BmEq7qJIkRsjWPNmakEoTR5NAiAGubhKcM2mhW5SSSKy3fx5kPJC+HM0JEH
         Wqs/V8yuWmpsFAKigvu0u+6r0bBbQmrMnBmyqitk9O+l6PAwAchAQ0K9yrKt+5emS9pX
         XAUVaRCi9y3eTW6ivfIFoqm2ezY7HfJEkipzBIIdw+OhxvuJmF48WkBGXeqgIRM5ctpC
         BhEw==
X-Gm-Message-State: APjAAAVYGy9C0dP8kYPzYgRBFNfM1earCqTI+xrWcv2aFBkVf9XqXpvA
        34LE+qZR/Q2Mr9av0CSvAuiSLQ==
X-Google-Smtp-Source: APXvYqwn+iQ3pVojvgDyvsr6gdQbHu0WY7g1yYKAvcNBdTRdeMj7qL3wttyDLkyFw+z/p7RjuNscIw==
X-Received: by 2002:a2e:8608:: with SMTP id a8mr2576547lji.172.1573133281587;
        Thu, 07 Nov 2019 05:28:01 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id y20sm3151507ljd.99.2019.11.07.05.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:28:00 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v3 2/6] rtnetlink: skip namespace change if already effect
Date:   Thu,  7 Nov 2019 14:27:51 +0100
Message-Id: <20191107132755.8517-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107132755.8517-1-jonas@norrbonn.se>
References: <20191107132755.8517-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTM_SETLINK uses IFA_TARGET_NETNSID both as a selector for the device to
act upon and as a selection of the namespace to move a device in the
current namespace to.  As such, one ends up in the code path for setting
the namespace every time one calls setlink on a device outside the
current namespace.  This has the unfortunate side effect of setting the
'modified' flag on the device for every pass, resulting in Netlink
notifications even when nothing was changed.

This patch just makes the namespace switch dependent upon the namespace
the device currently resides in.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/rtnetlink.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index aa3924c9813c..a21e7d47135b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2394,11 +2394,15 @@ static int do_setlink(const struct sk_buff *skb,
 			goto errout;
 		}
 
-		err = dev_change_net_namespace(dev, net, ifname);
-		put_net(net);
-		if (err)
-			goto errout;
-		status |= DO_SETLINK_MODIFIED;
+		if (!net_eq(dev_net(dev), net)) {
+			err = dev_change_net_namespace(dev, net, ifname);
+			put_net(net);
+			if (err)
+				goto errout;
+			status |= DO_SETLINK_MODIFIED;
+		} else {
+			put_net(net);
+		}
 	}
 
 	if (tb[IFLA_MAP]) {
-- 
2.20.1

