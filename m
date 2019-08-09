Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C36488641
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbfHIWuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:32 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42252 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbfHIWua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id t12so8813828qtp.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v1sOcuMv/2uHBK2P4/sE7Lsttb6UgjXcKXXXqrXRrS8=;
        b=s5RRib5qQIwF3vV0Ij5WvebwRR174Rr+uoXOPzXpHVzufihJ8dWKcIugNhnlNEZAql
         FfQYkA6JYc3eMS/V7281HXLrBGfszwvwCIqQ2MuAEJK5osFhmqQP2m3y3nLs0QclZ3Ta
         mWPPAHPoWRCBHxUr0hWLEtsU3GMDLxsdOuBjJGqHIJoWxmogOCpebsfIpnZE72UDiooe
         y99/OGZh/8ald/0/L/Sb/yqngVTmdZVULoFWxxsbKuGS4H8KR0fBnGRdgnfNk2SoA4Ny
         s3YdQ0CnItPxBp0j9lbzuTPRk4E+LUjmiiE8HEKcIIyxe+zHvUSJDD2czp7g5sVpirP7
         gKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1sOcuMv/2uHBK2P4/sE7Lsttb6UgjXcKXXXqrXRrS8=;
        b=WDEURrM5RphKMHsgYbopBv3mnMp1V0od8ohV9jrbhxRneskgYF0CzWUDGEEdZfSw39
         eHFb0idNYa2in5+OrCZ0W2jdmWW8GZWkLb8Ush6Ozv8Rp5XxU8cHH+qTCuFVHsyVOrnK
         d4L90FBwGazmEL8Jf+4zNgf3qwzdWv2KNzdR266C322OiwDON0l/wzmzU3+ZMOyF0gju
         HxVBRxrsWrHvoSWeuZT8Hejk9mMndyLdwxVNDxW38sw7g2hZr09LvYKSt8g046Ir/4G6
         kvZD49i/8agTinZSpfAanbbvlyjcTutF36cMOK2IDZWgxuV1yZcZzuoM4fxDwdSSPRBT
         FD5Q==
X-Gm-Message-State: APjAAAUrM+mmWpOmPkFk68Mgoqm4GdYDsGYQDaekYjgz4vX0QbcIlw5g
        p3B7jpkfnPHkeqAbngRdHYIjZ/x9
X-Google-Smtp-Source: APXvYqyvUnpsCmgG2Ci+Rdr+C6p1ylk3Dlrmvcd3p43SBFyV/8lQW4i/OZBhTZgR3NyC0Cgurrq7sw==
X-Received: by 2002:aed:3f57:: with SMTP id q23mr15018847qtf.39.1565391029150;
        Fri, 09 Aug 2019 15:50:29 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id i5sm39678355qtp.20.2019.08.09.15.50.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:28 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 7/7] net: dsa: mv88e6xxx: add delay in direct SMI wait
Date:   Fri,  9 Aug 2019 18:47:59 -0400
Message-Id: <20190809224759.5743-8-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6xxx_smi_direct_wait routine is used to wait on indirect
registers access. It is of no exception and must delay between read
attempts, like other wait routines.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/smi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 18e87a5a20a3..282fe08db050 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -66,6 +66,8 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 
 		if (!!(data & BIT(bit)) == !!val)
 			return 0;
+
+		usleep_range(1000, 2000);
 	}
 
 	return -ETIMEDOUT;
-- 
2.22.0

