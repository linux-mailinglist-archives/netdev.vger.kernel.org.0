Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58808327F95
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbhCANeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbhCANd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:33:28 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE32C061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:32:47 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id p15so10472623ljc.13
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 05:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pcHwrN0wdUgHRkW93Ilur7+SDuQt+zWeqr8EgwbfNpo=;
        b=nDVoUXsCLk26fGNNhSXXaXw6sR/qR9qagJ+MuZURL55GuNY25R96U9wauI0HryK0jp
         ez7dndZwAJfpv9ohgkDmAK7JWHMlNfjWwJWrnCs8mlgFSht5bk+cORgnPvDAH9fkNCMI
         SWEwSSNKp43YmycTufGOGOgVKUWbWDQYTtWKC/Hpqn58qT5O72+ejnFVuxhkk2fAJ2aR
         /9cRkhp0HkG+iXcY98nQAiE05WsOFVtx2FH3fHKk9+Fdp0dPDIpv4gy+L+cuDWyUhRyq
         7SLKXrTzus5JMedgDKnDonZGGEIdb0wwiJhr7r6AEW6jl6mo9TN5u3a7/3UdooMa9Mf/
         d8Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pcHwrN0wdUgHRkW93Ilur7+SDuQt+zWeqr8EgwbfNpo=;
        b=XCbP5FWCubGxk8gJrWMlZkDKMtykOJJkHEmEjxk+PiIWy4afcXg/MefkMZKLf/aptP
         tNhSpa0Vxg3BFWSSFTg8/TyGLPbbzuHiCXnLWBGmLBt+JfmafH/wDCQP5iUrOXJPGwBv
         yhzJFzwTyeaPyf8DKN1v5GG+DqLZArbs9VBm+YV5w2QzW6hER/XOfyNQHdk2PVHqpMg/
         q0wnVcErxlThoOJdxeybxJnFJex6gatw2/WulAqNBfHYxnIs56bZjDz1SiB/KicjS5u9
         p8t9Ob9acPqMY1HPPn8w4YEz5+e78GEhrpr81q5HkC4ggjS3AFptDVe9tO4scYzH6FSC
         p7ig==
X-Gm-Message-State: AOAM531vqAJHxYc2WWrs3WWMULBdMEduwCjb0jaLn9Jb3aYFTmkFy2Kf
        bfTxZF9Rr1Ca280kakwQKZS1fQ==
X-Google-Smtp-Source: ABdhPJw3k4r8JgUncNdDhkbexyVZJGTb73S8fwY4Vi7Kyi0DC3HHviucbdtcyDov+U8ZpGdWHpSNyg==
X-Received: by 2002:a2e:9791:: with SMTP id y17mr5165862lji.343.1614605566175;
        Mon, 01 Mar 2021 05:32:46 -0800 (PST)
Received: from localhost.localdomain (c-d7cb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.203.215])
        by smtp.gmail.com with ESMTPSA id c9sm2310066lft.144.2021.03.01.05.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:32:45 -0800 (PST)
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
Subject: [PATCH net 1/3] net: dsa: rtl4_a: Pad using __skb_put_padto()
Date:   Mon,  1 Mar 2021 14:32:39 +0100
Message-Id: <20210301133241.1277164-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eth_skb_pad() function will cause a double free
on failure since dsa_slave_xmit() will try to free
the frame if we return NULL. Fix this by using
__skb_put_padto() instead.

Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
Reported-by: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 net/dsa/tag_rtl4_a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index c17d39b4a1a0..804d756dd80a 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -40,7 +40,7 @@ static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
 	u16 out;
 
 	/* Pad out to at least 60 bytes */
-	if (unlikely(eth_skb_pad(skb)))
+	if (__skb_put_padto(skb, ETH_ZLEN, false))
 		return NULL;
 	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
 		return NULL;
-- 
2.29.2

