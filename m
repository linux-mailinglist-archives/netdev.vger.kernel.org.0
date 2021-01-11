Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462C32F1C1B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbhAKRS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731587AbhAKRS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:18:59 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800FCC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:18:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i24so517310edj.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4D2XSEoDONhR5HzQOyr+cjbc68tw+gl1DEWdzV/0GZQ=;
        b=mn20YgUTIzpDFM9IayTWLGjAndN8gyAAvJS3T0Ewy/gqHvxaaQh6S7Y09Ee8PfpS59
         tzUuhzKaHVtPSjHnpci/s1AW8x+h8E5IP7c/a18khFjQfl8MwwiwT8g0yrNC3K0v//af
         498gXbCk5xBgxtuthlmxFP/dSKR1jvxb+DTM3r2PpcjYTqgh78nG8KbuEPhpG7QbKjbd
         HAprBdQDQX6jT0oELIiKrW56KnJU/SZB0uV16OJINVn0w6goxdW6vWNreX/dv0oR8ujh
         HtDgd8vf/6+AgPFwHk8mssftT1l3yDhtzdCwY+EOctsL9xvMxe5LC90PrAAoNkCs1VIY
         qEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4D2XSEoDONhR5HzQOyr+cjbc68tw+gl1DEWdzV/0GZQ=;
        b=qwCRStZuU9Hhmu9EC+cAIMJUILQoxsD13kg1e4Vx91MPaMfZDnnjwUsh0mkG1C6Cug
         l01YdmtJBq6eZuWI1nVbs9P2UQypF5pO3GJJoWizJ2djbFRTmdIqKzHwdleS1knAfLsl
         hdFmiLBHzAKp1lPwhO3DP0CjUKxiolVqs4M2iETmPHk5Wi4Lgt4MewvfRhy+c9v1iQCb
         B6jajIncTKVmePVI9GyGPOW9F0O2ni2EDsYIFWU2J+w650NXahfeN58KbpVz84F70ylm
         dLRc5+OyJQ4UTjjyQcRSB0uUldkwsmL8r3sqFjy0lPJVV+WvNdp72vTIou3Z13OnHESX
         RBow==
X-Gm-Message-State: AOAM533TWorf2/9q3RdibRaNWvgxhZhmav9a4Mz45vspy6igFZYPxSXF
        +KZ+1IziyW2lVad7ZrCniVIDvVFwTFQ5VA==
X-Google-Smtp-Source: ABdhPJywFqgMGp1sJhwtxd5Ih3iAr9pPZZOQYeM4t+q3REJmUM12Oyp35yt+dPK45rD5kAhntJy5Eg==
X-Received: by 2002:aa7:cd44:: with SMTP id v4mr316091edw.156.1610385497196;
        Mon, 11 Jan 2021 09:18:17 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ck27sm229817edb.13.2021.01.11.09.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:18:16 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] dpaa2-mac: fix the remove path for non-MAC interfaces
Date:   Mon, 11 Jan 2021 19:18:02 +0200
Message-Id: <20210111171802.1826324-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Check if the interface is indeed connected to a MAC before trying to
close the DPMAC object representing it. Without this check we end up
working with a NULL pointer.

Fixes: d87e606373f6 ("dpaa2-mac: export MAC counters even when in TYPE_FIXED")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index dd00c5de2115..7cb286e53369 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4150,6 +4150,9 @@ static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 	if (dpaa2_eth_is_type_phy(priv))
 		dpaa2_mac_disconnect(priv->mac);
 
+	if (!dpaa2_eth_has_mac(priv))
+		return;
+
 	dpaa2_mac_close(priv->mac);
 	kfree(priv->mac);
 	priv->mac = NULL;
-- 
2.29.2

