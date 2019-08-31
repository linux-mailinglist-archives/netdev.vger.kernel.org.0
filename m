Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4A9A461B
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfHaUS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:18:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38229 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfHaUS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:18:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id b2so8014479qtq.5
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0OiSUird0vFe04TtU5pLNCnwi61Em2M+3v4sHmWrThc=;
        b=NJrJndzO8L+5fIDAZeM3zaK2LjQ/xAiJYyEzLlJudfMg2SQa6QpdXEewuVt/NMF7NF
         mEm8QUkaB6vsLxQcv38e4yMnhvaHqTyOK7YTYF5P/g2RNQhxH9fM5mw5/q6xETjMgZsF
         O9QlZnUhKKElheUwMoaChdaesv0CsnErpH1DZAMU/biG2ALq9Y5r2Lhpa9PQ/DAe7ja7
         Oq3QCzAR376ZTP6gpEe0fsLe7zpNIapA9iZkHyCQsaoHQCzzReQ/yEwNNfqMHyOu+aIP
         orBQQGB0BHbt7ohi9HKzZsXMpilOfO8Vzkx128b6U3ogDmvtLog2+x29cDkU5ZeQSBjR
         hKJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0OiSUird0vFe04TtU5pLNCnwi61Em2M+3v4sHmWrThc=;
        b=WxeZ8X7ZIoi/kWFUTL4uMgLb/+1zVw6+2HXOJVKRMdyZQnG3C41JvAqXjwrZKA7kaG
         kjCgSvPDjnNLSgLNzCWgefSWUYQkyrIWQobmQECEdB0s8ZJALWmj/c7w/N11GFonGPwu
         CT39kunIejDklb6gZTWMqYCvQQqQ6D4JwqGWv2CYVgKpxOHffLEAsWVJF3Tx9ynfaeVH
         fCWyl24/Pz2x7UskcTJAw777ehFdrFmRcRO+06LliZk/EoWHPB2Ba3+BG5Oldy+L+apg
         CoX3X5o25YlrFVENfwaEx0of8RdsKplNIRObhtUZwlxnFOCqIkP+GLAC+XSbHPu8n+oG
         wOwg==
X-Gm-Message-State: APjAAAUn9Se+RbdzAHdBXY/s057dmNtVKDYOdxiusS2Ug1UFGLcC4IWb
        RRyY29rvyJNEOjlfHaA1YCb8kz1p
X-Google-Smtp-Source: APXvYqxpenul8S61t34InFqr/yBcPSujHhuyDjmonS8BgIsxXNBSmG1J6rqrXD8jlFKTk9wcYR/r3A==
X-Received: by 2002:ac8:750e:: with SMTP id u14mr21833332qtq.282.1567282736887;
        Sat, 31 Aug 2019 13:18:56 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w34sm2128883qth.84.2019.08.31.13.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:18:56 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 01/10] net: dsa: mv88e6xxx: check errors in mv88e6352_serdes_irq_link
Date:   Sat, 31 Aug 2019 16:18:27 -0400
Message-Id: <20190831201836.19957-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6352_serdes_irq_link helper is not checking for any error that
may occur during hardware accesses. Worst, the "up" boolean is set from
the potentially unused "status" variable, if read operations failed.

As done in mv88e6390_serdes_irq_link_sgmii, return right away and do
not call dsa_port_phylink_mac_change if an error occurred.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 38c0da2492c0..7eb7ed68c91d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -186,14 +186,19 @@ static void mv88e6352_serdes_irq_link(struct mv88e6xxx_chip *chip, int port)
 	struct dsa_switch *ds = chip->ds;
 	u16 status;
 	bool up;
+	int err;
 
-	mv88e6352_serdes_read(chip, MII_BMSR, &status);
+	err = mv88e6352_serdes_read(chip, MII_BMSR, &status);
+	if (err)
+		return;
 
 	/* Status must be read twice in order to give the current link
 	 * status. Otherwise the change in link status since the last
 	 * read of the register is returned.
 	 */
-	mv88e6352_serdes_read(chip, MII_BMSR, &status);
+	err = mv88e6352_serdes_read(chip, MII_BMSR, &status);
+	if (err)
+		return;
 
 	up = status & BMSR_LSTATUS;
 
-- 
2.23.0

