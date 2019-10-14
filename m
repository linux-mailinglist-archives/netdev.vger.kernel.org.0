Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5901DD68B6
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388603AbfJNRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:40:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41729 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbfJNRk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:40:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so10492818pga.8;
        Mon, 14 Oct 2019 10:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qcbvr0gc2NuqSES9wh8FIsoaBFNjSsQ88EI5O4USk5E=;
        b=Ft42jQI9Iyk9a4wn1mA3+91FTLsH2+OzbibTCMdg6HAwmiZOqoeBLK1gMPhppdw5FT
         8EZi+TRRTJF3O2T3yyUas1T/Lv8v+TsyveORxmQu+PAdCqp7nJdwZLp1ssgHvt75JOQh
         DUBU+i0AfaLlboL3gdmDuTPQLrXpdu0+JmjDghprHn3hgcS0z0wbJTBKc9C2VSWI7J3z
         F9HTZCLOVDeSdHMHb4E6XnV4EecTxJDET/Z+ez+wuFG1H7v1XAdhB8t8172PbsXNKK7b
         ok2BhCbKIQqKHkE4hB68QZiSwfXmzjL2WbfvNnAziNsTf/AmUZqWlZ7hKmEG4e7JEPxZ
         S9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qcbvr0gc2NuqSES9wh8FIsoaBFNjSsQ88EI5O4USk5E=;
        b=Yox7dwwsdqFyxnT972mHbx6wZ7krgmVvzjiYwbATUrFqdTI1/TdSy2F21FcxzvIMqr
         ZsFI639zmdKmt7Q7Pe0e0FFjKsnDkWQE6/ZpRokyT8xR4LhpsCydWtakdfjFsaZMTmAW
         DKjtIbX7zKwXku5F2JRC7zC8fzieWbWL1/DDT0V9CR/txNyWkIHiVJsS36boFdBGQ/TJ
         9jP52pXi7OlfI3FGmlAvwZPbpZ8K4j8NSYYkI5uRR79EX42QK8wl8eZCEgqGYAUpnE+T
         UrIqAqwndYBRUdXpwK/GsbnU4WjgZB8hPmvmSJ1UQf8ZmTOUTO0L6bQdwr/xyCdrSlpu
         Br+A==
X-Gm-Message-State: APjAAAX2v6271sO1I2FSODKZQL7a4fgZGxRKAVvc1GKayjHrG4iI+SDK
        2f1VahfJuXT6slcFanYlDfU/znVz
X-Google-Smtp-Source: APXvYqwy3aNJ/+XgfAIlcNSQrUIZNlIR4utB8bAQRqPTTqGkTuqj5WZTo+9m9HZEYiyfa2SCttvWYw==
X-Received: by 2002:a63:131b:: with SMTP id i27mr18157179pgl.209.1571074826258;
        Mon, 14 Oct 2019 10:40:26 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id k66sm18784535pjb.11.2019.10.14.10.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 10:40:25 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 0/3] net: phy: switch to using fwnode_gpiod_get_index
Date:   Mon, 14 Oct 2019 10:40:19 -0700
Message-Id: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
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

Linus, as David would prefer not to pull in the immutable branch but
rather route the patches through the tree that has the new API, could
you please take them with his ACKs?

Thanks!

v2:
        - rebased on top of Linus' W devel branch
        - added David's ACKs

Dmitry Torokhov (3):
  net: phylink: switch to using fwnode_gpiod_get_index()
  net: phy: fixed_phy: fix use-after-free when checking link GPIO
  net: phy: fixed_phy: switch to using fwnode_gpiod_get_index

 drivers/net/phy/fixed_phy.c | 11 ++++-------
 drivers/net/phy/phylink.c   |  4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

