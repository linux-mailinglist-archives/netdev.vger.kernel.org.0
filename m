Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A2A2EC7B4
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbhAGBZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbhAGBZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:25:53 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFBFC0612EF
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 17:25:13 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw4so7510318ejb.12
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PKopvVV4C4gtzjXBFw5NnxkAEsRa1daGNJH9/GWSuls=;
        b=S7/ueT6naR6Swk/CTq34ahf5tNj2VpWqmvWvESfVq2+xCG2LdI8qp6wt52QDgE+SFs
         ZVtJgjU5fD1qlIgtao/Th8D/260cfbhebCsF/NaQ8pJEgfYAIvTnMxpK0UWcaYwCat7x
         vcfcW/Nd1ODACCDO+DIwfZUPMu5NIiEwraHt70ZngP5U2w1LFvsXh63JrcMeIpCoosEV
         IdHhuRPbmDv0B9SjwKZU938GjpeBI4sji/bH8eYid9dHoV2XAo1yFGCkTUaqcCQs/lol
         Uvrdq00bl2+lFrqcLbsxKVWvmnexSMpgxwOmwYIpcBEnfWodCOu47z0VB2CUfUplczFA
         nhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PKopvVV4C4gtzjXBFw5NnxkAEsRa1daGNJH9/GWSuls=;
        b=HhdAlvqSpld8GuITfYZQpYyQ2c0DjzNOl1eJZZWPKkpI2ra2t4NbZ6gin9X2ctLj+W
         JNxaLpmL8BNMpInVB3Txfe4Ts0FyQ0asezE5r8wgt95Q83SzZ1ptleyhOaX9lnsZAW/1
         +EiEoFTJA+rJXPov8Yvs4oZj1H7nAoCjuSJ//mcCGJ2Y3B9rrdiaf/mTSBC+xXTCHKmB
         zOUTCJgUxXsUKNaJdzUz9YwT7AzcoDPMZUmLKK4jsFmNmQZf1NSRGpxPU6+dB/Tx2Bu9
         HWDcaoTaBAHvOHE8oblE9dgJEn1Olf/ItaUsD62xFSUCUn33DScgGub9HdLXVDmiWd+F
         4W+A==
X-Gm-Message-State: AOAM531yYsiYDWmPek7zgYGF0C/1AmDs7ELo2p8gkvrLqQORMTA70NH7
        wzL+BAvdYyQq18EqLVbQdeM=
X-Google-Smtp-Source: ABdhPJytGXY7ScObQa2HaYL2VmXJyzCULqr5qgJ4+mTIO+bbl0/hQKMFOYqS/j8tm4wRl5Oj/EFoZg==
X-Received: by 2002:a17:906:d8dc:: with SMTP id re28mr4726920ejb.168.1609982711805;
        Wed, 06 Jan 2021 17:25:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm2041858edv.74.2021.01.06.17.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 17:25:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2 net-next 0/4] Reduce coupling between DSA and Broadcom SYSTEMPORT driver
Date:   Thu,  7 Jan 2021 03:23:59 +0200
Message-Id: <20210107012403.1521114-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Upon a quick inspection, it seems that there is some code in the generic
DSA layer that is somehow specific to the Broadcom SYSTEMPORT driver.
The challenge there is that the hardware integration is very tight between
the switch and the DSA master interface. However this does not mean that
the drivers must also be as integrated as the hardware is. We can avoid
creating a DSA notifier just for the Broadcom SYSTEMPORT, and we can
move some Broadcom-specific queue mapping helpers outside of the common
include/net/dsa.h.

Vladimir Oltean (4):
  net: dsa: move the Broadcom tag information in a separate header file
  net: dsa: export dsa_slave_dev_check
  net: systemport: use standard netdevice notifier to detect DSA
    presence
  net: dsa: remove the DSA specific notifiers

 MAINTAINERS                                |  1 +
 drivers/net/ethernet/broadcom/bcmsysport.c | 82 ++++++++++------------
 drivers/net/ethernet/broadcom/bcmsysport.h |  2 +-
 include/linux/dsa/brcm.h                   | 16 +++++
 include/net/dsa.h                          | 48 +------------
 net/dsa/dsa.c                              | 22 ------
 net/dsa/dsa_priv.h                         |  1 -
 net/dsa/slave.c                            | 18 +----
 net/dsa/tag_brcm.c                         |  1 +
 9 files changed, 60 insertions(+), 131 deletions(-)
 create mode 100644 include/linux/dsa/brcm.h

-- 
2.25.1

