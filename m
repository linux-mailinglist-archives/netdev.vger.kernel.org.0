Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BBC2DE860
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 18:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732849AbgLRRji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 12:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgLRRjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 12:39:37 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4589C06138C;
        Fri, 18 Dec 2020 09:38:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x12so1755270plr.10;
        Fri, 18 Dec 2020 09:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ACaeWtkV+q3cTh2w4YcqHiR4LP/rJ6sq24AO/HTE6FI=;
        b=Cgn7On0b4u35B7Af3dIGjoX+3awODiIMwsXG19rDIh3f4GNrzsKT5bperGmJq8YfMF
         Uwu3Lz7hyD4knve6jRigWBlir8xM3ffhjfMLxKgIGf1PkMWvZf8ncrc2jUVgTmj1ZLF8
         DpQQ4MhplQEsQ2VJkqkkaPeHY/tHAbFk2b2T6TIJivoGgUIslajj7NI8IL34xUXTYhBW
         v0z26HM/w4WZ5t7OZPorE4EyrSC+RFYJj4WGIbVxJp1QeUskzawlSS95N+k6Hxwjr2lj
         vHQL/zgx2zFuzdD85B2XuEtg2Z7NwK4BIe3JTtMQKh8oxP9IWNPVdl7NgEa7v/mYV10U
         VMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ACaeWtkV+q3cTh2w4YcqHiR4LP/rJ6sq24AO/HTE6FI=;
        b=esTsoS/xffImC4JMPt4cYk2539tSCwEbeoJBBYo6bFbBq1oDO8GkLRdmijRUiB8UKz
         ww6IQFWawUUNL/DCJUtdVDU3h6bWCXTjqS7CD13n6PswkxBNg85Psbcczqts9RaDfayX
         qON/ZuTIdGlA5dc1CNGmJOfttQUwH86+tag2D7qqmnwZru663glx42sZ+TV292X/TW4f
         VtsKAFc59NHz+G0wbeyq6EW6HSfeLaOh+hTJsR3k+AohW9QzQV4lERjdW3DWvHpzfm92
         HieXStlREVqQesL1vjtJGOWtqYsHGbJjkGOlBqiaOnmsl0ETPq86/gHfOuJSA5kQIjVV
         98Ug==
X-Gm-Message-State: AOAM532FWnkrfmWtIUDTeT2VvFqlUUB/786zS8P3FgiPN4cxRdDhtBgL
        zWhW/abhY9E53a/SvyCY8zYb0hK9Rac=
X-Google-Smtp-Source: ABdhPJxbqAjvu2zqYlE8aC4eO6ZAG0aSXf398BuFDTM7mtoLrVSeJbwX6vUZKAO3gUnAl8H59/1S6Q==
X-Received: by 2002:a17:90a:e00f:: with SMTP id u15mr5486399pjy.88.1608313135771;
        Fri, 18 Dec 2020 09:38:55 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b10sm9746623pgh.15.2020.12.18.09.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 09:38:55 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: systemport: set dev->max_mtu to UMAC_MAX_MTU_SIZE
Date:   Fri, 18 Dec 2020 09:38:43 -0800
Message-Id: <20201218173843.141046-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is already allocating receive buffers of 2KiB and the
Ethernet MAC is configured to accept frames up to UMAC_MAX_MTU_SIZE.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0fdd19d99d99..b1ae9eb8f247 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2577,6 +2577,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 			 NETIF_F_HW_VLAN_CTAG_TX;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
+	dev->max_mtu = UMAC_MAX_MTU_SIZE;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = 1;
-- 
2.25.1

