Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7D533C84E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhCOVPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhCOVPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:07 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F2EC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:07 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id v2so46087563lft.9
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=XjLm6pPqz9Ees7j3dEOzx7+S+ZAWiTFNe1naP4ehENI=;
        b=d24ERx0r8adqOPBrmGapFy0Dwz2pXpMP7biK2VWnEU6Q/OCvAh6/zGewRlw25ybKlE
         vU4+uBeEXIAkLEc8+yB2gqRJz65ZOoZ6DKdBKrDZjuMcfGBhRm3WZuNQ33BItv8n7TKS
         t2fVF7/uOfC4Z3ybK7wBr8U/fRWlnvJLJGn30nAAt/WpBy3BCE/wTrPovBMZ1QattHIM
         05qodnAUDDIo37y/+ZcxAOhHjdRNSOLNIGNd3CMG6cJP70oClw+862XRWXX+G4BLymwP
         X80l4uC4H2Q6oWFypMmdnXiwVt3VYRcEgTD8IPFwCSs4g2/J0roi/GSPJuY96j7u4FLq
         Wi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=XjLm6pPqz9Ees7j3dEOzx7+S+ZAWiTFNe1naP4ehENI=;
        b=PdvrBD590doPq11gJP63j3oG92i0xtVjlSzls/n/ohsNflTzGHOdbcuAvD7m32qbDI
         dcF+X77M5s5/gBkwu1yrOFb1Q4PmSEAHbJBPtP02oqmMWhNYewZ69GYrCfFaflnj1QRq
         ktkkoiddbYmFEBdm4pN3uvxYSGb0QWLkR4WKeJ/UNOxILq0NVQk1NzduZ8724ToXnNhE
         fEY1gb+hzJr4Dk4lCgkwLnrIogIE7PdtGwEMQr9Oap7zXJCHYwmt23Mz7ryPFHGjSWmz
         TBPACUBVZ2h1tnk4WrzkRrHRPegGwGDcIeY14KiCrB44u8uRZU64b9/FBbLRwIJ7YXVH
         1/fw==
X-Gm-Message-State: AOAM530u164nDaYmA3AnoQ0SdjJSU4+y6Owc0lohRQA5hX7/nyzP4ivi
        YADfHJ2/p8GFeqIJrLBNvycSbA==
X-Google-Smtp-Source: ABdhPJyj4qAzzPt3GiTLtsU/PYX91e/o8cGl4OelEeDizvYE+8fkhL9paMY2ZQT0ZvZltOTBjP7Wwg==
X-Received: by 2002:ac2:5d66:: with SMTP id h6mr9212469lft.359.1615842905765;
        Mon, 15 Mar 2021 14:15:05 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v11sm2975003ljp.63.2021.03.15.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:05 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] net: dsa: mv88e6xxx: Offload bridge port flags
Date:   Mon, 15 Mar 2021 22:13:55 +0100
Message-Id: <20210315211400.2805330-1-tobias@waldekranz.com>
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

Tobias Waldekranz (5):
  net: dsa: mv88e6xxx: Provide generic VTU iterator
  net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
  net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
  net: dsa: mv88e6xxx: Offload bridge learning flag
  net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag

 drivers/net/dsa/mv88e6xxx/chip.c | 248 +++++++++++++++++++++----------
 drivers/net/dsa/mv88e6xxx/port.c |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h |   2 +
 3 files changed, 196 insertions(+), 75 deletions(-)

-- 
2.25.1

