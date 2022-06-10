Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13081546984
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbiFJPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242029AbiFJPjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:39:17 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD2128D68C
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x5so30715214edi.2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttBUCbYGFLdzm2aXxZ1IGyfndCTrcRAN4ru0azsH/58=;
        b=cZYmDUDy0wu5c9j6ewi0ELxc7qQdw0DCbocteP7SGDeSU/o89n1z5e1aVYndYZuLf8
         vcmhpeWbwh5y1mYzyOM22ClVplmgYc831kwVHywjMRjHAgsz3d28u3WIXtmfaxFYWNyU
         e16JsDO1awPiuGSta1Vrs/klJXTKa0bU9VpMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttBUCbYGFLdzm2aXxZ1IGyfndCTrcRAN4ru0azsH/58=;
        b=CLCWYEWXcnXcuX8EeIte7OwmDfBcEH+wxy1UHFSVUsLJ7stJ3I0Lvchrkxx24xe9DR
         o6bzcDELMyN407fit3lUlZYNd9Y9foVnEESeRE+EQMZ5zA1cPhpZc1K2HqKLK4j7MO7+
         54gCXEI6fc6lLgHZmX9B9skiWyRSz8GClRWfa0PWXUrD9tTT864fZUfHZsCB+PF+RkeR
         u5pbZ9dof0zkzNQ91a04siYCnCuDyr94l7XXMzIZeayFLMef1MWym5b57lK/BqiRYmUY
         zinQCUaCPSj+3b9wAOkbqLv8lGci3CObFhQEojplZarhTHpSwhCpy5Ua/av0UvUG4nN+
         6+FQ==
X-Gm-Message-State: AOAM5320D8jrL6cOAptXUp1pYGPIoea2cbElPNNI94su+1kWlk9dIsaZ
        7PC3lXwrwKbu+/RWRobv3kfKtA==
X-Google-Smtp-Source: ABdhPJyspXoMrwetgWUuQuUkvvnhDg0orQX5YpJax1xZh6BFYrS78uu1TShKsDkAnTFa3pXF0usKJA==
X-Received: by 2002:a05:6402:22eb:b0:42d:d578:25d9 with SMTP id dn11-20020a05640222eb00b0042dd57825d9mr52318904edb.310.1654875552048;
        Fri, 10 Jun 2022 08:39:12 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id h24-20020a170906829800b0070f7d1c5a18sm9783857ejx.55.2022.06.10.08.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:39:10 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     hauke@hauke-m.de, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/5] net: dsa: realtek: rtl8365mb: improve handling of PHY modes
Date:   Fri, 10 Jun 2022 17:38:24 +0200
Message-Id: <20220610153829.446516-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

This series introduces some minor cleanup of the driver and improves the
handling of PHY interface modes to break the assumption that CPU ports
are always over an external interface, and the assumption that user
ports are always using an internal PHY.

Changes v1 -> v2:

 - patches 1-4: no code change

 - add Luiz' reviewed-by to some of the patches

 - patch 5: put the chip_infos into a static array and get rid of the
   switch in the detect function; also remove the macros for various
   chip ID/versions and embed them directly into the array

 - patch 5: use array of size 3 rather than flexible array for extints
   in the chip_info struct; gcc complained about initialization of
   flexible array members in a nested context, and anyway, we know that
   the max number of external interfaces is 3

Alvin Šipraga (5):
  net: dsa: realtek: rtl8365mb: rename macro RTL8367RB -> RTL8367RB_VB
  net: dsa: realtek: rtl8365mb: remove port_mask private data member
  net: dsa: realtek: rtl8365mb: correct the max number of ports
  net: dsa: realtek: rtl8365mb: remove learn_limit_max private data
    member
  net: dsa: realtek: rtl8365mb: handle PHY interface modes correctly

 drivers/net/dsa/realtek/rtl8365mb.c | 299 ++++++++++++++++------------
 1 file changed, 177 insertions(+), 122 deletions(-)

-- 
2.36.1

