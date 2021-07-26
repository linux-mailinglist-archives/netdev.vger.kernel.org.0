Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01D83D5CFE
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhGZOt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhGZOt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:49:27 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74CCC061757;
        Mon, 26 Jul 2021 08:29:55 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z2so16235770lft.1;
        Mon, 26 Jul 2021 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQDP+eHMr4gIyfgZISAXdJqxWneVlfNIaPi7Q7Y+BwY=;
        b=SwEHCOQT1sN8eHHMk33PPlmsf2WsfQgiHx8uF0f9S896ItrbMhXMPfDroM8u/gPvlr
         jwcDjHRK7IgMnr/RlEFwSUMQ7w7bb8fHlGO17KZ9Ml7hYWvXbFbD7S5pLW3is2aEaw+W
         7BMpPSJqapC2KUknmlHtxNq9Ph+r2LVKDs6aBSYfeuBiMIr5cxUsDGT+qnC5XepvYurQ
         UTjv11zmP//A1j7QBJ3djJ+W0kjagOj6ntkLvR1X6wHqbFNgB9v/767T595LLzo/a16d
         QCS/H8BWUODnEgzYrTvPUjTNHhMToryAk+86NXZjrcbbm2r6ENXgOfQSdOESaO2PEwCL
         0w8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQDP+eHMr4gIyfgZISAXdJqxWneVlfNIaPi7Q7Y+BwY=;
        b=NxbK7tT9VFAlFl975jNRkqRxJ5PAzPCw08MCjRzt2luWr6EmRTDcbXqh7bn/LktWw4
         72gDF87qZQwz0yAhS1ae3LurZhAVnoScDdmVHWajOoPeE6ZUtsRFng/5tgnSUVh9Gwhv
         LLy5k88IR8XeFYOvointQEyPVncDB9HpyXOVdqElA4Vx3XVrefo+GQLmlJhSnivkM19u
         arRtqcRYRCEurm+1knCnNeyOv8kVE1nucPTSWUuyqaZcAka+vkCfpnN+e+u4bGLf60vk
         XMrHe5iNcDXtxVV2Iw9eTa70Don95O6HZvMfkmrdYeubITezsJjSvXGQpU46aoech2dZ
         9Bfg==
X-Gm-Message-State: AOAM5319M3Tgw0ipMGoK41T82YzHj7/5PZOna9vyJv4+rtDpNvhD0yEy
        Nn0zeLoB2C3YDZt0o1jMAfY=
X-Google-Smtp-Source: ABdhPJwtzMFVQxYvh3fdYb9FSirxW5NjdglUjsIIDuSENTmCpKDBFWTRtL1xs+mKvC9NONt7zsDLkg==
X-Received: by 2002:a05:6512:3147:: with SMTP id s7mr12921939lfi.189.1627313394193;
        Mon, 26 Jul 2021 08:29:54 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id r201sm30165lff.179.2021.07.26.08.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:29:53 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        socketcan@hartkopp.net, mailhol.vincent@wanadoo.fr,
        b.krumboeck@gmail.com, haas@ems-wuensche.com, Stefan.Maetje@esd.eu,
        matthias.fuchs@esd.eu
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 0/3] can: fix same memory leaks in can drivers
Date:   Mon, 26 Jul 2021 18:29:38 +0300
Message-Id: <cover.1627311383.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Marc and can drivers maintainers/reviewers!

A long time ago syzbot reported memory leak in mcba_usb can driver[1]. It was
using strange pattern for allocating coherent buffers, which was leading to
memory leaks. Yesterday I got a report, that mcba_usb stopped working since my commit.
I came up with quick fix and all started working well.

There are at least 3 more drivers with this pattern, I decided to fix leaks
in them too, since code is actually the same (I guess, driver authors just copy pasted
code parts). Each of following patches is combination of 91c02557174b
("can: mcba_usb: fix memory leak in mcba_usb") and my yesterday fix [2].


Dear maintainers/reviewers, if You have one of these hardware pieces, please, test
these patches and report any errors you will find.

[1] https://syzkaller.appspot.com/bug?id=c94c1c23e829d5ac97995d51219f0c5a0cd1fa54
[2] https://lore.kernel.org/netdev/20210725103630.23864-1-paskripkin@gmail.com/


With regards,
Pavel Skripkin

Pavel Skripkin (3):
  can: usb_8dev: fix memory leak
  can: ems_usb: fix memory leak
  can: esd_usb2: fix memory leak

 drivers/net/can/usb/ems_usb.c  | 14 +++++++++++++-
 drivers/net/can/usb/esd_usb2.c | 16 +++++++++++++++-
 drivers/net/can/usb/usb_8dev.c | 15 +++++++++++++--
 3 files changed, 41 insertions(+), 4 deletions(-)

-- 
2.32.0

