Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360A488552
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 19:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiAHSQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 13:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiAHSQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 13:16:44 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C2C061746
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 10:16:40 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u25so35672519edf.1
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 10:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4VShwSPVfj7GfXP2tBCw17qNbBXH8y4PIVu4DylC+Yk=;
        b=deXjQd7iwt9NyWs3LiY3Y9oI7jXD9KYC0IAF+0hRTqNmUO46HyW8ILfoOLGfgz//vh
         bCPBuxZGgnjzyrl2hGUk+zougES865YL10Wa9bFX33dyhBpICNXBvbv61Ex2fXGdTLOW
         js2nQ8zOWSmp/Ib607pVKzFkn2YJ6TnrNafCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4VShwSPVfj7GfXP2tBCw17qNbBXH8y4PIVu4DylC+Yk=;
        b=f0VGdNwoLx1JQ/9LAMM8t2gBXDjuxZC2IzG8xsDl8TmQFbdNoz29e2t1jy++9u1FSW
         bz7QRx6n6KlXBiqMxvjE23atML2lLDBQHbYe/dINJkUDm9glx/e2u7RUJNtiP3iNdbGl
         FuHAiyQZt5H3BSsJf19KTScNe+JX75w/xnroyuuFdrxqUvtThlzX/ccgtQDwT7HvJ5wM
         r7J1EzS/mFtbpdI1EVUeVIof+Cj6xrXGgTBr4dgQhKitpe3XTIaj4HPJHyoODL2fWmjS
         /305QoQh4MxuAexV2bHbLuSMaevXIAmKohWWZBFOy3wfpv6LtwLX2CLKCCLWkN48dmfb
         YfoA==
X-Gm-Message-State: AOAM530dFgA7RTh18TD9vJXDVPLKYPmx1FREFSrwHjbWwZIQYEbWk/dp
        zQMsPb/DkOcmR06rTuURLOqBOg==
X-Google-Smtp-Source: ABdhPJwV7uU0oXOSs+GBb8Le/beFcuoTyG5jHEtbobZSHjJAhyGtEFElIRca3PoA1E/tV1K+/Oy+rA==
X-Received: by 2002:a17:906:6c1:: with SMTP id v1mr51856789ejb.638.1641665798545;
        Sat, 08 Jan 2022 10:16:38 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-244-92-231.retail.telecomitalia.it. [95.244.92.231])
        by smtp.gmail.com with ESMTPSA id cm12sm1016616edb.6.2022.01.08.10.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 10:16:38 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH] can: flexcan: add ethtool support to get rx/tx ring parameters
Date:   Sat,  8 Jan 2022 19:16:33 +0100
Message-Id: <20220108181633.420433-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds ethtool support to get the number of message buffers configured for
reception/transmission, which may also depends on runtime configurations
such as the 'rx-rtr' flag state.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

 drivers/net/can/flexcan/flexcan-ethtool.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/can/flexcan/flexcan-ethtool.c b/drivers/net/can/flexcan/flexcan-ethtool.c
index 5bb45653e1ac..d119bca584f6 100644
--- a/drivers/net/can/flexcan/flexcan-ethtool.c
+++ b/drivers/net/can/flexcan/flexcan-ethtool.c
@@ -80,7 +80,24 @@ static int flexcan_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 	return 0;
 }
 
+static void flexcan_get_ringparam(struct net_device *ndev,
+				  struct ethtool_ringparam *ring)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+
+	ring->rx_max_pending = priv->mb_count;
+	ring->tx_max_pending = priv->mb_count;
+
+	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX)
+		ring->rx_pending = __sw_hweight64(priv->rx_mask);
+	else
+		ring->rx_pending = 6;
+
+	ring->tx_pending = __sw_hweight64(priv->tx_mask);
+}
+
 static const struct ethtool_ops flexcan_ethtool_ops = {
+	.get_ringparam = flexcan_get_ringparam,
 	.get_sset_count = flexcan_get_sset_count,
 	.get_strings = flexcan_get_strings,
 	.get_priv_flags = flexcan_get_priv_flags,
-- 
2.32.0

