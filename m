Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531713CB884
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 16:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbhGPOOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 10:14:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59598 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhGPOOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 10:14:39 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 823B322B46;
        Fri, 16 Jul 2021 14:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626444703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qZY0smo+O+Xk7iA7lzz8gDAiURl0BK1XyowcQM/UtiM=;
        b=pQrhWDGDTiKDN16Qi3oehirpj9LgoFxfnXwRY7PRrj0cvkB0j4RZuTGc4B0nvWgxlmSycv
        Q4ebQ9v7hlyQ6ITOEoqZ03ykRsa8ObzGJCIPcq0ZUi74yp3u+GjQ3Qp7pR/LVjS/o0VBA9
        5xGKgK4884qqjIXAjAkte0KWilAKr6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626444703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qZY0smo+O+Xk7iA7lzz8gDAiURl0BK1XyowcQM/UtiM=;
        b=+YIPDQXHu0MZ2KzJWvt8YxlCNRVlfw1WDOkQCBvPoXKzwmVPiEWfR6n43SDzdloLBBSRI8
        YFNTP/JJuwHgcXDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2558C13AF6;
        Fri, 16 Jul 2021 14:11:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 5GVRBp+T8WCMTwAAGKfGzw
        (envelope-from <iivanov@suse.de>); Fri, 16 Jul 2021 14:11:43 +0000
From:   "Ivan T. Ivanov" <iivanov@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Date:   Fri, 16 Jul 2021 17:11:42 +0300
Message-Id: <20210716141142.12710-1-iivanov@suse.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prevents "No phy led trigger registered for speed(-1)"
alert message which is coused by phy_led_trigger_chage_speed()
being called during attaching phy to net_device where phy device
speed could be still unknown.

Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
---
 drivers/net/phy/phy_led_triggers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_led_triggers.c b/drivers/net/phy/phy_led_triggers.c
index f550576eb9da..4d6497c45ae4 100644
--- a/drivers/net/phy/phy_led_triggers.c
+++ b/drivers/net/phy/phy_led_triggers.c
@@ -33,7 +33,7 @@ void phy_led_trigger_change_speed(struct phy_device *phy)
 	if (!phy->link)
 		return phy_led_trigger_no_link(phy);
 
-	if (phy->speed == 0)
+	if (phy->speed == 0 || phy->speed == SPEED_UNKNOWN)
 		return;
 
 	plt = phy_speed_to_led_trigger(phy, phy->speed);
-- 
2.32.0

