Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8919CC650
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbfJDXN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:13:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39325 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:13:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id s17so3807237plp.6;
        Fri, 04 Oct 2019 16:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rT+pwTDKtcTWNo6TrCea3iAz2vib2fgSZtn46Sn4dMA=;
        b=OvfyC9XQ1RlfUeOOKJDsFHL9M92+y7JGRGw6eupbNp9cEpVBSCSvDM3leA2DzXEXE8
         mpMRvoieZvxxINtGsO1OOQs+amr2k+4+M39fBDm0BLAemBd2Tzh+bTRoaU/oi0u4Hnb0
         BiahbUNlMBIyRUvDnPsCD7x6Ctrxt2kSHOzhtwnHhBF3nGK7atcqVvW1lkHgMSeuLNe1
         hfk3PhNu64ODFnrHORnyq+zKS17Kq7sF5CBUeLPicAV23ZVV/pxgTwwAlmRd0s4rn5U6
         ae3rH8AaiwX3p37C/FuUe+FwkFHx9EShCQ/WXs3tkDPF4L4aTMWIn0Q1P7Tu+Gu3i1EB
         GfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rT+pwTDKtcTWNo6TrCea3iAz2vib2fgSZtn46Sn4dMA=;
        b=n4xPSFjX/aABV+mPhhbXsLd6eXkXpHmDRK69gQj5lp5vST2/Wz99JUPMeT3LYcrmE9
         id7j6SHbUCMXGtIn4fDfkd5GaH7TeMVxLROz+CC1vbjVWN6gKlTK+zFYMHnbmADcYJTN
         ZE2lnLdHijHz5npnd9N7tD8XNiJcFAy4CPZyyn9mhlg1pitPo9tYf7YR0B41pWRPsRc6
         E+kNG6qKHgeMvLRPp75D5JB0oo4YwKz8wkPdJuP5fbl8IgNtEDq18nZbXruzGqcQegp/
         jkgCqHRa23agVvcUwJNIhXk5qNH36M2+aMS2PVAnHl76fehvHYXdyv0E6WMDrTKmnQva
         XJsg==
X-Gm-Message-State: APjAAAU1IRhzlP2+MuIBca/6DEPwePwh6IbvMO3k8VNc4ZzCWABIpOH/
        rPk5HEwO7cXX08+D78JXnzc=
X-Google-Smtp-Source: APXvYqzi9hGmca+bzCUNnidvy/VO0pKq8Q7Gy8YzK4EmeeSSS71T3ovz2bhK+Hfkj9QTXoQkYKxZVA==
X-Received: by 2002:a17:902:7611:: with SMTP id k17mr16992908pll.314.1570230838514;
        Fri, 04 Oct 2019 16:13:58 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id y6sm9514353pfp.82.2019.10.04.16.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:13:57 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 0/3] net: phy: switch to using fwnode_gpiod_get_index
Date:   Fri,  4 Oct 2019 16:13:53 -0700
Message-Id: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series switches phy drivers form using fwnode_get_named_gpiod() and
gpiod_get_from_of_node() that are scheduled to be removed in favor
of fwnode_gpiod_get_index() that behaves more like standard
gpiod_get_index() and will potentially handle secondary software
nodes in cases we need to augment platform firmware.

This depends on the new code that can be bound in
ib-fwnode-gpiod-get-index immutable branch of Linus' Walleij tree:

        git pull git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git ib-fwnode-gpiod-get-index

I hope that it would be possible to pull in this immutable branch and
not wait until after 5.5 merge window.


Dmitry Torokhov (3):
  net: phylink: switch to using fwnode_gpiod_get_index()
  net: phy: fixed_phy: fix use-after-free when checking link GPIO
  net: phy: fixed_phy: switch to using fwnode_gpiod_get_index

 drivers/net/phy/fixed_phy.c | 11 ++++-------
 drivers/net/phy/phylink.c   |  4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)

-- 
2.23.0.581.g78d2f28ef7-goog

