Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22CF5659F3
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiGDPf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbiGDPfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:35:22 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27747B48C;
        Mon,  4 Jul 2022 08:35:22 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c137so7011190qkg.5;
        Mon, 04 Jul 2022 08:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYVz6RgMwxva5vAR4hhxFqjjc52IC4ZKYB0JkIwDMcQ=;
        b=XzcXXJEQfRnit2Sk0Wdc+B9FplU2xVf6nmkrVno7W59sLqNiT4zq+EuvRg4kM0tLvY
         WfwIVHiTYG+l+RTfHgLk2d0D2SVA8GUYDDAxG76fVBnSVKljioTpk/Yt5kjSnYyVZKJP
         dpKDwjZkXClMedHHvdG2P6MYke1CIP/7VweA4hcSWLMlkrI5POKLXUqqeaCWmpnMYcBk
         Yvca9KoGTcWZlEAvxeMC9MSj48qANPqMyS17JmEo1pVtFje/wmuSbL8rZ9+V7gDEt9S1
         4WUbe+PUTqMeHVbGKbLclw9PpuhOBOr551uagFmqLm/eFwizX2r5pKhRtFZfAa/cVNo1
         11KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYVz6RgMwxva5vAR4hhxFqjjc52IC4ZKYB0JkIwDMcQ=;
        b=C5kPrF7XCCzHX1m1vFWCsqXgK3aUBEMgyq6AAWiw1ee6/kSHq2dQhzoOOpBgET9ndU
         aEN668bkz5bY/LFl56r+l9IskX/JYpO/RwU5XAVY3nnvLb+xVXMwuy7Wdc4OK9lDnu3b
         5YU/N86UHDXxDGRLUY6vy/6ioCaVCUcQPO9rN354fkC8zYELr+L0HoI5mClWd/1a6zoX
         5FfRsq4Z2ZeEo2vEueghymnhZfzZwNPzSugB7DQ8UX52Aw9u8bqOe+ZWq3PFDyQ/tbz5
         z1DS+nEnEYFg7kIHXr/KIUSXaBs606Tv7xex2L5UkEeKlrL3vvN1zVn3cYrcnYGnhSJO
         DveA==
X-Gm-Message-State: AJIora9q/j8sE6CZqRXLQzFTfxx6aX+P504Al47zanZa0YlL/+DKJQE+
        G4WNZXgroIPkfdhKkZL3E4h/y0Y00/U=
X-Google-Smtp-Source: AGRyM1u3BSiIAzO3sZP6naJt1FRXk2EVVGKFDPibkp16OIUopRbZCkKaLUC1BqzUsOXrAP+LWDfHQQ==
X-Received: by 2002:a37:a1c9:0:b0:6ae:db28:ea0a with SMTP id k192-20020a37a1c9000000b006aedb28ea0amr20372220qke.141.1656948920753;
        Mon, 04 Jul 2022 08:35:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a05620a0f8c00b006a34a22bc60sm24366909qkn.9.2022.07.04.08.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 08:35:20 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 5.4] net: dsa: bcm_sf2: force pause link settings
Date:   Mon,  4 Jul 2022 08:35:10 -0700
Message-Id: <20220704153510.3859649-4-f.fainelli@gmail.com>
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
index 0ee1c0a7b165..282e9e2a50d9 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -602,6 +602,11 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
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

