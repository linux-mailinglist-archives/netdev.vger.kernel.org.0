Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DFE5439CF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbiFHQ40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343816AbiFHQyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:54:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1803C9641
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fu3so41127637ejc.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1tzR7s1CZMuNvxGPj/IhGD4aqO3yLek4cvJPPvYidL8=;
        b=nl01/m/isEBb2/WNGaE5pGOzAFS/toNd1+LgNOGNZiEkDpKuikHikABfUn9ZLLFPOL
         Gx97Wxzgo2utKjJ6X8raUKMZ81A7Is2ahwrwoU25iEOTU31KJ44ByK4r7BZwibqIoGKI
         Kv6camtC5L5z3yyn4hEue1FIxVwz9NM2rl6nA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1tzR7s1CZMuNvxGPj/IhGD4aqO3yLek4cvJPPvYidL8=;
        b=qYtCq9wgwxLF+lXAg+Fdyqw8RzvEkVciad1sqZRYKoYhxK0jjDFS52IN1t286ZnrAc
         BqNezruP3cET+c7E2wi2xplZ32MDjjY0Ej80l+uXpuxO/acL7fqNY82mNzvxRCVgpqb+
         Z85yTXbjGDituuQ8b9jHWqZNP0l/cIZ7UmOd8GUoikzGGEul2Cc17xywnOvyFgfQ/x00
         Ix0nefK2qqqMn9dQIHDruqge1H0gKJonXJZdgCyxwFln0Z6xw+rG9GRJcqekEKCA4zbw
         N4p2mZXH4/FdbUS7nk9WTURjwtm9krpgyMCL/htKIziec3+740DWoWIkXTJZBtcikY57
         jq3w==
X-Gm-Message-State: AOAM530HSHtr6PRZ2i6bZimIN/cpKpEymkod21VHFZN6fldDd2X3Pc2Z
        Zr3dFuanyDiqt5VCmc2KHshaGg==
X-Google-Smtp-Source: ABdhPJwgGIMnqb4IUHl6OCZQla++DSzXUH1qm1ke5AQ6QOBqDujMj5QQe1ZbiuE8xIZN1AD0+RMe9Q==
X-Received: by 2002:a17:906:79ca:b0:705:111f:12dc with SMTP id m10-20020a17090679ca00b00705111f12dcmr32096475ejo.602.1654707096469;
        Wed, 08 Jun 2022 09:51:36 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:36 -0700 (PDT)
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
Subject: [PATCH v2 09/13] can: slcan: send the close command to the adapter
Date:   Wed,  8 Jun 2022 18:51:12 +0200
Message-Id: <20220608165116.1575390-10-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
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

In case the bitrate has been set via ip tool, this patch changes the
driver to send the close command ("C\r") to the adapter.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Improve the commit message.

 drivers/net/can/slcan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index ec682715ce99..0722e7820564 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -430,9 +430,20 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
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

