Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B80B4F3597
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiDEKv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243817AbiDEJkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:40:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470D5B9192;
        Tue,  5 Apr 2022 02:25:03 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DB5C0221D4;
        Tue,  5 Apr 2022 11:25:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649150701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uk8mzQYPK6hRxrVTkR2htOw04+Yd2q9FLsv83PaJNfQ=;
        b=Mj1y4B8wxRiPbBrSLP3Z3gfqL9Mdb+B+0hX6u8Lzk6mE+3gi002hvqLIgAnXZGx83HvG76
        Yb9P5aBc+6P3dQ5kX7LAL/Bn8GONRzUVtZZdHsrUixUooOUcSLC3QKUEg6i0/Pf2LlL61C
        H2eEcVKJ02EM2E7wW5c5n2bw7Ve2/tM=
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v4 0/2] hwmon: introduce hwmon_sanitize()
Date:   Tue,  5 Apr 2022 11:24:50 +0200
Message-Id: <20220405092452.4033674-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During development of the support for the temperature sensor on the GPY
PHY, I've noticed that there is ususually a loop over the name to
replace any invalid characters. Instead of open coding it in the drivers
provide a convenience function.

changes since v3:
 - don't return NULL but ERR_PTR(-ENOMEM)
 - check !dev in devm_ variant

changes since v2:
 - doc update
 - dropped last three patches, the net patches will be submitted
   seperately

changes since v1:
 - split patches
 - add hwmon-kernel-api.rst documentation
 - move the strdup into the hwmon core
 - also provide a resource managed variant

Michael Walle (2):
  hwmon: introduce hwmon_sanitize_name()
  hwmon: intel-m10-bmc-hwmon: use devm_hwmon_sanitize_name()

 Documentation/hwmon/hwmon-kernel-api.rst | 16 +++++++
 drivers/hwmon/hwmon.c                    | 53 ++++++++++++++++++++++++
 drivers/hwmon/intel-m10-bmc-hwmon.c      | 11 ++---
 include/linux/hwmon.h                    |  3 ++
 4 files changed, 75 insertions(+), 8 deletions(-)

-- 
2.30.2

