Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943321C07DC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgD3UZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgD3UZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:25:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEA5C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 188so3513458wmc.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nuOnaJ92Udf/YFw6UJ3OTCOtQilazhEuNIKp9fYdOgo=;
        b=DHgJfbJKu9FrYddiRJr7GSUV+9x+fbN9yoGPlTnMcT8wWuMF6s7JkV7Az9zLcMOySW
         CHRipMB6DHJY/aAivOgBuIDPJK1ZI7EMl+nnwVhlWC6hX7AT5r+dJak8VUslEjZO6aUn
         fRZlrsNcVBK8CF4T1CbNXoHoxPDZoZZLXSc2269YqJ1H4XfSoKNQiINAWl/j+ESdgnbF
         asPLNnU6k9SGq/gd2NREyo1llJyPBrhW3TO7bNERXiWaM/n4/u0zy89duZh03g4HZI4X
         Qs/nY/+u2dyVF7GL++A3tMsJFlX0bZcTngVpf7rAcw0nVs8lwBCU6vQFdKrUGsJY7uUm
         a1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nuOnaJ92Udf/YFw6UJ3OTCOtQilazhEuNIKp9fYdOgo=;
        b=jyPuCsfHaa11zcSZ8hjNk9ZC5KI6twQsir5VJY6dPTxA4+PWSzw5G+gG4PjaW6C7yw
         5sU4FowxvWlfDywn79k28Ti00EO0ziLlYkSQbFm6eNjA2q4Hf4Z+tDRkS67L1Ewv3szW
         FsXQo03joEcwQV60aG1/sjBEjqj4WTG24D+iSAH2VshJaEeZRLzQuhCRWUJRMUgRzzEs
         HWWDlz3lAb4klVARTTIxh1iyt7/+7SkQYRSCZkXTaCm7rtP04DMFfkiWbwBa2eigPMT1
         BpHL2VJWr9LuPtYsEdPWY7dtrPMbmCsT12mLWxeTjxAyl4kUm4SD3LlXXbbGhQ6loC5v
         m57Q==
X-Gm-Message-State: AGi0PuZ4iMQwGOL9BIQoyhd2Sr7HduDv6ljmynMUHLEOvkR/bO95rcvR
        d6wlbXIlRAFzO9dVWtEaHaFLb4yj
X-Google-Smtp-Source: APiQypLcMwBocWmx8Lx+sOZoWZn3G8g/EMMPHkIK0zvwnSQoupSBY4SUVcl3tGWXvyfBOaFW/k7SPQ==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr374679wmi.71.1588278346521;
        Thu, 30 Apr 2020 13:25:46 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id f8sm1188462wrm.14.2020.04.30.13.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 13:25:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 0/4] Cross-chip bridging for disjoint DSA trees
Date:   Thu, 30 Apr 2020 23:25:38 +0300
Message-Id: <20200430202542.11797-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for boards where DSA switches of multiple types
are cascaded together. Actually this type of setup was brought up before
on netdev, and it looks like utilizing disjoint trees is the way to go:

https://lkml.org/lkml/2019/7/7/225

The trouble with disjoint trees (prior to this patch series) is that only
bridging of ports within the same hardware switch can be offloaded.
After scratching my head for a while, it looks like the easiest way to
support hardware bridging between different DSA trees is to bridge their
DSA masters and extend the crosschip bridging operations.

I have given some thought to bridging the DSA masters with the slaves
themselves, but given the hardware topology described in the commit
message of patch 4/4, virtually any number (and combination) of bridges
(forwarding domains) can be created on top of those 3x4-port front-panel
switches. So it becomes a lot less obvious, when the front-panel ports
are enslaved to more than 1 bridge, which bridge should the DSA masters
be enslaved to.

So the least awkward approach was to just create a completely separate
bridge for the DSA masters, whose entire purpose is to permit hardware
forwarding between the discrete switches beneath it.

v1 was submitted here:
https://www.spinics.net/lists/netdev/msg648112.html

Vladimir Oltean (4):
  net: bridge: allow enslaving some DSA master network devices
  net: dsa: permit cross-chip bridging between all trees in the system
  net: dsa: introduce a dsa_switch_find function
  net: dsa: sja1105: implement cross-chip bridging operations

 drivers/net/dsa/mv88e6xxx/chip.c       |  16 ++-
 drivers/net/dsa/sja1105/sja1105.h      |   9 ++
 drivers/net/dsa/sja1105/sja1105_main.c | 183 +++++++++++++++++++++++++
 include/net/dsa.h                      |  13 +-
 net/bridge/br_if.c                     |  32 +++--
 net/bridge/br_input.c                  |  23 +++-
 net/bridge/br_private.h                |   6 +-
 net/dsa/dsa2.c                         |  21 +++
 net/dsa/dsa_priv.h                     |   1 +
 net/dsa/port.c                         |  23 +++-
 net/dsa/switch.c                       |  21 ++-
 11 files changed, 318 insertions(+), 30 deletions(-)

-- 
2.17.1

