Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E877496F6E
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbiAWBdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbiAWBds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:48 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB2C061401;
        Sat, 22 Jan 2022 17:33:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id p15so11119455ejc.7;
        Sat, 22 Jan 2022 17:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=72fd0kAQyaswWgj6Iap+xPi/wGkAt4Is96xZtOnT9BM=;
        b=V0K/qHQB7VcMdwaOmds62Tu3ennndb2mGslxlZrVzHRB+tSm0OX9DeMKrjAOdfd9HU
         fK4VH+0r2pSJDQDdKjynAYN/TknYh3JSOF+m3G+5ZwcFqXCOckumqpX5od7LIzOK3OpU
         +OpfNL5lznkTo4kehIBflp6ytrctDGv5hiWlLhaFgPLhK91nDpi4otr/cEJV0jKRyY+6
         vBVWx5XGMH/+gKR14FPs4C7qPBLhlnK7TV6o6txrL7SOcR/Ev/kK8AtuASZFMtUw9HwM
         sGl8r+f3nfVzH7F9ym7524/jbAsdQ+c6XHBZJdKdW+HvKygf3MhipHH5LAjd9P7iddbH
         rqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72fd0kAQyaswWgj6Iap+xPi/wGkAt4Is96xZtOnT9BM=;
        b=r0EQbwRgTDZVJcNU7eOiRhPg/rAPcJLZLziMPk/r678/9t98nyajGUsQg+hOEqAfDZ
         HEICE3ogbj7dBACIRAJ+/oyEKFQHZMeR+MQf9uf/4Qac/mPQj8FKM3eCo5YheCU6eDf0
         9NzPBHBiWAv/X9Mjc2DkpLCJMPPf0ba7n6eH4BPfcZ/6X8pvFfZSaECF8sNTyfhlWSbM
         Z6iCmMMnHyrwQ1fQaOrYeMaROGfy+gs8PaGPiof0J/es48ud7Si1+12DmFC6ondTV2Sa
         QIAAh4AQFkBcHMn/f15ZI9MwWS3GPcBpCNqx0SPTE9PXmteusbWV76P/j0GDGmEwpCMa
         +Xqw==
X-Gm-Message-State: AOAM532macAgEIcfwUkDMAj+8TCWuFu8S/JInuBF+Rf0tnef/9cBerVb
        pECxrB1dbC/5vjfqY76zzKI=
X-Google-Smtp-Source: ABdhPJyLG5nv2fGX1Df4mclJWftpqHr0YovcIEaETikQEWt5/9pcvUvWxt8WPf13pyWo3HqYrh96cw==
X-Received: by 2002:a17:907:1c01:: with SMTP id nc1mr8216729ejc.679.1642901626423;
        Sat, 22 Jan 2022 17:33:46 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:46 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 05/16] net: dsa: tag_qca: enable promisc_on_master flag
Date:   Sun, 23 Jan 2022 02:33:26 +0100
Message-Id: <20220123013337.20945-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet MDIO packets are non-standard and DSA master expects the first
6 octets to be the MAC DA. To address these kind of packet, enable
promisc_on_master flag for the tagger.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 34e565e00ece..f8df49d5956f 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -68,6 +68,7 @@ static const struct dsa_device_ops qca_netdev_ops = {
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
+	.promisc_on_master = true,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.33.1

