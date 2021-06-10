Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE4F3A32E0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFJSSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:18:10 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:44896 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhFJSSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:18:04 -0400
Received: by mail-ej1-f50.google.com with SMTP id c10so572768eja.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YeqWtvbjRvmSP1von0nwbulIEK9PnlVuuWeXWTS2FLk=;
        b=bxMdtHzOT5li98ndrLCFtA5oZYAtYvoMhcl62ZmBZBeYb5yAahlsKBdu6oiNP8TMWd
         ApmRtuBqmJG3SWqQvOodnmgWQybZUQzksoFyCFn8CNLhGXUiPe7LAliN7WOVoMKdbrmO
         0y7T/NPn/dXm2h/5JTOdaHNsajyZTLtmPrCeRicDzSX7r2bdKfT+IlVK0x9DgJuScN2M
         iYKpcR2tCdf85aaDgQWvM0S5gJXRLYvHoCJeKcnywxFvBMd/T4R09kH+n+BKQJRmgHZS
         j2cwqzQKw2+kuz8Vlp6eDQRZ1+UWaNa513/rjT2XI3IK83pIRKYKWIAWekiaAOW2tVWO
         2Slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YeqWtvbjRvmSP1von0nwbulIEK9PnlVuuWeXWTS2FLk=;
        b=g7usl8+MGtKst8RzXinOXYIFu2v29NIh7sbPJc6kOnntrpDZVnOQEoKAsKFaYE2RHV
         4DckrIXLPki6ZA5RmZ4IYJ+IKlbHbVF7rLRkW4btcPMPtQbHPI/sxBh9leuUxlgW4G8G
         1z6UJ64Z479xhGqR0sERxZUdqOe8+G78IeerB26gdZ0FDECuqMqj65145CoGXwCGAZtw
         gDcXNJBG97lCN3yfgIdSQ0cTkPTjDTWOg9wIvSACHqcUC+Lq9/FXKlLLfFjoTnHHVyF+
         bFqDixKKFDgn2O1BSzBUrfqWFyz7otJ/t6nqcIXkv9iMqmc5hPvhwFPUKxkqpgiq5nad
         kpGg==
X-Gm-Message-State: AOAM530o5agkxF6F1eKXkwWPYjkOUeHZ1G/b5Oj+/QG/Myjs9hERqFwZ
        zjpHiEDQH0zpNy8CXBfPOY8=
X-Google-Smtp-Source: ABdhPJwzCaES+cL3xXWhWh+CUOHPTfxUClBOpqc/gkBS2T7rh9rMXHbqwXtanmk/o0a+NX5tjeXg7Q==
X-Received: by 2002:a17:906:85da:: with SMTP id i26mr831651ejy.185.1623348893227;
        Thu, 10 Jun 2021 11:14:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 12/13] net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
Date:   Thu, 10 Jun 2021 21:14:09 +0300
Message-Id: <20210610181410.1886658-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For the xMII Mode Parameters Table to be properly configured for SGMII
mode on SJA1110, we need to set the "special" bit, since SGMII is
officially bitwise coded as 0b0011 in SJA1105 (decimal 3, equal to
XMII_MODE_SGMII), and as 0b1011 in SJA1110 (decimal 11).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f4ed2f83a0c1..4392ffcfa8a0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -209,12 +209,14 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv)
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			mii->special[i] = true;
 			break;
 		case PHY_INTERFACE_MODE_2500BASEX:
 			if (!priv->info->supports_2500basex[i])
 				goto unsupported;
 
 			mii->xmii_mode[i] = XMII_MODE_SGMII;
+			mii->special[i] = true;
 			break;
 unsupported:
 		default:
-- 
2.25.1

