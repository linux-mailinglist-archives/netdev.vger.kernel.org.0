Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25E2454EF4
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbhKQVIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240315AbhKQVIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32FCC061764;
        Wed, 17 Nov 2021 13:05:24 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l25so513286eda.11;
        Wed, 17 Nov 2021 13:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FNU6xPKDr3rvlUjVkPE4P9ezAnb4hLxnQhk7TRXi4rs=;
        b=L1EIKewXih4eldhdfjzKyHVKl5Xpo1B+4qOJENeOBpqeKTcUvWfzTgsn4kghXc8MPI
         eI79hUDZaBxGWosvujzcLhn1b59vDUDCN91J+Qfcmf+NglPVTVtFdV7TtvJ3FrcdxqYJ
         ef4N0HixG/feh9yoN9hyVWtb0BJtpfgCs1T4dibq2DXnVtrGo9K1T5eUSPR4BDzVrkaR
         bxyv+6n4AiEFUKD426QNiDn4LzSkyshenzO976PXFn2uSSp1OwH/aFgjoE9DCCOGck8B
         CTHsOLR6bFTcg/jJHC0ZBbD+AWr9EjNNzHCt++Of988JVQZuV6QoqH89sZ5LJViUm6sD
         BNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FNU6xPKDr3rvlUjVkPE4P9ezAnb4hLxnQhk7TRXi4rs=;
        b=LV3goayS28bGXrUbLCCvF3w2DB0QayCaJKwmbTZ4rwe8kGbVjtYV0gH++WVtg3X07S
         Xfefe5lg1yS7ZZut7445Ze4kRTT6uUn5ccSDVDq9D660eV4S3ogec28DcM2jew+lGREg
         T026F9TtaIqq1lg94MJFcKVyxJWk0VnKhXSv/Gtl08iF1z/9QpQTmTn7UXhtRdyiBTBU
         4wHcP+jfxH+qAM039g0TSDuOnZ6Rbq0O/WWjQWD4ETd3fJzI4tTJfU4hLzTslvLFQsCD
         yNHU1knC8hrmaSvrQPsWB8T9oRWf2GTfnmIJOZgbNQlstqzH3cnsbroAPxwmzrKa2tup
         EHCA==
X-Gm-Message-State: AOAM530PIzXLVmst2QwhcfQLtQfv0FhE2igWSsD/UjJeqp6eaCIzo74N
        sJJR52Yu8aYjv2zBkQQpW2s=
X-Google-Smtp-Source: ABdhPJzf9Com31ZU9Qz2u9t1kEP7EvHfR6VfEbtY6a9t9cq38MeKolPpkZZjvQ2Yx7PT5/Bz9qlvfQ==
X-Received: by 2002:a50:9510:: with SMTP id u16mr2701745eda.134.1637183123336;
        Wed, 17 Nov 2021 13:05:23 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:23 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 06/19] net: dsa: qca8k: remove extra mutex_init in qca8k_setup
Date:   Wed, 17 Nov 2021 22:04:38 +0100
Message-Id: <20211117210451.26415-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mutex is already init in sw_probe. Remove the extra init in qca8k_setup.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index be98d11b17ec..ee04b48875e7 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1126,8 +1126,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	mutex_init(&priv->reg_mutex);
-
 	/* Start by setting up the register mapping */
 	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
 					&qca8k_regmap_config);
-- 
2.32.0

