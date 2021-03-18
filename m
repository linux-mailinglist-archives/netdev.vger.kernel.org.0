Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B34E340E30
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhCRT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCRTZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EA2C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:50 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x16so6740201wrn.4
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=zP0kBsVM+1TTrok+2Mhmew5SesmqBzk0gDKAfV3ffqs=;
        b=g3H5yuch4EXsJnSjGflpLOXhkwIXc108yJhaTZEpHaAsSWbaQEIMiB0hIHtGpZ70Er
         XoFbCsy1ftQZ/mnf/eLRzZYlxSuytSSauvPvuHa5LF9sp9SRfwEafhYqdDaf7H7qBAr3
         nHFyhEJMrFW2p+2Mi9q5yp+wjAyH7afKk+slQhLP/7oOeVDGwWwGXWhOYsvmgpmcBYP0
         Ha7gfjND1SV8M0cvstVau+4PWgjeXtXW9A1Pw6RhkEJbD6pxxLMJ/d0CZZ4stEnDsjht
         nVKfwj/ANOLjxur5DwecFl4hzOEssAPVObOQBBgsBUY9m1MwfCq2t4N7+Gc3n/Ro9ejA
         fEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=zP0kBsVM+1TTrok+2Mhmew5SesmqBzk0gDKAfV3ffqs=;
        b=FJ4XJq39e/cmxGuoFSzwPqoTL3kehBvX4nS3Fm5sw5744eazyMJ5kmtJpt1hj+c/Sw
         iVCI/H/+ArXsPe2sRvyCyv4vlsoTRpY1LiuHgCjGpsJzs04iEzwtOHPG6hwkujOep2+Z
         mVnHIkVp3qcGqfY4gBaRTVRHFf0UWr39kQU8hk+8JAm5ypmaAAM0uhqSZMlUnI31ihBz
         SRQhJUUxWNFcyQj0t/NbUkurZKWB3tbToJRfWEl9tVrwNFnKmW5whc3FqKMpj/Mxw35b
         tl1X+92TW0xzqn6hmRERkJm7rs5nBAi6i+1BaXbw9eiTr7uEpf891co0pgMo4a2hcJxO
         1Qog==
X-Gm-Message-State: AOAM531kSlvvk8k79Hd8LkcWO+eScRvPoR1fe6Zb4wQlWQn5VjMENaq0
        c7wnIRiaMXcVMd61WcLRP5ECRA==
X-Google-Smtp-Source: ABdhPJyAwgg3Bedt3PfOVmR4pLZ9uI9UFilerbmJdSSjDkgh3RTLjK0NFc3MI1v6kHLfa6bDWBLCrw==
X-Received: by 2002:adf:e391:: with SMTP id e17mr777881wrm.285.1616095549274;
        Thu, 18 Mar 2021 12:25:49 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:49 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 5/8] net: dsa: mv88e6xxx: Use standard helper for broadcast address
Date:   Thu, 18 Mar 2021 20:25:37 +0100
Message-Id: <20210318192540.895062-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the conventional declaration style of a MAC address in the
kernel (u8 addr[ETH_ALEN]) for the broadcast address, then set it
using the existing helper.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c18c55e1617e..17578f774683 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1968,8 +1968,10 @@ static int mv88e6xxx_set_rxnfc(struct dsa_switch *ds, int port,
 static int mv88e6xxx_port_add_broadcast(struct mv88e6xxx_chip *chip, int port,
 					u16 vid)
 {
-	const char broadcast[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 	u8 state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC;
+	u8 broadcast[ETH_ALEN];
+
+	eth_broadcast_addr(broadcast);
 
 	return mv88e6xxx_port_db_load_purge(chip, port, broadcast, vid, state);
 }
-- 
2.25.1

