Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270096989E1
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBPBgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBPBgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:36:18 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A0442DF0;
        Wed, 15 Feb 2023 17:36:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso432996wms.4;
        Wed, 15 Feb 2023 17:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/1hkZg8A4EmBuVis3IHFGticAZdxNJl1p3OSUfGtWaA=;
        b=dnCfzecbg9zzd6qLie831efng+VlSP8B4sOVH29D/TCpNwuLhm/6LZHbYc1GqaQMcF
         rNs8XqIdqLxG1AoLljRHqWN0eIb5R/0Jjm4wqyBSzgn40eVw4xbVS9SLwBFgg7XWcgo4
         EOgtwJuEKXhAWAugQEtA2zK6oJhh+AkLtXyz3ZwSEsPBilZaM0HiT6dJXoG9hwIymYN/
         WKxPlSHnGIeWdBrjj6GEO5wEZ2epqnkh7J57oOMy+mLOIGEQjzEbYSD69snTFv0ZtzOY
         rxxRzmYfEobPDmxhjQICBIXvtCRIHhm/LouxIKcTUz0R60MTmrzkQRq0bOPF7KVum6hL
         /Pjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1hkZg8A4EmBuVis3IHFGticAZdxNJl1p3OSUfGtWaA=;
        b=eKc0V0JESdTkIZti8xcCk2cMc4+yVfTZGK8MzFcGhzK2QfFIKjRL1xr3r99NwzIcJj
         59Z08oTWkSbAdJyeA1CH/85Wh7xVc1r29c3/plH0u4nnJou+FD+9fCHfAtywtalhXAYI
         MRTnPqDUDnMAWV/ETNdLsHi3BJn68UztptmfUnClWhyu3hcBzpTXVaCEuuxc8P3O8S6z
         Rjmg2Zw6riP//fvqKGJsr2KZvtYYaJhrBrOWKm+iwr1bJn15SUZdgxBJ/qIRzoAPyVMp
         PmkQj3sjPJVcv0vc3thQzH/nMdgQ5fX9Ft0f5n5c72qtYo+XvVOa0KVkvhn+Dd/hIZYy
         NwVA==
X-Gm-Message-State: AO0yUKVypkNEOaYVIKmFdqMGa2UDkpsdflT7j+RJVvlpwV1YQLCeOOHc
        y7T5d/suQjdRKRuWf6KKKHY=
X-Google-Smtp-Source: AK7set9isTHReF5LHmRJOi8vQdGmVupf6/i4hTJgHxQcb0CSAQs1J1UbLmF/OYdVZpfDhoTeL8xJ0A==
X-Received: by 2002:a05:600c:2a08:b0:3da:fb3c:c1ab with SMTP id w8-20020a05600c2a0800b003dafb3cc1abmr3239734wme.0.1676511375775;
        Wed, 15 Feb 2023 17:36:15 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:15 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
Date:   Thu, 16 Feb 2023 02:32:17 +0100
Message-Id: <20230216013230.22978-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another attempt on adding this feature on LEDs, hoping this is
the right time and someone finally notice this.


Most of the times Switch/PHY have connected multiple LEDs that are
controlled by HW based on some rules/event. Currently we lack any
support for a generic way to control the HW part and normally we
either never implement the feature or only add control for brightness
or hw blink.

This is based on Marek idea of providing some API to cled but use a
different implementation that in theory should be more generilized.

The current idea is:
- LED driver implement 3 API (hw_control_status/start/stop).
  They are used to put the LED in hardware mode and to configure the
  various trigger.
- We have hardware triggers that are used to expose to userspace the
  supported hardware mode and set the hardware mode on trigger
  activation.
- We can also have triggers that both support hardware and software mode.
- The LED driver will declare each supported hardware blink mode and
  communicate with the trigger all the supported blink modes that will
  be available by sysfs.
- A trigger will use blink_set to configure the blink mode to active
  in hardware mode.
- On hardware trigger activation, only the hardware mode is enabled but
  the blink modes are not configured. The LED driver should reset any
  link mode active by default.

Each LED driver will have to declare explicit support for the offload
trigger (or return not supported error code) as we the trigger_data that
the LED driver will elaborate and understand what is referring to (based
on the current active trigger).

