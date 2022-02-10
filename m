Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BE64B18DB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345302AbiBJWyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:54:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiBJWyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:54:01 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0F55A4;
        Thu, 10 Feb 2022 14:54:02 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id h7so9358264iof.3;
        Thu, 10 Feb 2022 14:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VUKtrHLt0fjPmTgGEZzFREYA4A6F0kdoS7SyUvKa0qA=;
        b=O4LOqpJXDQnBxYPr0uj95YnMfkewxiGbbQ/CJY8h9XDEPOvDjwh5qXW6DLwNj/4efC
         P5rQp/xAmEmeII8/061Ts7JTt7EVmLB+11xoYOuxl7Aj0qEYkDOLJXycZvl5sufYs5DF
         4vgFdiDGtrUyNKnS0E80RAJT2kAGsFDMrBOB59uXItyZqs3bPTBgtjGn6yYWYd71QIEW
         8KOtB1BJ6WgWf06cjSV8ERv8TMMgsw5f8McINFBn9SGaJ/oPcElXl8/Qyis/NPO2ABMh
         WOFjIQmst1HJnqh3/u46Cy212ZQva5eXTTBHPDZw+ohS/wXIhQ4nIa2v1/cyXJNuAQAX
         FndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VUKtrHLt0fjPmTgGEZzFREYA4A6F0kdoS7SyUvKa0qA=;
        b=ChNSB6q5ku8zlDdlNMr7s6ZV4KdXrcvnRGXcNXTUii0pJwXgivl1Ag29XMp9HHeYQn
         teG2SSycs0FxW6k+SJZvPBwY0YOnT33z6or8FFwz+l+Fl9A7vdiTIjAd67bBxJBxzzOF
         D1g5u65zm4HSUw7PolBbfrja/d6FPUjxfLN6A8tmZOGcSzRBLYl2xIPlyijjeNf3+MfH
         wazvh9dMghQFf9xfgBJLW+5hbqVFGtLqog9IqCCt9jbv94fQRZGnWVAwKLWhX1pQkaOc
         uNBHynbqVVnoLIoCbOaaJ5JOOpy66LRYwYpf4hiORQtMuvwWSz3wr6X4ivc2bEqSusHP
         jA+g==
X-Gm-Message-State: AOAM530oEcxM0DdC/p7UYeWBrAYcCcFWtZliBpATdg8cqsPBWLHXQqrg
        i2GqOUZX8dmSWqOY1ENYTh4=
X-Google-Smtp-Source: ABdhPJzaRpwSbO6X1WBTl+WfBx/q4TwWiCIEqIJ9Q6DkzZZR70REkK2F4cQiJwbzEUceoLbWMe36Mg==
X-Received: by 2002:a02:cd0a:: with SMTP id g10mr5229490jaq.223.1644533641691;
        Thu, 10 Feb 2022 14:54:01 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id a15sm6591675ilq.24.2022.02.10.14.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 14:54:01 -0800 (PST)
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
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 01/49] net: dsa: don't use bitmap_weight() in b53_arl_read()
Date:   Thu, 10 Feb 2022 14:48:45 -0800
Message-Id: <20220210224933.379149-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't call bitmap_weight() if the following code can get by
without it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a3b98992f180..d99813bf3cdd 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1620,12 +1620,8 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 		return 0;
 	}
 
-	if (bitmap_weight(free_bins, dev->num_arl_bins) == 0)
-		return -ENOSPC;
-
 	*idx = find_first_bit(free_bins, dev->num_arl_bins);
-
-	return -ENOENT;
+	return *idx >= dev->num_arl_bins ? -ENOSPC : -ENOENT;
 }
 
 static int b53_arl_op(struct b53_device *dev, int op, int port,
-- 
2.32.0

