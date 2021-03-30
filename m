Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB634DE1F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhC3CSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhC3CRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:17:47 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3430C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:47 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id v70so14525581qkb.8
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYpyY1TOa+Yl8BrX8XRiUJe9gV2CoaxgtkA+KYhmVKE=;
        b=Y/s/ORXJWshz61UqGJHDlwixtxdCFhgDqAhS9r79QpUW+lSnB4019HqWR7HPrMDhqr
         QB7F4l9287vlJ8+dRCT5XYDA37sqqVc+qANTimeoGpN6T/Zx/GIYlOEUhAeKcgXX+Ww9
         XrAoHU2FFL2i0Shz5uF1lOGAUU9+SBTvXoG60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYpyY1TOa+Yl8BrX8XRiUJe9gV2CoaxgtkA+KYhmVKE=;
        b=IMGDKQYeMPfL0yoBNZtEGj7AdAk+yt77OAoG3iJ7FzBkLjlNJ7GVygCeiVagptx3rF
         T1OHmMxwKbrPWXJputHiGLL+GyPUVjg9wX5fSL5U2rFZB/tbWm+EEBh9OW2TqLd33MUz
         nF5Jwq7qLlErqsGIXvku5ZZ0jsMyW0VpOwxa2Jmp56iyDsrr/k/b/sF35xh/zRdWDXI7
         IpBosNJCJpWab1SFz2YAiVGPAnlhtUfDnzktKjCUznocKbzB5+Et4SdChc7XEELdRUf0
         t3HoBvcW5rvIwgQcXi3M0AO3qj6ccdmlUb2HUj8eqTWM4lQD5ORFUOLWfzEUtSDdEwFs
         413A==
X-Gm-Message-State: AOAM530HothcDaJd0GLjgKSO4HKjUyaITGx/Q2d5Tsica7lggh1wbHaW
        dqYFl7SvSqfdIoqJFMIz9l5wFA==
X-Google-Smtp-Source: ABdhPJwAWKLv9lBuLdhP4/ZS1OiI52qq100NGYn+M6dBf86Me1mmwLYSBhLAFmwV+rhvDmbxq045mA==
X-Received: by 2002:a37:a643:: with SMTP id p64mr26959945qke.276.1617070666774;
        Mon, 29 Mar 2021 19:17:46 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id j30sm12433067qtv.90.2021.03.29.19.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 19:17:45 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCHv4 0/4] usbnet: speed reporting for devices without MDIO
Date:   Mon, 29 Mar 2021 19:16:47 -0700
Message-Id: <20210330021651.30906-1-grundler@chromium.org>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
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
