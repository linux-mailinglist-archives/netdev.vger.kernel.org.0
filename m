Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F44340E29
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhCRT0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbhCRTZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5676C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:45 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so7443431wma.0
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=GEf7/EW2NN3RcpIhnybPn1vrj0aMdVXjgcYs4ITWQ98=;
        b=DSmuaWbili8TRCwEKZD7ruuqiM0SwqKc9WclA78shEzyKuJPVMfS3JAmsHxYasz0pJ
         A7tpWC9f24tFNDuNRmEi4OEwMOpVQkYb5g7gm845dJ6QULO2AhAVnUBIBA6J14FipYom
         VH71B1no/6AeE8j0aBkI0Q6+xhBr71OjKRb7yETEneXfT2thrELhw/RSr2USwkPAPH8Y
         7C6Xlqe/+P9Yqsb69BT/5bwPlD/RXMVA2B4nmgWscNRs/+s+uzITwQeV3JF8kKKXp7dn
         YCf/VZzhdEpECwrAHQ+W2NF4EIjd4p6G6ldIs8ZyenyC8bz2eq4pU3nkRPcBLej7s8+Z
         oEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=GEf7/EW2NN3RcpIhnybPn1vrj0aMdVXjgcYs4ITWQ98=;
        b=ZBQv018InTwYd4AOcCLuwBHfdC2vV6e0yS1IEbI0QWSpurDhK8e39hi4EbOZ/vWDFx
         OBCqB94vxo7Llt+0GD5ouLrevcXYES8zoxD3M7FAiAnIV4yt6hArLJP1F4HxyyB5Xouj
         mTfWMHYf6dzZt/b2a3CywYCrmwx8g81+mNX1H2ThMgr1AaadJ57PjZk0mSbBJVHvUyiS
         EoKx3Lt6m6yIShRfSkUjgvsJHeSzXUR5zcjgQyWIINt7jRwEMjfcCwXsAdSkYyG1lqEP
         SP0g/a1VmiyicyjKO/6pIBduwrEJXh+yIGptQOXh2/mYym+niwUG/fPJutxtLxtiiXIO
         XAnQ==
X-Gm-Message-State: AOAM530StAqdW3BPVBUQg+DBrdNJG1h9dTt3PynQ/rZ39Z0enuaaPZjE
        r974wehL4qGzLJ5/n3djzzBlqg==
X-Google-Smtp-Source: ABdhPJzpaBtpzsceMeYw6UQVXTVql3zDI9Gx70yTNPi9KkJGolG/joCnZNxJMGoK6FAKthN6rTpaww==
X-Received: by 2002:a7b:c0d1:: with SMTP id s17mr586326wmh.153.1616095544619;
        Thu, 18 Mar 2021 12:25:44 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:43 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 0/8] net: dsa: mv88e6xxx: Offload bridge port flags
Date:   Thu, 18 Mar 2021 20:25:32 +0100
Message-Id: <20210318192540.895062-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading learning and broadcast flooding flags. With
this in place, mv88e6xx supports offloading of all bridge port flags
that are currently supported by the bridge.

Broadcast flooding is somewhat awkward to control as there is no
per-port bit for this like there is for unknown unicast and unknown
multicast. Instead we have to update the ATU entry for the broadcast
address for all currently used FIDs.

v2 -> v3:
  - Only return a netdev from dsa_port_to_bridge_port if the port is
    currently bridged (Vladimir & Florian)

v1 -> v2:
  - Ensure that mv88e6xxx_vtu_get handles VID 0 (Vladimir)
  - Fixed off-by-one in mv88e6xxx_port_set_assoc_vector (Vladimir)
  - Fast age all entries on port when disabling learning (Vladimir)
  - Correctly detect bridge flags on LAG ports (Vladimir)

Tobias Waldekranz (8):
  net: dsa: Add helper to resolve bridge port from DSA port
  net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
  net: dsa: mv88e6xxx: Provide generic VTU iterator
  net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
  net: dsa: mv88e6xxx: Use standard helper for broadcast address
  net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
  net: dsa: mv88e6xxx: Offload bridge learning flag
  net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag

 drivers/net/dsa/mv88e6xxx/chip.c | 270 ++++++++++++++++++++++---------
 drivers/net/dsa/mv88e6xxx/port.c |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h |   2 +
 include/net/dsa.h                |  14 ++
 net/dsa/dsa_priv.h               |  14 +-
 5 files changed, 232 insertions(+), 89 deletions(-)

-- 
2.25.1

