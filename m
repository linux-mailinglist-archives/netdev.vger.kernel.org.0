Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F8E376DD1
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhEHAcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhEHAay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:54 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5940CC06134E;
        Fri,  7 May 2021 17:29:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l13so10839894wru.11;
        Fri, 07 May 2021 17:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8sajiSIf/5pTPBguI/wez7hVMELG4ud231DvDE/urxk=;
        b=vX3hlikPhjLM0Xm3vaRwe90HnlU6TFU1qR83hY0BA4uAnVO2h3BOTSqZbeIiP1XKg+
         dyLeg8reFZPTvsEIPRd9uh5RLdZIgJpZHbxATWV9ReZugbha85STNTPXy+Mmm8Hr20Jz
         MkgO/54Fv7V68jMttp7lLQ9PeHTycuQCiHziZ0sntjxa0Xd8pXakAIvatYIJdbK4z6s0
         Nb4QbbUvRuVJ9u2PhsbuYafd7oNr82srE9nqqEFcGsoAIBR1Kpo2I3PKO46+rE1qtnqW
         bp0A8+oyfFVQ4Esg2BTBskLU2gK5sBr5N5j2MvpxqMRhqvWVclYMsUByW/9oWd7A26ma
         wjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sajiSIf/5pTPBguI/wez7hVMELG4ud231DvDE/urxk=;
        b=iKKIEidTOxNNJgHVg/G0qzQavC+4KqGlFfTbfyGOB1Hl1SCalGd0NtIWgv2dfalnzK
         jujIou/Xho92/2aiQNSspKp9qy5Sp9eSkpr1MJmk8iFaSTOMXE1t9Y5nt7jQsHvzsy00
         kbKtaBGOynW/jFzAICZt0ZfehNmXzojyIgpQ9UeSo3F4FP61DNPWhpd+OJxYwR75WDxT
         J91g6hMwwhGIDcfRInlJat74chl1seMI2efbvH1yqLiLUvr0VVD+Yw3Mh62RoeaLvRpJ
         q7RtUnECKSoaVpv9d1PugWaj/7Rw3ONq7Qz4Cf/+uo34BCcpO80nkSP+HsjXT9rgpIzC
         TGuQ==
X-Gm-Message-State: AOAM530zNDBHDkKiqB2Db/YD60oj73uCyLkn3ZKOOmCsdKW3aUvWcULk
        K8mt4qwRjZ0EKagy4YaK4mU=
X-Google-Smtp-Source: ABdhPJwgRXuG54zM64g5N3HqgDlGY5z18OiYi8k9DXBg/OYGx4StUyhmywCfDzeae0XYYC6wxZ/8Bg==
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr16068796wrr.114.1620433780766;
        Fri, 07 May 2021 17:29:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:40 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 20/28] net: dsa: qca8k: clear MASTER_EN after phy read/write
Date:   Sat,  8 May 2021 02:29:10 +0200
Message-Id: <20210508002920.19945-20-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear MDIO_MASTER_EN bit from MDIO_MASTER_CTRL after read/write
operation. The MDIO_MASTER_EN bit is not reset after read/write
operation and the next operation can be wrongly interpreted by the
switch as a mdio operation. This cause a production of wrong/garbage
data from the switch and underfined bheavior. (random port drop,
unplugged port flagged with link up, wrong port speed)
Also on driver remove the MASTER_CTRL can be left set and cause the
malfunction of any next driver using the mdio device.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0c53b6fdf6ee..2e0d2f918efe 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -661,8 +661,14 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	if (ret)
 		return ret;
 
-	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-		QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
+	return ret;
 }
 
 static int
@@ -697,6 +703,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
 	return val;
 }
 
-- 
2.30.2

