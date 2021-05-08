Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9F5376DCD
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhEHAbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhEHAal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:41 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DEDC06134A;
        Fri,  7 May 2021 17:29:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s8so10862895wrw.10;
        Fri, 07 May 2021 17:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VxdnfwS83mL792/gMDUPBetwEP7r6LLFgozjaMCuGc8=;
        b=u9ktDqyIQBBO/JkRMfDN845QXtJ9fOk0hwu7hCzyb1gH8YueKz2MlAJVZmpqz1myRP
         Vw2mWxLHccvfzK86XoudZ4UUp51QVqUpr0BtteJhOpaDzPaApgxMoffhiDM5I/qjJfC/
         xRoh021LSsG76u7J/nQH576jaduAKYZZArEBp4+H2esBEZtuL9j5D89Ic+giHdPCxPgF
         kcR+YMTrRFItSs3CkPguW3hSIspf0F6G35mDKrpx3/a1yYKxtP9ziK8NMJWc7z177jqL
         M5iaI7aIM31P3DXtmeexrg7bwfSuO+JkISdOSCub8ftulojZZH63d5TOkcw9deUSXCMy
         xmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VxdnfwS83mL792/gMDUPBetwEP7r6LLFgozjaMCuGc8=;
        b=XFPybQ34yLSC+B4DvB0ycsC5221OsvFjlMiSUFkicPtWTkGzc60S0slgl4WvclZUyd
         vy7qKRv1ZZrE84NSlF8bRF2az88L4csYVjsxsx4nYqNlEx2xZAXFenv8VuAOq7LWeZOV
         0XlUArgaCmpaTD2W2NRcwescezkAu8r642q8gji57ILLO0+tX4Ava752a+0IXl8NfNxi
         llXh5vo3wiUsIH1cY+0E7XgvUBcwAwgvD/cUEqt4pEvm608L9G0G131Cx0TWimWFLbbK
         0iGBhuCKCx9qtErwyfK3uscIV8ioQYCqSxdMnylbbIu7mpn+6gh+4cmfsRSDMJVL4vAk
         WKbg==
X-Gm-Message-State: AOAM533LAuOB6uFAB4pq5mkdii0eIa9LwjpnRIaRlnX6sR070mdEmWO3
        HKFYXAQkjIT9fQFjF8C3qf74fkZz6asH6g==
X-Google-Smtp-Source: ABdhPJzFV8l0djkc+Zef2/k0xt9WwTs5aE1ZaEzQ1nr4GaJfHANkXqLbZhk3qLFhg/RflLadx3C2hQ==
X-Received: by 2002:a05:6000:1ac7:: with SMTP id i7mr15898888wry.380.1620433778543;
        Fri, 07 May 2021 17:29:38 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:38 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 18/28] net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
Date:   Sat,  8 May 2021 02:29:08 +0200
Message-Id: <20210508002920.19945-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dsa now also supports ethernet-ports. Add this new binding as a fallback
if the ports node can't be found.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9905a2631420..285cce4fab9f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -730,6 +730,9 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	int err;
 
 	ports = of_get_child_by_name(priv->dev->of_node, "ports");
+	if (!ports)
+		ports = of_get_child_by_name(priv->dev->of_node, "ethernet-ports");
+
 	if (!ports)
 		return -EINVAL;
 
-- 
2.30.2

