Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D871E9781
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEaM1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaM1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:05 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A354C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:05 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z5so6595220ejb.3
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AiNGarBZtu/82wT45Q+33O8Cd48rBTG3T6gYv5coMEg=;
        b=l1fI9SPnfaFtbBQn+pQ2ynrjvLBL/0/Uea5Q9rQ6DquXkxaWiq2oG/VzdmK+8nDYHh
         vqLgSXg7TJ4vGW588yfxZ4iREcQxEcWv+CjGTkyY7v6o0aLQ9ZjcDaw47XPxp+ZNAArL
         9MB0+nTMV5IOIiQYCF+AAPxMt43TmNmtIlYbSiKjGUp5CLcVWHU2iIPsdTVhtZ1jPicU
         /C+2hE4NKQonnB5XOCwZVbI3WJ/lR4OzKxDoRGyTv45rBgAjj0UD7lcXxKZZ2ePge3zB
         lDTnBGMb1Pz6p/wF3fF2exMKLovXocvG+dajOg10L82RVKvh8yMCgayEOusOxJ7nIwaG
         MjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AiNGarBZtu/82wT45Q+33O8Cd48rBTG3T6gYv5coMEg=;
        b=dIE5EYyHjn20j99ioLlcu48oi54OwVdbpa0OgHc9u3ecIKFpuJAl1VmWE0XoaNO+jo
         8OwT2heuyWDPzMh0jZdxgpKZDS2wEOjr09/9xHO4M/45Yr6QOcxw8M1fAkbr7xzfoABN
         +MJj77Ltfn+UhQC3Nte++uQLzW7SMms1PXPMvuibm9DgHpq8OC9pGss/Fuf9006F8OZi
         i6tWimRVu7Qjs0IRU79aTHtP2kgu9KrcYV5dsFypF0ft10ldpm5MZkn08qTPFQpfeWUv
         INkGX7h+maYUrG1y2HoexWHpt4fZXsm9Y/hw9dW2+FLd1nJHFWzhE/nD1umlpUd35xxW
         utig==
X-Gm-Message-State: AOAM532SQ/EEmVlkjO9rSSgV+ym09/hH0IF3F6TH7mIrH0zewiS9Dqj6
        85Y/bxdnPqEs6bV56mZmMVU=
X-Google-Smtp-Source: ABdhPJzWJxssR1YER4jQdUF1zPKRXVePdJ9C5hkxMPSYCFGvBwurcxUYnE/IdNliqTIxDb5jeOOYGQ==
X-Received: by 2002:a17:906:6c98:: with SMTP id s24mr547900ejr.438.1590928024093;
        Sun, 31 May 2020 05:27:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 01/13] regmap: add helper for per-port regfield initialization
Date:   Sun, 31 May 2020 15:26:28 +0300
Message-Id: <20200531122640.1375715-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
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

