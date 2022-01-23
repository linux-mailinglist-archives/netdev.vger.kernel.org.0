Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C069E497465
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239580AbiAWSkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbiAWSjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:39:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58292C06173B;
        Sun, 23 Jan 2022 10:39:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l16so14124384pjl.4;
        Sun, 23 Jan 2022 10:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JVlgIOfm3MirYG6wT3KmStCSBcBsfAc0KKMNuO1EDBQ=;
        b=IRJeAZll5KWb5nZplfSeU6guRB4GiFVlmwRWN5THO4+nOHnkye//P3+ooMx1qU0Idu
         fFZVRqj/QyGAVXmatp5tgfaYpJXYAtpnjBBxRWu5Wvkmnwsx3g8Tjgh9oQwBR2wPW++P
         wLdOy3uqaoPu+EyqNkH5kZ+fUz4ohWrcIVJxTC3MCifIpKCWGz1qFS6FNHxpXxFe0PoC
         AT3uXJOngA4y0EhtxI53KfYaPrJAqJrWOBT1HOtR03NOY7P0vt4kZgHhC2coLJKo7Us3
         W80ZyTrpVomG2skPaPmorlVBJwVUANQ70fcVX6xsG5vtQhhZlfbAeqKRjnknAq4cVDJ8
         6T7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JVlgIOfm3MirYG6wT3KmStCSBcBsfAc0KKMNuO1EDBQ=;
        b=LY27OMni/Ch9QPMSY9/fawSBd29VXXhViJjf7V5KOlyuU5a5Z0hVdoHGUVlkjOnoiJ
         6E2TaawilckyX6XMpXTXUO9qcdgNGpgf/gLelj7ekTSZlP3e3wdCmwilKSMt/PVRwAwI
         H945s3KkQKZDuNSy2eid0mXDhohxrB5gIMHhs21TW9jLC0zQ1rghGes0NG3p0rlbF45I
         zOQ7DeKqs5JhhUIkEWAXmXcazyU0syqxqAsYtOirvlIUVxFhKSTY1TFIZw15ETsXk+4+
         vqKMOV3v24tbaKbtm5euFuOs9DTbo5O5NgMog3NUWIHZ1F0g6GVQe7NxmHxRn/P/IQHE
         QXCw==
X-Gm-Message-State: AOAM532vCQX9D/SVJ6A5fFxxob4yc7SlO/E4k+uvqZDn0pepd9vdvjN3
        HaY7Gs9xANKkLwitvctgqkU=
X-Google-Smtp-Source: ABdhPJxoxLg5zqGpwJYdAVGDViNYQ/g58elCQIgqh6DVg5oaESBFyRvjiA+IS22GevMehG0R2Obh9g==
X-Received: by 2002:a17:90b:1e05:: with SMTP id pg5mr9787026pjb.188.1642963194829;
        Sun, 23 Jan 2022 10:39:54 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id h9sm2038248pfi.54.2022.01.23.10.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:39:54 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller " <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH 02/54] net/ethernet: don't use bitmap_weight() in bcm_sysport_rule_set()
Date:   Sun, 23 Jan 2022 10:38:33 -0800
Message-Id: <20220123183925.1052919-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't call bitmap_weight() if the following code can get by
without it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 60dde29974bf..5284a5c961db 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2180,13 +2180,9 @@ static int bcm_sysport_rule_set(struct bcm_sysport_priv *priv,
 	if (nfc->fs.ring_cookie != RX_CLS_FLOW_WAKE)
 		return -EOPNOTSUPP;
 
-	/* All filters are already in use, we cannot match more rules */
-	if (bitmap_weight(priv->filters, RXCHK_BRCM_TAG_MAX) ==
-	    RXCHK_BRCM_TAG_MAX)
-		return -ENOSPC;
-
 	index = find_first_zero_bit(priv->filters, RXCHK_BRCM_TAG_MAX);
 	if (index >= RXCHK_BRCM_TAG_MAX)
+		/* All filters are already in use, we cannot match more rules */
 		return -ENOSPC;
 
 	/* Location is the classification ID, and index is the position
-- 
2.30.2

