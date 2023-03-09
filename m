Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC56B24A1
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCIMzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjCIMzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:12 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215B18DCF0;
        Thu,  9 Mar 2023 04:55:11 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 82C0585EB0;
        Thu,  9 Mar 2023 13:55:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366508;
        bh=xNmNmjH4DCoGV9RiVPer+i2QQA4k61osHG4pT21zA8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NE05gklUX2YM/e3lSEfPg3sR9qbwD4NAzeyVSFJ0gDPU8EXpgA4LA9b0+iRPdxdiQ
         h1nYwvc059gMVRGC3b00kjno3MWtEQcpsKzGf489eTrf//zhaNwTJaNY5ekOJQGLIo
         42PIhcTkU7mHSitFiIkydj/XSp8L9Kmii1VNQKRgXaKJUQV8hBPdO8jBDE18zmmb9D
         6IWKC3ZA/9UajiLyD7/AgYEoOTPpp+jmKr8QB41w5jBXe2viS8pyKh12tw5RTPn8Fu
         hdKlxoftm4IjmyQHB0MB7tmw66KDilejbTCvicRQCSgYtNGr+oSfQlZUhO09Wi1fvi
         1skZzxkqsSyGA==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 7/7] dsa: marvell: Modify get max MTU callback to use per switch provided value
Date:   Thu,  9 Mar 2023 13:54:21 +0100
Message-Id: <20230309125421.3900962-8-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309125421.3900962-1-lukma@denx.de>
References: <20230309125421.3900962-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After this change the value specified in max_frame_size variable is used
to provide information regarding the maximal size of frame supported in
the switch.

This approach replaces the current detection scheme, which extracts
information about max frame size depending on set of provided callbacks.

This is wrong, as some switch ICs can have max frame size equal to 1632
or 2048 and both would provide set_max_frame_size callback.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v5:
- New patch
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dbb69787f4ef..6a5acbba381e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3545,11 +3545,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	if (chip->info->ops->port_set_jumbo_size)
-		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	WARN_ON_ONCE(!chip->info->max_frame_size);
+
+	return chip->info->max_frame_size - VLAN_ETH_HLEN - EDSA_HLEN
+	       - ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
-- 
2.20.1

