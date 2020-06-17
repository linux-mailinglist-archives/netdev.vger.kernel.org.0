Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A461FD34D
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQRTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgFQRTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:19:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3689FC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:19:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p22so3253596ybg.21
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m13kTJ1NjOac60RYaNiwR+Kl1zyg1f1CHhviTMQRb58=;
        b=QlO7eCTdVDclZRyBIK+U2UpFkAWi6lsZ/9yPDOfAsSx52HgaSti86p+i+J2t+9KIqW
         kcD3vIoIiRP2PKIqyJV5v/P9gZRlcX+vykJAeLpIntxAivH509m6C6QXGg+y6tYcUHjt
         /f4+eccjm6vyXk3GLe7hRB0/Z7FnLt8N3G4BNLnBOceMr7J9XJlXPhkcOMOJU/3x+x+n
         tyR390ZyA3s+hbgqO7N0WdrnXaXsoBKbxahOC5QSzNgwfcYOZNv1Rm8J/g+vFsqdszuV
         nlaowDiRc5bQ6N9sTzuYG8/a1T8MhY78nYpOzfO3hgBiL7jG/FocJugzAl25OFqa+xwG
         /moQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m13kTJ1NjOac60RYaNiwR+Kl1zyg1f1CHhviTMQRb58=;
        b=MRl56Gi2P6H2pzsjbDOOLJKjyqEqxk7JBADMxRQpPFHnxBdKCIPHR5fh/q+0NbMJQI
         wODL26j0oLJ/aLkikg2L4u+5BEMlKg7OCQ+MwGnmkNUhsoFZmvTwWaIXSQmSEfM2JE+Q
         S7GcnV7g2HW7Rad/r/ZgjXv2Z1uy8Tr1Nt7cNhWMl2gTL8vtLvrbELBrZNVPre9UvPjF
         BnY0ktIRZ5CFsCCG0svTjDKTKTBacrCu9xLXpdUTmNUDqDccHT4NkSCmG7XIx42HzPoC
         bNcJfCY8oXZQeVbHpddj74vlT1/Efldojn0nN8SZl7H7PQZYmh7MXLvkqmi1IXcVzJ4m
         O3aQ==
X-Gm-Message-State: AOAM532B5qFZ7GESUPNTi4jz06I0LzcAHfP2zsMs4cgmBfiGtqoSq7gb
        EIACqy24d8ZcxiZDWw+yyf+/X0XhaR+uoA==
X-Google-Smtp-Source: ABdhPJzBiFcIUKgSewU4LjVGSzAGmL5TDLFtWPrmmRGOPGU4y5uTTP9734zfV82PqFL9TamRGnYuWpelihFc2A==
X-Received: by 2002:a25:bb90:: with SMTP id y16mr13712959ybg.231.1592414357467;
 Wed, 17 Jun 2020 10:19:17 -0700 (PDT)
Date:   Wed, 17 Jun 2020 10:19:11 -0700
Message-Id: <20200617171912.224416-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next] net: tso: double TSO_HEADER_SIZE value
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transport header size could be 60 bytes, and network header
size can also be 60 bytes. Add the Ethernet header and we
are above 128 bytes.

Since drivers using net/core/tso.c usually allocates
one DMA coherent piece of memory per RX queue, this patch
might cause issues if a driver was using too many slots.

For 1024 slots, we would need 256 KB of physically
contiguous memory instead of 128 KB.

Alternative fix would be to add checks in the fast path,
but this involves more work in all drivers using net/core/tso.c.

Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
---
Note: probably needs to stay in net-next for one release cycle.

 include/net/tso.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tso.h b/include/net/tso.h
index 7e166a5703497fadf4662acc474f827b2754da78..c33dd00c161f7a6aa65f586b0ceede46af2e8730 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -4,7 +4,7 @@
 
 #include <net/ip.h>
 
-#define TSO_HEADER_SIZE		128
+#define TSO_HEADER_SIZE		256
 
 struct tso_t {
 	int next_frag_idx;
-- 
2.27.0.290.gba653c62da-goog

