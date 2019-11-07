Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96954F3A41
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfKGVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:14:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38734 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:14:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id z19so4078641wmk.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 13:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XzBnWL1r7tpWL54uUJokCBbhiDopM830YKmNfWMaaio=;
        b=MoK0ZD1QhNC8Y2UrM1IN5H+dPXW65Dr7xDIWTpBBLeCUGmc7HphxuqK7LWGAAfHIr3
         ofVdilG6mzxanAh7oDDked1mV3VYN47rk3z/DA9uIKT/FJEENGuMXQmZmt92trtwoU8a
         SRkr6w+zk9MzjI7JKwJvMsPuGhrQITGBa5iSLCttp/t7IEEBhBzKeXPV8DfATqv/oKme
         9pRlWBNxtSZKneOnpXG0fuJTAUoV0MWVg2IFTQuZZUEzwa9CcCmfNHhpl/lsIQ7UeQQm
         q3kUJnQT5wURPHrDK1FVQstuLlLStoaIua1hrOdpjV9aSFs7KBA2Bf2yFmLZhB2cp3x4
         twrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XzBnWL1r7tpWL54uUJokCBbhiDopM830YKmNfWMaaio=;
        b=CbLFb8GcSJmjXkg0yaZkEQtVNYc0q2cVsg6pA1yjQGp/NF2/hoUfgg1sHfOcUOp7fu
         ZIqGSU0+4xtOiQW5t5yH7oOPW1NKc7vuLMlOVaUeeZ9LD592iWu4CD71BzufngNyl8gq
         MWOAYzNsMMca/EImTZ8XngeWx7nbxPMxzfytbedSLn/Xf6oRfzkWA5Lz5hvucITbKUwt
         /VmTZI2pmT8Vq9axh05byMcIAXqoKD5Z0sNqVeMaW37hGV8iRmYoxBt7sqJ21ARMWpdF
         PEtvctm3gMFZuxnlcidv89GO95xucy9+Vk8FZR+73rszW/6xMH6BXU5zEwoLSEo/OvTt
         lMYg==
X-Gm-Message-State: APjAAAVEmPe3Y97YejVDnDvz2ll9qukdVnVE1FfXuXsW4z/gq/hxkHh6
        MHLgSzZA6E7yWLg6R9PUNOT3T8ptjvA=
X-Google-Smtp-Source: APXvYqxnVg97U48UXxo5NeqI2RvFCURSuFGK7Ew1p0LVPIwAxXSw9LuPBL8tqmBaNxtp47u52Alytw==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr5262990wme.76.1573161238734;
        Thu, 07 Nov 2019 13:13:58 -0800 (PST)
Received: from i5wan.lan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id l4sm3188596wml.33.2019.11.07.13.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 13:13:57 -0800 (PST)
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, Iwan R Timmer <irtimmer@gmail.com>
Subject: [PATCH net-next v3 0/2] net: dsa: mv88e6xxx: Add support for port mirroring
Date:   Thu,  7 Nov 2019 22:11:12 +0100
Message-Id: <20191107211114.106310-1-irtimmer@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch serie add support for port mirroring in the mv88e6xx switch driver.
The first patch changes the set_egress_port function to allow different egress
ports for egress and ingress traffic. The second patch adds the actual code for
port mirroring support.

Tested on a 88E6176 with:

tc qdisc add dev wan0 clsact
tc filter add dev wan0 ingress matchall skip_sw \
        action mirred egress mirror dev lan2
tc filter add dev wan0 egress matchall skip_sw \
        action mirred egress mirror dev lan3

Changes in v3

- Use enum for egress traffic direction
- Keep track of egress ports on mv88e6390
- Move booleans in struct for better structure packing

Changes in v2

- Support mirroring egress and ingress traffic to different ports
- Check for invalid configurations when multiple ports are mirrored

Iwan R Timmer (2):
  net: dsa: mv88e6xxx: Split monitor port configuration
  net: dsa: mv88e6xxx: Add support for port mirroring

 drivers/net/dsa/mv88e6xxx/chip.c    | 85 ++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    | 15 ++++-
 drivers/net/dsa/mv88e6xxx/global1.c | 60 ++++++++++++++------
 drivers/net/dsa/mv88e6xxx/global1.h |  8 ++-
 drivers/net/dsa/mv88e6xxx/port.c    | 37 +++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h    |  3 +
 6 files changed, 188 insertions(+), 20 deletions(-)

-- 
2.23.0

