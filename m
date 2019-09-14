Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FB0B2988
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 06:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbfINEB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 00:01:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43100 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfINEB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 00:01:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id u72so16279876pgb.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 21:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=z8C48pxHbnpxzephm2iJiudOrNDelXO+1+G5iIKs+LU=;
        b=CabwZyDCMep82ea62tUzDrO0MwOlvUNSMZaDKID9ba4jImQtSBX7E6yVmcNYzNIYPf
         lImcPXwd0B2wQejRWD7J/MrUdAkquiLz6GahEQfyeNOB5pAmgoADzPnkmA/DrCh8eOMM
         wEOvvcdNckYx+x8vZg3am4GFEUi9RiY7Nlgm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z8C48pxHbnpxzephm2iJiudOrNDelXO+1+G5iIKs+LU=;
        b=t0X+p6JjPA6aZVNldWac3q1d1HX9NMt3oX3fhHbnJbTmKXF5Zm91FBQm2xPWsISwBW
         epwgtSPU+ulcmcWDPHjvhOFWACsHwij0qWSkEO2Ov6ZJlASarzEumkQLRlNLe7VWl8PD
         o4LTUT4SLMulid7gCkDiJ63ccbYrJA+MM1DsTygrDtzjCYlgtUCRjrIxK5WrdZUAqzE6
         +QvZHGnIpn0eHSCprAIh+/AjlK4lF+sdAXF+YW0GM77OCDSx8C87SqzQzy1DRaBy/HCT
         ggGaJWJmZTg2yAqNUfZh2Tw2vtBJqZWnQfNlwCtSYYChwFJMDugzHK10RkISrMAUa5SP
         OGlQ==
X-Gm-Message-State: APjAAAUnYsCq+HnlmNBZYLkirYwwmct8Qux1szAGOQJ+MNZ7sJ0cQNYh
        Esb/15cLC05Iq2x9AHCZhcku6Je6Trc=
X-Google-Smtp-Source: APXvYqxeS/HNtBV3ot4T6KHL4T64yW8zlbDzAtqlXxAdUTABRrRMuJyZ75uzJoX+hgc4JQzHi8AoXA==
X-Received: by 2002:a17:90a:d0c4:: with SMTP id y4mr9221094pjw.116.1568433716635;
        Fri, 13 Sep 2019 21:01:56 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a29sm52363908pfr.152.2019.09.13.21.01.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 21:01:56 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net-next 0/4] bnxt_en: error recovery follow-up patches.
Date:   Sat, 14 Sep 2019 00:01:37 -0400
Message-Id: <1568433701-29000-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A follow-up patchset for the recently added health and error recovery
feature.  The first fix is to prevent .ndo_set_rx_mode() from proceeding
when reset is in progress.  The 2nd fix is for the firmware coredump
command.  The 3rd and 4th patches update the error recovery process
slightly to add a state that polls and waits for the firmware to be down.

Michael Chan (2):
  bnxt_en: Don't proceed in .ndo_set_rx_mode() when device is not in
    open state.
  bnxt_en: Update firmware interface spec. to 1.10.0.100.

Vasundhara Volam (2):
  bnxt_en: Increase timeout for HWRM_DBG_COREDUMP_XX commands
  bnxt_en: Add a new BNXT_FW_RESET_STATE_POLL_FW_DOWN state.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  56 +++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 146 +++++++++++++++-------
 4 files changed, 156 insertions(+), 52 deletions(-)

-- 
2.5.1

