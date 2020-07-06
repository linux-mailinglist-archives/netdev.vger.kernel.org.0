Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6202151A7
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 06:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgGFE2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 00:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgGFE2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 00:28:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB381C061794;
        Sun,  5 Jul 2020 21:28:04 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t11so11586717pfq.11;
        Sun, 05 Jul 2020 21:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c0/ZnaHlwR0HIQUxoQtTXVqcJB0m2bht+2IMFyQlFwE=;
        b=L+zNyhLgXoLTLnSy9wtpK//KjcLMBvbzVUmzxN1L5xtScgLPGZXQ7x3CGgzEVQ7Qny
         slKxBaboWJeVh9pB3Yr2DjwzURtQhZcxE/0GRix0a1rijKpOV8UEc0ECRNb1/Vmp1ssc
         uyNduXjT0sZgicKMBQM+KR8InLHeOAB5Xz1liCaIlm4Hjf6o5FLPZI9n3t4XliDDbEbt
         yO6xrR4DvyZA/O/vx3H13JS4V6Y2Cvn8VqGID4nyVsTLfxwXkOKOA1iER8ojDxOYJX5s
         B5hgMCskLwwq2UUx8/gJW3+kkUm//e0QvkaXgyrfOj3lLQE2LitZHxNDa0BV7qa+0IoN
         C6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c0/ZnaHlwR0HIQUxoQtTXVqcJB0m2bht+2IMFyQlFwE=;
        b=dSLczE8rBYmC+EdBle1b3UO+RkUtHenJECuuABR1/QTQcFVW5eJfOiR3wN0/A7//5Y
         5iTdvJIloDvlgPJ+wyVX1pGTxR4tz4ocCPIQqJxdBJhtsEzj4Xryt7YBA36U3UtJTk3M
         KwA7y4e9CX5X+NfN78t1swfqgOvug4qWN09Cn7v7cHLU5kpWuVTfmLC7BgzFAkIKGi8P
         k+2Q7L/NKml6jHsbelYVal6IDW9u8vFQKR3WV+PyNkWvAXxibO4tnfJrtd4WgkjBtdWd
         m4UsEvGDFgNkK1j9TYjwV4U7klcJXOY9baMODK1J18sJBNC9Kro2x3kBO1F8qEfORsVW
         S7yQ==
X-Gm-Message-State: AOAM531ETGjriA4Ng3sAhSTv/OjSC46bxr6NhGRBaJNNSz++PHaU4b/0
        r/oYu9dFzs31XjHX60L6ncgrcDBz
X-Google-Smtp-Source: ABdhPJx/3odWdSz9MMj8+RDHBuZysYmRiGNViGogz/1LUUwvthBso3wywjnUS6wOzOOlf3xAH0fwoQ==
X-Received: by 2002:a05:6a00:1589:: with SMTP id u9mr44431242pfk.201.1594009683833;
        Sun, 05 Jul 2020 21:28:03 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id ia13sm16558680pjb.42.2020.07.05.21.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 21:28:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2 0/3]  net: ethtool: Untangle PHYLIB dependency
Date:   Sun,  5 Jul 2020 21:27:55 -0700
Message-Id: <20200706042758.168819-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series untangles the ethtool netlink dependency with PHYLIB
which exists because the cable test feature calls directly into PHY
library functions. The approach taken here is to introduce
ethtool_phy_ops function pointers which can be dynamically registered
when PHYLIB loads.

Florian Fainelli (3):
  net: ethtool: Introduce ethtool_phy_ops
  net: phy: Register ethtool PHY operations
  net: ethtool: Remove PHYLIB direct dependency

 drivers/net/phy/phy_device.c |  7 +++++++
 include/linux/ethtool.h      | 25 +++++++++++++++++++++++++
 net/Kconfig                  |  1 -
 net/ethtool/cabletest.c      | 18 ++++++++++++++++--
 net/ethtool/common.c         | 11 +++++++++++
 net/ethtool/common.h         |  2 ++
 6 files changed, 61 insertions(+), 3 deletions(-)

-- 
2.25.1

