Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275C826D1DC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQDnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgIQDnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:43:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086B6C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:43:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s65so566778pgb.0
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYSQIoimD3mchHCcAhQWspQEmWN2T/bb5l34becbl9Q=;
        b=aBmPYkQBWzHLjPqmb0B9cHXdrRjvLGHo/js3ASErzSzLtcwTp+8wDAkyWlqAOZXxqs
         9qXwU9eIw5aOql6FvGN1tSNwvKXvHyBkM1uirSneDmjKpOwuusmhQkkEtpTU9Sxwgz/B
         2C1i2AYbSUHvMYHJlksm18XQ75bHdk8eHK61Nx/hcb157H9jyjREpaynB9PprJxOj0Pc
         oZgkbt9kOJtgFA0sFRJ5Y5mcT1nqoDVT7TZmuaR1M7rtbuqsIyxjMJOTi/gMb60E8Lze
         GAi45rWZxkjUJN8R7gQ3Xajr8AOZEfI3Fr9jTtRiVaypz7XhWgqG+QuRb4RrVqFkTXm+
         E12g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dYSQIoimD3mchHCcAhQWspQEmWN2T/bb5l34becbl9Q=;
        b=CKPJIxKnX05CWNXOYktnbOsrwHE/2fcBgTItP98KW3zYplUI3lLl7bO10jc4s8asFN
         voeeDixbhcY/KawkkmPvxQwuErMu9A6HYibdRV+5nIC5tlT//PhK3QUwBGIQNeLt4TJ6
         whsz2q66l74MmaujHX66Z1A8247nNJQWmi8BZAD/iSVbGmHdfIAJskzma0lM24Hp71bz
         WHnrs0xvKQxx1xBlnLNNWwiWnjttW6kwhnQFAr71Nepi+sR/+EDglyeRD8k19GfhAlnI
         qPGzHv6h4ci/Uu9ycPjExyKTJa1h/gpYot3D6M+FD/R+mvwnFQJrt6e13QOA6BwG6UBs
         bNVg==
X-Gm-Message-State: AOAM532KtjsHQ1ZdwMm7bOgxlLRVQOdSZ+nyisArPAkkQQ+/uIYoqbIB
        RAvultV+TLyXhBZsv6iallPI1Zjf5JAsGw==
X-Google-Smtp-Source: ABdhPJzTaYQ8OQsD/sbAipdxFJXzxwLzskPOx93fH1MjKq5hHVL2Fmt6nTW53mlySkgiHRkgIyfUzQ==
X-Received: by 2002:a63:df42:: with SMTP id h2mr17744907pgj.239.1600314197119;
        Wed, 16 Sep 2020 20:43:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i187sm15810116pgd.82.2020.09.16.20.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 20:43:16 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net 0/2] net: phy: Unbind fixes
Date:   Wed, 16 Sep 2020 20:43:08 -0700
Message-Id: <20200917034310.2360488-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes a couple of issues with the unbinding of the PHY
drivers and then bringing down a network interface. The first is a NULL
pointer de-reference and the second was an incorrect warning being
triggered.

Florian Fainelli (2):
  net: phy: Avoid NPD upon phy_detach() when driver is unbound
  net: phy: Do not warn in phy_stop() on PHY_DOWN

 drivers/net/phy/phy.c        | 2 +-
 drivers/net/phy/phy_device.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.25.1

