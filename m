Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264DF5BCB16
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiISLxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiISLxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:53:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0E2B62B;
        Mon, 19 Sep 2022 04:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663588388; x=1695124388;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fl+CRwJvohlUFljXx4Dh9qqZ9DaMcxPOTMEqp6Hmx4o=;
  b=DS1NBUvZdpkUkIX7vh1WOyoUgTT7FaVnZYE+6ZLZIKF2tvNmKxMP6uLP
   P+m3yqq9Gf2mZgEiPtb8CN2cDkybVP7M00eUIBwQbABe0cGFkY6OomvqY
   KNZxuruCIMF0VJb3DshPsdo5FfA/PhM8lWOJeq6mJKTwKv3usAW8q8Z7S
   Xk/q3uKoj6hgqiokgR0aY1Wv7D5QoWS0Q13IQWhgtCxXAzAa53HHO019z
   OJK+rlhv/7LkYhKSufacpYPuSLtswfoMqCZG1uQk94UTcPbgPXdmi7ddV
   OyOQ7AhjUwHVX7D8jeQ4oq8aU3oxSZAvhDXBwMcwLqhou0QXeZ+b4SUp/
   w==;
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="180955226"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Sep 2022 04:53:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 19 Sep 2022 04:53:06 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 19 Sep 2022 04:53:03 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <horatiu.vultur@microchip.com>,
        <casper.casan@gmail.com>, <rmk+kernel@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 0/5] Add QoS offload support for sparx5
Date:   Mon, 19 Sep 2022 14:02:10 +0200
Message-ID: <20220919120215.3815696-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for offloading QoS features with the tc
command suite, to the sparx5 switch. The new offloadable QoS features
introduced in this patch series are:

  - tc-mqprio for mapping traffic class to hardware queue. Queues are by
    default mapped 1:1  in hardware, as such the mqprio qdisc is used as
    an attachment point for qdiscs tbf and ets.
    
    $ tc qdisc add dev eth0 root handle 1:0 mqprio
    
  - tc-tbf for setting up shaping on scheduler elements of the HSCH
    (Hierarchical Scheduler) block. Shaping on either port output or
    queue output is supported.
    
    Port shaper: $ tc qdisc add dev eth0 root handle 1:0 tbf rate \
    10000000 burst 8192 limit 1m

    Queue shaper: $ tc qdisc replace dev eth0 parent 1:5 handle 2:0 tbf \
    rate 10000000 burst 8192 limit 1m
  
  - tc-ets for setting up strict and or bandwidth-sharing bands on one
    through eight priority queues.
    
    Configure a mix of strict and bw-sharing bands: 
    $ tc qdisc add dev eth0 handle 1: root ets bands 8 strict 5 \ 
    quanta 1000 1000 1000 priomap 7 6 5 4 3 2 1 0

Patch #1 Sets up the tc hook.
Patch #2 Adds support for offloading the tc-mqprio qdisc.
Patch #3 Adds support for offloading the tc-tbf qdisc.
Patch #4 Adds support for offloading the tc-ets qdisc.
Patch #5 Updates the maintainers of the sparx5 driver.

Daniel Machon (5):
  net: microchip: sparx5: add tc setup hook
  net: microchip: sparx5: add support for offloading mqprio qdisc
  net: microchip: sparx5: add support for offloading tbf qdisc
  net: microchip: sparx5: add support for offloading ets qdisc
  maintainers: update MAINTAINERS file.

 MAINTAINERS                                   |   1 +
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |   7 +
 .../microchip/sparx5/sparx5_main_regs.h       | 165 ++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |   8 +-
 .../ethernet/microchip/sparx5/sparx5_qos.c    | 514 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_qos.h    |  82 +++
 .../net/ethernet/microchip/sparx5/sparx5_tc.c | 125 +++++
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |  15 +
 9 files changed, 917 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc.h

-- 
2.34.1

