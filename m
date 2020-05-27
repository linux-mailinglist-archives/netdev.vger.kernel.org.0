Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F561E51EA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgE0Xlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgE0Xl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:41:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB58AC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:25 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id i16so21701876edv.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 16:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ReEv6VHmmSs/5dJy3OyWVgvfCAbe+LncVGMy+qOSkVQ=;
        b=kkHeKDl+Y+oIO0GtzrsW8PI0/3Sh4XzJxaOYJfLIO7qQG4zLiOewIDV4wgUvd+u7I/
         DjKh24eajWmeDynK8lSLkTOeol/sI9sg+QdiqiZde82bGdMXBT2dMF0g08xkHqa6Pkiq
         g5A37FR+RTrqgKm2jG2snLAG3v8Tz9Rd+E0uzfOxD9dD1Ty8OvPwK8KvhFQRrOD3YPw9
         OPoi1uprSUpBLI1rGhPveHpOhr/mJsdwY8THi4wuTEK9haLNGfmGHiNq+e9HQEueWbFK
         3MPEYWcD17pbzyaTx9Dyf6S2/UUCZP5RzaAZaX+8dtudDE2adJCci0s+95FK4ta/LAtf
         AyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ReEv6VHmmSs/5dJy3OyWVgvfCAbe+LncVGMy+qOSkVQ=;
        b=PB4B3SE8WT97DpCTXz9jKAYcu2BK0rkLwEDMENhVWc4xrh8SoX3l+xvHmZ65Tm7Ax6
         boUZ9aEPcJbT3SdE1Y5wtBytD4Bo60sTsh1yKOW0KzacScQuZE3CzNNGjjbCibnzwS57
         KPNGVnp1OuO1US+a9Ap/787/hLogwQiXavZL+xtoBMgGbIWqAIXFFuat1s4BmDghQVqN
         XKBnId7e6py374C/UOrLWp2Z7yFnk2k8BIe559Blben4/yDSh/1c5WH4/wCSPJteSTg+
         uoCxQEfr4uYqXyfqyf7eUFyRY93wH19MHt8rT60iiEsxUFxHrECHS7DvxhLzmeNe6l/z
         RJyA==
X-Gm-Message-State: AOAM532hTWNC1I1/JmfU7vrQQtzoBq40Fffbiej3zTY2Cs4iFRd5JmuQ
        jo9BMYTODISQKvOzQmktcGs=
X-Google-Smtp-Source: ABdhPJzoFHXFIx6Kg6fyFa5V0Rcl2zHkEZg6FmRCw0JYe9nr2KFl+FN8rNmVF/l0O0vRO/m4q8iV+g==
X-Received: by 2002:a50:a365:: with SMTP id 92mr521379edn.220.1590622884372;
        Wed, 27 May 2020 16:41:24 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id a13sm3236555eds.6.2020.05.27.16.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 16:41:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: [PATCH net-next 01/11] regmap: add helper for per-port regfield initialization
Date:   Thu, 28 May 2020 02:41:03 +0300
Message-Id: <20200527234113.2491988-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200527234113.2491988-1-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
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