I posted a user for this new implementation that will benefit from this
and will add a big feature to it. Currently qca8k can have up to 3 LEDs
connected to each PHY port and we have some device that have only one of
them connected and the default configuration won't work for that.

The netdev trigger is expanded and it does now support hardware only
triggers.
The idea is to use hardware mode when a device_name is not defined.
An additional sysfs entry is added to give some info about the available
trigger modes supported in the current configuration.


It was reported that at least 3 other switch family would benefits by
this as they all lack support for a generic way to setup their leds and
netdev team NACK each try to add special code to support LEDs present
on switch in favor of a generic solution.

v8:
- Improve the documentation of the new feature
- Rename to a more symbolic name
- Fix some bug in netdev trigger (not using BIT())
- Add more define for qca8k-leds driver
- Add activity led mode
- Drop interval support
- Move qca8k brightness set to blocking variant (can sleep while
  setting the mode)
- More some function out of config define and provide variant if not
  selected
- Fix many bugs in the validate option in the netdev trigger
- Add phy generic schema for leds support
- Add additional required Documentation changes
v7:
- Rebase on top of net-next (for qca8k changes)
- Fix some typo in commit description
- Fix qca8k leds documentation warning
- Remove RFC tag
v6:
- Back to RFC.
- Drop additional trigger
- Rework netdev trigger to support common modes used by switch and
  hardware only triggers
- Refresh qca8k leds logic and driver
v5:
- Move out of RFC. (no comments from Andrew this is the right path?)
- Fix more spelling mistake (thx Randy)
- Fix error reported by kernel test bot
- Drop the additional HW_CONTROL flag. It does simplify CONFIG
  handling and hw control should be available anyway to support
  triggers as module.
v4:
- Rework implementation and drop hw_configure logic.
  We now expand blink_set.
- Address even more spelling mistake. (thx a lot Randy)
- Drop blink option and use blink_set delay.
- Rework phy-activity trigger to actually make the groups dynamic.
v3:
- Rework start/stop as Andrew asked.
- Introduce more logic to permit a trigger to run in hardware mode.
- Add additional patch with netdev hardware support.
- Use test_bit API to check flag passed to hw_control_configure.
- Added a new cmd to hw_control_configure to reset any active blink_mode.
- Refactor all the patches to follow this new implementation.
v2:
- Fix spelling mistake (sorry)
- Drop patch 02 "permit to declare supported offload triggers".
  Change the logic, now the LED driver declare support for them
  using the configure_offload with the cmd TRIGGER_SUPPORTED.
- Rework code to follow this new implementation.
- Update Documentation to better describe how this offload
  implementation work.

Christian Marangi (13):
  leds: add support for hardware driven LEDs
  leds: add function to configure hardware controlled LED
  leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
  leds: trigger: netdev: rename and expose NETDEV trigger enum modes
  leds: trigger: netdev: convert device attr to macro
  leds: trigger: netdev: add hardware control support
  leds: trigger: netdev: use mutex instead of spinlocks
  leds: trigger: netdev: add available mode sysfs attr
  leds: trigger: netdev: add additional hardware only triggers
  net: dsa: qca8k: add LEDs support
  dt-bindings: leds: Document netdev trigger
  dt-bindings: net: phy: Document support for leds node
  dt-bindings: net: dsa: qca8k: add LEDs definition example

 .../devicetree/bindings/leds/common.yaml      |   2 +
 .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 +
 .../devicetree/bindings/net/ethernet-phy.yaml |  22 +
 Documentation/leds/leds-class.rst             |  94 ++++
 drivers/leds/Kconfig                          |  11 +
 drivers/leds/led-class.c                      |  27 ++
 drivers/leds/led-triggers.c                   |  38 ++
 drivers/leds/trigger/ledtrig-netdev.c         | 414 ++++++++++++-----
 drivers/net/dsa/qca/Kconfig                   |   9 +
 drivers/net/dsa/qca/Makefile                  |   1 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |   4 +
 drivers/net/dsa/qca/qca8k-leds.c              | 419 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  69 +++
 include/linux/leds.h                          |  95 +++-
 14 files changed, 1126 insertions(+), 103 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c

-- 
2.38.1

