Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E273A1CF5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFISpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:45:25 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:40891 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhFISpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:45:22 -0400
Received: by mail-ej1-f46.google.com with SMTP id my49so23234418ejc.7
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tXFXzN+F0haZQ9awXHtahyqOKcu8kLUn5UfFNzzYnII=;
        b=DlLrbEObJ/dZQ36BpCi8eRs5bh1r4d0jFbJ9Naka10WYZeldMXLQLbGsVH6Whhms+D
         oVnI46pfQICvWITGj1e3od4iIgXw2PzBQNUqe0vI6BtgpMnCDwyXPVEqFa/lC/wBAiFz
         +Q30qDYHc1l3Nr8dytIgEbU8LxTFXl5NPojLBjg1jkxTXQ5ubAi9d5cNeplpe3/TL/+2
         j+wuMNCAg2PbUi8pDOapAO7RviyRUM4+WFdBfc5XAMp4h49Yskhfx5ASTWJcjiCKzgC7
         FB8Ga3VqIGvzsNRxmKp+eoUeF6Ow+StaSBAYcKc6OEOiXFnLJRNw61f8bPXKMkgYfS3X
         OIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tXFXzN+F0haZQ9awXHtahyqOKcu8kLUn5UfFNzzYnII=;
        b=jo7niskAJbesjY/ic/Y7TRx36bNWaUigZT1UXFKYj8NifdJQFAQkT7pMXvefKEekIK
         QZV+EyrLWALhERCxwbvngOktQBqUZa+4HBE3d45pIBNLi1QuyDwmt2vc16BZyhZ5w1gz
         IDFVl6FnAoCRbRnWZ/JqtyekcMPovkRo3X9kgWVFNhx7nctyb4ZWQRW5vc2Q6X5JUnta
         VCNwG0PxhWO+yAyqKLFnX6SRMeYR7d1CpUfFGjzbUAv93YVTl6+DFolHQuSCvFfiQ4N/
         Wh6HV0BItyxscO3LmF+0Eyirw1hzUZ+W6heuraU5y1DXvFhqyxsU2EbATs1KTZmYln5K
         SDog==
X-Gm-Message-State: AOAM531PEWxPSsQBa6LHGvNju842FuKYe6qgBSwLlAxSZsmPTxbcOkGs
        N1lSte7JY6ElqwXcJ5Eg5lKl4sk1ANk=
X-Google-Smtp-Source: ABdhPJxZMbAlLt05Nz658ddRs3WlXkkxUq2O3q8pTkjefn+h33ONH8ouvOv2Sk7nK16GDTjuPpFCYw==
X-Received: by 2002:a17:906:5a88:: with SMTP id l8mr1118933ejq.163.1623264147217;
        Wed, 09 Jun 2021 11:42:27 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:26 -0700 (PDT)
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
Subject: [PATCH net-next 12/13] net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
Date:   Wed,  9 Jun 2021 21:41:54 +0300
Message-Id: <20210609184155.921662-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 12de2dfff043..aca243665f3b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -210,12 +210,14 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv)
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

