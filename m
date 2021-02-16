Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6631CA0C
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBPLom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhBPLmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:42:17 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC667C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:41:26 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b14so9996106eju.7
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 03:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ripVg4GHIrzqLApODJeiJ04dXI7yF4Jv+aS5HCEiDIQ=;
        b=cCoEDWafj0YiFgw7TY6vuzw8ZBUoI7/0uiV7YhzyEuRlDvcQPy1npTT8oI8Ilq3mDX
         Q+jpMAUkuVwqbhkkFuN0qR24lpVUzelvYcMjv1pjp8c5G2E03CccA2pjd0vVkyB1UqZm
         3berpR0AKPdBVMPcx2JU/L0EJpZ76uwTkrrxhZhsZpmLsyrBnwKGQ0CW5zlgH6XaOvhV
         bS7kLdJ+L1Ujd98YdtY2p0hze1QLpgGnAPkGU13woo6cQzpwdULh3jkigH/QtQeg9ON+
         ybI+7MaMzfNUn37WfKQG8eEURldvfBBY8WAhmOGUrUlCIMTIGdQG/1Nl7Zx3ASGw633D
         Z3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ripVg4GHIrzqLApODJeiJ04dXI7yF4Jv+aS5HCEiDIQ=;
        b=rsH0lNB86R9Q0bEndmrBudKbvmL31ocilYjf3mU1RIVI+0ruJYWE+E7HIspkgs4Nzt
         gN6tjbTEAW7UUgWZ+VepdVqB423/G03Hf4KNk7k3L7RkQhe7iYbEAX2xEdtYl4m9BRjL
         zCpf3qW1rPbz5stRFT2Xb3V71dHH/a3PkwjWiFmVlphk4sT+yn354Kqb9JbjrdAw/+Rb
         U6wJm+LZ1pAM+oq5j2Va/kqSCQGSrQgQ7NtnpWaO3jd3IkVrhsborxkTvP3b8hNDk+Cv
         +gG3r7P8BkELj+1X0u77u4T+gM055MPNXJN9AACTdJfnbkojP+DHWxx8j/0dw++iSl/m
         OhEA==
X-Gm-Message-State: AOAM532lgIT4CHzNQPpba2HH2J8jlNPAMlCpx/cROD76/HmRXJ4wUw5c
        K6HiZ1eZkwGDw9kMav3kWmM=
X-Google-Smtp-Source: ABdhPJxuOJowO7YPGWVhEk5whU4ep7XKlpa+hA4w72TXtN6OwqICvw1wnAuvO43z/5/Xh9HZFm4WDA==
X-Received: by 2002:a17:906:1352:: with SMTP id x18mr14488487ejb.418.1613475685711;
        Tue, 16 Feb 2021 03:41:25 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id kb25sm13287397ejc.19.2021.02.16.03.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 03:41:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH RESEND net-next 0/2] Fix buggy brport flags offload for SJA1105 DSA
Date:   Tue, 16 Feb 2021 13:41:17 +0200
Message-Id: <20210216114119.2856299-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

I am resending this series because the title and the patches were mixed
up and these patches were lost. This series' cover letter was used as
the merge commit for the unrelated "Fixing build breakage after "Merge
branch 'Propagate-extack-for-switchdev-LANs-from-DSA'"" series, as can
be seen below:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=ca04422afd6998611a81d0ea1b61d5a5f4923f84

while the actual patches from the "Fix buggy brport flags offload for
SJA1105 DSA" series were marked as superseded and not applied:
https://patchwork.kernel.org/project/netdevbpf/cover/20210214155704.1784220-1-olteanv@gmail.com/
which they should have.

I know with so many bugs I introduced it's hard to keep track, I'm sorry.

Original series description:

While testing software bridging on sja1105, I discovered that I managed
to introduce two bugs in a single patch submitted recently to net-next.

Vladimir Oltean (2):
  net: dsa: sja1105: fix configuration of source address learning
  net: dsa: sja1105: fix leakage of flooded frames outside bridging
    domain

 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 117 ++++++++++++++++---------
 2 files changed, 77 insertions(+), 42 deletions(-)

-- 
2.25.1

