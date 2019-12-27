Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C1112B4B6
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 14:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfL0NCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 08:02:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34350 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0NCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 08:02:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id c127so6845476wme.1
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 05:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H6yhrk7MOPfgAqOyYMkFlyk4k0Gx1xWrJTv4PbVvw0k=;
        b=Pm2djIftyQXWQ+R/ei0b3D2k5tKUtGW2Rg9CWolpH06vLB0I71L2SB3pLoLDmxgJt4
         IxTitPorkLfQ4eCaBB6XqkIJZ5qYm7Y2eqj/hMY7sSnehxbckhec8tbfG82vx1QPrbx6
         dRwV8bPenPi82FXSimi71WjkFhpD0czxeYYX59iok/GFFKsAChXNtpRhBKX0u3DixSnw
         CNTYtGror79smIow6G8jhS6826Y1mZNcjHcjlcPflgbvq9FWM+QJSj8cc1TgdmfEyYYM
         iaqeO3nyug+mYc0DGq4n6zPLwPZoKyeNRK1oX4k4AAodyVZWbRFDlcKouIMljulOrb/I
         B9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H6yhrk7MOPfgAqOyYMkFlyk4k0Gx1xWrJTv4PbVvw0k=;
        b=SXf8JufFWmKpgBYF1gll5zLGVJQ5SIzAR+hVwck894YysHse7rP6BHEcZZRG/2R8nx
         WM9Ipwhg7TTwm7ZztSVjUJKCQ5C1PboKe5hFprCrvjxB2kdHBgdxY3T3YReFrX1iToWa
         P0CpCx7kbpaTOIFzojDk/Fp8OKIn4Do8qlie0aRFtrWJ9ShmFLG/r6/+gX61YM26SWav
         syFNdw07sm4a0RNNYWjYUb1r62wbU6FsMcyAGSt4CkCjDDO8Qrk5g04fW+f6O1lVqA/J
         y8HwFRvMdwaqdUE3HazOP0OOHSZ8IlwyVKmk+pBQkInM09xNFulrnsg7a0HlufoV7l4U
         b10g==
X-Gm-Message-State: APjAAAVE2fN0sQlPhcaavno0yo/4ozNM2/84JptxTX/MrUDMhbzOToYa
        ps2e0ulbCPwlX5LNiFTs2Oc=
X-Google-Smtp-Source: APXvYqwefgcfuGvSCuoGlrlYzC2aEz/yQMK5zBlJ+apyJMjXpZVpfaNWB+zzPEecA8cTROFyn5ScxA==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr20072090wmj.25.1577451756999;
        Fri, 27 Dec 2019 05:02:36 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id i5sm34307357wrv.34.2019.12.27.05.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 05:02:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/3] Improvements to SJA1105 DSA RX timestamping
Date:   Fri, 27 Dec 2019 15:02:27 +0200
Message-Id: <20191227130230.21541-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes the sja1105 DSA driver use a dedicated kernel thread
for RX timestamping, a process which is time-sensitive and otherwise a
bit fragile. This allows users to customize their system (probabil an
embedded PTP switch) fully and allocate the CPU bandwidth for the driver
to expedite the RX timestamps as quickly as possible.

While doing this conversion, add a function to the PTP core for
cancelling this kernel thread (function which I found rather strange to
be missing).

Vladimir Oltean (3):
  ptp: introduce ptp_cancel_worker_sync
  net: dsa: sja1105: Use PTP core's dedicated kernel thread for RX
    timestamping
  net: dsa: sja1105: Empty the RX timestamping queue on PTP settings
    change

 drivers/net/dsa/sja1105/sja1105_ptp.c | 36 +++++++++++++--------------
 drivers/net/dsa/sja1105/sja1105_ptp.h |  1 +
 drivers/ptp/ptp_clock.c               |  6 +++++
 include/linux/dsa/sja1105.h           |  2 --
 include/linux/ptp_clock_kernel.h      |  9 +++++++
 5 files changed, 34 insertions(+), 20 deletions(-)

-- 
2.17.1

