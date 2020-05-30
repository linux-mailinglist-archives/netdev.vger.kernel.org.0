Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6031E90EF
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgE3LwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgE3LwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:18 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF32C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:18 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m21so3705415eds.13
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AiNGarBZtu/82wT45Q+33O8Cd48rBTG3T6gYv5coMEg=;
        b=cXRWGyJ6uH9mjOVaKVtKvELb4gEYjQUnMq2kejS9xy1eHu+6UoPrt0tQLRhkW2df9I
         BU6uHTk/alK07Y95Hmebaod7gRBkeaD29D2RKyUxnNRvPsLhR2T7oddj0Lj27/ToUmo8
         rdsW3XQ0kxOVxEtA9WksdnfJ+i2gIaVn2aGfAb8yp0Lt1rWwDDgoUbBr/UIzzaBF6Btd
         J8u6zf6afiJ2R21qU+9JZg8t1rN5tjNXmy2UwEY8cBthReP1gYBbrf2Mm8S5wvCfI5US
         odEC3XstrWW+s4o/F+bteXulQoNgfgBU51nH7CnCy5jN9l1C77/X/pFcliJCmpg4Xu+d
         MD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AiNGarBZtu/82wT45Q+33O8Cd48rBTG3T6gYv5coMEg=;
        b=t+tIebVc4W+VMdq9uVyR/KGoTu0YVOi9m7hwtI+9bZo/ZWpABqwJqEPV29VwaFP+82
         J3h8rOAri12CMcrqZdKTWhZK8NaEmhSPFbWgAvERnVCvWhULdef803jL69XyQUimkxxo
         djWVsQR8yDLppFx+PuTZcmyrfRMVkr7CM98CBuNoF6G+WTfywauZLUN1h0miwtGDe8FW
         2Fp/I8Kgu+UW1q9zrms1DFkpJPZyUsW2NvG41SlH3B3rCjmG7Q/NdfWDggcCqkYWHadK
         3YZ9BdOxkgfMCXe7SsOTZUFz06K7lGVHUkdQib9zhvuR+eyG77kHqjoH7tRKBXFeyZzm
         2b5Q==
X-Gm-Message-State: AOAM531T38Vtp9MAGfIimjoSQI4WRyhIZPsGU/A8bq20LnZj0z3iP73M
        JR4E/OY8f2xv2uWhHY3P7OM=
X-Google-Smtp-Source: ABdhPJxSol15FHrlVY3uKaW43a1Kq3IBl20jK0Ga0taKElXXzGpRb9p8RmVKNpHMt2EKGE8dOzNCgA==
X-Received: by 2002:a05:6402:c09:: with SMTP id co9mr583958edb.238.1590839537037;
        Sat, 30 May 2020 04:52:17 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 01/13] regmap: add helper for per-port regfield initialization
Date:   Sat, 30 May 2020 14:51:30 +0300
Message-Id: <20200530115142.707415-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Similar to the standalone regfields, add an initializer for the users
who need to set .id_size and .id_offset in order to use the
regmap_fields_update_bits_base API.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20200527234113.2491988-2-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 include/linux/regmap.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 40b07168fd8e..87703d105191 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -1134,6 +1134,14 @@ struct reg_field {
 				.msb = _msb,	\
 				}
 
+#define REG_FIELD_ID(_reg, _lsb, _msb, _size, _offset) {	\
+				.reg = _reg,			\
+				.lsb = _lsb,			\
+				.msb = _msb,			\
+				.id_size = _size,		\
+				.id_offset = _offset,		\
+				}
+
 struct regmap_field *regmap_field_alloc(struct regmap *regmap,
 		struct reg_field reg_field);
 void regmap_field_free(struct regmap_field *field);
-- 
2.25.1

