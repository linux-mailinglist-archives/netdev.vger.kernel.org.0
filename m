Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB022685F6
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgINHb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgINHbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:42 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE3CC06174A;
        Mon, 14 Sep 2020 00:31:42 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so10812080pgl.10;
        Mon, 14 Sep 2020 00:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KL7w+c0/QzBqZxa4PuZvixOgYFy6Q1ksga1wZFj49Gw=;
        b=mRF56UAhuY6HklKPGyQcAHTCRt8j/ZNoAfrX0y4zRUjwSuUwBA7+GDi97p5z08pwUk
         JxFvogTRccJ/bwpUJvWnlHr/l3f9XLsiJtpJyStJEfrgmmwJL0SXI7lEzDm5XSzRXDkG
         2xK8boKj9p8F9jZTWK5h/bBjvyXseLVmDfKaLcwRJPShTsrA2RDyeWUHPfpwWWth+BgF
         seElpTgyrGLV96iUxZE5aX9IUNyuhlglCwOXYle43YmlpUZRKo2VtBIYeLGm1xFu2ARt
         EiS1xgdlT6y+hqVKRf4fKzUwxLffpxKDUjJJNuxUOuQ7WeislYY9tqVyflgo6XRxg2Ok
         xUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KL7w+c0/QzBqZxa4PuZvixOgYFy6Q1ksga1wZFj49Gw=;
        b=hQ94DK9IC/CwEcQDn0DjXKauePDULmMZG+bcX1lnLAe85DAZ9utd0kcRqsFYQH8AVc
         L1S1A2ZBTiLMs/Jm5p1Vd3lyU4aRGPhqzNTFwPjfF1SaVjmv+xBSK2usG2bQtq7rkSNv
         duxN2GHhLtP0MmbGWWNu6fj09OqjQtTnHy0G53PlqMOUMqFQWrPT0G4ADK9FV1PzUb3M
         kf/S+liUjcLNdAOBWw7/6P8ORkC4b8qY9yaZAYzU5eIbGAMtYhJRVGLHbjXJ4jBT2VjI
         coomQNQsLHGiGeAavcAoQAjTLNqdVv+4He9+UYNiD6+CYYUBf4vc19TuEykVaTs1B0AS
         hw8Q==
X-Gm-Message-State: AOAM531+/MoYXnMrxK/J16lgRwW09O97VFi5DwbP1WCvwOyvN/C374Wt
        cGJ89ZywxRHOrMTX7CXTKlI=
X-Google-Smtp-Source: ABdhPJx4cGqYeqDRpl4zzCjFSXPxdGg8i0k9FfFRJ39DfWhh6Ev0FjPxYYt/tNCE6CUloWvB9Q3sjg==
X-Received: by 2002:a17:902:8c8c:b029:d1:cc21:9056 with SMTP id t12-20020a1709028c8cb02900d1cc219056mr2014633plo.22.1600068701932;
        Mon, 14 Sep 2020 00:31:41 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:41 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [RESEND net-next v2 00/12]drivers: net: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:19 +0530
Message-Id: <20200914073131.803374-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

ommit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the net/* drivers to use the new tasklet_setup() API

This series is based on v5.9-rc5

Allen Pais (12):
  net: mvpp2: Prepare to use the new tasklet API
  net: arcnet: convert tasklets to use new tasklet_setup() API
  net: caif: convert tasklets to use new tasklet_setup() API
  net: ifb: convert tasklets to use new tasklet_setup() API
  net: ppp: convert tasklets to use new tasklet_setup() API
  net: cdc_ncm: convert tasklets to use new tasklet_setup() API
  net: hso: convert tasklets to use new tasklet_setup() API
  net: lan78xx: convert tasklets to use new tasklet_setup() API
  net: pegasus: convert tasklets to use new tasklet_setup() API
  net: r8152: convert tasklets to use new tasklet_setup() API
  net: rtl8150: convert tasklets to use new tasklet_setup() API
  net: usbnet: convert tasklets to use new tasklet_setup() API

 drivers/net/arcnet/arcnet.c                     |  7 +++----
 drivers/net/caif/caif_virtio.c                  |  8 +++-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  1 +
 drivers/net/ifb.c                               |  7 +++----
 drivers/net/ppp/ppp_async.c                     |  8 ++++----
 drivers/net/ppp/ppp_synctty.c                   |  8 ++++----
 drivers/net/usb/cdc_ncm.c                       |  8 ++++----
 drivers/net/usb/hso.c                           | 10 +++++-----
 drivers/net/usb/lan78xx.c                       |  6 +++---
 drivers/net/usb/pegasus.c                       |  6 +++---
 drivers/net/usb/r8152.c                         |  8 +++-----
 drivers/net/usb/rtl8150.c                       |  6 +++---
 drivers/net/usb/usbnet.c                        |  3 +--
 14 files changed, 41 insertions(+), 46 deletions(-)

-- 
2.25.1

