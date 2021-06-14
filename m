Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EBE3A684B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhFNNrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhFNNrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:47:04 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C84C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:01 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id my49so16811748ejc.7
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBvdvEd0kB8KSfGEXJJDh8EYk67MFTvE46bTVJD59Ws=;
        b=D8XQ5khN900HTeyF7tQBbXfNUAFEMvUTYSVEB8JVmhkRwJWM47qp+/OxVR5s/E6JQm
         FEyEKHBKO/aLmwnIq+4MmJn/P6mdDeJKd1RJDB38UAKiiA55BKYJg9QNXGPbmnMULPSs
         AC3UA7Ngt/7pzIOAuRg5cnDHB7+90AN1Lsnl96yd5gkyz2QjxNsH1F43Dfegf6L9o7H9
         ms/0WLEur/I/MkqLlGwMiEO6CWFlDFFfCQmxRdSoUdGEuefXnN4TIKGTV3M6/04lRpQr
         /S+yEtaw4p4nE/FXw9SwTPmwajcFMmk5NuYfoFFuiNc+Dm4k3fvhC4TLXjU/utj4F3zs
         WRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBvdvEd0kB8KSfGEXJJDh8EYk67MFTvE46bTVJD59Ws=;
        b=sC2ofzqxpiOLf3NSo4zH5xDaeRs6IT0WrB0fnWhMSz3UFaJ9Eu36EacpA0f82FkKyn
         4VgLUzxkClzdtCz+83WSDCZRfolTIaZd1Bsy/SUV1sZSY3MEgDUzPcJCCN51ME/s7tj2
         XbTJqIJS66ZbiWL0EKplNwlaFz+BiZHST9KjCv1YqI47SEqrzDcHihccuKKrPu8XYr8N
         xeEm5vilA8jT1+I1q/eFPwRkYY2zYpI4lb2nx6dvkktsT/q0uz3Aw7ps1aoHIgUuqfz6
         IqFrRnv0XWwvtC8VS/mRyAgSbrn65uHnbPQk0WWqh433MqP/7+YZNPFALSZkONsFqZRA
         DAGw==
X-Gm-Message-State: AOAM532PaDTnPpHOP+4VENyQVUhDIFmdciU8Kf1HFHU1S1MFSoyDNHTL
        2aVUSmM4smwe0+rgRbyFCMg=
X-Google-Smtp-Source: ABdhPJxGGh6VZqghkyY4c1BtfNzRl9rIlrmw4bDheFY4W+LVwjGy7xDLnFhJiYw3bih6sS4HsWOlsA==
X-Received: by 2002:a17:906:dfd1:: with SMTP id jt17mr15344994ejc.486.1623678299581;
        Mon, 14 Jun 2021 06:44:59 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id q20sm7626891ejb.71.2021.06.14.06.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:44:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 0/4] Fixes and improvements to TJA1103 PHY driver
Date:   Mon, 14 Jun 2021 16:44:37 +0300
Message-Id: <20210614134441.497008-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series contains:
- an erratum workaround for the TJA1103 PHY integrated in SJA1110
- an adaptation of the driver so it prints less unnecessary information
  when probing on SJA1110
- a PTP RX timestamping bug fix and a clarification patch

Targeting net-next since the PHY support is currently in net-next only.

Changes in v3:
Added one more patch which improves the readability of
nxp_c45_reconstruct_ts.

Changes in v2:
Added a comment to the hardware workaround procedure.

Vladimir Oltean (4):
  net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to
    debug
  net: phy: nxp-c45-tja11xx: express timestamp wraparound interval in
    terms of TS_SEC_MASK
  net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
  net: phy: nxp-c45-tja11xx: enable MDIO write access to the
    master/slave registers

 drivers/net/phy/nxp-c45-tja11xx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
2.25.1

