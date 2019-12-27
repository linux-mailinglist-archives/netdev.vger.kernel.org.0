Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22BC12B005
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 01:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfL0ApW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 19:45:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40198 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfL0ApW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 19:45:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so24827622wrn.7
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 16:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=96tdXftOy4hwueHCZ0IEKWbINataYy8PdTQtP87hM+Y=;
        b=g3zH/XkZOcqkvfF3Boyq6BiemJO6KdkOlNj64XEBlXqWCIs+f/W/8RWRVCyff0XEmw
         ySY26f+Y3//J6S4vgDJFwHnLFHa5FpgcZtZW2Tapkmr+kpIqHHne5v0BlLBHlZJ9ef9o
         QQ8ac1lGDVmWVr9NthBbBtns2LnS3Tq4MW2LpJrny25EOXu6Rk5hsiX4+a86ogfMesxr
         B3WmlUylKXFk/5Jr8lTfMvgaGtUDcoik6ZkPiAIpiCMJ+np01XD8oe0eUHmKhs0SatRm
         QprEfZ6aOHFo/TihSlTfeO856ldPsrOSa5Rl+6cO/BIOrIUaZLsDN315LYeP120mjAsA
         /C7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=96tdXftOy4hwueHCZ0IEKWbINataYy8PdTQtP87hM+Y=;
        b=Zz5Fot0APcAaOLWdnxdYLvKgNnoEkS/sjSBMpez6v55go82ZBg6XLtMEbpXYjccopO
         5e1AJWaCfCaClRHLOF4WOyQ1C1AT9km1Uye89aQr2v9R5EsFVJ75A4qBwSj5RphZU1kJ
         P146m3Rwo2V/OERGmJPDnKKaQrxnx+JWy1h+hXtZ9+8t1BmvHNd5yR5ju8mxO1tPMQ0Z
         5vvLck0vDbkfGh82jq+KYQOCNOmBVVMw9cXNLzyaRYmo8ehzzhPR5yIPRn/FsADXQExr
         vBe42Mq7Yv1NzXATTatmoLLVtYdyjyhMoMuBUCJVcAd8pn2in0XvUtj/0OjzbUo7qTGs
         8duw==
X-Gm-Message-State: APjAAAUDZBVc1sXvlzObkWRXuA4N6X8ZFvZRB+VLYridvHB07nro4peA
        MijrV3ap1chyef7+AoniAB4=
X-Google-Smtp-Source: APXvYqwC7d604jgKh0laKxpSElJs8gzLPpuieYaOwZXfMpNaZZARRz0XVT4lMICccPZsxagXHU3Ixg==
X-Received: by 2002:adf:e683:: with SMTP id r3mr47071189wrm.38.1577407520697;
        Thu, 26 Dec 2019 16:45:20 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id 60sm33816488wrn.86.2019.12.26.16.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 16:45:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/2] The DSA TX timestamping situation
Date:   Fri, 27 Dec 2019 02:44:33 +0200
Message-Id: <20191227004435.21692-1-olteanv@gmail.com>
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
  gianfar: Fix TX timestamping with stacked (DSA and PHY) drivers
  net: dsa: Deny PTP on master if switch supports it

 drivers/net/ethernet/freescale/gianfar.c | 10 +++++---
 net/dsa/master.c                         | 30 ++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

-- 
2.17.1

