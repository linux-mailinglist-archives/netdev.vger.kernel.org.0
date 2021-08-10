Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0393E5E37
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbhHJOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbhHJOom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:44:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A491C0613C1;
        Tue, 10 Aug 2021 07:44:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d1so21335901pll.1;
        Tue, 10 Aug 2021 07:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XpRr5gblx36zwkAxrcFt06PD4M4rG/alI4T4WiPvXMM=;
        b=e5RZslBil4ln7liljh9m0KAfKbbrILqVd1FdYXuw0c0hZF2lVC0XOIT91sU7zj75f4
         P5sNyXVfw5GTs4RevU9OPC+/Uxncn5Kjrbo3qW2PF9zAECuft/rgTHiPFTObg69FIoWb
         YooMCyaEK+P9Ms/b8qbYWyTMIA0oNRusZkCK8TFzUKt1Gud2d+y9eCjR8IY00MkxzkMS
         Hk2c/K4WCYUSQ9h5LUEaE04asZqdhx3POXpA8JeIwDcGs8MEwv+3UBF4Xta+bmuKEPEz
         CG1w4rFjwvpoQY71Ve92qeJicEB/3un7Ai9vmrEkU+W+e24hdaP0qkdP1IMnN/JTzhHW
         Vzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XpRr5gblx36zwkAxrcFt06PD4M4rG/alI4T4WiPvXMM=;
        b=STSwC68FaeEK8S0gAJOClK7ppjW031WeKxssTcPPDiyMI9Q2kAm9/Is/4u+nl5ipD+
         lXCTsDxRM8xXB09EBguCyxlQggAT3Y1iQFKr35K+uP/xpwnfxnGYAfv2mxE2TZm3/G5y
         Ei4vGWjWtvipu7qW8+FCzcpzO5ZHRVR3TAPV9pZJOLOQJtcMfwIRjILubHMOBl0oVYVq
         P7aGHt0hbPfvWGV68sPfYGfDNCbAYbQmQDrJMQ+aIc/v/2zYWLNfyPQLbXjCH8m27k+k
         HI3QNsnBtKhuLt8ZBeMuoSp0Xn0ifydcWD6kdci43LzLYH6TeDtPV/TazF/1Vi+MgSXu
         GFXw==
X-Gm-Message-State: AOAM5317T3F6CmIYiHfu6z4VkLqwvHJozgffsjUfNmK+3DL7NApJZwZy
        KZg5CKTw3gHfkzyNo9/EhR/N1YSP7za21nXV
X-Google-Smtp-Source: ABdhPJz4ffqL7hMXRS9xsOpgRofJU0w4da4FG+ZK40NW+QtjSpj9Oa06SCvEh5nRb3eJnyJ8EVTV1Q==
X-Received: by 2002:a65:5a83:: with SMTP id c3mr231414pgt.321.1628606659715;
        Tue, 10 Aug 2021 07:44:19 -0700 (PDT)
Received: from localhost.localdomain ([123.20.118.31])
        by smtp.gmail.com with ESMTPSA id h21sm24809652pfq.130.2021.08.10.07.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 07:44:19 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        minhquangbui99@gmail.com, lesedorucalin01@gmail.com
Subject: [PATCH 0/2] UDP socket repair
Date:   Tue, 10 Aug 2021 21:43:57 +0700
Message-Id: <20210810144357.40367-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series implement UDP_REPAIR sockoption for dumping the corked packet
in UDP socket's send queue. A new path is added to recvmsg() for dumping
packet's data and msg_name related information of the packet.

Thanks,
Quang Minh.

Bui Quang Minh (2):
  udp: UDP socket send queue repair
  selftests: Add udp_repair test

 include/linux/udp.h                      |   3 +-
 include/net/udp.h                        |   2 +
 include/uapi/linux/udp.h                 |   1 +
 net/ipv4/udp.c                           |  94 +++++++++-
 net/ipv6/udp.c                           |  56 +++++-
 tools/testing/selftests/net/.gitignore   |   1 +
 tools/testing/selftests/net/Makefile     |   1 +
 tools/testing/selftests/net/udp_repair.c | 218 +++++++++++++++++++++++
 8 files changed, 371 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/net/udp_repair.c

-- 
2.17.1

