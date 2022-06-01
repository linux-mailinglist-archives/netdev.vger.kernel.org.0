Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FE8539DE5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346018AbiFAHI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344414AbiFAHHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:07:15 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CF2DF16
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 00:07:12 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c11-20020a17090a4d0b00b001e4e081d525so689950pjg.7
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 00:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Mk17D+aOzb7UCdNS2oz9IAwDr5MmRg+quCipw6fx4RQ=;
        b=hQa0JnnmV2cX05wxogayF7DAeIwm91UA5DD4Pd0261qK2nG5mlRfb8p0PwXRgLwmcG
         6gimTBEfRJnzqCBPwGFDLXwY23Jge7qCK5EKBtDVk+4ZHueBZe2ScEh2abiJOXvqClXF
         aItT2KKmdUihJqxg6KlMJQ+n9hDQfaXwUgpDUXId5vW641rUWKofWrnrujEe72Sytvnk
         iXsC3g9D+PkO64XwFNhsJCy/xgMMwq44IzwR510vfqTBnn54+HA0yDiVcTK99umRrrcq
         KawtwQ3E7vKCwmO2izMB9zQh9evWd8zx74HbqExwInwGL34iXnuFQ1QqmbkBW7qSDv5A
         GPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Mk17D+aOzb7UCdNS2oz9IAwDr5MmRg+quCipw6fx4RQ=;
        b=rR+gD6zOKYtQ4P7OLhShtx21EMVdimeDivaemcSR4rbM9bvj6BW9Bzsn9xEEI/pHoN
         WNxnaz4o8hF9n/5FR5BTjtPl8jDK12H+nTfzFJrDX2CZQovZBDRVXBhlTkmuhAJJZWXo
         86g7sFtKyo/Xr8Lwyo0oBHkFWMwkMLoEzPLOTTbb74sy1eAm0g4oZzd53I6KyrtBY7o1
         sgL8okLEg3zywxv3xiOWF3/FJAVK+Z0jZXbUIz2j+L60Ab1CkNiWqH6NZLW0gG3hfG2v
         inTpy5qgYVdV9LsYDLUOV5O7edk5b3yn3g7wWayVSJiZP4GJECNJV+c4JGkG71Xho3nh
         v8NA==
X-Gm-Message-State: AOAM533C1gHcD742dTSoYMSEi1brH/huK90BH+ldBgQq+W88c3V1nJWo
        IPAOWroxJbCWIviPZ7nnc86jSEnte8rVt4E=
X-Google-Smtp-Source: ABdhPJwo0w/Ul81l80Uz+X1lE0Knuok5VeKXEtMoQ0Yzewr/LH6PL8JE3PUvMoXQAWKjDKNKYDX9hXZkKLb6+II=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f3aa:cafe:c20a:e136])
 (user=saravanak job=sendgmr) by 2002:a17:902:da8e:b0:164:537:d910 with SMTP
 id j14-20020a170902da8e00b001640537d910mr7067516plx.75.1654067231712; Wed, 01
 Jun 2022 00:07:11 -0700 (PDT)
Date:   Wed,  1 Jun 2022 00:06:56 -0700
Message-Id: <20220601070707.3946847-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 0/9] deferred_probe_timeout logic clean up
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is based on linux-next + these 2 small patches applies on top:
https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/

A lot of the deferred_probe_timeout logic is redundant with
fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
a few cases.

This series tries to delete the redundant logic, simplify the frameworks
that use driver_deferred_probe_check_state(), enable
deferred_probe_timeout=10 by default, and fixes the nfsroot failure
case.

The overall idea of this series is to replace the global behavior of
driver_deferred_probe_check_state() where all devices give up waiting on
supplier at the same time with a more granular behavior:

1. Devices with all their suppliers successfully probed by late_initcall
   probe as usual and avoid unnecessary deferred probe attempts.

2. At or after late_initcall, in cases where boot would break because of
   fw_devlink=on being strict about the ordering, we

   a. Temporarily relax the enforcement to probe any unprobed devices
      that can probe successfully in the current state of the system.
      For example, when we boot with a NFS rootfs and no network device
      has probed.
   b. Go back to enforcing the ordering for any devices that haven't
      probed.

3. After deferred probe timeout expires, we permanently give up waiting
   on supplier devices without drivers. At this point, whatever devices
   can probe without some of their optional suppliers end up probing.

In the case where module support is disabled, it's fairly
straightforward and all device probes are completed before the initcalls
are done.

Patches 1 to 3 are fairly straightforward and can probably be applied
right away.

Patches 4 to 6 are for fixing the NFS rootfs issue and setting the
default deferred_probe_timeout back to 10 seconds when modules are
enabled.

Patches 7 to 9 are further clean up of the deferred_probe_timeout logic
so that no framework has to know/care about deferred_probe_timeout.

Yoshihiro/Geert,

If you can test this patch series and confirm that the NFS root case
works, I'd really appreciate that.

Thanks,
Saravana

v1 -> v2:
Rewrote the NFS rootfs fix to be a lot less destructive on the
fw_devlink ordering for devices that don't end up probing during the
"best effort" attempt at probing all devices needed for a network rootfs

Saravana Kannan (9):
  PM: domains: Delete usage of driver_deferred_probe_check_state()
  pinctrl: devicetree: Delete usage of
    driver_deferred_probe_check_state()
  net: mdio: Delete usage of driver_deferred_probe_check_state()
  driver core: Add wait_for_init_devices_probe helper function
  net: ipconfig: Relax fw_devlink if we need to mount a network rootfs
  Revert "driver core: Set default deferred_probe_timeout back to 0."
  driver core: Set fw_devlink.strict=1 by default
  iommu/of: Delete usage of driver_deferred_probe_check_state()
  driver core: Delete driver_deferred_probe_check_state()

 drivers/base/base.h            |   1 +
 drivers/base/core.c            | 102 ++++++++++++++++++++++++++++++---
 drivers/base/dd.c              |  54 ++++++-----------
 drivers/base/power/domain.c    |   2 +-
 drivers/iommu/of_iommu.c       |   2 +-
 drivers/net/mdio/fwnode_mdio.c |   4 +-
 drivers/pinctrl/devicetree.c   |   2 +-
 include/linux/device/driver.h  |   2 +-
 net/ipv4/ipconfig.c            |   6 ++
 9 files changed, 126 insertions(+), 49 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

