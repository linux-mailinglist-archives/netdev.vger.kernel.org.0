Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E664408C6
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 14:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhJ3MmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 08:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhJ3MmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 08:42:22 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59376C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 05:39:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t184so11894286pfd.0
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 05:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tatH8G3lOSXXjEaDBbhP/GuBT+yMKoy/T6BQUwlBwug=;
        b=UbjYYz/9vO8cDiP2DJYJHYnMCo8W15P5mAi6uaQN4fTvB7AabM2cSrYV8S217NCxGL
         ZhT8ipnruJ1iwZ1/trASe9fAyxTBVcvSdh8/ugzA6VXbql2cpC10GL8MNUAAe/02nzXZ
         1x/oQORZxB1NDMDNY2CmztNXguWghltkiDPcTVS87ZJ/hjVwlaXpZo3DhIcUDkpZ8yst
         W/RUww+c/vxuhFOqQWoLU/bbmb0cdhavhoKJOwng1/1u8C8+SiatpgIYSyGk+gm19A4e
         joZoua1yQxY/pZgSio6N9Mq4/BZK2TbLMMEIOppn4fyILVRbFDwFi8KYgnBeRm09IgC/
         vNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tatH8G3lOSXXjEaDBbhP/GuBT+yMKoy/T6BQUwlBwug=;
        b=gPPsQQwdShrsoU38/wRiOuHzL5VsWZmMH80VVXeqXkTembFpk5P1amkUYtxiFFeHE5
         R7IR7Cp4+6gasVyFZX4E610XZ9GoLRFdZJByADM8mscrF4nSlcxaVcaPBwEc91ovB8ro
         N+YC4ywf4k+d4v4TDCBqvzUzhl8YdN0DAb7PpM+jHkJE7d+luDla/h8B6DB6mNCVcz0R
         tQTtKrvHFDWpPeJ7Q+gD065XxRoNBDbGOM7tqi3BOvFx/eSLL2zdzduCUzMn2SJ/OVkh
         bg8mvlz8vhKsNyhatRNgk9FDwM95O5VwBlyUM6aVHP8I/QnoTQOpQJeMc5Nmv1ZSr1Dg
         NUfg==
X-Gm-Message-State: AOAM532noBkTi3MrqGM6UuAro9l+GdN03bOnM7NQXi3/XJMEKlsCU9r2
        K84oai+wP9VV5STDxM/5KLo=
X-Google-Smtp-Source: ABdhPJx+lpqzG38Q5sp4wfc1nugDDz7uDhd0d1yrABH9QjcGrfvFGxkfdZVaRCnPFixGksiUYpA4Pg==
X-Received: by 2002:a05:6a00:1915:b0:47e:4c36:e9af with SMTP id y21-20020a056a00191500b0047e4c36e9afmr15632233pfi.57.1635597591716;
        Sat, 30 Oct 2021 05:39:51 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k73sm7312664pgc.63.2021.10.30.05.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 05:39:51 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v5 0/5] amt: add initial driver for Automatic Multicast Tunneling (AMT)
Date:   Sat, 30 Oct 2021 12:39:16 +0000
Message-Id: <20211030123921.29672-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
https://datatracker.ietf.org/doc/html/rfc7450

This implementation supports IGMPv2, IGMPv3, MLDv1, MLDv2, and IPv4
underlay.

 Summary of RFC 7450
The purpose of this protocol is to provide multicast tunneling.
The main use-case of this protocol is to provide delivery multicast
traffic from a multicast-enabled network to sites that lack multicast
connectivity to the source network.
There are two roles in AMT protocol, Gateway, and Relay.
The main purpose of Gateway mode is to forward multicast listening
information(IGMP, MLD) to the source.
The main purpose of Relay mode is to forward multicast data to listeners.
These multicast traffics(IGMP, MLD, multicast data packets) are tunneled.

Listeners are located behind Gateway endpoint.
But gateway itself can be a listener too.
Senders are located behind Relay endpoint.

    ___________       _________       _______       ________
   |           |     |         |     |       |     |        |
   | Listeners <-----> Gateway <-----> Relay <-----> Source |
   |___________|     |_________|     |_______|     |________|
      IGMP/MLD---------(encap)----------->
         <-------------(decap)--------(encap)------Multicast Data

 Usage of AMT interface
1. Create gateway interface
ip link add amtg type amt mode gateway local 10.0.0.1 discovery 10.0.0.2 \
dev gw1_rt gateway_port 2268 relay_port 2268

2. Create Relay interface
ip link add amtr type amt mode relay local 10.0.0.2 dev relay_rt \
relay_port 2268 max_tunnels 4

v1 -> v2:
 - Eliminate sparse warnings.
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.
 - Use CHECKSUM_NONE instead of CHECKSUM_UNNECESSARY.
 - Fix compile error.

v4 -> v5:
 - Remove unnecessary rcu_read_lock().
 - Remove unnecessary amt_change_mtu().
 - Change netlink error message.
 - Add validation for IFLA_AMT_LOCAL_IP and IFLA_AMT_DISCOVERY_IP.
 - Add comments in amt.h.
 - Add missing dev_put() in error path of amt_newlink().
 - Fix typo.
 - Add BUILD_BUG_ON() in amt_smb_cb().
 - Use macro instead of magic values.
 - Use kzalloc() instead of kmalloc().
 - Add selftest script.

Taehee Yoo (5):
  amt: add control plane of amt interface
  amt: add data plane of amt interface
  amt: add multicast(IGMP) report message handler
  amt: add mld report message handler
  selftests: add amt interface selftest script

 MAINTAINERS                          |    8 +
 drivers/net/Kconfig                  |   16 +
 drivers/net/Makefile                 |    1 +
 drivers/net/amt.c                    | 3290 ++++++++++++++++++++++++++
 include/net/amt.h                    |  386 +++
 include/uapi/linux/amt.h             |   62 +
 tools/testing/selftests/net/Makefile |    1 +
 tools/testing/selftests/net/amt.sh   |  284 +++
 tools/testing/selftests/net/config   |    1 +
 9 files changed, 4049 insertions(+)
 create mode 100644 drivers/net/amt.c
 create mode 100644 include/net/amt.h
 create mode 100644 include/uapi/linux/amt.h
 create mode 100644 tools/testing/selftests/net/amt.sh

-- 
2.17.1

