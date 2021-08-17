Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7CB3EF16A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhHQSJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhHQSJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:09:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC34CC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:08:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e75-20020a25374e000000b00597165a06d2so1494504yba.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8kgk+BpommirHls2uRzbi0bVBuVaNpx/BJiAFWzQtfM=;
        b=hv6kBEiIQY8ZwKTk/AGU9pYfugigxNUP9zTYmVHVf3+Ir+1qXspVTq4MYyqWKyHaR+
         occf49HcYA4aVinDTCA2K/JwGIx5EE9iVIsFY/2UYEuxPjhKNehdmsH3RWn8JVK0nMqV
         qS9EJ7PrP9h4qR7FCEpvlqmvAQ/eh8x/H37f+HLDwv2azSU6UO3QFkTGrjNOyKrOR32o
         5FvcS+UfminyWGFD0KW88yu9Q76QNsRGtKvCFy9BA+ckgAmNO3v8I20gk1rArdUqSvzb
         CQRqroXMhQ/N2ba2k6hS0j0MkEOZw6MXh7GoEdAoLfcD3ppsxMkbRX2c/IfbLxOyUITJ
         CL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8kgk+BpommirHls2uRzbi0bVBuVaNpx/BJiAFWzQtfM=;
        b=e5oebKyvdSlygVf9+29v3dajbJQBxBGVa08l6al5fUqTiwLjtzNBXdpYHzmm6OV6mF
         CJwOJUnESt0hbPvRjR5OYgTBBHVfJEpcT3eTrddMNWYxtU3y673jCSltQnKAseIiroYV
         NXl8uJudm/MyFkqiiEkH+w6+x4En114p7jZZAQc+Vic5Jhg+Qqq9ndSZFksjEuJHaHWp
         PmLw+cq4hNnde5/ECX/aLVCojORfJhpAcQYqPBS6D95WhOhwQzUjv9777tTlGGo5DpzZ
         WnKfGJbu893sCUURowJunxRa4rJEIKaE19puRhSDN7dw50Ar8XOsPTrINEdV5hE3OINx
         b5eQ==
X-Gm-Message-State: AOAM5309z8B+STkJAvSq7YxQ6gs1AG3dAFXIj5EIWrnwaa+mWtfgLf2y
        m7BB8PiZEeyC1KJLmG4sagNZ1Go3w7d7gu8=
X-Google-Smtp-Source: ABdhPJzzMnLsy+mggIhll1Tgv95gQE6Fl9gFFqTUDqh3VJEcIDBqOztjcutTtVo24Qx3VaJgMXMUlxPHVt/sBgU=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7750:a56d:5272:72cb])
 (user=saravanak job=sendgmr) by 2002:a25:d68c:: with SMTP id
 n134mr6532708ybg.67.1629223725029; Tue, 17 Aug 2021 11:08:45 -0700 (PDT)
Date:   Tue, 17 Aug 2021 11:08:38 -0700
Message-Id: <20210817180841.3210484-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net v2 0/3] Clean up and fix error handling in mdio_mux_init()
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
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

Saravana Kannan (3):
  net: mdio-mux: Delete unnecessary devm_kfree
  net: mdio-mux: Don't ignore memory allocation errors
  net: mdio-mux: Handle -EPROBE_DEFER correctly

 drivers/net/mdio/mdio-mux.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

