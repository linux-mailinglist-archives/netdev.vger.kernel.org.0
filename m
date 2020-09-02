Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0FA25B5F0
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgIBVdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIBVdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:33:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9355C061244;
        Wed,  2 Sep 2020 14:33:52 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u13so384091pgh.1;
        Wed, 02 Sep 2020 14:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HWoZ9gSaMASNiVIiMLFlBXVKhhMlezf7hmycIYQmTtU=;
        b=cFESmkLD8yy831D2HFGzsgZm1mQg4ISvI8BOdLP+P8yZ/C6xowW505VKvlJqBz/vBO
         50lzVLV0N6745Q4r/pxWyTiamMiIvT2s+/8NqsdN+9HLVBV9Kr/4PKLAQNZtCBkM41/q
         1rpnDR5HWwVqo+enwEtBct61BTcGrL+IbqWwOz+aKREHvfZQg5wkbbw03UrGZi+hHNCt
         /sPt0NkgoCAgv8bE1+Cd6gueATIwYTPIlfOq8ThACXU++wfI9d+UGaKT3a1vMrpHsDUb
         ip/BqjMSopzHCB7M8iD14tVNDq4oRSzD6NN1huxNk+syl+P+YhdWIAtbq5cr33ssIfha
         ShpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HWoZ9gSaMASNiVIiMLFlBXVKhhMlezf7hmycIYQmTtU=;
        b=JriCVnkZyqCrugRLllAg2DCU2MIe8dQ8caXkciyUUeQkDJ1h4y2HHSGLvqlccz/TEE
         DQ3fjbzUZpFE8kFOv9HucBOB2koEaIRPxRaupYnhrPKva5xdbfxMjrqQQjdc/7jiBAQr
         3Ujxhn5yArPgVPSPkFWqG6G/kuvaXU6apyCrSr6komN2E09U7dRVF5iKnbY5f0EB3eLy
         YVFW6DJzEonOHb5tvEtAClv1QyFhT+A1aW2AcR0hjjpo/1IC1i0Lwmg0tziZ+k8T+H0Y
         bgqerlTl5VYjV5ptgL9Dl/zSpmTvjwe77YBC3hOr+EKmB747UEjUCr+xbeNEC38nFIVt
         nU6g==
X-Gm-Message-State: AOAM533BFe4uaUVuq2pOXEjgZ2cjDRkiiKvljg7gmU3J8y6US/zOednO
        e3LrNooS1WnVFIfWBTOuKTqYJMb8HVM=
X-Google-Smtp-Source: ABdhPJw3TDRUc4jlzjW63Njr42xrqCuWybdXD7zNqVCo++TulE5gKF0qplMJh58PIrKAhX3LGGSSig==
X-Received: by 2002:a17:902:8c83:: with SMTP id t3mr374229plo.150.1599082431739;
        Wed, 02 Sep 2020 14:33:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g5sm466881pfh.168.2020.09.02.14.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:33:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [RFC net-next 0/2] net: phy: Support enabling clocks prior to bus probe
Date:   Wed,  2 Sep 2020 14:33:45 -0700
Message-Id: <20200902213347.3177881-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series takes care of enabling the Ethernet PHY clocks in
DT-based systems (we have no way to do it for ACPI, and ACPI would
likely keep all of this hardware enabled anyway).

Please test on your respective platforms, mine still seems to have
a race condition that I am tracking down as it looks like we are not
waiting long enough post clock enable.

The check on the clock reference count is necessary to avoid an
artificial bump of the clock reference count and to support the unbind
-> bind of the PHY driver. We could solve it in different ways.

Comments and test results welcome!

Florian Fainelli (2):
  net: phy: Support enabling clocks prior to bus probe
  net: phy: bcm7xxx: request and manage GPHY clock

 drivers/net/phy/bcm7xxx.c    | 29 ++++++++++++-
 drivers/net/phy/phy_device.c |  6 ++-
 drivers/of/of_mdio.c         | 84 ++++++++++++++++++++++++++++++++++++
 include/linux/of_mdio.h      |  7 +++
 include/linux/phy.h          | 12 ++++++
 5 files changed, 136 insertions(+), 2 deletions(-)

-- 
2.25.1

