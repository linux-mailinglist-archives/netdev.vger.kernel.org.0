Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4030459143
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239890AbhKVP13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239898AbhKVP11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:27 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8A3C061746;
        Mon, 22 Nov 2021 07:24:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so78673637edb.8;
        Mon, 22 Nov 2021 07:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XRbU5EwqGblDrN2z+6KzV4MrrpDP5P5PHn+nXQzP+Q8=;
        b=gFEITTs1QHovxGHCWQqIkTf3ELkgXJs8BrxOzYXjj42a3mNpjRuLO3Xhjnx6mp/a90
         GEqnZkp5WtkHwwwTpEsfqj5xnUe6CWz+WqBcZ/eZPgTo4cUJymeiNTVTFn1Ev08UUVqh
         Eh/vIMKSsQb8NWARRrBJY2+yAw4vInJ3LmxLwoM+Fo3QmUaXNjbiAGe2eLMBiFvc8AUG
         E34coFUZxKnh1Nn6SQ+0/ATAXwUdunGrc53OybHopmm1WkxuXkJro/zxjt5afSLbLiFd
         KTrFtUv4IfujEtyzw33VekZR+nKC2Cbg2MSB0MSvLexYo14Fnj1krW7E1nWmOcvXRkin
         xmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XRbU5EwqGblDrN2z+6KzV4MrrpDP5P5PHn+nXQzP+Q8=;
        b=LTRNGSn3427Mf4L/OHG7LyAx5lFkRr5+qCtyMhYncOAiKyJnixXgIOslh32EK/sHX8
         Sw3mSNOuvHD3q/ouVlsCiXRcrjiMlCIyyKSO/GTg0G5R30SxUjq0ZyimidTTaLU9UvLr
         FY+lfMIcBVgKf3SwEjAJT5n+Swk92ov170R4x+pms+TWV8VH4iml7kwhNL2vxO2l4Nsh
         xXUQQ5sAc1BwjpKoAq+6K4zaDFTGDlwZ7h6Ez/z5TK9ahXUsiiCMHMz4jTiJ9vuWy9kv
         HsMQsSrJKUyeMdmF+rYBhWWHl9yR4U3gME8mdwChUPA0ZpxvmNAuZR/AX3QUZMQOaxsW
         T6bQ==
X-Gm-Message-State: AOAM530GzVfps4eD42PnConIIwQUsp+q4JnVerMSrb8TctfytB3SKIFL
        vFMJKIK4vrWznQ37uvMT5eXvooawQYE=
X-Google-Smtp-Source: ABdhPJx+urhtXEBO7LVRfkQdTVBuTzGCMdrFb8SavLQvjnk9BA4p8mT19nl/nqzW2Q+A8ZMqJOgjwg==
X-Received: by 2002:a17:907:7ea4:: with SMTP id qb36mr42635859ejc.146.1637594656973;
        Mon, 22 Nov 2021 07:24:16 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:16 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 3/9] net: dsa: qca8k: remove extra mutex_init in qca8k_setup
Date:   Mon, 22 Nov 2021 16:23:42 +0100
Message-Id: <20211122152348.6634-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mutex is already init in sw_probe. Remove the extra init in qca8k_setup.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0eceb9cba2dc..ae02043a5207 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1086,8 +1086,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	mutex_init(&priv->reg_mutex);
-
 	/* Start by setting up the register mapping */
 	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
 					&qca8k_regmap_config);
-- 
2.32.0

