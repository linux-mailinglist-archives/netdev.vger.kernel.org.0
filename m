Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA943FA802
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 01:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhH1X7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 19:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbhH1X7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 19:59:20 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37926C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 16:58:29 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id f2so18682762ljn.1
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 16:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vaw7+EGtDVmvakBZapwviClraNwR4N7ABgcvGSn1w7I=;
        b=RfL+F9xAaxNhIEILZAxYGxY10fRYs4McHJ5Wr8A5vB9GfSUpWCVAy979+M2sztxvut
         2RXjxaR5g242aVy/nRMZbdWzHsGerOYqo+inRir6QRIqGt3P8b0rsbL9YXbaFH6OqwYk
         okZuOWFg7jUQ7S/b6Lbjg+WfUoQZMKUIvJ3HqUlAq4jaabrW0tLFDkYpAnDVv0cI7Izm
         uHNnoS0pyejmaz4p1w1cdWmExE1aAUp48vgEIx8YGhoPujY4i+t2GnQscKBaxiqLFbeG
         EdyoyVIWsqok+j7Npr3XDdMSYF/LuES+2FMHFjXXsxA6Uy+L54WqoajUpUTTiploKfxt
         HCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vaw7+EGtDVmvakBZapwviClraNwR4N7ABgcvGSn1w7I=;
        b=cGDj0ujKzGoONmmAL9ysOu1Vr5HGlX0rj4ArR2wrq9nmq6GhcdyC170VyQ4A/cCcBs
         i9J/bpnwTVBpXzck907/XeBIEznsRtwlrco5isTprSNuXODrupiyBrzeMegjll3erBou
         UIdRKPQqGFsPgRqdQtDoZTq+KzA4JGYsrqjzQF2YbHnfcNyYa4VV2GChmCdiURLbdoQS
         HRJh/K+Q6XmHXIaQ8tzCGGYIzYv90u9mvbZlO8daWEsguoeOIBeAshzotMcgIdK+7zB0
         3Jutzjc9JbmS5vff1HL0CjjPIbp9b3+Z4aAhRsp5MScmptHpgYU6atOHfco806Mh9mIj
         /VRw==
X-Gm-Message-State: AOAM533Ed0GSBR/Ap2rhJr6J3YtFo/KcL1gNa1A43g6JjXHhBDxO2EfA
        84XVLfxkV29k7j5ajvF5Ed2jbg==
X-Google-Smtp-Source: ABdhPJyBYG9jMxRzG2edNvc4c8NNizK9EV3RvlHcIUXhDg3Xv63F7qGuSo1hVO/SXeVlV9by2WUlyg==
X-Received: by 2002:a2e:a413:: with SMTP id p19mr13736150ljn.412.1630195106793;
        Sat, 28 Aug 2021 16:58:26 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id w16sm986914lfd.295.2021.08.28.16.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 16:58:26 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [PATCH net] net: dsa: tag_rtl4_a: Fix egress tags
Date:   Sun, 29 Aug 2021 01:56:19 +0200
Message-Id: <20210828235619.249757-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed that only port 0 worked on the RTL8366RB since we
started to use custom tags.

It turns out that the format of egress custom tags is actually
different from ingress custom tags. While the lower bits just
contain the port number in ingress tags, egress tags need to
indicate destination port by setting the bit for the
corresponding port.

It was working on port 0 because port 0 added 0x00 as port
number in the lower bits, and if you do this the packet gets
broadcasted to all ports, including the intended port.
Ooops.

Fix this and all ports work again.

Tested on the D-Link DIR-685 by sending traffic to each of
the ports in turn. It works.

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/dsa/tag_rtl4_a.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 57c46b4ab2b3..042a6cb7704a 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -54,9 +54,10 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	p = (__be16 *)tag;
 	*p = htons(RTL4_A_ETHERTYPE);
 
-	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
-	/* The lower bits is the port number */
-	out |= (u8)dp->index;
+	out = (RTL4_A_PROTOCOL_RTL8366RB << RTL4_A_PROTOCOL_SHIFT);
+	/* The lower bits indicate the port number */
+	out |= BIT(dp->index);
+
 	p = (__be16 *)(tag + 2);
 	*p = htons(out);
 
-- 
2.31.1

