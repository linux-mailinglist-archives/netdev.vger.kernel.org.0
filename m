Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BD4351F4E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhDATFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbhDATD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECCEC0F26DF
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso1418854pjb.4
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=i+aPU5Ee9/6UCmQ5mpktEF4Z5MZf27bH3a8PlGJ9k0A=;
        b=Yk3NNpOYoTHprEkN3B9amkQ8A4MHJRTEgaTkow5pfXNHUlMyDGSiMZdN1JW46VgMhn
         zCbt2N2AL7xtxaJthyqL5g5VcQ2g9p0Y2yJ4GS66hfVGHLkQbEWxM2RMVVJavq5mxkbD
         UjNgIQWO/qt91OKTxpb6Z02/9OvIl7PdPUr4R/oy9Ow1/KEZ4RTMt6mSHFqRq7AF5gQW
         R+nnHUiWqD9ggvPt116X25Vw7ilSAjx0sXnZSxdHvpVz1st61HPHOx7W2AFB4/n5a01B
         1bvA3MzNBtBS7ViIY1xR4JDzBd5W09bDgOa68iNVn41gOXL8HDUy8WIXcGMqGI0kPM+t
         VKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=i+aPU5Ee9/6UCmQ5mpktEF4Z5MZf27bH3a8PlGJ9k0A=;
        b=SPponuMG7ACsvsfp/+fgyOo31wO2oT89V2AofyRtBPY+yzbd3WxDhmUTKo6GSqq5SP
         QEdJKyrV7Bdpo4CgoKhBOf24x7xkTqi/X9rHLHxmFE2xVVn/Sehp/kMKg41wafBXJukI
         HkPkmzjwKkRGq2DJwtv51A9pd0eRyXsummp2hlg2DnweqWBydkvKcgjddR1S/+XiaTeK
         q6O5NmaKYh+BK8nutR1/E2jRifINIQ0z94WwcYO4/257QB4Wo5EURTm8QVWwVEOmOzzZ
         ADeAzmUeWy0Hrmof9Y9HaZw66OC6j5f/uHzDANsbv8Uwu2FZTe63PaFSUpNGHg2QqUe2
         hRBw==
X-Gm-Message-State: AOAM533DXZKPiHuW41vY9E+qdVr580oQ0k52mmU8stiBPbujY+rk8Rc9
        JInoHWKhhaS43Kmxw2Za/GBYCK30E4GGZw==
X-Google-Smtp-Source: ABdhPJxE3kJAKrCyJpag7Xmv6uDYG8Vp+8jTYsrK49eciID9RsmYidh7vZKdL3UVpXrIpUDn08b4rw==
X-Received: by 2002:a17:90a:43a2:: with SMTP id r31mr10117022pjg.52.1617299780928;
        Thu, 01 Apr 2021 10:56:20 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:20 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 00/12] ionic: add PTP and hw clock support
Date:   Thu,  1 Apr 2021 10:55:58 -0700
Message-Id: <20210401175610.44431-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for accessing the DSC hardware clock and
for offloading PTP timestamping.

Tx packet timestamping happens through a separate Tx queue set up with
expanded completion descriptors that can report the timestamp.

Rx timestamping can happen either on all queues, or on a separate
timestamping queue when specific filtering is requested.  Again, the
timestamps are reported with the expanded completion descriptors.

The timestamping offload ability is advertised but not enabled until an
OS service asks for it.  At that time the driver's queues are reconfigured
to use the different completion descriptors and the private processing
queues as needed.

Reading the raw clock value comes through a new pair of values in the
device info registers in BAR0.  These high and low values are interpreted
with help from new clock mask, mult, and shift values in the device
identity information.

First we add the ability to detect new queue features, then the handling
of the new descriptor sizes.  After adding the new interface structures,
we start adding the support code, saving the advertising to the stack
for last.

Shannon Nelson (12):
  ionic: add new queue features to interface
  ionic: add handling of larger descriptors
  ionic: add hw timestamp structs to interface
  ionic: split adminq post and wait calls
  ionic: add hw timestamp support files
  ionic: link in the new hw timestamp code
  ionic: add rx filtering for hw timestamp steering
  ionic: set up hw timestamp queues
  ionic: add and enable tx and rx timestamp handling
  ionic: add ethtool support for PTP
  ionic: ethtool ptp stats
  ionic: advertise support for hardware timestamps

 drivers/net/ethernet/pensando/ionic/Makefile  |   1 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |   2 +
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   3 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  93 +++
 .../net/ethernet/pensando/ionic/ionic_if.h    | 214 ++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 439 ++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  75 +++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  17 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   | 589 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  21 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   1 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  38 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 138 +++-
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   3 +
 15 files changed, 1565 insertions(+), 75 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_phc.c

-- 
2.17.1

