Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094658863B
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbfHIWuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38433 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbfHIWuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id n11so97381683qtl.5
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpicpGdXTK1PGBwl0mUzVUTuW/a7NOSNYmHY4CsCJao=;
        b=MQc6CohN7GdAAAWIjoStcvcZlHac1dExi0UFKKpv4IVLNeepgHdvZr58beUdz6MGt1
         MPZkt94L43cfOI4EdSe6mmhiKPxs7bL+lFRdcysIqhZMXGkfnJ/7s5icKC330V9rjCKX
         pP3euZ7oe0uRre/8Cqz4ofbQ3cNGfFL0LWIjaGdIVRnLeUJg3UrtmaK+BLQzZW7OiYqi
         0LRSRVr0A154qYAxTv3/GGMqyEtI8s5qgTj302HAOXUEPOgG74PIkNHwCxTeb3+VAAnW
         ZrYqvole7FusKaUvA845MIcrzlLN1x10WszoplKtV+SvH5iyhZckg+8WB8AicGx8w9FL
         g6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpicpGdXTK1PGBwl0mUzVUTuW/a7NOSNYmHY4CsCJao=;
        b=uLpar9+AEZaNLDQFDBgtLAmcIILTP+d3BdsKNhSd+zpw95qsc7ALdZw4E6y/Zup/tj
         MtrVOArz5rdivuH/1762kkmIUjwfcJFnH+n3VNubMjJ6VC3zI6MCK8N824mw87O6GcLq
         r5N6d9xDuZSO5Re4Xn+fKIlsNaVsXV2quj5pdEBXeF0W5Jxsj3LIwPwKOqa1PWnlo6C4
         1iUsaJVsR+CRlgidRPsHxM2hHBSd8RVLOwnsHCQmDxrjQz9sJgdlWUqwR8X0ZIddtIql
         b7JyOVEoW/tkqFyoZm/okzxDEVN1hkDg7K+D3onA/ZH1KxH9jiSmcI5EBfXDjrh61Eep
         IBbQ==
X-Gm-Message-State: APjAAAUH7zuu9ZluZR9DIpoe5GIecBRJeSI32TY6pxWmslaaF4aANaBT
        H9syNrMg0aE9/Lbe5UGBjdaIPMei
X-Google-Smtp-Source: APXvYqwrcgQiKhRnLWdQ/nAxfxZl6CvAAavRIBcKvLnX0BKz2OAldRcLPKEMx6ro8ys1Tu5wmpM9IQ==
X-Received: by 2002:ac8:2439:: with SMTP id c54mr19945788qtc.160.1565391021041;
        Fri, 09 Aug 2019 15:50:21 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t1sm7496539qkb.68.2019.08.09.15.50.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:20 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/7] net: dsa: mv88e6xxx: wait for 88E6185 PPU disabled
Date:   Fri,  9 Aug 2019 18:47:53 -0400
Message-Id: <20190809224759.5743-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PPU state of 88E6185 can be either "Disabled at Reset" or
"Disabled after Initialization". Because we intentionally clear the
PPU Enabled bit before checking its state, it is safe to wait for the
MV88E6185_G1_STS_PPU_STATE_DISABLED state explicitly instead of waiting
for any state different than MV88E6185_G1_STS_PPU_STATE_POLLING.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/global1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 1323ef30a5e9..bbd31c9f8b48 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -46,7 +46,7 @@ static int mv88e6185_g1_wait_ppu_disabled(struct mv88e6xxx_chip *chip)
 
 		/* Check the value of the PPUState bits 15:14 */
 		state &= MV88E6185_G1_STS_PPU_STATE_MASK;
-		if (state != MV88E6185_G1_STS_PPU_STATE_POLLING)
+		if (state == MV88E6185_G1_STS_PPU_STATE_DISABLED)
 			return 0;
 
 		usleep_range(1000, 2000);
-- 
2.22.0

