Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF1359A832
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiHSWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239418AbiHSWQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:16:21 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C03C0E41
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:16:20 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-335420c7bfeso97366797b3.16
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=t5NMSCOXrbG0Qu3FAuWbHVmFLW5D0kFYreRH8zEIjV8=;
        b=gWwBFfQzdDln3NwaMOLGITORJZRdOHNWfwYN4lk8hEGSpzD3nf0hp2vwhR0ehr9i2w
         R29Hm5/+BlRY+39ZdmD1y+vr3jEPlfnvwSvpVelQwQO1O7uxHZYyvePk913Fc2Fz55iX
         QjzGWD5mo4bmDesrjxJb2EwyBMXHWwWyQyFGrGuWY2g2Dc8APPCBlo+u1d7Cd73v12ib
         1Xy8VHJ3p5JBMqH9WrjSqdKP7zkHUsHt6QG1+x689dosBCL7ZjXPRMDXAxU6K3HdAbOj
         4wQEDnRMFUt+HthMu1axqnRVGLRFtqAAl07/bp2Re7kFQ2Bm7Z0Zbz/5vPJvBClJV19J
         Ff2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=t5NMSCOXrbG0Qu3FAuWbHVmFLW5D0kFYreRH8zEIjV8=;
        b=xxt0xXTIec6VG5T4euLBTd95lU4IeKrz6NhiAngmVYoAMqF/EpBeF0r2+WqnXKXVd1
         BVyhs6STVrvBfSii98iVdBDKXU0VgyQf0B/sbyw+SQqsq785qmg79HD0sSENJNz6NqVP
         JxU2q61O4EV6Q3B3y91FBjYpBIYU1O8j0oUbxTgleSq/BZ5E3tbBTz/xl5LPdLdIEOqw
         8Y69LHEdYUdTjxkaYIMDmExAKNwz+pg4Q9gEeA9kMjhToBDA7XjqIKps/lyE0rM2UE0C
         wJBpLLhugpeRn6Xf8pOxO/nGsoZro9buOi+G0w1sTgaVWuX1fg+oSaO5xJbfVvxs2fji
         iHqQ==
X-Gm-Message-State: ACgBeo2rgTW5hGOo3UVLjjCa29XkZZBv5pEUo7EvL0jrZtJtFVuwcLYU
        /6/AXxnO7H1WwOjzRXWbbHrqZclPw5ZSSx0=
X-Google-Smtp-Source: AA6agR4EX1OBULn40ut/MjDpJQQkX96WwHfTFwXQk6CpU2kNVzlbku/C8FdhqvNBCu/ZTTWVaRDqauv3HvTZg1M=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:f93e:7b61:ce3d:5b06])
 (user=saravanak job=sendgmr) by 2002:a81:d353:0:b0:31e:2888:93a1 with SMTP id
 d19-20020a81d353000000b0031e288893a1mr9560863ywl.498.1660947379483; Fri, 19
 Aug 2022 15:16:19 -0700 (PDT)
Date:   Fri, 19 Aug 2022 15:16:10 -0700
Message-Id: <20220819221616.2107893-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 0/4] Bring back driver_deferred_probe_check_state() for now
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     Peng Fan <peng.fan@nxp.com>, Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux.dev,
        netdev@vger.kernel.org
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

A bunch of issues have been reported in the original series[1] that removed
driver_deferred_probe_check_state(). While most of the issues have been
fixed in a new series that improved fw_devlink [2], there are still a few
unresolved issues I need to address.

So let's bring back driver_deferred_probe_check_state() until the other
issues are resolved.

Greg,

Can we get this into 6.0-rcX please?

-Saravana

[1] - https://lore.kernel.org/lkml/20220601070707.3946847-1-saravanak@google.com/
[2] - https://lore.kernel.org/lkml/20220810060040.321697-1-saravanak@google.com/

v1 -> v2:
- Added a revert of the iommu change too.

Saravana Kannan (4):
  Revert "driver core: Delete driver_deferred_probe_check_state()"
  Revert "net: mdio: Delete usage of
    driver_deferred_probe_check_state()"
  Revert "PM: domains: Delete usage of
    driver_deferred_probe_check_state()"
  Revert "iommu/of: Delete usage of driver_deferred_probe_check_state()"

 drivers/base/dd.c              | 30 ++++++++++++++++++++++++++++++
 drivers/base/power/domain.c    |  2 +-
 drivers/iommu/of_iommu.c       |  2 +-
 drivers/net/mdio/fwnode_mdio.c |  4 +++-
 include/linux/device/driver.h  |  1 +
 5 files changed, 36 insertions(+), 3 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

