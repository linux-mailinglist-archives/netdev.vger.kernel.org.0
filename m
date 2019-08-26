Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52849C817
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfHZDzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:55:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46024 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfHZDzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:55:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id w26so10846033pfq.12
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8afPwHGhGEuFHvdZbRVZUQLq1e+/ddzy2JUA+x6XSNA=;
        b=WeTEWkV/5p3UFnJgITIweuEdV71l+LsvO+T05/UY9gIV8VB7MRGuEJVPhc6VVMhEYH
         KvwOPYVo5v7QOwdUMTAgMB+IbTucS4Z0mBTq6gz4PA4PjxfGkKrsZaVDio3ewqTkwZka
         zsvzMmliv15yTo5a3ESYzKY+jcSKGK6mPjRDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8afPwHGhGEuFHvdZbRVZUQLq1e+/ddzy2JUA+x6XSNA=;
        b=J46ceO3NX+iu+perSrQiUWgCCciKu/y+Xd1TQ53+DBjCFa3+g7hnuaZ0tM1qHNcU+Y
         iBfHEnapU6HBsMhyEMyBmbg/q7cfFkAFIX74+zF5A3TbicKxUGKNi7ovo50q+wLKtUQc
         6zKqhaQ2V3iWqsyjKiocJuO42VK9mroebONqZNqO5vK7HmnZ4DpJakHG2RWw+67bzeVp
         CWLu2xnV0AzFI7qHzOQdrSO/Tt8sJW8B4tAPEjPS19KY9oEgBlBdKxccYgYadnsiKKdv
         zvmSXbz4vSdoa3sYQFr1ty4ILleGQLk1HA1yUHAM3mlgI3lA1gXfLmJvaSo1J4FoLK/e
         8/rQ==
X-Gm-Message-State: APjAAAVYVkmD+g+M6a04x74RmajOUdiuCS/0v/yHC2AW/B+fRRmr6M+e
        8k8l+WB2mASHQL7CykLj8C2kxQ==
X-Google-Smtp-Source: APXvYqzmDkMejOyvEul0py96zIpModZnpDjQ7J1Ft8fG3SRXEIBKvv/SckeRIq3rykAGF4Jvn8B+Ng==
X-Received: by 2002:a63:ff03:: with SMTP id k3mr14825336pgi.40.1566791751705;
        Sun, 25 Aug 2019 20:55:51 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:51 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 00/14] bnxt_en: health and error recovery.
Date:   Sun, 25 Aug 2019 23:54:51 -0400
Message-Id: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements adapter health and error recovery.  The status
is reported through several devlink reporters and the driver will
initiate and complete the coordinated recovery process.

Michael Chan (11):
  bnxt_en: Suppress all error messages in hwrm_do_send_msg() in silent
    mode.
  bnxt_en: Prepare bnxt_init_one() to be called multiple times.
  bnxt_en: Refactor bnxt_sriov_enable().
  bnxt_en: Handle firmware reset status during IF_UP.
  bnxt_en: Discover firmware error recovery capabilities.
  bnxt_en: Pre-map the firmware health monitoring registers.
  bnxt_en: Enable health monitoring.
  bnxt_en: Add BNXT_STATE_IN_FW_RESET state and pf->registered_vfs.
  bnxt_en: Handle RESET_NOTIFY async event from firmware.
  bnxt_en: Do not send firmware messages if firmware is in error state.
  bnxt_en: Add RESET_FW state logic to bnxt_fw_reset_task().

Vasundhara Volam (3):
  bnxt_en: Add new FW devlink_health_reporter
  bnxt_en: Retain user settings on a VF after RESET_NOTIFY event.
  bnxt_en: Add FW fatal devlink_health_reporter

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 795 ++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  88 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c     |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 189 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |  96 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h   |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |   3 +
 9 files changed, 1092 insertions(+), 88 deletions(-)

-- 
2.5.1

