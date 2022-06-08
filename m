Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE95439D9
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiFHQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiFHQzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:55:00 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504033CA2CD
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fu3so41127637ejc.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r56OkRGS+scgiov9hraSbcrm1/dO+C0ISd2zgdsHS2U=;
        b=fOek92UJg6uOVWRQgugew1DRpDVhrJOSH+LH2ckhtwtc/to81tI0cdC7SvceF5zOAG
         UplhYkxagPGq+KtCwSUVP4SWg32V69zususPIYoIqO23c8TzOEkhXgvhtucRqj1CaJFV
         Gl8IogK6CQTY1UC+0NOnims7v3I8M5QhswyWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r56OkRGS+scgiov9hraSbcrm1/dO+C0ISd2zgdsHS2U=;
        b=fljqtWBnc0JOKzzIGdqySEPtx08KLMpY4n2KyDTpXGZ0Ny2M6Q1SQ0axrPIzhEe3m0
         KceUE8rJRdvrFQysu07zDmhe9Q8zmZA4Kn84iDg9XQAcgaXFBRXGZ2nXbO+zMT8aQVzG
         DLJsuqbVgfbnekHPpSNH6YI46Ei6gdnf70b0ZAirbql3hUIuB77vTNc+GU41RGlKs5gf
         AhuihxW9nhYbKKcvW/IsRzkv0TlfmDjWhZ+LTun9EK+XUnv30iVnrW5jnOOjt8ZJtmLZ
         Dd0UiyE4UhH+9+EGc2Hc4Uv8jfswaLLK/cCl1NbM9qP4ISwMsrAg0Jr3MIkK1e75Xweq
         zc+w==
X-Gm-Message-State: AOAM533V/UnFqJx+EqMJO1TK4tT7h6tyMHevIzrAW8zL8arF+Grm1mpZ
        k4KFLTQTEloqU5UD4eDlLYEMvA==
X-Google-Smtp-Source: ABdhPJxOrh7uNoFiv4QEt1dF+0ccXnsitPoDYnkvFbaj2vUGNEGN/OHPrC1gI/BAF8mijHB7GrisQw==
X-Received: by 2002:a17:906:51c5:b0:711:f4ee:6574 with SMTP id v5-20020a17090651c500b00711f4ee6574mr3748661ejk.509.1654707100906;
        Wed, 08 Jun 2022 09:51:40 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:40 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 12/13] can: slcan: extend the protocol with error info
Date:   Wed,  8 Jun 2022 18:51:15 +0200
Message-Id: <20220608165116.1575390-13-dario.binacchi@amarulasolutions.com>
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

It extends the protocol to receive the adapter CAN communication errors
and forward them to the netdev upper levels.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Protect decoding against the case the len value is longer than the
  received data.
- Continue error handling even if no skb can be allocated.

 drivers/net/can/slcan/slcan-core.c | 130 ++++++++++++++++++++++++++++-
 1 file changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 038ce7c25d42..aba42e284274 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -170,8 +170,118 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
   *			STANDARD SLCAN DECAPSULATION			 *
   ************************************************************************/
 
+static void slc_bump_err(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	bool rx_errors = false, tx_errors = false;
+	int i, len;
+
+	if (*cmd != 'e')
+		return;
+
+	cmd += SLC_CMD_LEN;
+	/* get len from sanitized ASCII value */
+	len = *cmd++;
+	if (len >= '0' && len < '9')
+		len -= '0';
+	else
+		return;
+
+	skb = alloc_can_err_skb(dev, &cf);
+
+	if (skb)
+		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
+	for (i = 0; i < len; i++, cmd++) {
+		switch (*cmd) {
+		case 'a':
+			netdev_dbg(dev, "ACK error\n");
+			tx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_ACK;
+				cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+			}
+
+			break;
+		case 'b':
+			netdev_dbg(dev, "Bit0 error\n");
+			tx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_BIT0;
+
+			break;
+		case 'B':
+			netdev_dbg(dev, "Bit1 error\n");
+			tx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_BIT1;
+
+			break;
+		case 'c':
+			netdev_dbg(dev, "CRC error\n");
+			rx_errors = true;
+			if (skb) {
+				cf->data[2] |= CAN_ERR_PROT_BIT;
+				cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+			}
+
+			break;
+		case 'f':
+			netdev_dbg(dev, "Form Error\n");
+			rx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_FORM;
+
+			break;
+		case 'o':
+			netdev_dbg(dev, "Rx overrun error\n");
+			dev->stats.rx_over_errors++;
+			dev->stats.rx_errors++;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+			}
+
+			break;
+		case 'O':
+			netdev_dbg(dev, "Tx overrun error\n");
+			dev->stats.tx_errors++;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_TX_OVERFLOW;
+			}
+
+			break;
+		case 's':
+			netdev_dbg(dev, "Stuff error\n");
+			rx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_STUFF;
+
+			break;
+		default:
+			if (skb)
+				dev_kfree_skb(skb);
+
+			return;
+		}
+	}
+
+	if (rx_errors)
+		dev->stats.rx_errors++;
+
+	if (tx_errors)
+		dev->stats.tx_errors++;
+
+	if (skb)
+		netif_rx(skb);
+}
+
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump(struct slcan *sl)
+static void slc_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -249,6 +359,24 @@ static void slc_bump(struct slcan *sl)
 	dev_kfree_skb(skb);
 }
 
+static void slc_bump(struct slcan *sl)
+{
+	switch (sl->rbuff[0]) {
+	case 'r':
+		fallthrough;
+	case 't':
+		fallthrough;
+	case 'R':
+		fallthrough;
+	case 'T':
+		return slc_bump_frame(sl);
+	case 'e':
+		return slc_bump_err(sl);
+	default:
+		return;
+	}
+}
+
 /* parse tty input stream */
 static void slcan_unesc(struct slcan *sl, unsigned char s)
 {
-- 
2.32.0

