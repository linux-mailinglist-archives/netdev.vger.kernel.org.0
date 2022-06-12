Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1554D547C92
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiFLVkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbiFLVkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:40:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A281CFD7
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:39:59 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id kq6so7662572ejb.11
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hx0NO2HP0dNrW23jq3KzvYzEwbT+EuqW3kfxDZENRj0=;
        b=d9VwXs1IvLvFf22zAwdC4zv3o35n9iN0Jkzqf+gR7xFRn7za4RlbbaSN+WZ0eahMMd
         PuHx75bCypApa8Nj5S0A33EtZDnX0o2mtkUtRGDcmSQNXBQ+9AZTD/yX5UzKM7a5MROz
         zrVC3G+6xoh4IgI2LIkCJzaG5IsltdFlnXkL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hx0NO2HP0dNrW23jq3KzvYzEwbT+EuqW3kfxDZENRj0=;
        b=uThLT8UwV6X0A2fjKNV5Y9BD758QxPxYn0ghGe86gFcoxJM8dd0ZbLGjIw88iPb19r
         W85tF9/uLcU45nUZwrRzY0fIjzYcpOaNb6leUwD1JkK0nER4kuAUJlOaFnx6T3x2f4VD
         5oecou3iXR7xjzWFVo1OHsoOfkPG/syFuJ70jk/yPQQnqqdRkANiJGGJ+yU5UySq15F/
         ZpG1D+w0CQQiJmw4nyX9vZM8Z0UfrEf6f0Prd1HH03ENWzwTsfTteW+vI7IpIMi80IuA
         8U8r2aQ2Am4J6zIH6J23rnSWUUOXOqbwryEIZjgHFu9HxuGMwLhpg/Es3ywxTt50iKbN
         KVYQ==
X-Gm-Message-State: AOAM532eHcOTqvBBg3tFHmeUy/B+zavyv0NJCaQ7+lpCtntJ0FJiPtzP
        QAqozYFhK4C3+kITZBEpdwIcTw==
X-Google-Smtp-Source: ABdhPJxmPNiE8Egs8cQHYE/AWnP5Ves/8od02ASU+2Mz05zD0p27lsnsJ/FcOTrEnc8mB1B9u0rhRw==
X-Received: by 2002:a17:906:7a57:b0:711:faf1:587d with SMTP id i23-20020a1709067a5700b00711faf1587dmr20191424ejo.581.1655069997739;
        Sun, 12 Jun 2022 14:39:57 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm2909398ejh.139.2022.06.12.14.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 14:39:57 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 05/13] can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U
Date:   Sun, 12 Jun 2022 23:39:19 +0200
Message-Id: <20220612213927.3004444-6-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
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

Adding Netlink support to the slcan driver made it necessary to set the
bitrate to a fake value (-1U) to prevent open_candev() from failing. In
this case the command `ip --details -s -s link show' would print
4294967295 as the bitrate value. The patch change this value in 0.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/dev/netlink.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 7633d98e3912..788a6752fcc7 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -505,11 +505,16 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct can_ctrlmode cm = {.flags = priv->ctrlmode};
 	struct can_berr_counter bec = { };
 	enum can_state state = priv->state;
+	__u32 bitrate = priv->bittiming.bitrate;
+	int ret = 0;
 
 	if (priv->do_get_state)
 		priv->do_get_state(dev, &state);
 
-	if ((priv->bittiming.bitrate &&
+	if (bitrate == -1U)
+		priv->bittiming.bitrate = 0;
+
+	if ((bitrate &&
 	     nla_put(skb, IFLA_CAN_BITTIMING,
 		     sizeof(priv->bittiming), &priv->bittiming)) ||
 
@@ -563,9 +568,10 @@ static int can_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    can_ctrlmode_ext_fill_info(skb, priv)
 	    )
 
-		return -EMSGSIZE;
+		ret = -EMSGSIZE;
 
-	return 0;
+	priv->bittiming.bitrate = bitrate;
+	return ret;
 }
 
 static size_t can_get_xstats_size(const struct net_device *dev)
-- 
2.32.0

