Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136DA12BDA3
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 14:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfL1Nb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 08:31:57 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37168 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfL1Nb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 08:31:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so10499989wmf.2
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 05:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2CBnFdu7h79LP/YJbXlskuY8H1I58h7AMKEABcQ0FTU=;
        b=Cg0aF0IyCUAIxdQiQZj55NwbFiUGx4kd+IPcPzzhZ4afv+ni14BzJbiGFeqqT+vHLn
         3P0zw+njHPMT1xUgPe8HND+Na7i22LTqUmxIeEiPtMrgAE8y5t1SuFWNkFusVEP3VPfV
         DMoudVFVmMnDogsd+V4s6HiBkhlVP5MtfqJcPXDWVyHVA9rH2C9xTLyCNAkBbRVVbcsj
         XZuPYvWaPQC7Ta5lf1gQqax97jWx0/HZQg7eVCHEt4IVMLxrB9Y3+K6Zt0kDGpzc5I8M
         /+/yrP2OP2Ba+nyD4PtRJucniJUKB00nB+HjN11nzo4XflH9/UMkw+nT1pY8JHwE5Dvu
         tnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2CBnFdu7h79LP/YJbXlskuY8H1I58h7AMKEABcQ0FTU=;
        b=tpCT4XXdl6FAJciNlDrJ9LDaPQ8Ap0Gj6ESDdjM4X7GwIX40gxqcYH5tjLKaUxcJS9
         9IzziQAMmDlh18l2Sq6pbDZRLeXn8xSUR9150TOH3Ygw+GemGHmh3SxkBJpfvbt+8Va+
         x6uK8U3mzaCBYsGpnZpC9yQzZx7E/CGzN5kkxxHZ7nizBvmmXGgCG6pOF+TJrG9RxgQJ
         5gxrSpSGcVFur+zD2+da1Z+xkmhlkY5iWs+jz3cWT4sDb5Grs/oz5Frh4+Ihea9mRjBp
         p0TdRhNlbpjrZXgqhf3Nstjp5lqiu6GON9mVN6YmxzN2qWLfKSVsxLPBa+KQHoZ4ikuO
         RWiw==
X-Gm-Message-State: APjAAAVVgYpg0enTdocBgoxzUM3QPWCmSIqVGsi7OC3K16TLz422pGO7
        iFT/1Wugq1QBqEMu50YT/yI=
X-Google-Smtp-Source: APXvYqyjkT3GwOkEBdHdaCGqORh6vuPtVuBv7zMPNwLGK1TcEw2U7q2+12PLFG/VckBbmkyU/ulvHw==
X-Received: by 2002:a7b:cb0d:: with SMTP id u13mr25523750wmj.68.1577539915113;
        Sat, 28 Dec 2019 05:31:55 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id a1sm37846199wrr.80.2019.12.28.05.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 05:31:54 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, claudiu.manoil@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 0/2] The DSA TX timestamping situation
Date:   Sat, 28 Dec 2019 15:30:44 +0200
Message-Id: <20191228133046.9406-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is the moral v2 of "[PATCH net] net: dsa: sja1105: Fix
double delivery of TX timestamps to socket error queue" [0] which did
not manage to convince public opinion (actually it didn't convince me
neither).

This fixes PTP timestamping on one particular board, where the DSA
switch is sja1105 and the master is gianfar. Unfortunately there is no
way to make the fix more general without committing logical
inaccuracies: the SKBTX_IN_PROGRESS flag does serve a purpose, even if
the sja1105 driver is not using it now: it prevents delivering a SW
timestamp to the app socket when the HW timestamp will be provided. So
not setting this flag (the approach from v1) might create avoidable
complications in the future (not to mention that there isn't any
satisfactory explanation on why that would be the correct solution).

So the goal of this change set is to create a more strict framework for
DSA master devices when attached to PTP switches, and to fix the first
master driver that is overstepping its duties and is delivering
unsolicited TX timestamps.

[0]: https://www.spinics.net/lists/netdev/msg619699.html

Vladimir Oltean (2):
  gianfar: Fix TX timestamping with a stacked DSA driver
  net: dsa: Deny PTP on master if switch supports it

 drivers/net/ethernet/freescale/gianfar.c | 10 +++++---
 net/dsa/master.c                         | 30 ++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

-- 
2.17.1

