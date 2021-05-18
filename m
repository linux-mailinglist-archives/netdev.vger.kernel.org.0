Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF05387EF2
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351380AbhERRu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345233AbhERRuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 13:50:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA1FC061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 10:49:32 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c20so15964794ejm.3
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 10:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOIrXjNEmPihq41EZN0fi6oGGGIK0Yz1blMZtu90Tzk=;
        b=qTHkaLT9nOsMJVCrC4ZOTh/lxVdJz86RFzOCwT8rAP5j0YpYcw6WezHTDNgkAFi42j
         nvlwEUc+6jruo6ri0pnC69W+cIaLbYwB5QXxwg0r/WEJUVvu9Vph1ofGy33HKS9gNm3P
         LBt0NxWGGSbJmGjs14bR6vX5YwoZVGQntia+AXLDvjx9gnYcaR7rH6lH5CcaEIyNnFqt
         xS2LrQEtU3picH6QKubb9dc1HX8P53L2ycTIAY2ZTjmcBzh7pruUnKZPE+b2GWnep66B
         P/Y11EAcT2bXWzhv0oFhmHy3HkAOdezo6g8lvkBft8V1oRqSfKY6qJzbvkl01aIIvIgm
         DDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOIrXjNEmPihq41EZN0fi6oGGGIK0Yz1blMZtu90Tzk=;
        b=nicKrSZ6vCOnPzsZd94LynDZKN0rlkx3G2v179aulI5haguImC25TmbHCNFeDBZJd5
         +Ly+uXq5NkQOjDE5qJRGKSvmDxqRfCdgWlR7qkZUwEtXs4BgZ37DfAoG8OtpT7sM/vbE
         96QaXY+JflQLgRLPXX5zow75iZJYP0jqKi53vFukUYTSsi9MHgyQ1mCi4CW6KD1EJemt
         9lIu/o0ggluolA44p/TJNIGA+7aYd6om0koFlLKhlKo7OdnnZ5303DwwszsT+m0gpNCc
         4WsPwmKHf9sp7tXkm08qJvPU0F2EvA+XJdfYXGsfaUVXiOOzZLUZ6fgzhbyCKCzxsIK3
         xoYA==
X-Gm-Message-State: AOAM530BdsEB/LR85QgwpVVC7jHHG28T8t5hjwVXRCpjlCgXT7Uc9TFy
        b/EyMrY/n2CLrGpqL2hLEK0=
X-Google-Smtp-Source: ABdhPJyExUKOJiw289dbieH/2Chdgh+jrG8FZK7FQNg7sVbrSLL02yvIys89/pHHD9NMpgYWq0QDFQ==
X-Received: by 2002:a17:906:1496:: with SMTP id x22mr7300917ejc.419.1621360171311;
        Tue, 18 May 2021 10:49:31 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id f7sm10504663ejz.95.2021.05.18.10.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:49:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next] net: mdio: provide shim implementation of devm_of_mdiobus_register
Date:   Tue, 18 May 2021 20:49:24 +0300
Message-Id: <20210518174924.1808602-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the way in which of_mdiobus_register() has a fallback to the
non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
a shim for the device-managed devm_of_mdiobus_register() which calls
devm_mdiobus_register() and discards the struct device_node *.

In particular, this solves a build issue with the qca8k DSA driver which
uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/of_mdio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 2b05e7f7c238..da633d34ab86 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -72,6 +72,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
 	return mdiobus_register(mdio);
 }
 
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return devm_mdiobus_register(dev, mdio);
+}
+
 static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
 	return NULL;
-- 
2.25.1

