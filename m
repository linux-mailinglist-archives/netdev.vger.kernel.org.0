Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BBA40441F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 05:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhIID66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 23:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhIID65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 23:58:57 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6C4C061575;
        Wed,  8 Sep 2021 20:57:48 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso819344ots.5;
        Wed, 08 Sep 2021 20:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6nfIMaaVLj1YzU7mkiPI+ONBiuveYWVyPFsoIJsROgY=;
        b=btMnqgkad9oUWL8mWAP6fG+U3m+iZ/3foSLMTZfyTk3Lxf2embDq4Ngbcs+9GH0ug5
         ckt+fhaat3Eky7CIB2UW+LxLzXN0lV+YOY60ZtKPLu121XgUM2Gjc8OjCprtcnMNaHPf
         Pf7G39qXQlIpL/1VVlPHROupfdlrSG0XVmskKdcmmrHKjBmDKwRvgLnQGPTD1kaG/rg0
         dnD0KNMldZWbnq5QM2xo7KycXDsZ38DfiiTY0izkrGMzDVc0QgCqasqsuCuuVkApy7LY
         ugm8dcynjpnc16BlUdDJ6wtb9n4HymTgl2u98X6qE0kc5kvAJIi9Gopuj3npHmucBpdf
         1KWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=6nfIMaaVLj1YzU7mkiPI+ONBiuveYWVyPFsoIJsROgY=;
        b=IFdlEYV05u4+w5iNSJMj5FLomAK4NQsp85omvCeuOzFvKPWl4n0aXIMMGBXDT8FzPD
         ak10m4E/0feN9c9sGAV4wcHZ307JCMgiq+fj4611eBqaLItWbjAopt2XaPwm6Zo7DmQZ
         EG5hl8qKpOVi8JLPVwiQj1Lnc9Zl2WRbqNJVDgKwvjQH6thkPaYxKZVVYjew3xnGqoH7
         FVvxAPtKriLgAgWJErdhwUG8c/+rCIDmifv1VrFagPMT4NcUT0oJapqO7DP7hZ0539KK
         3G+erPettvw5xidtw2wxHrSdkDDIW1H0O5PE7zuruYhSwP/HLIH90wpSP/R8H/z+vw86
         f0cg==
X-Gm-Message-State: AOAM533jY7ndZWKYkcrq/ufzE62Q3VIiaqv0McFiFzLX5Isi6IPT2Vpm
        pfJx43B4+ayeUXOfwuBGot4=
X-Google-Smtp-Source: ABdhPJzXy1WjAqijs/abzPhzNbUm43O6U1lhkDUnGBOqquBQWTlPexXbC/JyB6CBBkvoR4NQuwGKjg==
X-Received: by 2002:a9d:490f:: with SMTP id e15mr746111otf.340.1631159867638;
        Wed, 08 Sep 2021 20:57:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w12sm148411oie.41.2021.09.08.20.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 20:57:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Andreas Koensgen <ajk@comnets.uni-bremen.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: 6pack: Fix tx timeout and slot time
Date:   Wed,  8 Sep 2021 20:57:43 -0700
Message-Id: <20210909035743.1247042-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tx timeout and slot time are currently specified in units of HZ.
On Alpha, HZ is defined as 1024. When building alpha:allmodconfig,
this results in the following error message.

drivers/net/hamradio/6pack.c: In function 'sixpack_open':
drivers/net/hamradio/6pack.c:71:41: error:
	unsigned conversion from 'int' to 'unsigned char'
	changes value from '256' to '0'

In the 6PACK protocol, tx timeout is specified in units of 10 ms
and transmitted over the wire. Defining a value dependent on HZ
doesn't really make sense. Assume that the intent was to set tx
timeout and slot time based on a HZ value of 100 and use constants
instead of values depending on HZ for SIXP_TXDELAY and SIXP_SLOTTIME.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
No idea if this is correct or even makes sense. Compile tested only.

 drivers/net/hamradio/6pack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 8fe8887d506a..6192244b304a 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -68,9 +68,9 @@
 #define SIXP_DAMA_OFF		0
 
 /* default level 2 parameters */
-#define SIXP_TXDELAY			(HZ/4)	/* in 1 s */
+#define SIXP_TXDELAY			25	/* 250 ms */
 #define SIXP_PERSIST			50	/* in 256ths */
-#define SIXP_SLOTTIME			(HZ/10)	/* in 1 s */
+#define SIXP_SLOTTIME			10	/* 100 ms */
 #define SIXP_INIT_RESYNC_TIMEOUT	(3*HZ/2) /* in 1 s */
 #define SIXP_RESYNC_TIMEOUT		5*HZ	/* in 1 s */
 
-- 
2.33.0

