Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333435659F1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiGDPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiGDPfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:35:21 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA3564D5;
        Mon,  4 Jul 2022 08:35:20 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id r138so6976062qke.13;
        Mon, 04 Jul 2022 08:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rqNnyVELFwQfCagJ4035B4k1YceE/CVo0ygtBq5QF9Y=;
        b=gk2kIIpv+K3dwJ45xo7nquQBkTBXP1/JL1bwpcuPTyjbkVe8kj81Pu0IN3YQJnlelj
         ZWfn001Wek86xfOnoxtL7ugw7D9fUWPjFgPlbBsrpVo+r2RNjQq3pLhmNYNBF5oZadpX
         lmg5bOfnUanQMIVIxD2CBWtPIqJGPIM5KARdJ9Zc6VBwnd9TDuc5nbwfGDy/IvPZP4g6
         R1uJdvfHcvc2fmPYydvouWoX90r0UtIqCmhhFS9fh0hxbMTQ/FlUAAELkVpmvgqcUwOC
         QtosE1KBVBXC2nhoUqM0VaoULcL6xPrSRV+Mp/qgTUkoAF/Cq3z9AglHh3EsJNz08rYV
         Oycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rqNnyVELFwQfCagJ4035B4k1YceE/CVo0ygtBq5QF9Y=;
        b=pQqQgbp46K6rZyT+gr8GLG9U+uOHgWQJNl8C7+yt1QlCuurRwxAFIZbyiHpit5EjWs
         6uSTwWoSasVXtO4JeCXvrHvauTAWvMHvSwhThbyB/AZtaBYWHE1WcqrAp/l+XIxn0ppi
         lINmhb+jEzMPzwv0d7BAvMhqzEIerbYY6g+UjiXmasD0YMtrX1sNR0r1YcOChW+z7zBT
         KUyL273Wc8xVEw1xigNz9o0f6UtJdQOjUM5yZ3LwnINqrr+M+zqkc0zLDnzxFXXEMi48
         cJ0hgykPnlEWn1HnZKQhJn9/I5Lvl9itobw8TX2h+nPxV81ZM3UbkWx862uhSy3xcUdN
         blHA==
X-Gm-Message-State: AJIora/+Pn0Ws2S6u5Mu+Qr7lzfMmBISl9Yt6KVOykjaKygyuUceocy0
        m5b6qLxfOTt6oMHjLfsW3DGiXti70BQ=
X-Google-Smtp-Source: AGRyM1uT9dWksiRHDkPlcAV9EDG6/pp/2xQiF6JMSVJVsHnOeUbTxZDAP23BOrAM4GgrOpTZYKmzPw==
X-Received: by 2002:ae9:c213:0:b0:6b2:7945:ec85 with SMTP id j19-20020ae9c213000000b006b27945ec85mr7134621qkg.543.1656948919156;
        Mon, 04 Jul 2022 08:35:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a05620a0f8c00b006a34a22bc60sm24366909qkn.9.2022.07.04.08.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 08:35:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.19] net: dsa: bcm_sf2: force pause link settings
Date:   Mon,  4 Jul 2022 08:35:09 -0700
Message-Id: <20220704153510.3859649-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704153510.3859649-1-f.fainelli@gmail.com>
References: <20220704153510.3859649-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3deda0321c00..8a67c6f76e3b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -599,6 +599,11 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		reg |= LINK_STS;
 	if (state->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (state->pause & MLO_PAUSE_TXRX_MASK) {
+		if (state->pause & MLO_PAUSE_TX)
+			reg |= TXFLOW_CNTL;
+		reg |= RXFLOW_CNTL;
+	}
 
 	core_writel(priv, reg, offset);
 }
-- 
2.25.1

