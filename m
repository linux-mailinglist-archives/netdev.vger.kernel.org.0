Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E05118C10E
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCSUM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:12:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44423 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSUM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 16:12:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id o12so4264232wrh.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 13:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Sf+qh/uAduizz6nVQCWbaxYrwjEvBQnYHGJv+CUkwQ0=;
        b=RroZbWuXQ7BR3kDKj4us39I8jrA3uZ2FcHm08xRulzNH6q9NNdCLLzH9cSwbPK62mQ
         PuEcWen95czAY18NRUIPmRfA28P/mnIBJXgvU3Ez6aXCNiqlz2k7RD0nBXKQPMqA0MIk
         BfpUFAIB5s/VVK3F2mB/0GyYS8hwwdrFkkHmC8xwiPLop1L82fkeLbqiD4/NDMmwINGZ
         cyiRc9m1ZIH054WFmexCiFIU9Rbw3jEKjJF1QH7+LEO9gviC3xp7EMrSo/CvfHLzHBoi
         hC5lmm4vROwcU/fOdx+lKlWOotfCMSJCaz6uoVlpEl0U4Q8ZglNUQgiRrzbTSgaENWk7
         c6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Sf+qh/uAduizz6nVQCWbaxYrwjEvBQnYHGJv+CUkwQ0=;
        b=mEVF1TDGvpJ7hlYDM5OvG/noS85em9ufHosY+S+zpe0WFhvxlp1EywlmVynxf8nnH1
         kJO450Njq06YQjTw9w9xFr9awSr4cCYdZVlpaiVmA1h8JEdDNGi4CFy4GrwLqQRvewIc
         zg+UDESS1iTB9JWFpA69o5GOvu9Z5ikXydT7918pQkbOrLRPbX9kB7wW48cHtz83XDJl
         hrRWIP+FLW3M2rz+GMAussNbwDfdwOAo1fBkmawK1qOY5Csnnvd/TR7mpsJLk5oab0hf
         Yzvj5xvMPrjrrrvj4J0C4lcuieAACNSjblCox4RIz3h7tBD4fBXrylXuQOODMCXzGPtd
         9Peg==
X-Gm-Message-State: ANhLgQ2IveuliToA6xnh5rJOMqvvhAZE5WBMEUVO8pezHSOEWi0eqgQk
        y68tTX+DCdGy9waFfrYRoLY=
X-Google-Smtp-Source: ADFU+vv/P0lpUqYV2v3Q3+hBgKXt/MGti3fRNKGXHeZSX6E8BEyBaZFNGdcnag1VPLHObVuqLZGrYw==
X-Received: by 2002:adf:a285:: with SMTP id s5mr6712768wra.118.1584648744358;
        Thu, 19 Mar 2020 13:12:24 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id g8sm4204252wmk.21.2020.03.19.13.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 13:12:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH v2 net-next] net: dsa: sja1105: Avoid error message for unknown PHY mode on disabled ports
Date:   Thu, 19 Mar 2020 22:12:10 +0200
Message-Id: <20200319201210.22824-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When sja1105_init_mii_settings iterates over the port list, it prints
this message for disabled ports, because they don't have a valid
phy-mode:

[    4.778702] sja1105 spi2.0: Unsupported PHY mode unknown!

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Suggested-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d8123288c572..edf57ea07083 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -162,6 +162,9 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 	mii = table->entries;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		if (dsa_is_unused_port(priv->ds, i))
+			continue;
+
 		switch (ports[i].phy_mode) {
 		case PHY_INTERFACE_MODE_MII:
 			mii->xmii_mode[i] = XMII_MODE_MII;
-- 
2.17.1

