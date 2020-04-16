Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D281AC65A
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgDPOhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732826AbgDPOIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:08:31 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2623C061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:08:30 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id j3so7503933ljg.8
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G5ggDZ1v3A6kQc3OJTARyj3Ghh9ae4R1QQxarRtXKZQ=;
        b=bZmFjNrT2PhYv0+GlJPOFRCUdoklRITtflU0d2ClsY/L119cmZ6oCS6JGB669NtYG5
         oWJl+Z3Qr57IBKjZeYIZOvUnd+tOLz1Gz9rssrfBvbuPQzLKnCi11U2VYEtO/eB4GTmk
         2yM2sasTR6ygWvgDEn++hO6ccxlzFhL+sccyiU6OzmKmKN5RfZfxJkLdgVHSXTeEWtxW
         sRLdSNmyoM2pmg2IZmw6fM1JgIC4cPysfEFSpWjxOcS53PMT3fP6RsR7YFFo+8Qhe5mW
         0r0JvBOHCdFOGRhXFM502j140YYh00C8AKLXP1qZ3uuAmQvAdquqHNVHOzjutcSCnWR7
         FcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G5ggDZ1v3A6kQc3OJTARyj3Ghh9ae4R1QQxarRtXKZQ=;
        b=hjZZlQ45M0y+c4AXLQDNN4U/HfiiK4vMyI3CxXPsApm+kKYPiD4hdqOoYuMIo19alk
         6HWC3H+CaOm5QyKEoEYdv4n4Fx26uoMGq40tWQ/aCd+Y1dnR1pUQYEJRK9QPCIWVRnPG
         UYUX7tyXutLbzZYcy7sE9toEJSzYrraSplU/quaA6YfHVA68XFBDLdRAtyqTO8Ygc0ZZ
         Cc/uqVQRcxfHgkqf9dFNjt1fdj6mDmNItCsSTGrlfMaQjddgWcSEm8XSo2r72TgXCn3x
         BKkX3g+TRXQP0N3XgmZvz66h/hJKdEi0ayZgKxM+E+THGakUKsRx38TQe9TIYfllZL3z
         /nkg==
X-Gm-Message-State: AGi0PuaV/XQwz0s5MFuk5ofEEwpKNJjofeb0PG+oe5qoIQN66AaEmDfR
        QvG/xm6l13qqW9GfVbJP+B2Gd3/i/T5aCJFx
X-Google-Smtp-Source: APiQypKd2NSnBObWH0beElbeH7n9hUrQlvVPCw1QPrHOeNrV9J0Ms1UiMMr1iOH0pS1hnHJKk2F3Kw==
X-Received: by 2002:a2e:9ac9:: with SMTP id p9mr6590141ljj.222.1587046109122;
        Thu, 16 Apr 2020 07:08:29 -0700 (PDT)
Received: from xps13.home ([2001:4649:7d40:0:4415:c24b:59d6:7e4a])
        by smtp.gmail.com with ESMTPSA id i20sm16137868lfe.15.2020.04.16.07.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 07:08:28 -0700 (PDT)
From:   Odin Ugedal <odin@ugedal.com>
To:     odin@ugedal.com
Cc:     netdev@vger.kernel.org, toke@redhat.com
Subject: [PATCH v2 3/3] tc_util: detect overflow in get_size
Date:   Thu, 16 Apr 2020 16:08:14 +0200
Message-Id: <20200416140814.171242-1-odin@ugedal.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200415143936.18924-1-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This detects overflow during parsing of value using get_size:

eg. running:

$ tc qdisc add dev lo root cake memlimit 11gb

currently gives a memlimit of "3072Mb", while with this patch it errors
with 'illegal value for "memlimit": "11gb"', since memlinit is an
unsigned integer.

Signed-off-by: Odin Ugedal <odin@ugedal.com>
---
 tc/tc_util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 5f13d729..68938fb0 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -385,6 +385,11 @@ int get_size(unsigned int *size, const char *str)
 	}
 
 	*size = sz;
+
+	/* detect if an overflow happened */
+	if (*size != floor(sz))
+		return -1;
+
 	return 0;
 }
 
-- 
2.26.1

