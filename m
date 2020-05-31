Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4705B1E95FF
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEaHGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgEaHGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:06:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1474C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f185so8237048wmf.3
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=elDQpODIiaQUs3zg/KlaGUWifEXR1SPnIQSDswktTdE=;
        b=P5puP0A/RXHPgP2mTSh9wm3fyz2QQh73lPw3XIjsR5CnT7KlMLjECBg9tj4QUNZOOr
         GZUxe9Fb80e8YexkQQ5rJikYz4xi9J7irM1SMMpYgVqKJ2sNzv4wk7/mdA1b6JJQS1cx
         WPCaht66gZGee2wUT9PLIG20B9GzEHrpwScoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=elDQpODIiaQUs3zg/KlaGUWifEXR1SPnIQSDswktTdE=;
        b=dztj1seF0PAzfOcmoKsJUzXeX6cKPtN1Lsu7V+7efa5EBVVkAjtv61MG/RRM1ioKln
         KusnLX3k0yNOnEO6Abr3NK1g0rbFa5PyWgvuIx8hZ/e9Wlkizohb2dpIxlZfhdyGZkKE
         FaK6iw++R7q9R/kCO5N2LnKPmmpWScIz6SXHmmQtplSeP0WrKS8Ef1aQ6sSUmDXEkd/y
         FgNEPbzh9aYPd1WL6JideHEtmGbt3gvNOd8miI3OUrDEovfWjWcD7nHleS7WVypXPnQ5
         2jD6m5EcBTtRDNkMx1TIPY5+UNwxgJUswQFKjwM/MqhM1wP2KtyTbDhqVH2ZtFvwfHEJ
         BfKQ==
X-Gm-Message-State: AOAM531wQy7E2aqdz7d99XeISK77hvfd4xAXJVnZtTAu7pTjVh+8tZFV
        p+leiu55ja0prJWkoFMpN6lOQA==
X-Google-Smtp-Source: ABdhPJxDSdIOgDOO7s7iaJSAVkEh9W1Q3tsUBvULMNjHHMa5HFg2V5kMb/wX8yYVGiFtq1IrN5jlNQ==
X-Received: by 2002:a1c:2bc1:: with SMTP id r184mr16426858wmr.58.1590908765227;
        Sun, 31 May 2020 00:06:05 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.06.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:06:04 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params.
Date:   Sun, 31 May 2020 12:33:39 +0530
Message-Id: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Live device reset capability allows the users to reset the device in real
time. For example, after flashing a new firmware image, this feature allows
a user to initiate the reset immediately from a separate command, to load
the new firmware without reloading the driver or resetting the system.

When device reset is initiated, services running on the host interfaces
will momentarily pause and resume once reset is completed, which is very
similar to momentary network outage.

This patchset adds support for two new generic devlink parameters for
controlling the live device reset capability and use it in the bnxt_en
driver.

Users can initiate the reset from a separate command, for example,
'ethtool --reset ethX all' or 'devlink dev reload' to reset the
device.
Where ethX or dev is any PF with administrative privileges.

Patchset also updates firmware spec. to 1.10.1.40.


v2->v3: Split the param into two new params "enable_live_dev_reset" and
"allow_live_dev_reset".
- Expand the documentation of each param and update commit messages
 accordingly.
- Separated the permanent configuration mode code to another patch and
rename the callbacks of the "allow_live_dev_reset" parameter accordingly.

v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
- Update documentation files and commit messages with more details of the
 feature.

Vasundhara Volam (6):
  devlink: Add 'enable_live_dev_reset' generic parameter.
  devlink: Add 'allow_live_dev_reset' generic parameter.
  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
  bnxt_en: Update firmware spec. to 1.10.1.40.
  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET

 Documentation/networking/devlink/bnxt.rst          |  4 ++
 .../networking/devlink/devlink-params.rst          | 28 ++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
 include/net/devlink.h                              |  8 +++
 net/core/devlink.c                                 | 10 ++++
 10 files changed, 175 insertions(+), 36 deletions(-)

-- 
1.8.3.1

