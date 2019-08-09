Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D878863E
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfHIWua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39651 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbfHIWu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:29 -0400
Received: by mail-qk1-f195.google.com with SMTP id w190so72915005qkc.6
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tG4GKa9SdRuZmk3UpWAt4OVlqd1Y0flBXHqmilPFQns=;
        b=M0rWA7NXBCgc1SC2PktG2sBRfI6HkKASQP4Q6MiHEt0ZkEYBLDOoXjHRIid/Mk4K9k
         kG2B1ebyJpv3NNBFIM0Bi2sT1FYy0JhHpLpVvFi1fGyoJtD4k+YzS6zkJ1q7GKjnC1kg
         10v5/Ms6ediGKA190x1+ZsgjfiX/T+uq6qiEoMyR/kv1sC7L50CT7usfj+A8TuPRVl53
         uEMS3NwVAXnMPB+6Ww7E5DgMm5x4RhgmBhkZs1jIf8Xp0ulFcBV6Bqg1l2EVl0y8GN9W
         q5+9ubVS4nfXw7YqKVmq1/IYapUIEDplcF/cloWNJ/AivV0u89n+UUaLBvrwjA04Kx1F
         eQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tG4GKa9SdRuZmk3UpWAt4OVlqd1Y0flBXHqmilPFQns=;
        b=ZJaGP2gfFwTocH0BjGoNIJKUj2+m5+i5xNTQ9xpzwlHcqpeLc3Bzn94fHxUIPU1zsQ
         I/hiy1VQvJ1sXiV9mZqQxv7+j/2l2xx74VHl7o5u8CAFH3c14t5d2vd4ya2rkQjLnzXV
         cu085gNFkgIzNyF2U33qTsfGMExTbM9cSXfDrA6xVCb9qxfiUftZv8vw9ggkc3pebvxW
         HFRRn5Z79/prYHHz/O1iby2qMkh4yJy+hGjZG3bBOgySrB2kfaIki3HVfH65Y7IlVBKA
         b+S4ORXq7HpxS39kNSgKVD2IxqmNPgQ6zbsAN4n+ElshxLxwYLHE0nQfo6PXQKypz/3p
         CEvQ==
X-Gm-Message-State: APjAAAU7Fb9hZwNh8fjE2+fErhjHl+T+qXHR7dBJVMg/+WXMNahfhvT+
        4nhkGcaqBCMomrKqUcdPDcW/pf4a
X-Google-Smtp-Source: APXvYqzcpfMoBro8vsdcA5aXyAs/66AczyZcdipVLL59hZ4DZBMNXgZbqwcDrHGrO/eQij5+N2uPYA==
X-Received: by 2002:ae9:e313:: with SMTP id v19mr14338559qkf.22.1565391027855;
        Fri, 09 Aug 2019 15:50:27 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j6sm42773389qkf.119.2019.08.09.15.50.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:27 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 6/7] net: dsa: mv88e6xxx: fix SMI bit checking
Date:   Fri,  9 Aug 2019 18:47:58 -0400
Message-Id: <20190809224759.5743-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mv88e6xxx_smi_direct_wait function is only used to check
the 16th bit of the (16-bit) SMI Command register. But the bit shift
operation is not enough if we eventually use this function to check
other bits, thus replace it with a mask.

Fixes: e7ba0fad9c53 ("net: dsa: mv88e6xxx: refine SMI support")
Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/smi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 5fc78a063843..18e87a5a20a3 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -64,7 +64,7 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 		if (err)
 			return err;
 
-		if (!!(data >> bit) == !!val)
+		if (!!(data & BIT(bit)) == !!val)
 			return 0;
 	}
 
-- 
2.22.0

