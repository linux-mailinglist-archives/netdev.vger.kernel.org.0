Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104F85A687F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 18:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiH3Qfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 12:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiH3Qfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 12:35:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3000F220E1
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:35:36 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661877334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GlgFQz5OkagtqJlWT5jLpBRUzvAEIB6+i2RwxsYrHPY=;
        b=kiqmysfUj+GJeWVUgAkUit4vLRtkM9tHlrNsiIACYQBUp5TEJob2SVyb2s1nIimaxl+0C4
        2Eovlpv5ky/i7r9+uiUBHEuZS0Bc2XjzgsfX0ubbML/UdCB0bforzO0+6dCOsr3CBpbGYR
        SzTl12xK+nACb4hJ6xlOeoL+M1+AzgH7m+RaMDXdPlpg9xOtxcPZ4fjTNJ1xxV/iqibd1X
        TMJTzOBG0OEZyRSMlmjCPk9lqyk5rk+6zqAw9BWgtuAbyyJcUb/yMA0ZszLEgVuq6zTz/c
        dVcTTLluotEa00l6In8obhnb9GQy1WkVC1YUzP9i3gODDlh91R2fvb7pJtVVEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661877334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GlgFQz5OkagtqJlWT5jLpBRUzvAEIB6+i2RwxsYrHPY=;
        b=vK/B/gKZiRGUahda22KIToSgpth18j5uddVjeRJZdUsWDCYTJL5KIipUfTrvjZ8k4zbmPw
        iDCRr+yB7a1E+4Dw==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Date:   Tue, 30 Aug 2022 18:34:48 +0200
Message-Id: <20220830163448.8921-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the source port cannot be decoded, print the warning only once. This
still brings attention to the user and does not spam the logs at the same time.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/dsa/tag_hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index eb204ad36eee..846588c0070a 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -45,7 +45,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev) {
-		netdev_warn(dev, "Failed to get source port: %d\n", port);
+		netdev_warn_once(dev, "Failed to get source port: %d\n", port);
 		return NULL;
 	}
 
-- 
2.30.2

