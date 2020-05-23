Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F27D1DF520
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbgEWGKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387446AbgEWGKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 02:10:40 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1468C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 23:10:39 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nu7so5931570pjb.0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 23:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cM3nz+0zy9LY4O2VygzkZ47UR9lt31QkovdddF0FgyY=;
        b=cIfrATYe1jeUD8gZaDOkotreT6vjn4KZ12kULxwXntRTAuZL4wpUv5PH7SH8cASBst
         9P3S4DxyfTlm89yPjKfigU63OxXrs2dFrxgcwviEqBvua7Tcn4jDTCUbIup5+nnFYQNX
         tcq6PwYBC/JkfNU63h7trE92vgVsOqpiTDITs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cM3nz+0zy9LY4O2VygzkZ47UR9lt31QkovdddF0FgyY=;
        b=PBDRs/5y1OQBMtlc1r1athBKM+s35CQOIDXlBCB5e7cxxc35euWAuHH3rS+WlqwLgs
         gV88AqSCdJScESf+yiLMDHt0vnux7uGXa5lKvvSSCsgcB07jL9I5dLyF0SaZKEe0CGUn
         njTv9GVjgAuLvB198KtdXEwV/nLQHmMVh7KGyHr8H9SriTOEmEU+GlY7K9guQdIIPqkL
         iRhhRq9XSQtpc8VtUCS57lbOX55ONiAO9cHRnzFu2EzhV9Lp5Cy8mS0BdOzvWEWQdAnq
         p7zdsvXyK//zyciI03SIVH3yFgSnSPIwVOcf+38GH4BTFSfNF7rrHHJphh3xmzfZoIJf
         c63A==
X-Gm-Message-State: AOAM532BrVBG6Ql3fTJuqWYkuV72oaBZeeycw/G4OsfaUSTwctc97HG9
        /3pInH1R0/3L5EEmN5reXEjJxQ==
X-Google-Smtp-Source: ABdhPJxF6GitruPZ9YsreOq4wkhPb5uOFZBidC6vEm73qfZ/wPggd6+prtKuV2MKmXj/C0a7wBB3/g==
X-Received: by 2002:a17:90a:3d49:: with SMTP id o9mr8158326pjf.26.1590214239083;
        Fri, 22 May 2020 23:10:39 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 1sm8455414pff.180.2020.05.22.23.10.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 May 2020 23:10:38 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v2 net-next 0/4] bnxt_en: Add new "allow_fw_live_reset" generic devlink parameter
Date:   Sat, 23 May 2020 11:38:21 +0530
Message-Id: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for a "allow_fw_live_reset" generic devlink
parameter and use it in bnxt_en driver.

Firmware live reset allows users to reset the firmware in real time. For
example, after firmware upgrade, this feature can immediately reset to run
the new firmware without reloading the driver or rebooting the system. When
device reset is initiated, services running on the host interfaces will
momentarily pause and resume once reset is completed which is very similar
to momentary network outage.

User can initiate the fw reset by using "ethtool --reset ethX all" command.
Where ethX is any PF of the device with administrative privileges.

Firmware can initiate the live reset only when all the installed host
driver(s) also support the feature. For example, if a function is loaded
with a very old driver that is not aware of live reset capability,
firmware cannot initiate the reset until that driver is unloaded or
upgraded.

"allow_fw_live_reset" runtime configuration mode allows the user to control
this feature by enabling or disabling it in the host driver. And permanent
configuration mode allows the user to enable the firmware live reset
capability in NVRAM configuration of the device.

Also, firmware spec. is updated to 1.10.1.40.

v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
Update documentation files and commit messages with more details of the
feature.

Vasundhara Volam (4):
  devlink: Add new "allow_fw_live_reset" generic device parameter.
  bnxt_en: Update firmware spec. to 1.10.1.40.
  bnxt_en: Use allow_fw_live_reset generic devlink parameter
  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET

 Documentation/networking/devlink/bnxt.rst          | 13 +++++
 .../networking/devlink/devlink-params.rst          |  6 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 61 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
 include/net/devlink.h                              |  4 ++
 net/core/devlink.c                                 |  5 ++
 10 files changed, 165 insertions(+), 36 deletions(-)

-- 
1.8.3.1

