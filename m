Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E60354927
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhDEXOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhDEXOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 19:14:00 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460A2C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 16:13:53 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id c4so13191280qkg.3
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 16:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oY9AEHqMCoctA85AChPKxlTTwqq5V8ksN6WFesdYeHM=;
        b=SPE2oLxix0ZnxE10qCqINgJc8Ncpd4gIloyEunLq07fnxspwS+9sqwRSnsr/P0mpKV
         QRzQUhfmHGXXQO7NrE2twBpRcVECM2vnTmGi4rBYW80eb3qLiSN1X09SAM21337HbF40
         8/UACXQ34wfjiQWXws7DZNxpf6Yi/+TRHV/bw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oY9AEHqMCoctA85AChPKxlTTwqq5V8ksN6WFesdYeHM=;
        b=hNtjyqGLrMAw0vZZgrgenCPoez6d/OsoS3Dw2B7iPqC+HBkkv/j36U6u4D1NYk7p/k
         ip4sb9Sb73PlvU/uyBBPegQn2Iji4H4vHcHPU9ow37m4L9uPMa03C+8AMNSNxJ2FPt75
         Ws7ImrZsFX1ATonlnaUsMYIlVW0WzNu6/ktmNKFHTuRY9TvXy55vESfBSqLtSFiRh2dm
         PF8mryTpuhuGjmlSHpGrUKfzuOMfgP1w8+Plr7DCt5Dq14Ap42zsldKlZjS9vb2yHfau
         zYrYCbCgi42s57KED0pBVKF21rx349ymdfLY9sheNimEOqUSPQQ20NAW1nZI9Mk1ebHy
         on2Q==
X-Gm-Message-State: AOAM531pGe0Y9YgzXXCIhtmsKVehbLtePNzw73uHwrc7k8QO6BOba1jm
        4+av14eh13Ru7NORByi6C6ACZg==
X-Google-Smtp-Source: ABdhPJwyGo4QG+wg2pQsoVa5tL2+SgxR3n93EHzX1oJNog5PTiePblgDmjkdHHKviHB91pxQcFs8lQ==
X-Received: by 2002:a05:620a:440a:: with SMTP id v10mr26128060qkp.357.1617664432401;
        Mon, 05 Apr 2021 16:13:52 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id b17sm13151650qtp.73.2021.04.05.16.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 16:13:51 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH net-next v4 0/4] usbnet: speed reporting for devices without MDIO
Date:   Mon,  5 Apr 2021 16:13:40 -0700
Message-Id: <20210405231344.1403025-1-grundler@chromium.org>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces support for USB network devices that report
speed as a part of their protocol, not emulating an MII to be accessed
over MDIO.

v2: rebased on recent upstream changes
v3: incorporated hints on naming and comments
v4: fix misplaced hunks; reword some commit messages;
    add same change for cdc_ether
v4-repost: added "net-next" to subject and Andrew Lunn's Reviewed-by

I'm reposting Oliver Neukum's <oneukum@suse.com> patch series with
fix ups for "misplaced hunks" (landed in the wrong patches).
Please fixup the "author" if "git am" fails to attribute the
patches 1-3 (of 4) to Oliver.

I've tested v4 series with "5.12-rc3+" kernel on Intel NUC6i5SYB
and + Sabrent NT-S25G. Google Pixelbook Go (chromeos-4.4 kernel)
+ Alpha Network AUE2500C were connected directly to the NT-S25G
to get 2.5Gbps link rate:
# ethtool enx002427880815
Settings for enx002427880815:
        Supported ports: [  ]
        Supported link modes:   Not reported
        Supported pause frame use: No
        Supports auto-negotiation: No
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 2500Mb/s
        Duplex: Half
        Auto-negotiation: off
        Port: Twisted Pair
        PHYAD: 0
        Transceiver: internal
        MDI-X: Unknown
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes


"Duplex" is a lie since we get no information about it.

I expect "Auto-Negotiation" is always true for cdc_ncm and
cdc_ether devices and perhaps someone knows offhand how
to have ethtool report "true" instead.

But this is good step in the right direction.

base-commit: 1c273e10bc0cc7efb933e0ca10e260cdfc9f0b8c
