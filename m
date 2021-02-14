Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1A31B10D
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBNP6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhBNP56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:57:58 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52F6C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:57:17 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f14so7295324ejc.8
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4i1VbRxKBDPUW0vWWbx0BPL/Uvnb0ch6r6DGv5dnM6I=;
        b=XIV7Y9LeG85EFn1LUrY2nufnpz5+sS0JKAEafiOUjPRc4J0Wqw9sSnNdKooMIWM6Nb
         XvBxXUuegNDLSvX0IOa+blhHXmsc9kCbdPpfoYfnFxeyvN1H5seueGFdjh6SYchSaC4p
         hkDW/wRwb5MIkIKZi9khvvsjiLY1TdlVgol1Z6jeHU++QGlBxA3H0PY2TDvsKjtP3Bgj
         HxbrtLTKBwWlJb+aR6oxZFihn7T6RD2M7gERPOw5kEICGRtV7veHshIR51diiix3Necz
         SRruSL8F+T4ikWCYuuvcldMaxx3na8wGQQznuhXBrvoWfKtXcb0YRXNZrrOhnBanJ6vc
         cQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4i1VbRxKBDPUW0vWWbx0BPL/Uvnb0ch6r6DGv5dnM6I=;
        b=eAfY82QsezPUXwLxh4gs4VJmoSiLwkZs6h6PmZKxqf0zLlGRYVk/H7WWY7+to+BxKH
         5cy3HrQlLD4DjkgXht8QCKecjNKoz9+XQhAdzpUvamI2PH7H6AekppTONR7Lh56qMz0M
         1qK9zrIWE/lrafP2nCT12iw6yEqPR7EMfTV1czA9o9A5FWoLwQhuYcZa4xCe0F+WqA4C
         L9gRZJ9Qng3hlmnMecwYjBYaT7KqM5D7F/ZUQF9rNKXWW9U0USRyj4nVvQ/j4rY7nWW8
         mo+VVuBMOpwSIjxZVabca9Mss/4285zg7sA/4XSJ8BYPFeEK0xTFq9zC7Ph/lWAFKfG/
         lbiw==
X-Gm-Message-State: AOAM533BQzAbDVEm9OA8rsTgBswLPE3GwJ5idud5zuVZ5/C8oBht3blZ
        2wH6+yn7LT2GDBRtUwtMXt4=
X-Google-Smtp-Source: ABdhPJwggJyxBIm397MnHa6n/wuCOU7X3QSuJGIXU7gWrDPS1MZFswERTGHjVJFGvIn3eqUW0UafJQ==
X-Received: by 2002:a17:906:2bce:: with SMTP id n14mr11551176ejg.171.1613318236350;
        Sun, 14 Feb 2021 07:57:16 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d16sm8671829edq.77.2021.02.14.07.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:57:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/2] Fix buggy brport flags offload for SJA1105 DSA
Date:   Sun, 14 Feb 2021 17:57:02 +0200
Message-Id: <20210214155704.1784220-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

While testing the "Software fallback for bridging in DSA" on sja1105, I
discovered that I managed to introduce two bugs in a single patch
submitted recently to net-next.

Vladimir Oltean (2):
  net: dsa: sja1105: fix configuration of source address learning
  net: dsa: sja1105: fix leakage of flooded frames outside bridging
    domain

 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 117 ++++++++++++++++---------
 2 files changed, 77 insertions(+), 42 deletions(-)

-- 
2.25.1

