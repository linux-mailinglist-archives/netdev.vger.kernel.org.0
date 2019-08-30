Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1991EA2DA5
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfH3Dzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42264 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfH3Dzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so2787875pgb.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=UimNwb3naHjcDyKccX6nJ8ydZSlBRJQDSwhCLNPDx60=;
        b=GLiCzFJcAVVxGRAmACILj6fEDE/e48kqZBGB8Nd6g3yCdlhEiO2+tZOCeD4uIYcqZi
         Rubfw2Uk30nCAwJvxG5HzkN5NCBzaZDZaxZtPEKSzOICgqXcvPKGjBSyek6he2x90lMu
         8z8+tb2jqAyrSOiUpqHIBingFZSivnNjmuAz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UimNwb3naHjcDyKccX6nJ8ydZSlBRJQDSwhCLNPDx60=;
        b=i5LXwY1OBdO9LOATXkMfdIgcL3ogF7241ORNvXlKEX2LYk4xZtk5Wff5+ssmPfqgJS
         KMGMDw6bVgNe5R7FQrQ4DQUb/DIFB+tdinwpl4Q9mJVdbTFmZpgK19jWOxdNXvizqFmH
         6e7C1guHhjSMfRiHTwQRYj9vyrHB/qn2BGCgG49GmWkv9ZEfOTXDZgI+evR9KIUB77ZX
         iNeEKoMmnxxDhDOT+/qb/JXkwVDD8zE7dOv3TZyxWjrantVNA9hld+MR/RndG5Py28e8
         Cz5VDy0ZVam8nF5lKskj63TbCJniA5+kUWVqoQeR5UED09ReJLLCfjMSMuQmVs5Sz1mv
         w7yw==
X-Gm-Message-State: APjAAAX3h/yeq9g1QX0r7cGyanjvWc71yU1bpOewJVsdb23JRi6r2mzs
        eFLsmLB3F8mTg9MBjfPqwF9VDw==
X-Google-Smtp-Source: APXvYqwhElZhe5vd+wkEYoGcPDkUXpF7uSVhVsIM4avoo3bJL2gATlyKtro2sge0+jVnO6N9p7sveA==
X-Received: by 2002:a63:7205:: with SMTP id n5mr11210221pgc.443.1567137331175;
        Thu, 29 Aug 2019 20:55:31 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:30 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 00/22] bnxt_en: health and error recovery.
Date:   Thu, 29 Aug 2019 23:54:43 -0400
Message-Id: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements adapter health and error recovery.  The status
is reported through several devlink reporters and the driver will
initiate and complete the recovery process using the devlink infrastructure.

v2: Added 4 patches at the beginning of the patchset to clean up error code
    handling related to firmware messages and to convert to use standard
    error codes.

    Removed the dropping of rtnl_lock in bnxt_close().

    Broke up the patches some more for better patch organization and
    future bisection.

Michael Chan (17):
  bnxt_en: Use a common function to print the same ethtool -f error
    message.
  bnxt_en: Remove the -1 error return code from bnxt_hwrm_do_send_msg().
  bnxt_en: Convert error code in firmware message response to standard
    code.
  bnxt_en: Simplify error checking in the SR-IOV message forwarding
    functions.
  bnxt_en: Suppress all error messages in hwrm_do_send_msg() in silent
    mode.
  bnxt_en: Prepare bnxt_init_one() to be called multiple times.
  bnxt_en: Refactor bnxt_sriov_enable().
  bnxt_en: Handle firmware reset status during IF_UP.
  bnxt_en: Discover firmware error recovery capabilities.
  bnxt_en: Pre-map the firmware health monitoring registers.
  bnxt_en: Enable health monitoring.
  bnxt_en: Add BNXT_STATE_IN_FW_RESET state.
  bnxt_en: Handle RESET_NOTIFY async event from firmware.
  bnxt_en: Handle firmware reset.
  bnxt_en: Do not send firmware messages if firmware is in error state.
  bnxt_en: Add RESET_FW state logic to bnxt_fw_reset_task().
  bnxt_en: Add bnxt_fw_exception() to handle fatal firmware errors.

Vasundhara Volam (5):
  bnxt_en: Register buffers for VFs before reserving resources.
  bnxt_en: Add new FW devlink_health_reporter
  bnxt_en: Add devlink health reset reporter.
  bnxt_en: Retain user settings on a VF after RESET_NOTIFY event.
  bnxt_en: Add FW fatal devlink_health_reporter.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 884 +++++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  91 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 197 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  39 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   | 181 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h   |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c      |  17 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |   3 +
 10 files changed, 1172 insertions(+), 248 deletions(-)

-- 
2.5.1

