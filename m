Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28E3EF8C1
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbhHRDin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbhHRDim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:38:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74907C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:38:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f3-20020a25cf030000b029055a2303fc2dso1442427ybg.11
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ug2zcdMCaeHh0XAdi8LdoXsjv0peD2Al0CHXVkIyFY8=;
        b=IuWtNEvbDa2kpwWZYNZufkDH3pFlfMBnmV2plEsPX+lVFttpkpGqKCyO/xZB2wnrds
         6wEc1MPmXYPK3s4rRR6KlAL9DiCQFCUb3x8xBsQmdoRDlQARWdB1ByrLFE67wb2xt6VP
         WSiB2iDjxxBOZ3kUnzweyTO7jeQV5oq4BZyrsGGY3RJneu0bNyf1VlhtD79puiBt029H
         g/PGEpSsTfka2jQ3l1aQC8L4ovpccysQglCUHEAusTuLJ6ziMuLtLnKSHbV9U8vGouzK
         paEKrl1apxdiScM3OZSe56Koc7gpQP1CslR710iZzLGRJ4pVBsliAGK6ieIIsSb0ZIyT
         0NlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ug2zcdMCaeHh0XAdi8LdoXsjv0peD2Al0CHXVkIyFY8=;
        b=rSuuE7k7qweleBHoJBX8KHaVypDulf5fqpEy6Zrxb+Kzk9YzJrsnDnCx2ax3uBB/cN
         7kIj7Yr60ZIyA3EICFwa0gtIaigsN4fJagpc8VvK3xZQh2szRBruxXuXLEKZvTwLzML0
         bxt3l8kJtzfk2SyxrY6rlf57ANJj3a6NAnH6oZ+DSIfdmz3kogB1JoHKzAofZUmY52vK
         vrDbztxEf0/ggG5lQzWsq4WgB/piBjVmuMj1YsWRKwb3uUV9IQyjivHxgoB4+C69Ytkb
         uErf6Cc9i0B4sqS+tq3fcUNVekX1X7m8pho+EVuLqUVYnvq/SuKKTdDvevWxSJG0Arjw
         2Mug==
X-Gm-Message-State: AOAM533rIo4pgCXgRxcIV8V3XF/DRT89MgqzttoW1oh9a9rkoEFKnAQE
        lBMp3n/hKiZG/+g1XScP6gfTMb9WnDjlJaM=
X-Google-Smtp-Source: ABdhPJwlv55rDjktIeu+22XottH9UI4zxlHdsPFmVybWBm49omkRuuXWyfT9pG7F4w0AsUzbyOEeNNSnYdbnAlc=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7750:a56d:5272:72cb])
 (user=saravanak job=sendgmr) by 2002:a25:d1c2:: with SMTP id
 i185mr8917811ybg.466.1629257887738; Tue, 17 Aug 2021 20:38:07 -0700 (PDT)
Date:   Tue, 17 Aug 2021 20:38:00 -0700
Message-Id: <20210818033804.3281057-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net v3 0/3] Clean up and fix error handling in mdio_mux_init()
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Mason <jon.mason@broadcom.com>,
        David Daney <david.daney@cavium.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series was started due to -EPROBE_DEFER not being handled
correctly in mdio_mux_init() and causing issues [1]. While at it, I also
did some more error handling fixes and clean ups. The -EPROBE_DEFER fix is
the last patch.

Ideally, in the last patch we'd treat any error similar to -EPROBE_DEFER
but I'm not sure if it'll break any board/platforms where some child
mdiobus never successfully registers. If we treated all errors similar to
-EPROBE_DEFER, then none of the child mdiobus will work and that might be a
regression. If people are sure this is not a real case, then I can fix up
the last patch to always fail the entire mdio-mux init if any of the child
mdiobus registration fails.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Kevin Hilman <khilman@baylibre.com>
[1] - https://lore.kernel.org/lkml/CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com/#t

v1 -> v2:
- Added Acked-by, Tested-by and Reviewed-by
- Fixing the subject so it goes to "net" tree
v2 -> v3:
- Added Fixes tag to all the patches

Saravana Kannan (3):
  net: mdio-mux: Delete unnecessary devm_kfree
  net: mdio-mux: Don't ignore memory allocation errors
  net: mdio-mux: Handle -EPROBE_DEFER correctly

 drivers/net/mdio/mdio-mux.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

