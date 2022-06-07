Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98E53FA41
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbiFGJtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbiFGJsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:48:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3872EE7329
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:48:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d14so14353599wra.10
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rU6AiPibH9nPjTI2YMHiF2ibJt+OjRoO+BIERVnAwAU=;
        b=XBJoJxny7hKfatnte2GxHsKCTr5HmbSa2HX7z2Oon+3tp6gqSpMNrsozStQxyX+/i8
         6ZBuiMvGaFnPKR7uDYIf+GZ9VlEqid4N/lJaYDl7QIzgLlD+9KO8++3nYsVmHuFgb5Dr
         yxyYAy5XHqhFLRgEfLXwEqRD4AddRRa2jY4Ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rU6AiPibH9nPjTI2YMHiF2ibJt+OjRoO+BIERVnAwAU=;
        b=Zm+0xLIIeBQcRmZdFRL1BvSTGlXByfiZ6POr1wlKmZmbaN3Lup27D4YXyhRuEjLnNk
         Unj0h+wdVv+ljN9A3jSzW6Akn3Z2ZVvc4kPkPUHOq+3/uvJPTucY6oMDZgGZKX0uS4my
         PjKjzrHF+ZZAUurOGUMWP9FJwpGVLpxpntAHhr5QUPp96BGNsFApPLf06z2Voh6Wov2n
         Q0TfwkGk1gmvqv3mDPbapfhU1Lug/0sTUjD22hoZLoihRqJGfz2zJAsepvVj9cuXzicT
         zuVaV9cDcZHKulquo/WLwF28LnBWAwEneLk7R/UtjruE+jBW1pKu7jsxl+UFUJJ5vmmV
         E7sA==
X-Gm-Message-State: AOAM532TFpSeZqt5ilqEc7hgytygfPRv+N8NT2uxv8w3z8XuAyNySGPE
        NJQUixu9OGhGwc0n0y958/FtcQ==
X-Google-Smtp-Source: ABdhPJxWpSQZMMlLoNuWN1W3nkSA26lOK6DFhDAfwDjaK3p3poJehcnXzGH/UYToEGi2OU6/PPSoEA==
X-Received: by 2002:a5d:4572:0:b0:213:bb00:86e6 with SMTP id a18-20020a5d4572000000b00213bb0086e6mr21860193wrc.284.1654595307649;
        Tue, 07 Jun 2022 02:48:27 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (mob-5-90-137-51.net.vodafone.it. [5.90.137.51])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b0039748be12dbsm23200547wms.47.2022.06.07.02.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:48:27 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 09/13] can: slcan: send the close command to the adapter
Date:   Tue,  7 Jun 2022 11:47:48 +0200
Message-Id: <20220607094752.1029295-10-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the bitrate has been set via ip tool, it sends the close command
("C\r") to the adapter.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

 drivers/net/can/slcan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index f18097c62222..d63d270d21da 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -438,9 +438,20 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 static int slc_close(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
+	int err;
 
 	spin_lock_bh(&sl->lock);
 	if (sl->tty) {
+		if (sl->can.bittiming.bitrate &&
+		    sl->can.bittiming.bitrate != -1) {
+			spin_unlock_bh(&sl->lock);
+			err = slcan_transmit_cmd(sl, "C\r");
+			spin_lock_bh(&sl->lock);
+			if (err)
+				netdev_warn(dev,
+					    "failed to send close command 'C\\r'\n");
+		}
+
 		/* TTY discipline is running. */
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	}
-- 
2.32.0

