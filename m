Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2F31FD4C1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgFQSoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgFQSoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:44:08 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8771FC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:44:07 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id t20so2258609qvy.16
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xtNpgjeC+vuPrrXlD/xInlHQ99Epa7kISaCzCK7ILus=;
        b=LG8aI0gmhCYY5K0MzX0BCyzEQveIFY0Xc9hjzdLQjfJuVc8s/O2GckHWEnADRyBqz7
         1iztOEoF0SAX4AM81iggWWEuF7oRu10X70zFlZddrxxaQx7xV640oPsld4/oIcZLDR67
         JhjYtKswIZTbJDSl3XhxPuQWcfxBuZ4YdqY7GY4sszicA5WBlEvb3ZFhDYw0lC7pk2JK
         ZIIopZnIWhnYDR4rhkTebPi0psGhVdvw/qGIs6nKZ+NgbV9NvZQfTpdE1BooK0ZVV8DV
         LlwMJHzWn6+C8oh/NEZ1lpByFUF05b8b9WCrtwzyMU5REDXxpRZzY9CVmBC5Hw6NF6tz
         96lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xtNpgjeC+vuPrrXlD/xInlHQ99Epa7kISaCzCK7ILus=;
        b=hE8rXzokNuBuS//EwoIMAoTnAbKcfGo/66LKTMlviUkFYoMRNE+NdiXQ2rgcbWWkpA
         RqMpNXanOUlaEj06HJ0I8aToQpdHeByemgDLYmDlqYruZKt2chPDkuELusmyXt7EDRAM
         fC2RBh6YCshvhO7ovzmzcqknd0rhTgbNuivSQPyjB6bfZTqSY0ixaCws0EUz2NZrXDXO
         XNcSz99CDEAu6o+tF3LrVDxTtdcWTx8ulTaFF/6JMz5AD0LJDX98PnUi1vItpF8eRurA
         Pbm7LxTdnQpwGVcUyt0RC5N/Cgu+AUaiDvWYLMGh0zrIyWAr+Eoq6clryJCDdVI0bQyx
         hYJA==
X-Gm-Message-State: AOAM530NxP1nIIG0QH7nwZUsEBx3153njhla3B74zGtXztmXIVKGZYJM
        ECx1T+7ey2LY1MAbeo/5y1CYJ8Sl+VCp9A==
X-Google-Smtp-Source: ABdhPJyKwHBF5QSXK1x1wNFGXWHxEHSV1Vf9rNIz6FT74HLwsq6mP3K1l7zm6jqRD5pYnvRS1N+FbTgxJRQzOg==
X-Received: by 2002:a0c:f494:: with SMTP id i20mr9035919qvm.179.1592419446691;
 Wed, 17 Jun 2020 11:44:06 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:44:03 -0700
Message-Id: <20200617184403.48837-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next 1/5] net: tso: double TSO_HEADER_SIZE value
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
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
one DMA coherent piece of memory per TX queue, this patch
might cause issues if a driver was using too many slots.

For 1024 slots, we would need 256 KB of physically
contiguous memory instead of 128 KB.

Alternative fix would be to add checks in the fast path,
but this involves more work in all drivers using net/core/tso.c.

Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
---
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

