Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093DF569294
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiGFTZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiGFTZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:25:08 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F2A286F4;
        Wed,  6 Jul 2022 12:25:08 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id he28so19674078qtb.13;
        Wed, 06 Jul 2022 12:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ka4Vl0mox2qelZAShFc0o0WArrtGE2LgSdY8PeqbE0w=;
        b=fiJ5gqRzVK1yWNZLK8Q2sn6R1xQ1qE0nrn5FA1b9VwHHx4BULoZKqNzZzoMJ4lssTM
         BzbIxvkYRjf5Pv40CrtlJ/6WlgeNXqhnfr+zttnzztSN3hJuyFL8p/wGd8xvQpv68zMg
         A6MjjdJZYQZUfAlmkinWJXRQAa7Ymlo/rV82OwTg2QM2wjohWo0ibH/2TbNVtj8x62dG
         9ADLzLz1guoKMiW1bRTZ5RrHSj4HfmOHmdXiL7AjUzA3RYcEaiB+IfjyeaUbXRNJc2nn
         AwptIGJv7tJXEpp6LrEH3Ep2j6BSdn9VGKqJAQ4O7URgJtx9CljceJ1j/Kyj7VZNXzBz
         wntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ka4Vl0mox2qelZAShFc0o0WArrtGE2LgSdY8PeqbE0w=;
        b=L5uaX+9KdY9NQ0xyUS9UjQ0s1IP090FyTjzl8yizHpYrdv7eQY7/nSQn/H/RGHwSTR
         IOIQ417ltSOacubK3vt/R/YvGvNad7E4dpb/KPGg3eD0aHJ1lAGu9PhU5TPUai+O4jJ1
         O7/cHOMj8RrTOmK6X0dtRWctBruEiaXUykv4J8k+U1h6JuwNU6Y3PZqLEDHnPC89p/zl
         imiImBrrcTzFdZpDbGNui8/cl5Aq0BHLtfolbrHc1XgWKZdhMIm9zretpd+IfW1nKeMg
         S3p92S/hUQFoPz3NAU7DcdxYXM+/pXDmw997savRANGRY77fqr93KoIG/qBVXrBjyF89
         VKsQ==
X-Gm-Message-State: AJIora/rneLKIB25dB02C4DEL9bdkfbXkd4cpaWHktPqj+IIsykPl14R
        QWFCOLePQ2OIomIbnB2SbB3We3yb/a4=
X-Google-Smtp-Source: AGRyM1vXbVspth0bWp9nPvSI7bdqztEpj+2aACatlTbYhvF5ZjCukXRRNjb2GiXI+YLLHXJLi25bbQ==
X-Received: by 2002:a05:6214:19c8:b0:472:f250:2d97 with SMTP id j8-20020a05621419c800b00472f2502d97mr15528518qvc.13.1657135506883;
        Wed, 06 Jul 2022 12:25:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u9-20020a05622a17c900b0031d3d0b2a04sm10545523qtk.9.2022.07.06.12.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 12:25:06 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.14 v2] net: dsa: bcm_sf2: force pause link settings
Date:   Wed,  6 Jul 2022 12:24:55 -0700
Message-Id: <20220706192455.56001-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706192455.56001-1-f.fainelli@gmail.com>
References: <20220706192455.56001-1-f.fainelli@gmail.com>
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

The pause settings reported by the PHY should also be applied to the
GMII port status override otherwise the switch will not generate pause
frames towards the link partner despite the advertisement saying
otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Changes in v2:

- use both local and remote advertisement to determine when to apply
  flow control settings

 drivers/net/dsa/bcm_sf2.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 11a72c4cbb92..42b4f49c9f47 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -625,7 +625,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->port_sts[port].eee;
 	u32 id_mode_dis = 0, port_mode;
+	u16 lcl_adv = 0, rmt_adv = 0;
 	const char *str = NULL;
+	u8 flowctrl = 0;
 	u32 reg, offset;
 
 	if (priv->type == BCM7445_DEVICE_ID)
@@ -697,10 +699,24 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 		break;
 	}
 
+	if (phydev->pause)
+		rmt_adv = LPA_PAUSE_CAP;
+	if (phydev->asym_pause)
+		rmt_adv |= LPA_PAUSE_ASYM;
+	if (phydev->advertising & ADVERTISED_Pause)
+		lcl_adv = ADVERTISE_PAUSE_CAP;
+	if (phydev->advertising & ADVERTISED_Asym_Pause)
+		lcl_adv |= ADVERTISE_PAUSE_ASYM;
+	flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+
 	if (phydev->link)
 		reg |= LINK_STS;
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (flowctrl & FLOW_CTRL_TX)
+		reg |= TXFLOW_CNTL;
+	if (flowctrl & FLOW_CTRL_RX)
+		reg |= RXFLOW_CNTL;
 
 	core_writel(priv, reg, offset);
 
-- 
2.25.1

