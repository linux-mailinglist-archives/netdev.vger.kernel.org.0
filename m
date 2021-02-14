Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D160B31B107
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBNPz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhBNPzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:55:14 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAF3C061786
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:33 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v9so959563edw.8
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cxB5vd8snAATgGMACotVhpSbwuBBRtJ2WkoyrEzEaWk=;
        b=WMgoyffU3MsRZpcA5WiCunkrG1GQH1Xr4cKJiMatlV/+rOZnYdrvoaSgO4cB9qVzWU
         c16Ywa4fQTmd8D3cinOMEjtGWrBcV5xIxSvE259GGxXKIBuMVOGansfR8OtMv7Oj9gyl
         rVN4tXkO/TAk5d1h9juggDViSHE6frsOXpJiZt5DS3H9tNdyvL1sKt1nVKLsaYM3NTN1
         BDDQMl15b1soA2RYi91gByjgydUxfLypvX4s7J7slPip8d4cLrcyF8peq8SOeK0pTC7Z
         51Kj22mY5IpvXzBoN/40QpMvsPoZDN+QZwYCCBtJonRe7+oPqEHXML/VeGmq7ngLrQ2p
         6bJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cxB5vd8snAATgGMACotVhpSbwuBBRtJ2WkoyrEzEaWk=;
        b=S6Kkv8ZCCyW4ncW5ZwBzAYUJHJw6Y1uNdbSvHzSfeknRRDIwlkpQrIqenLVEeIXzua
         2ooufg4wFX43VHHVDA+EPY8jxRG0EZ0NuJe15px33pD5Ppwupyb78mE7ErGE64SG8pb8
         IHfyk54zzpvDuDuCkNIu6N/C9Qydp40+K+0eseb2+he3KsxJfe9OOwIDvDEr7sokIkMH
         aax6feYQiVDL2OcWu+j+jCcEGG24+q509goq+ztkZwpbCahhVnFGr3fKQfK/gIP3v7N5
         R4/dIpuJ+itHnfg7/KNVcWEvgQGEsbgvyE5Wyv8u8eJmUsCraGk5GzufK3HsFqRFURad
         db2g==
X-Gm-Message-State: AOAM532zGepS2/ZtEJT6NJd3MOL4iOj5loOFoS6bcVMvhSf7VHnsanNA
        i3U68cbZriR51vgxQS0gcjg=
X-Google-Smtp-Source: ABdhPJyOMPvedFWyMS0qTRR3covtA1swEISLSkpBi1qANaVVU1QrPvpF5o8iKh1hRIqltVxHMj5DgA==
X-Received: by 2002:a05:6402:27cf:: with SMTP id c15mr11788618ede.179.1613318071876;
        Sun, 14 Feb 2021 07:54:31 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cn18sm8576003edb.66.2021.02.14.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:54:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH net-next 3/4] net: dsa: return -EOPNOTSUPP if .port_lag_join is not implemented
Date:   Sun, 14 Feb 2021 17:53:25 +0200
Message-Id: <20210214155326.1783266-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210214155326.1783266-1-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is currently some provisioning for DSA to use the software
fallback for link aggregation, but only if the .port_lag_join is
implemented but it fails (for example because there are more link
aggregation groups than the switch supports, or because the xmit hash
policy cannot be done in hardware, or ...).

But when .port_lag_join is not implemented at all, the DSA switch
notifier returns zero and software fallback does not kick in.
Change that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4137716d0de5..15b0c936ba01 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -203,9 +203,13 @@ static int dsa_switch_lag_change(struct dsa_switch *ds,
 static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
-	if (ds->index == info->sw_index && ds->ops->port_lag_join)
+	if (ds->index == info->sw_index) {
+		if (!ds->ops->port_lag_join)
+			return -EOPNOTSUPP;
+
 		return ds->ops->port_lag_join(ds, info->port, info->lag,
 					      info->info);
+	}
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-- 
2.25.1

