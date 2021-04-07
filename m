Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788033575B0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356013AbhDGUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356004AbhDGUPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:15:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC99C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 13:15:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n2so23505040ejy.7
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 13:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83KBHma6fh8UBfgUixf3vjb3SGMdmrshYrqfmkk+l2k=;
        b=huA25B0no4h4tfvdGiiSG3DQJTE0ybhQXjVFGHthZYjnn1PS4WNOg5uH7MKSAOSh0w
         Bnqw1hGL9jG2Kz5MWBO5O0baAEuXv/ODdDevKfVuucYm/zXjP9vG+CAXZzCXUwHyIzgm
         gmtqSMJfABpOXg39UFZYzFedRT/RKncI7kh8K4St3pUTvotbNYL13hAgbEaq4AvHXy7w
         mDmhrgubSkqLZ/Oe3WioGz2wsGO5uP00Hjhw+8xF2o6v1jZaNLnQ4xZF883xU/DUFacw
         z4P76BR0ULUX2xhMXtgpFKPmyzTWk1SZHm4VvmCHLSCgRqXUAVTM7viV7z7rsbyemlh/
         zA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=83KBHma6fh8UBfgUixf3vjb3SGMdmrshYrqfmkk+l2k=;
        b=ggHoKXdXi2uUZPkfAtookRVPuCk5oRaQ7RiMV65sKHgetflr9MEQfi033RHkv5TYgi
         2XocEUvFT8hZ80cLnVZoC3SQ2hQOLNioUQFssLC1GyDaUz5ftOOM3FA/4q4T7WRw85NW
         iSpNb9zLvGRDUYSyQhzuFKaSgnpy5MKRWDmkoLtHnVXGgJKXvs+IdTUPzv6BO/dNVyuo
         gb9TcAj2lu7h3soaa6KVrKLNEW9oZsqKVjGrsysEs5yM9kkjNp4rxTh0fzg+68iBojBR
         IrC4QeEnCuslZKJYMcwgv3fxlfaQPBq0/zRLpkvCl1sg7izcZah5DC8e0pzwrYCmqNBs
         YJoQ==
X-Gm-Message-State: AOAM5328X3GtxgHNQ2l7jHWizMmwjrMN2knaFzdVLdlHI005qfBNVH7w
        JP13JkJxeDZtgD/ctt5u3xs=
X-Google-Smtp-Source: ABdhPJwXd+b6naFrUjxuirT1W172w5ziX20cyCMu5uvrbXI8CpkL0+wNeuRG/m1fjx/UYOp3OfWcaA==
X-Received: by 2002:a17:907:3393:: with SMTP id zj19mr5911780ejb.347.1617826504942;
        Wed, 07 Apr 2021 13:15:04 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r26sm4982892edc.43.2021.04.07.13.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:15:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 0/3] Fixes for sja1105 best-effort VLAN filtering
Date:   Wed,  7 Apr 2021 23:14:49 +0300
Message-Id: <20210407201452.1703261-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series addresses some user complaints regarding best-effort VLAN
filtering support on sja1105:
- switch not pushing VLAN tag on egress when it should
- switch not dropping traffic with unknown VLAN when it should
- switch not overwriting VLAN flags when it should

Those bugs are not the reason why it's called best-effort, so we should
fix them :)

Vladimir Oltean (3):
  net: dsa: sja1105: use the bridge pvid in best_effort_vlan_filtering
    mode
  net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic
  net: dsa: sja1105: update existing VLANs from the bridge VLAN list

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 61 ++++++++++++++++++--------
 2 files changed, 43 insertions(+), 19 deletions(-)

-- 
2.25.1

